Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab1HKSKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 14:10:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40757 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab1HKSKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 14:10:33 -0400
Date: Thu, 11 Aug 2011 13:10:23 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        LXC Development <Lxc-devel@lists.sourceforge.net>
Subject: Re: [RFC] catching sys_reboot syscall
Message-ID: <20110811181022.GA12307@peqn>
References: <4E4051A0.8030009@free.fr>
 <20110810221028.2e0c8590@neptune.home>
 <4E42EEE3.9050608@free.fr>
 <20110811183027.49275b2d@neptune.home>
 <4E44082F.6040606@free.fr>
 <20110811190456.77ff9280@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110811190456.77ff9280@neptune.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Bruno Prémont (bonbons@linux-vserver.org):
> On Thu, 11 August 2011 Daniel Lezcano <daniel.lezcano@free.fr> wrote:
> > On 08/11/2011 06:30 PM, Bruno Prémont wrote:
> > > On Wed, 10 August 2011 Daniel Lezcano <daniel.lezcano@free.fr> wrote:
> > >> On 08/10/2011 10:10 PM, Bruno Prémont wrote:
> > >>> Hi Daniel,
> > >>>
> > >>> [I'm adding containers ml as we had a discussion there some time ago
> > >>>  for this feature]
> > >> [ ... ]
> > >>
> > >>>> +    if (cmd == LINUX_REBOOT_CMD_RESTART2)
> > >>>> +        if (strncpy_from_user(&buffer[0], arg, sizeof(buffer) - 1) < 0)
> > >>>> +            return -EFAULT;
> > >>>> +
> > >>>> +    /* If we are not in the initial pid namespace, we send a signal
> > >>>> +     * to the parent of this init pid namespace, notifying a shutdown
> > >>>> +     * occured */
> > >>>> +    if (pid_ns != &init_pid_ns)
> > >>>> +        pid_namespace_reboot(pid_ns, cmd, buffer);
> > >>> Should there be a return here?
> > >>> Or does pid_namespace_reboot() never return by submitting signal to
> > >>> parent?
> > >> Yes, it does not return a value, like 'do_notify_parent_cldstop'
> > > So execution flow continues reaching the whole "host reboot code"?
> > >
> > > That's not so good as it then prevents using CAP_SYS_BOOT inside PID namespace
> > > to limit access to rebooting the container from inside as giving a process
> > > inside container CAP_SYS_BOOT would cause host to reboot (and when not given
> > > process inside container would get -EPERM in all cases).
> > >
> > > Wouldn't the following be better?:
> > > ...
> > > +
> > > +    /* We only trust the superuser with rebooting the system. */
> > > +    if (!capable(CAP_SYS_BOOT))
> > > +        return -EPERM;
> > > +
> > > +    /* If we are not in the initial pid namespace, we send a signal
> > > +     * to the parent of this init pid namespace, notifying a shutdown
> > > +     * occured */
> > > +    if (pid_ns != &init_pid_ns) {
> > > +        pid_namespace_reboot(pid_ns, cmd, buffer);
> > > +        return 0;
> > > +    }
> > > +
> > >      mutex_lock(&reboot_mutex);
> > >      switch (cmd) {
> > > ...
> > >
> > >
> > > If I misunderstood, please correct me.
> > 
> > Yep, this is what I did at the beginning but I realized I was closing
> > the door for future applications using the pid namespaces. The pid
> > namespace could be used by another kind of application, not a container,
> > running some administrative tasks so they may want to shutdown the host
> > from a different pid namespace.
> > 
> > For this reason, to prevent this execution flow, the container has to
> > drop the CAP_SYS_BOOT in addition of taking care of the SIGCHLD signal
> > with CLDREBOOT.
> 
> Ok, though for later source code readers to know adding/extending comment
> would be nice.
> Maybe something like
> 
> +    /* If we are not in the initial pid namespace, we send a signal
> +     * to the parent of this init pid namespace, notifying a shutdown
> +     * occured
> +     * NOTE: if process has CAP_SYS_BOOT it will additionally have the
> +     * same effect as if it was not namespaced */
> 
> 
> How would all of this integrate with the ongoing work on user namespaces?
> Maybe that one should later be the differentiator for who may or may not
> trigger the host reboot.

Right, then you'll be able to do:

	if (ns_capable(current_pid_ns()->user_ns, CAP_SYS_BOOT)) {
		// do container reboot stuff
	}

	if (!capable(CAP_SYS_BOOT)
		return;

	// do host reboot stuff

The first checks whether the task has privilege against the user ns
which owns his pid_ns.

The second one is a synonym for

	if (!ns_capable(&init_user_ns, CAP_SYS_BOOT))

where init_user_ns is the owner of all physical resources.

Right now pid_ns doesn't yet have a user_ns owner (except in my patch over
here: http://kernel.ubuntu.com/git?p=serge/linux-syslogns.git;a=commit;h=63556e9a39bcd75ec4a88333425800905013c73e )
and, if it did, well you can't yet do enough in a user namespace to run
a container.  But that'll be the ideal.  Hopefully soon...

-serge
