Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529Ab0KPTqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 14:46:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756133Ab0KPTqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 14:46:51 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTikjQKmo0j5xbvPiS=eriAUUZPMGKkcxt8w_z8XB@mail.gmail.com>
References: <1289820766.16406.45.camel@maggy.simson.net> <1289821590.16406.47.camel@maggy.simson.net>
 <20101115125716.GA22422@redhat.com> <1289856350.14719.135.camel@maggy.simson.net>
 <20101116015648.GA11534@redhat.com> <1289916171.5169.117.camel@maggy.simson.net>
 <1289916683.2109.625.camel@laptop> <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
 <20101116170312.GA19327@tango.0pointer.de> <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de> <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
 <AANLkTikjQKmo0j5xbvPiS=eriAUUZPMGKkcxt8w_z8XB@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 16 Nov 2010 11:45:55 -0800
Message-ID: <AANLkTikKdjH-ZM0eXTQMvzJjYkpyfKZR2OK06tNtCGFs@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
To: Dhaval Giani <dhaval.giani@gmail.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 11:27 AM, Dhaval Giani <dhaval.giani@gmail.com> wrote:
>
> So what do you think about something like systemd handling it. systemd
> already does a lot of this stuff already in the form of process
> tracking, so it is quite trivial to do this. And more happily avoids
> all this complexity in the kernel.

What complexity? Have you looked at the patch? It has no complexity anywhere.

It's a _lot_ less complex than having system daemons you don't
control. We have not had good results with that approach in the past.
System daemons tend to cause nasty problems, and debugging them is a
nightmare.

Have you ever tried to debug the interaction between acpid and the
kernel? I doubt it. It's not simple.

Did you ever try to understand how the old pcmcia code worked, with
the user daemon to handle the add/remove requests?

Have you ever really worked with the "interesting" situations that
come from the X server handling graphics mode switching, and thus
being involved in suspend, resume and VT switching? Trust me, just
designing the _interfaces_ to do that thing is nasty, and the code
itself was a morass. There's a reason the graphics people wanted to
put modeswitching in the kernel. Because doing it in a daemon is a
f*cking pain in the ass.

Put another way: "do it in user space" usually does _not_ make things simpler.

For example: how do you do reference counting for a cgroup in user
space, when processes fork and exit without you even knowing it? In
kernel space, it's _trivial_. That's what kernel/autogroup.c does, and
it has lots of support for it, because that kind of reference counting
is exactly what the kernel does.

In a system daemon? Good luck with that. It's a nightmare. Maybe you
could just poll all the cgroups, and try to remove them once a minute,
and if they are empty it works. Or something like that. But what a
hacky thing it would be.

And more importantly: I don't run systemd. Neither do a lot of other
people. The way the patch does things, "it just works".

Did you go to the phoronix forum to look at how people reacted to the
phoronix article about the patch? There were a number of testers. It
was just so _easy_ to test and set up. If you want people to run some
specific system daemon, it immediately gets much harder to set up and
do.

                         Linus
