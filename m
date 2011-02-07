Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab1BGSwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 13:52:25 -0500
Received: from sentry-three.sandia.gov ([132.175.109.17]:58309 "EHLO
	sentry-three.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab1BGSwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 13:52:22 -0500
X-WSS-ID: 0LG9GF6-0C-0YF-02
X-M-MSG: 
X-Server-Uuid: AF72F651-81B1-4134-BA8C-A8E1A4E620FF
Subject: Re: [PATCH 17/46] fs: Use rename lock and RCU for multi-step
 operations
From: "Jim Schutt" <jaschut@sandia.gov>
To: "Nick Piggin" <npiggin@gmail.com>
cc: "Yehuda Sadeh Weinraub" <yehudasa@gmail.com>,
        "Nick Piggin" <npiggin@kernel.dk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sage Weil" <sage@newdream.net>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
In-Reply-To: <AANLkTinmaojfNDYk1i4jMP33MmEQDur9XZvFp=qhV01e@mail.gmail.com>
References: <cover.1290852958.git.npiggin@kernel.dk>
 <d44ddcf1d1e0813b3ce2b3872c7c702a31b62894.1290852959.git.npiggin@kernel.dk>
 <AANLkTi=pj-pLYVSrU+6+BtioCWLod2ueZecNaap619fw@mail.gmail.com>
 <AANLkTik3ScP5rvR2bOXOEEH8SNZGg+xO6Gy32CW3XmU6@mail.gmail.com>
 <AANLkTinVP=OuJ-3u9pHdDuuKJoVrP4Unr5Dx1x=qHtXC@mail.gmail.com>
 <AANLkTimUjC8B0=nn5+yDshzp0hy6Zk1wxYHWEZbk83Tf@mail.gmail.com>
 <AANLkTi=or1Ya21Am8Dr4KVHgqkwvNxFwgn407=wxRfVa@mail.gmail.com>
 <AANLkTinmaojfNDYk1i4jMP33MmEQDur9XZvFp=qhV01e@mail.gmail.com>
Date: Mon, 7 Feb 2011 11:52:11 -0700
Message-ID: <1297104732.15475.60.camel@sale659.sandia.gov>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5)
X-TMWD-Spam-Summary: TS=20110207185212; ID=1; SEV=2.3.1;
 DFV=B2011020718; IFV=NA; AIF=B2011020718; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413031303230342E34443530334635442E303032422C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAACADrBBQCbCiIAAAAAAAAAAAAAAAAAAAB9
X-MMS-Spam-Filter-ID: B2011020718_5.03.0010
X-WSS-ID: 614EE0D60YW2554626-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2011-01-26 at 22:18 -0700, Nick Piggin wrote:
> On Wed, Jan 26, 2011 at 9:10 AM, Yehuda Sadeh Weinraub
> <yehudasa@gmail.com> wrote:
> > On Wed, Jan 19, 2011 at 2:32 PM, Nick Piggin <npiggin@gmail.com> wrote:
> >> On Thu, Jan 20, 2011 at 9:27 AM, Yehuda Sadeh Weinraub
> >> <yehudasa@gmail.com> wrote:
> >>> On Tue, Jan 18, 2011 at 2:42 PM, Nick Piggin <npiggin@gmail.com> wrote:
> >>>> On Wed, Jan 19, 2011 at 9:32 AM, Yehuda Sadeh Weinraub
> >>>
> >>>>> There's an issue with ceph as it references the
> >>>>> dentry->d_parent(->d_inode) at dentry_release(), so setting
> >>>>> dentry->d_parent to NULL here doesn't work with ceph. Though there is
> >>>>> some workaround for it, we would like to be sure that this one is
> >>>>> really required so that we don't exacerbate the ugliness. The
> >>>>> workaround is to keep a pointer to the parent inode in the private
> >>>>> dentry structure, which will be referenced only at the .release()
> >>>>> callback. This is clearly not ideal.
> >>>>
> >>>> Hmm, I'll have to think about it. Probably we can check for
> >>>> d_count == 0 rather than parent != NULL I think?
> >>>>
> >>>
> >>> That'll solve ceph's problem, don't know about how'd affect other
> >>> stuff. We'll need to know whether this is the solution, or whether
> >>> we'd need to introduce some other band aid fix.
> >>
> >> No I think it will work fine. Basically we just need to know whether
> >> we have been deleted, and if so then we restart rather than walking
> >> back up the parent.
> >>
> >> I'll send a patch in a few days. For the meantime, it's a rathe
> >> small window for ceph to worry about. So we'll have something
> >> before -rc2 which should be OK.
> >>
> >
> > I guess that it's a bit late for -rc2, should we assume that it'll be on -rc3?
> 
> Yeah, I'm sorry I've been travelling and a bit disconnected.
> 
> NFS folk are having a similar problem and looks like similar
> proposed fix will do it.
> 
> http://marc.info/?l=linux-fsdevel&m=129599823927039&w=2
> 
> So I think it is the best way to go to restore behaviour back to what
> filesystems already expect, to avoid more surprises in future.

