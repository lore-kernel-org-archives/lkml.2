Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680Ab1I3S66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:58:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165Ab1I3S65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:58:57 -0400
Date: Fri, 30 Sep 2011 20:54:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
Message-ID: <20110930185454.GA2479@redhat.com>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org> <20110930165206.GA22048@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110930165206.GA22048@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30, Oleg Nesterov wrote:
>
> On 09/30, Matt Fleming wrote:
> >
> > However, it's a good first step and
> > hopefully by keeping it relatively simple it'll make it easier to
> > review.
>
> Cough. I'll try to read this series next week, but currently I feel
> I will never able to understand this code. It surely compliacates
> things a lot.
>
> But. All I can do is to _try_ to check this series from the correctness
> pov. I can't believe (at least at first glance) this worth the trouble,
> but otoh I won't argue unless I'll find the bugs.
>
> >  arch/ia64/kernel/signal.c           |    4 +-
> >  drivers/block/nbd.c                 |    2 +-
> >  drivers/usb/gadget/f_mass_storage.c |    2 +-
> >  drivers/usb/gadget/file_storage.c   |    2 +-
> >  fs/autofs4/waitq.c                  |    5 +-
> >  fs/exec.c                           |   17 +-
> >  fs/jffs2/background.c               |    2 +-
> >  fs/ncpfs/sock.c                     |    2 +
> >  fs/proc/array.c                     |    2 +
> >  fs/signalfd.c                       |   11 +-
> >  include/linux/init_task.h           |    4 +
> >  include/linux/sched.h               |   23 +-
> >  kernel/exit.c                       |   29 +-
> >  kernel/fork.c                       |    4 +
> >  kernel/freezer.c                    |   10 +-
> >  kernel/kmod.c                       |    8 +-
> >  kernel/posix-timers.c               |    5 +-
> >  kernel/ptrace.c                     |   68 ++--
> >  kernel/signal.c                     |  737 +++++++++++++++++++++++++++--------
> >  net/9p/client.c                     |    6 +-
> >  net/sunrpc/svc.c                    |    3 -
> >  security/selinux/hooks.c            |   11 +-
> >  22 files changed, 677 insertions(+), 280 deletions(-)
>
> And, this patch adds 4 new locks:
>
> 	sighand_struct->action_lock
>
> 	signal_struct->ctrl_lock
> 	signal_struct->shared_siglock
>
> 	task_struct->siglock
>
> Nice ;) For what? This should be justified, imho.

Yes. I did the quick and dirty check (under kvm),

Before this series:

	[tst@myhost ~]$ time perl -wle '$SIG{HUP}=sub{}; kill HUP, $$ for 1..100_000'

	real    0m2.451s
	user    0m0.350s
	sys     0m2.097s
	[tst@myhost ~]$ time perl -wle '$SIG{HUP}=sub{}; kill HUP, $$ for 1..100_000'

	real    0m2.475s
	user    0m0.357s
	sys     0m2.117s
	[tst@myhost ~]$ time perl -wle '$SIG{HUP}=sub{}; kill HUP, $$ for 1..100_000'

	real    0m2.443s
	user    0m0.330s
	sys     0m2.113s

After:

	tst@myhost ~]$ time perl -wle '$SIG{HUP}=sub{}; kill HUP, $$ for 1..100_000'

	real    0m3.194s
	user    0m0.283s
	sys     0m2.910s
	[tst@myhost ~]$ time perl -wle '$SIG{HUP}=sub{}; kill HUP, $$ for 1..100_000'

	real    0m3.212s
	user    0m0.357s
	sys     0m2.853s
	[tst@myhost ~]$ time perl -wle '$SIG{HUP}=sub{}; kill HUP, $$ for 1..100_000'

	real    0m3.196s
	user    0m0.350s
	sys     0m2.846s

Doesn't like very good (may be only under kvm?). In fact I am really
surprised, I didn't expect the difference will be that noticeable.

Yes, yes, I understand that your goal is scalability, but still.

Oleg.

