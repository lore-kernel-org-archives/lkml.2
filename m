Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab0KTBdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 20:33:43 -0500
Received: from tango.0pointer.de ([85.214.72.216]:49706 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab0KTBdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 20:33:42 -0500
Date: Sat, 20 Nov 2010 02:33:22 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Gamari <bgamari.foss@gmail.com>, David Miller <davem@davemloft.net>,
        tytso@mit.edu, a.p.zijlstra@chello.nl, debiandev@gmail.com,
        alan@lxorguk.ukuu.org.uk, dhaval.giani@gmail.com, efault@gmx.de,
        vgoyal@redhat.com, oleg@redhat.com, markus@trippelsdorf.de,
        mathieu.desnoyers@efficios.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101120013321.GC4183@tango.0pointer.de>
References: <C47257FC-498A-41B0-BC94-C81C72601D53@mit.edu>
 <20101119.082944.226775934.davem@davemloft.net>
 <20101119163430.GA12353@tango.0pointer.de>
 <20101119.084302.71115175.davem@davemloft.net>
 <AANLkTiksmvcLKGx7-u5CnTnZU6dgOgg7wem6qf384zUg@mail.gmail.com>
 <87mxp53z72.fsf@gmail.com>
 <AANLkTi=XPxnrKKu5yuJSpJjVis7MnP5d1bvhT_gKHJyV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=XPxnrKKu5yuJSpJjVis7MnP5d1bvhT_gKHJyV@mail.gmail.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19.11.10 11:48, Linus Torvalds (torvalds@linux-foundation.org) wrote:

> 
> On Fri, Nov 19, 2010 at 11:12 AM, Ben Gamari <bgamari.foss@gmail.com> wrote:
> >
> > On that note, is there a good reason why the notify_on_release interface
> > works the way it does? Wouldn't it be simpler if the cgroup simply
> > provided a file on which a process (e.g. systemd) could block?
> 
> Actually, the sane interface would likely just be to have a "drop on
> release" interface.

Hmm, I think automatic cleanup would be quite nice, but there are some
niche cases to think about first (i.e. what do you do if a process
generates a cgroup and wants to make itself a member of it, but then
dies before it can do that, and the cgroup stays around but empty and
never gets cleaned up).

> Who uses that thing now? The desktop launcher/systemd approach
> definitely doesn't seem want the overhead of being notified and having
> to remove it manually. Does anybody else really want it?

I'd like automatic cleanup, but definitely also want to be notified when
a cgroup runs empty. Here's the use case: we run apache in a cgroup (in
a named hierarchy, not attached to any controller, we do this for
keeping track of the service and all its children). Now apache dies. Its
children, various CGI scripts stay around. However, since Apache is
configured to be restarted systemd now kills all remaining children and
waits until they are all gone, so that when it starts Apache anew we are in
a clean and defined environment, and no remains of the previous instance
remain. For this to work I need some kind of notification when all
children are gone. Of course if systemd is PID 1, I can just use SIGCHLD
for that, but that's more difficult when we are managing user porcesses,
and want to do that with a PID != 1. And even even we are PID 1 its kinda
neat to have an explicit notification for when a cgroup is empty instead
of having to constantly check whether the cgroup is now empty after each
SIGCHLD we receive.

Also, there must be a way to opt out of automatic cleanup for some
groups, since it might make sense to give users access to subtrees of
the hierarchy and if you clean up groups belonging to privileged code
then you get a namespace problem because unprivileged code might
recreate that group and confuse everybody.

So yeah, auto-cleanup is nice, but notifications I want too, please
thanks.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
