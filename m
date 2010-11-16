Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab0KPUSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:18:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777Ab0KPUSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:18:46 -0500
Date: Tue, 16 Nov 2010 15:17:57 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Paul Menage <menage@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Message-ID: <20101116201757.GI13092@redhat.com>
References: <1289916171.5169.117.camel@maggy.simson.net>
 <1289916683.2109.625.camel@laptop>
 <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
 <20101116170312.GA19327@tango.0pointer.de>
 <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
 <20101116181603.GC19327@tango.0pointer.de>
 <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
 <AANLkTikjQKmo0j5xbvPiS=eriAUUZPMGKkcxt8w_z8XB@mail.gmail.com>
 <AANLkTikKdjH-ZM0eXTQMvzJjYkpyfKZR2OK06tNtCGFs@mail.gmail.com>
 <AANLkTikSrN_Ur24xd7XYJyV3H8Cv9kXyDeBUpahNJHBU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikSrN_Ur24xd7XYJyV3H8Cv9kXyDeBUpahNJHBU@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 11:56:33AM -0800, Paul Menage wrote:
> On Tue, Nov 16, 2010 at 11:45 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > In a system daemon? Good luck with that. It's a nightmare. Maybe you
> > could just poll all the cgroups, and try to remove them once a minute,
> > and if they are empty it works. Or something like that. But what a
> > hacky thing it would be.
> 
> There's an existing cgroups API - release_agent and notify_on_release
> - whereby the kernel will spawn a userspace command once a given
> cgroup is completely empty. It's intended for pretty much exactly this
> purpose.

Yes. And it seems to be working just fine for me. I modiefied Lennart's
script a bit to achieve that.

Addition to my .bashrc.

if [ "$PS1" ] ; then
        mkdir -m 0700 -p /cgroup/cpu/$$
        echo 1 > /cgroup/cpu/$$/notify_on_release
        echo $$ > /cgroup/cpu/$$/tasks
fi

I created one file /bin/rmcgroup to clean up the cgroup.

#!/bin/bash
rmdir /cgroup/cpu/$1

And did following to mount cgroup and setup empty group notification.

mount -t cgroup -o cpu none /cgroup/cpu
echo "/bin/rmcgroup" > /cgroup/cpu/release_agent

And it works fine. Upon ssh to my box, a cpu cgroup is automatically
created and upon exiting the shell, this group is automatically destroyed.

So API/interface for automatically reclaiming the cgroup once it is empty 
seems to be pretty simple and works.

Thanks
Vivek
