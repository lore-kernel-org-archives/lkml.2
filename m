Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab2DCHxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 03:53:50 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39244 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab2DCHxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 03:53:48 -0400
Date: Tue, 3 Apr 2012 09:53:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] Prevent crash on unset sysfs group attributes
Message-ID: <20120403075343.GE26826@gmail.com>
References: <20120402165036.2bc987ad@pluto.restena.lu>
 <m17gxyklfm.fsf@fess.ebiederm.org>
 <20120402213440.49e9de74@neptune>
 <1333401898.2960.78.camel@laptop>
 <1333403193.2960.80.camel@laptop>
 <20120403060252.GA27084@gmail.com>
 <20120403081735.78ca3bb3@pluto.restena.lu>
 <m1d37pgugy.fsf@fess.ebiederm.org>
 <20120403071543.GA17502@gmail.com>
 <20120403094107.4f641ed8@pluto.restena.lu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120403094107.4f641ed8@pluto.restena.lu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bruno Prémont <bonbons@linux-vserver.org> wrote:

> Do not let the kernel crash when a device is registered with
> sysfs while group attributes are not set (aka NULL).
> 
> Warn about the offender with some information about the offending
> device.
> 
> This would warn instead of trying NULL pointer deref like:
>  BUG: unable to handle kernel NULL pointer dereference at
> (null) IP: [<ffffffff81152673>] internal_create_group+0x83/0x1a0
>  PGD 0 
>  Oops: 0000 [#1] SMP 
>  CPU 0 
>  Modules linked in:
> 
>  Pid: 1, comm: swapper/0 Not tainted 3.4.0-rc1-x86_64 #3 HP ProLiant
>  DL360 G4 RIP: 0010:[<ffffffff81152673>]  [<ffffffff81152673>]
>  internal_create_group+0x83/0x1a0 RSP: 0018:ffff88019485fd70  EFLAGS:
>  00010202 RAX: 0000000000000001 RBX: 0000000000000000 RCX:
>  0000000000000001 RDX: ffff880192e99908 RSI: ffff880192e99630 RDI:
>  ffffffff81a26c60 RBP: ffff88019485fdc0 R08: 0000000000000000 R09:
>  0000000000000000 R10: ffff880192e99908 R11: 0000000000000000 R12:
>  ffffffff81a16a00 R13: ffff880192e99908 R14: ffffffff81a16900 R15:
>  0000000000000000 FS:  0000000000000000(0000) GS:ffff88019bc00000(0000)
>  knlGS:0000000000000000 CS:  0010 DS: 0000 ES: 0000 CR0:
>  000000008005003b CR2: 0000000000000000 CR3: 0000000001a0c000 CR4:
>  00000000000007f0 DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>  0000000000000000 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>  0000000000000400 Process swapper/0 (pid: 1, threadinfo
>  ffff88019485e000, task ffff880194878000) Stack:
>   ffff88019485fdd0 ffff880192da9d60 0000000000000000 ffff880192e99908
>   ffff880192e995d8 0000000000000001 ffffffff81a16a00 ffff880192da9d60
>   0000000000000000 0000000000000000 ffff88019485fdd0 ffffffff811527be
>  Call Trace:
>   [<ffffffff811527be>] sysfs_create_group+0xe/0x10
>   [<ffffffff81376ca6>] device_add_groups+0x46/0x80
>   [<ffffffff81377d3d>] device_add+0x46d/0x6a0
>   ...
> 
> Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
> ---
> 
> On Tue, 3 Apr 2012 09:15:43 Ingo Molnar wrote:
> > > > Greg, is this ok for you or should the check be moved out to 
> > > > calling internal_create_group()?
> > > 
> > > Please put changes in internal_create_group where all of the 
> > > rest of the checks are.
> > 
> > So you *do* agree that a check in a generic place is useful 
> > after all? ;-)
> > 
> > > We should do something like:
> > > if (!grp->attrs) {
> > > 	WARN(1, "sysfs: idiot subsystem did not include attrs for group: %s/%s\n"
> > >         	kobj->name, grp->name?"":grp->name);
> > > 	return -EINVAL;
> > > }
> > >
> > > As it stands your patch is horrible it leaves sysfs in an 
> > > inconsistent state.  Creating the directory and leaving it 
> > > there.  Not returning an error code.  It looks like there are 
> > > all kinds of weird problems that removing the group or 
> > > updating the group could get into if we go with your patch.
> > 
> > This is actually a sensible suggestion. Bruno, mind updating 
> > your patch to do something like this? Assuming Greg agrees with 
> > putting the check/warning there.
> 
> Here come a respin with Eric's suggestion.
> 
> In my case it would show the following result:
> 
> [    0.975025] ------------[ cut here ]------------
> [    0.977507] WARNING: at /data/kernel/linux-2.6-git/fs/sysfs/group.c:72 internal_create_group+0x18c/0x1f0()
> [    0.981932] Hardware name: ProLiant DL360 G4
> [    0.983916] sysfs: attrs not set by subsystem for group: cpu/
> [    0.987030] Modules linked in:
> [    0.988664] Pid: 1, comm: swapper/0 Not tainted 3.4.0-rc1-x86_64 #6
> [    0.991639] Call Trace:
> [    0.992911]  [<ffffffff8104d11a>] warn_slowpath_common+0x7a/0xb0
> [    0.995903]  [<ffffffff8104d1f1>] warn_slowpath_fmt+0x41/0x50
> [    0.998593]  [<ffffffff8115277c>] internal_create_group+0x18c/0x1f0
> [    1.001366]  [<ffffffff8115280e>] sysfs_create_group+0xe/0x10
> [    1.003898]  [<ffffffff81376cf6>] device_add_groups+0x46/0x80
> [    1.006955]  [<ffffffff81377d8d>] device_add+0x46d/0x6a0
> [    1.009565]  [<ffffffff813778e1>] ? device_private_init+0x51/0x90
> [    1.012806]  [<ffffffff81a98975>] ? utsname_sysctl_init+0x14/0x14
> [    1.015866]  [<ffffffff810a7228>] pmu_dev_alloc+0x98/0xe0
> [    1.018234]  [<ffffffff81a98975>] ? utsname_sysctl_init+0x14/0x14
> [    1.021408]  [<ffffffff81a989c0>] perf_event_sysfs_init+0x4b/0x9a
> [    1.025517]  [<ffffffff810002ad>] do_one_initcall+0x3d/0x170
> [    1.029102]  [<ffffffff81a85cbd>] kernel_init+0x12d/0x1be
> [    1.031844]  [<ffffffff81a85505>] ? rdinit_setup+0x28/0x28
> [    1.034571]  [<ffffffff815f3794>] kernel_thread_helper+0x4/0x10
> [    1.037734]  [<ffffffff81a85b90>] ? start_kernel+0x373/0x373
> [    1.040790]  [<ffffffff815f3790>] ? gs_change+0xb/0xb
> [    1.043354] ---[ end trace 319c95c486d7d9cd ]---
> [    1.045536] ------------[ cut here ]------------
> [    1.047640] WARNING: at /data/kernel/linux-2.6-git/kernel/events/core.c:7144 perf_event_sysfs_init+0x70/0x9a()
> [    1.052595] Hardware name: ProLiant DL360 G4
> [    1.055027] Failed to register pmu: cpu, reason -22
> [    1.057720] Modules linked in:
> [    1.059284] Pid: 1, comm: swapper/0 Tainted: G        W    3.4.0-rc1-x86_64 #6
> [    1.062785] Call Trace:
> [    1.064094]  [<ffffffff8104d11a>] warn_slowpath_common+0x7a/0xb0
> [    1.067192]  [<ffffffff81a98975>] ? utsname_sysctl_init+0x14/0x14
> [    1.070305]  [<ffffffff8104d1f1>] warn_slowpath_fmt+0x41/0x50
> [    1.073129]  [<ffffffff810a7244>] ? pmu_dev_alloc+0xb4/0xe0
> [    1.075771]  [<ffffffff81a989e5>] perf_event_sysfs_init+0x70/0x9a
> [    1.078878]  [<ffffffff810002ad>] do_one_initcall+0x3d/0x170
> [    1.081879]  [<ffffffff81a85cbd>] kernel_init+0x12d/0x1be
> [    1.084714]  [<ffffffff81a85505>] ? rdinit_setup+0x28/0x28
> [    1.087754]  [<ffffffff815f3794>] kernel_thread_helper+0x4/0x10
> [    1.090639]  [<ffffffff81a85b90>] ? start_kernel+0x373/0x373
> [    1.093372]  [<ffffffff815f3790>] ? gs_change+0xb/0xb
> [    1.096312] ---[ end trace 319c95c486d7d9ce ]---
> 
> 
> 
>  fs/sysfs/group.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
> index dd1701c..2df555c 100644
> --- a/fs/sysfs/group.c
> +++ b/fs/sysfs/group.c
> @@ -67,7 +67,11 @@ static int internal_create_group(struct kobject *kobj, int update,
>  	/* Updates may happen before the object has been instantiated */
>  	if (unlikely(update && !kobj->sd))
>  		return -EINVAL;
> -
> +	if (!grp->attrs) {
> +		WARN(1, "sysfs: attrs not set by subsystem for group: %s/%s\n",
> +			kobj->name, grp->name ? "" : grp->name);
> +		return -EINVAL;
> +	}

Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