I think the following BUG indicates I'm hitting this problem?
All I have to do to cause it is unlink a file.

My ceph client kernel is 8dbdea8444 (master branch) from 
  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
+ e41cdbb6c5 (master branch) + a3f5274e53 (unstable branch)
  from git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git

Are there any patches available for this I can test?

Thanks -- Jim

[ 1471.018973] BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
[ 1471.019909] IP: [<ffffffffa0748275>] ceph_dentry_release+0x31/0x148 [ceph]
[ 1471.019909] PGD 121fb9067 PUD 120520067 PMD 0 
[ 1471.019909] Oops: 0000 [#1] SMP 
[ 1471.019909] last sysfs file: /sys/block/md0/range
[ 1471.019909] CPU 1 
[ 1471.019909] Modules linked in: ceph libceph ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp i2c_dev i2c_core ext3 jbd be2iscsi iscsi_boot_sysfs iscsi]
[ 1471.019909] 
[ 1471.019909] Pid: 20, comm: kworker/1:1 Not tainted 2.6.38-rc3-00247-g4a9cd22 #13 0UR033/PowerEdge 1950
[ 1471.019909] RIP: 0010:[<ffffffffa0748275>]  [<ffffffffa0748275>] ceph_dentry_release+0x31/0x148 [ceph]
[ 1471.019909] RSP: 0018:ffff88012b09ba20  EFLAGS: 00010286
[ 1471.019909] RAX: 0000000000000000 RBX: ffff880129e3f0c0 RCX: ffff88011d448280
[ 1471.019909] RDX: 000000000000cbc0 RSI: 0000000000000001 RDI: ffff880129e3f0c0
[ 1471.019909] RBP: ffff88012b09ba60 R08: 0000000000000000 R09: ffff88012b09b9e0
[ 1471.019909] R10: 000001000000fa40 R11: ffff88012b09ba20 R12: ffff88011d448840
[ 1471.019909] R13: 0000000000000000 R14: ffff880129e3f0c0 R15: ffff88011d416000
[ 1471.019909] FS:  0000000000000000(0000) GS:ffff8800cfc40000(0000) knlGS:0000000000000000
[ 1471.019909] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1471.019909] CR2: 0000000000000030 CR3: 0000000128a1b000 CR4: 00000000000006e0
[ 1471.019909] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1471.019909] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1471.019909] Process kworker/1:1 (pid: 20, threadinfo ffff88012b09a000, task ffff88012b0a8000)
[ 1471.019909] Stack:
[ 1471.019909]  ffff88011d448840 ffff880128f89800 fffffffffffffffe ffff880129e3f0c0
[ 1471.019909]  ffff88011d448840 ffff880129fa70c0 0000000000000001 ffff880120f86000
[ 1471.019909]  ffff88012b09ba80 ffffffff81104007 ffff880129e3f0c0 ffff880129fa70c0
[ 1471.019909] Call Trace:
[ 1471.019909]  [<ffffffff81104007>] d_free+0x37/0x5c
[ 1471.019909]  [<ffffffff811048d4>] dentry_kill+0x11a/0x126
[ 1471.019909]  [<ffffffff8110523d>] dput+0xbc/0xc9
[ 1471.019909]  [<ffffffffa076099c>] ceph_mdsc_release_request+0xa9/0x117 [ceph]
[ 1471.019909]  [<ffffffffa07608f3>] ? ceph_mdsc_release_request+0x0/0x117 [ceph]
[ 1471.019909]  [<ffffffff811ab542>] kref_put+0x43/0x4f
[ 1471.019909]  [<ffffffffa075bab9>] ceph_mdsc_put_request+0x1c/0x1e [ceph]
[ 1471.019909]  [<ffffffffa075fc26>] dispatch+0xbdc/0x1282 [ceph]
[ 1471.019909]  [<ffffffff81192c70>] ? chksum_update+0x15/0x1d
[ 1471.019909]  [<ffffffff8118cf30>] ? crypto_shash_update+0x1f/0x21
[ 1471.019909]  [<ffffffff812cf943>] ? kernel_recvmsg+0x3a/0x46
[ 1471.019909]  [<ffffffffa0704c69>] ? ceph_tcp_recvmsg+0x4e/0x5b [libceph]
[ 1471.019909]  [<ffffffffa07066ce>] try_read+0x1363/0x1508 [libceph]
[ 1471.019909]  [<ffffffff81030af3>] ? should_resched+0xe/0x2f
[ 1471.019909]  [<ffffffffa0707318>] con_work+0xec/0x1426 [libceph]
[ 1471.019909]  [<ffffffff81030adb>] ? need_resched+0x23/0x2d
[ 1471.019909]  [<ffffffff8136f43a>] ? schedule+0x68d/0x6a7
[ 1471.019909]  [<ffffffff8104e9d5>] ? add_timer+0x1c/0x1e
[ 1471.019909]  [<ffffffff81058341>] ? queue_delayed_work_on+0xde/0xf2
[ 1471.019909]  [<ffffffff81056dc5>] process_one_work+0x16e/0x26a
[ 1471.019909]  [<ffffffffa070722c>] ? con_work+0x0/0x1426 [libceph]
[ 1471.019909]  [<ffffffff8105852d>] ? worker_thread+0x0/0x183
[ 1471.019909]  [<ffffffff810585f0>] worker_thread+0xc3/0x183
[ 1471.019909]  [<ffffffff8105be62>] kthread+0x72/0x7a
[ 1471.019909]  [<ffffffff81003914>] kernel_thread_helper+0x4/0x10
[ 1471.019909]  [<ffffffff8105bdf0>] ? kthread+0x0/0x7a
[ 1471.019909]  [<ffffffff81003910>] ? kernel_thread_helper+0x0/0x10
[ 1471.019909] Code: 41 56 41 55 41 54 53 48 83 ec 18 0f 1f 44 00 00 48 8b 47 18 45 31 ed 4c 8b 7f 78 49 89 fe 48 c7 45 d0 fe ff ff ff 48 39 c7 74 14 <4c> 8b 68 30 4d 85 ed 74 0b 49 8b 85 08 fd ff ff 48 89 45 d0 80 
[ 1471.019909] RIP  [<ffffffffa0748275>] ceph_dentry_release+0x31/0x148 [ceph]
[ 1471.019909]  RSP <ffff88012b09ba20>
[ 1471.019909] CR2: 0000000000000030
[ 1471.455942] ---[ end trace 782e52b3ca82de3c ]---
[ 1471.460581] BUG: unable to handle kernel paging request at fffffffffffffff8
[ 1471.461551] IP: [<ffffffff8105bb0e>] kthread_data+0x10/0x16
[ 1471.461551] PGD 1805067 PUD 1806067 PMD 0 
[ 1471.461551] Oops: 0000 [#2] SMP 
[ 1471.461551] last sysfs file: /sys/block/md0/range
[ 1471.461551] CPU 1 
[ 1471.461551] Modules linked in: ceph libceph ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge stp i2c_dev i2c_core ext3 jbd be2iscsi iscsi_boot_sysfs iscsi]
[ 1471.461551] 
[ 1471.461551] Pid: 20, comm: kworker/1:1 Tainted: G      D     2.6.38-rc3-00247-g4a9cd22 #13 0UR033/PowerEdge 1950
[ 1471.461551] RIP: 0010:[<ffffffff8105bb0e>]  [<ffffffff8105bb0e>] kthread_data+0x10/0x16
[ 1471.461551] RSP: 0018:ffff88012b09b5b8  EFLAGS: 00010092
[ 1471.461551] RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffff88012b0a8000
[ 1471.461551] RDX: 000000000000cbc0 RSI: 0000000000000001 RDI: ffff88012b0a8000
[ 1471.461551] RBP: ffff88012b09b5b8 R08: ffff8800cfc54f40 R09: dead000000200200
[ 1471.461551] R10: dead000000200200 R11: 0000000000000002 R12: 00007ffffffff000
[ 1471.461551] R13: 0000000000000001 R14: ffff8800cfc51cc0 R15: 0000000000000001
[ 1471.461551] FS:  0000000000000000(0000) GS:ffff8800cfc40000(0000) knlGS:0000000000000000
[ 1471.461551] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1471.461551] CR2: fffffffffffffff8 CR3: 0000000128a1b000 CR4: 00000000000006e0
[ 1471.461551] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1471.461551] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1471.461551] Process kworker/1:1 (pid: 20, threadinfo ffff88012b09a000, task ffff88012b0a8000)
[ 1471.461551] Stack:
[ 1471.461551]  ffff88012b09b5e8 ffffffff810583d7 ffff88012b09b5f8 0000000000000001
[ 1471.461551]  00007ffffffff000 0000000000011cc0 ffff88012b09b6f8 ffffffff8136ef22
[ 1471.461551]  ffff88012b09b618 ffff88012b0a8000 ffff88012b6b0850 ffff88012b0a83a0
[ 1471.461551] Call Trace:
[ 1471.461551]  [<ffffffff810583d7>] wq_worker_sleeping+0x1a/0x87
[ 1471.461551]  [<ffffffff8136ef22>] schedule+0x175/0x6a7
[ 1471.461551]  [<ffffffff8108b8d0>] ? call_rcu_sched+0x15/0x17
[ 1471.461551]  [<ffffffff810e8b0e>] ? __slab_free+0x52/0xe9
[ 1471.461551]  [<ffffffff8108b8d0>] ? call_rcu_sched+0x15/0x17
[ 1471.461551]  [<ffffffff810443f2>] ? release_task+0x32b/0x343
[ 1471.461551]  [<ffffffff810601df>] ? switch_task_namespaces+0x1d/0x51
[ 1471.461551]  [<ffffffff810456cf>] do_exit+0x678/0x692
[ 1471.461551]  [<ffffffff81371b59>] oops_end+0xb7/0xbf
[ 1471.461551]  [<ffffffff81026de1>] no_context+0x1fa/0x209
[ 1471.461551]  [<ffffffff81027076>] __bad_area_nosemaphore+0x187/0x1aa
[ 1471.461551]  [<ffffffff810b517d>] ? __pagevec_free+0x70/0x8c
[ 1471.461551]  [<ffffffff810b8ab2>] ? hpage_nr_pages+0x1a/0x2c
[ 1471.461551]  [<ffffffff81027123>] bad_area_nosemaphore+0x13/0x18
[ 1471.461551]  [<ffffffff81373aa5>] do_page_fault+0x175/0x325
[ 1471.461551]  [<ffffffff810afe20>] ? find_get_pages+0x44/0xbb
[ 1471.461551]  [<ffffffffa075070b>] ? list_add+0x11/0x13 [ceph]
[ 1471.461551]  [<ffffffffa0753773>] ? ceph_put_cap+0xf6/0x12d [ceph]
[ 1471.461551]  [<ffffffff810b9611>] ? pagevec_lookup+0x24/0x2d
[ 1471.461551]  [<ffffffff813710df>] page_fault+0x1f/0x30
[ 1471.461551]  [<ffffffffa0748275>] ? ceph_dentry_release+0x31/0x148 [ceph]
[ 1471.461551]  [<ffffffff81104007>] d_free+0x37/0x5c
[ 1471.461551]  [<ffffffff811048d4>] dentry_kill+0x11a/0x126
[ 1471.461551]  [<ffffffff8110523d>] dput+0xbc/0xc9
[ 1471.461551]  [<ffffffffa076099c>] ceph_mdsc_release_request+0xa9/0x117 [ceph]
[ 1471.461551]  [<ffffffffa07608f3>] ? ceph_mdsc_release_request+0x0/0x117 [ceph]
[ 1471.461551]  [<ffffffff811ab542>] kref_put+0x43/0x4f
[ 1471.461551]  [<ffffffffa075bab9>] ceph_mdsc_put_request+0x1c/0x1e [ceph]
[ 1471.461551]  [<ffffffffa075fc26>] dispatch+0xbdc/0x1282 [ceph]
[ 1471.461551]  [<ffffffff81192c70>] ? chksum_update+0x15/0x1d
[ 1471.461551]  [<ffffffff8118cf30>] ? crypto_shash_update+0x1f/0x21
[ 1471.461551]  [<ffffffff812cf943>] ? kernel_recvmsg+0x3a/0x46
[ 1471.461551]  [<ffffffffa0704c69>] ? ceph_tcp_recvmsg+0x4e/0x5b [libceph]
[ 1471.461551]  [<ffffffffa07066ce>] try_read+0x1363/0x1508 [libceph]
[ 1471.461551]  [<ffffffff81030af3>] ? should_resched+0xe/0x2f
[ 1471.461551]  [<ffffffffa0707318>] con_work+0xec/0x1426 [libceph]
[ 1471.461551]  [<ffffffff81030adb>] ? need_resched+0x23/0x2d
[ 1471.461551]  [<ffffffff8136f43a>] ? schedule+0x68d/0x6a7
[ 1471.461551]  [<ffffffff8104e9d5>] ? add_timer+0x1c/0x1e
[ 1471.461551]  [<ffffffff81058341>] ? queue_delayed_work_on+0xde/0xf2
[ 1471.461551]  [<ffffffff81056dc5>] process_one_work+0x16e/0x26a
[ 1471.461551]  [<ffffffffa070722c>] ? con_work+0x0/0x1426 [libceph]
[ 1471.461551]  [<ffffffff8105852d>] ? worker_thread+0x0/0x183
[ 1471.461551]  [<ffffffff810585f0>] worker_thread+0xc3/0x183
[ 1471.461551]  [<ffffffff8105be62>] kthread+0x72/0x7a
[ 1471.461551]  [<ffffffff81003914>] kernel_thread_helper+0x4/0x10
[ 1471.461551]  [<ffffffff8105bdf0>] ? kthread+0x0/0x7a
[ 1471.461551]  [<ffffffff81003910>] ? kernel_thread_helper+0x0/0x10
[ 1471.461551] Code: e5 0f 1f 44 00 00 65 48 8b 04 25 80 b5 00 00 48 8b 80 48 03 00 00 8b 40 f0 c9 c3 55 48 89 e5 0f 1f 44 00 00 48 8b 87 48 03 00 00 <48> 8b 40 f8 c9 c3 55 48 89 e5 0f 1f 44 00 00 48 8d 47 08 c7 07 
[ 1471.461551] RIP  [<ffffffff8105bb0e>] kthread_data+0x10/0x16
[ 1471.461551]  RSP <ffff88012b09b5b8>
[ 1471.461551] CR2: fffffffffffffff8
[ 1471.461551] ---[ end trace 782e52b3ca82de3d ]---
[ 1471.461551] Fixing recursive fault but reboot is needed!

> 
> Thanks,
> Nick
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


