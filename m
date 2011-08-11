Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab1HKRFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 13:05:39 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:53918 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab1HKRFg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 13:05:36 -0400
Date: Thu, 11 Aug 2011 19:04:56 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        LXC Development <Lxc-devel@lists.sourceforge.net>,
        containers@lists.linux-foundation.org
Subject: Re: [RFC] catching sys_reboot syscall
Message-ID: <20110811190456.77ff9280@neptune.home>
In-Reply-To: <4E44082F.6040606@free.fr>
References: <4E4051A0.8030009@free.fr>
	<20110810221028.2e0c8590@neptune.home>
	<4E42EEE3.9050608@free.fr>
	<20110811183027.49275b2d@neptune.home>
	<4E44082F.6040606@free.fr>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 August 2011 Daniel Lezcano <daniel.lezcano@free.fr> wrote:
> On 08/11/2011 06:30 PM, Bruno Prémont wrote:
> > On Wed, 10 August 2011 Daniel Lezcano <daniel.lezcano@free.fr> wrote:
> >> On 08/10/2011 10:10 PM, Bruno Prémont wrote:
> >>> Hi Daniel,
> >>>
> >>> [I'm adding containers ml as we had a discussion there some time ago
> >>>  for this feature]
> >> [ ... ]
> >>
> >>>> +    if (cmd == LINUX_REBOOT_CMD_RESTART2)
> >>>> +        if (strncpy_from_user(&buffer[0], arg, sizeof(buffer) - 1) < 0)
> >>>> +            return -EFAULT;
> >>>> +
> >>>> +    /* If we are not in the initial pid namespace, we send a signal
> >>>> +     * to the parent of this init pid namespace, notifying a shutdown
> >>>> +     * occured */
> >>>> +    if (pid_ns != &init_pid_ns)
> >>>> +        pid_namespace_reboot(pid_ns, cmd, buffer);
> >>> Should there be a return here?
> >>> Or does pid_namespace_reboot() never return by submitting signal to
> >>> parent?
> >> Yes, it does not return a value, like 'do_notify_parent_cldstop'
> > So execution flow continues reaching the whole "host reboot code"?
> >
> > That's not so good as it then prevents using CAP_SYS_BOOT inside PID namespace
> > to limit access to rebooting the container from inside as giving a process
> > inside container CAP_SYS_BOOT would cause host to reboot (and when not given
> > process inside container would get -EPERM in all cases).
> >
> > Wouldn't the following be better?:
> > ...
> > +
> > +    /* We only trust the superuser with rebooting the system. */
> > +    if (!capable(CAP_SYS_BOOT))
> > +        return -EPERM;
> > +
> > +    /* If we are not in the initial pid namespace, we send a signal
> > +     * to the parent of this init pid namespace, notifying a shutdown
> > +     * occured */
> > +    if (pid_ns != &init_pid_ns) {
> > +        pid_namespace_reboot(pid_ns, cmd, buffer);
> > +        return 0;
> > +    }
> > +
> >      mutex_lock(&reboot_mutex);
> >      switch (cmd) {
> > ...
> >
> >
> > If I misunderstood, please correct me.
> 
> Yep, this is what I did at the beginning but I realized I was closing
> the door for future applications using the pid namespaces. The pid
> namespace could be used by another kind of application, not a container,
> running some administrative tasks so they may want to shutdown the host
> from a different pid namespace.
> 
> For this reason, to prevent this execution flow, the container has to
> drop the CAP_SYS_BOOT in addition of taking care of the SIGCHLD signal
> with CLDREBOOT.

Ok, though for later source code readers to know adding/extending comment
would be nice.
Maybe something like

+    /* If we are not in the initial pid namespace, we send a signal
+     * to the parent of this init pid namespace, notifying a shutdown
+     * occured
+     * NOTE: if process has CAP_SYS_BOOT it will additionally have the
+     * same effect as if it was not namespaced */


How would all of this integrate with the ongoing work on user namespaces?
Maybe that one should later be the differentiator for who may or may not
trigger the host reboot.


In addition sending the signal to parent process seems moot as chances are
that parent process will never have the opportunity to see the signal when
the host is being rebooted.

Then a construct like the following would give a better hint to the reader:
...
+
+    /* We only trust the superuser with rebooting the system. */
+    if (!capable(CAP_SYS_BOOT)) {
+        /* If we are not in the initial pid namespace, we send a signal
+         * to the parent of this init pid namespace, notifying a shutdown
+         * occured */
+        if (pid_ns != &init_pid_ns)
+            pid_namespace_reboot(pid_ns, cmd, buffer);
+
+        return -EPERM;
+    }
+
...

Thanks,
Bruno
