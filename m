Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab1JXUbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 16:31:07 -0400
Received: from ping.pong.ch ([217.197.135.101]:39782 "EHLO ping.pong.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755520Ab1JXUbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 16:31:04 -0400
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Oct 2011 16:31:03 EDT
From: Gaudenz Steinlin <gaudenz@debian.org>
To: Tejun Heo <tj@kernel.org>, Matthijs Kooijman <matthijs@stdin.nl>,
        linux-kernel@vger.kernel.org
Cc: Jameson Graef Rollins <jrollins@finestructure.net>,
        Jonathan Nieder <jrnieder@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Amit Shah <amit.shah@redhat.com>, David Zeuthen <zeuthen@gmail.com>,
        Martin Pitt <martin.pitt@ubuntu.com>
Subject: Re: [regression] CD-ROM polling blocks suspend on some machines (Re: [PATCH 1/2] cdrom: always check_disk_change() on open)
In-Reply-To: <20110911040826.GP29319@htj.dyndns.org>
References: <20110406121920.GC4142@mtj.dyndns.org> <20110903221456.GA2877@elie> <20110904024244.GB3083@htj.dyndns.org> <87y5y37o7h.fsf@servo.factory.finestructure.net> <20110906174524.GN18425@mtj.dyndns.org> <20110907085037.GX10237@login.drsnuggles.stderr.nl> <20110911040826.GP29319@htj.dyndns.org>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 24 Oct 2011 22:25:03 +0200
Message-ID: <87r5222l40.fsf@meteor.durcheinandertal.local.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


Hi

I stumbled upon this old thread while debugging a hung cdrom_id task on
my Thinkpad X200.=20

On Sun, 11 Sep 2011 13:08:26 +0900, Tejun Heo <tj@kernel.org> wrote:
> On Wed, Sep 07, 2011 at 10:50:37AM +0200, Matthijs Kooijman wrote:
> > Hi Tejun,
> >=20
> > > Also, can you please explain the steps needed to trigger this problem?
> > I'm not the one that supplied the backtraces, but I'm having the same
> > problem. I did a fairly extensive writeup on the Debian bug report,
> > perhaps this could (help to) answer your question:
> >=20
> > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D628600#23
> >=20
> > I'll leave the other questions to Jameson for now.
>=20
> Hmm... so, hibernation, disk event or udev isn't the cause.  Device
> removal somehow ends up with stalled request queue hanging event check
> which eventually propagates as failed freeze during hibernation
> attempt.

Yes this seems to be a race condition or a deadlock while removing the
cdrom drive when undocking the notebock from the dock which contains the
cd drive. The process is already unkillable before any attempt to
suspend the machine.

Please see the requested dmesg output below. I can also provide
additional debugging information if needed.

>=20
> Can someone please attach dmesg output cdrom_id is hung after dock
> removal and also the output of sysrq-t?
>=20

Dmesg output after a faild suspend attempt:
Oct 24 21:12:05 meteor kernel: [84916.468058] Freezing of tasks failed afte=
r 20.01 seconds (1 tasks refusing to freeze, wq_busy=3D0):
Oct 24 21:12:05 meteor kernel: [84916.468142] cdrom_id        D ffff8800a5e=
1a970     0 26723  26720 0x00800004
Oct 24 21:12:05 meteor kernel: [84916.468149]  ffff8800a5e1a970 00000000000=
00086 ffff8800a5e1ad28 00ff88013bc92800
Oct 24 21:12:05 meteor kernel: [84916.468157]  ffff88010ee8e300 00000000000=
12800 ffff88012a539fd8 ffff88012a539fd8
Oct 24 21:12:05 meteor kernel: [84916.468165]  0000000000012800 ffff8800a5e=
1a970 0000000000012800 0000000000012800
Oct 24 21:12:05 meteor kernel: [84916.468173] Call Trace:
Oct 24 21:12:05 meteor kernel: [84916.468179]  [<ffffffff81335bb1>] ? sched=
ule_timeout+0x2d/0xd7
Oct 24 21:12:05 meteor kernel: [84916.468186]  [<ffffffff81038189>] ? test_=
tsk_need_resched+0xe/0x17
Oct 24 21:12:05 meteor kernel: [84916.468192]  [<ffffffff8133598b>] ? wait_=
for_common+0x9d/0x116
Oct 24 21:12:05 meteor kernel: [84916.468197]  [<ffffffff8103f0a4>] ? try_t=
o_wake_up+0x199/0x199
Oct 24 21:12:05 meteor kernel: [84916.468203]  [<ffffffff8105b266>] ? start=
_flush_work+0xec/0x103
Oct 24 21:12:05 meteor kernel: [84916.468208]  [<ffffffff8105b57c>] ? flush=
_work+0x24/0x2c
Oct 24 21:12:05 meteor kernel: [84916.468214]  [<ffffffff8105ae8f>] ? do_wo=
rk_for_cpu+0x1b/0x1b
Oct 24 21:12:05 meteor kernel: [84916.468220]  [<ffffffff81199092>] ? disk_=
clear_events+0x86/0xe4
Oct 24 21:12:05 meteor kernel: [84916.468230]  [<ffffffff81121ef2>] ? check=
_disk_change+0x22/0x50
Oct 24 21:12:05 meteor kernel: [84916.468235]  [<ffffffffa0a3d051>] ? cdrom=
_open+0x45/0x4aa [cdrom]
Oct 24 21:12:05 meteor kernel: [84916.468238]  [<ffffffff811a484d>] ? kobje=
ct_get+0x12/0x17
Oct 24 21:12:05 meteor kernel: [84916.468242]  [<ffffffff81197c4d>] ? get_d=
isk+0x6d/0x8d
Oct 24 21:12:05 meteor kernel: [84916.468245]  [<ffffffff8103840a>] ? shoul=
d_resched+0x5/0x24
Oct 24 21:12:05 meteor kernel: [84916.468248]  [<ffffffff813358d7>] ? _cond=
_resched+0x9/0x20
Oct 24 21:12:05 meteor kernel: [84916.468252]  [<ffffffff8124b753>] ? kobj_=
lookup+0x13a/0x174
Oct 24 21:12:05 meteor kernel: [84916.468255]  [<ffffffff811a484d>] ? kobje=
ct_get+0x12/0x17
Oct 24 21:12:05 meteor kernel: [84916.468259]  [<ffffffffa0a4485d>] ? sr_bl=
ock_open+0x93/0xbc [sr_mod]
Oct 24 21:12:05 meteor kernel: [84916.468263]  [<ffffffff81122c95>] ? __blk=
dev_get+0xe3/0x380
Oct 24 21:12:05 meteor kernel: [84916.468266]  [<ffffffff810cf9c5>] ? set_p=
te_at+0x5/0x8
Oct 24 21:12:05 meteor kernel: [84916.468269]  [<ffffffff811231d9>] ? blkde=
v_get+0x2a7/0x2a7
Oct 24 21:12:05 meteor kernel: [84916.468272]  [<ffffffff811230f9>] ? blkde=
v_get+0x1c7/0x2a7
Oct 24 21:12:05 meteor kernel: [84916.468276]  [<ffffffff811231d9>] ? blkde=
v_get+0x2a7/0x2a7
Oct 24 21:12:05 meteor kernel: [84916.468279]  [<ffffffff810fa612>] ? __den=
try_open+0x182/0x29c
Oct 24 21:12:05 meteor kernel: [84916.468283]  [<ffffffff811038c3>] ? dget+=
0x12/0x1e
Oct 24 21:12:05 meteor kernel: [84916.468286]  [<ffffffff81105b45>] ? do_la=
st+0x46d/0x584
Oct 24 21:12:05 meteor kernel: [84916.468289]  [<ffffffff81106ece>] ? path_=
openat+0xc7/0x349
Oct 24 21:12:05 meteor kernel: [84916.468292]  [<ffffffff810d0562>] ? tlb_f=
lush_mmu+0x37/0x50
Oct 24 21:12:05 meteor kernel: [84916.468296]  [<ffffffff8110717c>] ? do_fi=
lp_open+0x2c/0x72
Oct 24 21:12:05 meteor kernel: [84916.468299]  [<ffffffff813358d7>] ? _cond=
_resched+0x9/0x20
Oct 24 21:12:05 meteor kernel: [84916.468303]  [<ffffffff811aca91>] ? __str=
ncpy_from_user+0x19/0x4a
Oct 24 21:12:05 meteor kernel: [84916.468306]  [<ffffffff811104ec>] ? alloc=
_fd+0x69/0x110
Oct 24 21:12:05 meteor kernel: [84916.468309]  [<ffffffff810fb41c>] ? do_sy=
s_open+0x5f/0xe6
Oct 24 21:12:05 meteor kernel: [84916.468313]  [<ffffffff8133bd12>] ? syste=
m_call_fastpath+0x16/0x1b
Oct 24 21:12:05 meteor kernel: [84916.468324]=20
Oct 24 21:12:05 meteor kernel: [84916.468325] Restarting tasks ... done.

Output of sysrq-w (blocked tasks):
Oct 24 21:29:12 meteor kernel: [85943.671066] SysRq : Show Blocked State
Oct 24 21:29:12 meteor kernel: [85943.671078]   task                       =
 PC stack   pid father
Oct 24 21:29:12 meteor kernel: [85943.671212] kworker/1:0     D ffff88012ff=
aa080     0 25836      2 0x00000000
Oct 24 21:29:12 meteor kernel: [85943.671225]  ffff88012ffaa080 00000000000=
00046 ffff8801074bb000 ffffffff81071f28
Oct 24 21:29:12 meteor kernel: [85943.671237]  ffff88011902e1c0 00000000000=
12800 ffff880135eaffd8 ffff880135eaffd8
Oct 24 21:29:12 meteor kernel: [85943.671249]  0000000000012800 ffff88012ff=
aa080 0000000000012800 0000000000012800
Oct 24 21:29:12 meteor kernel: [85943.671261] Call Trace:
Oct 24 21:29:12 meteor kernel: [85943.671278]  [<ffffffff81071f28>] ? arch_=
local_irq_save+0x14/0x1d
Oct 24 21:29:12 meteor kernel: [85943.671292]  [<ffffffff81335c24>] ? sched=
ule_timeout+0xa0/0xd7
Oct 24 21:29:12 meteor kernel: [85943.671303]  [<ffffffff81052bcf>] ? run_t=
imer_softirq+0x28a/0x28a
Oct 24 21:29:12 meteor kernel: [85943.671312]  [<ffffffff8133598b>] ? wait_=
for_common+0x9d/0x116
Oct 24 21:29:12 meteor kernel: [85943.671322]  [<ffffffff8103f0a4>] ? try_t=
o_wake_up+0x199/0x199
Oct 24 21:29:12 meteor kernel: [85943.671330]  [<ffffffff81336a8d>] ? _raw_=
spin_lock_irq+0xd/0x1a
Oct 24 21:29:12 meteor kernel: [85943.671340]  [<ffffffff81195532>] ? blk_e=
xecute_rq+0xa5/0xe7
Oct 24 21:29:12 meteor kernel: [85943.671350]  [<ffffffff8112098e>] ? bio_p=
hys_segments+0xf/0x14
Oct 24 21:29:12 meteor kernel: [85943.671361]  [<ffffffff811928ee>] ? blk_r=
q_bio_prep+0x39/0x6c
Oct 24 21:29:12 meteor kernel: [85943.671371]  [<ffffffff81195177>] ? blk_r=
q_map_kern+0xef/0x11f
Oct 24 21:29:12 meteor kernel: [85943.671457]  [<ffffffffa00959a0>] ? scsi_=
execute+0xfb/0x14d [scsi_mod]
Oct 24 21:29:12 meteor kernel: [85943.671491]  [<ffffffffa0095a7b>] ? scsi_=
execute_req+0x89/0xb9 [scsi_mod]
Oct 24 21:29:12 meteor kernel: [85943.671502]  [<ffffffff81197af0>] ? disk_=
events_set_dfl_poll_msecs+0x44/0x44
Oct 24 21:29:12 meteor kernel: [85943.671514]  [<ffffffffa0a442c2>] ? sr_ch=
eck_events+0x9a/0x230 [sr_mod]
Oct 24 21:29:12 meteor kernel: [85943.671525]  [<ffffffff81030008>] ? compo=
und_head+0x3/0x10
Oct 24 21:29:12 meteor kernel: [85943.671537]  [<ffffffffa0a3a041>] ? cdrom=
_check_events+0xf/0x22 [cdrom]
Oct 24 21:29:12 meteor kernel: [85943.671546]  [<ffffffff81197b2a>] ? disk_=
events_workfn+0x3a/0xd5
Oct 24 21:29:12 meteor kernel: [85943.671555]  [<ffffffff81197af0>] ? disk_=
events_set_dfl_poll_msecs+0x44/0x44
Oct 24 21:29:12 meteor kernel: [85943.671566]  [<ffffffff8105b943>] ? proce=
ss_one_work+0x193/0x28f
Oct 24 21:29:12 meteor kernel: [85943.671575]  [<ffffffff8105cacf>] ? worke=
r_thread+0xef/0x172
Oct 24 21:29:12 meteor kernel: [85943.671584]  [<ffffffff8105c9e0>] ? manag=
e_workers.clone.17+0x15b/0x15b
Oct 24 21:29:12 meteor kernel: [85943.671593]  [<ffffffff8105c9e0>] ? manag=
e_workers.clone.17+0x15b/0x15b
Oct 24 21:29:12 meteor kernel: [85943.671603]  [<ffffffff8105fc0b>] ? kthre=
ad+0x7a/0x82
Oct 24 21:29:12 meteor kernel: [85943.671613]  [<ffffffff8133ce24>] ? kerne=
l_thread_helper+0x4/0x10
Oct 24 21:29:12 meteor kernel: [85943.671622]  [<ffffffff8105fb91>] ? kthre=
ad_worker_fn+0x149/0x149
Oct 24 21:29:12 meteor kernel: [85943.671630]  [<ffffffff8133ce20>] ? gs_ch=
ange+0x13/0x13
Oct 24 21:29:12 meteor kernel: [85943.671637] cdrom_id        D ffff8800a5e=
1a970     0 26723  26720 0x00000004
Oct 24 21:29:12 meteor kernel: [85943.671647]  ffff8800a5e1a970 00000000000=
00086 ffff8800a5e1ad28 00ff88013bc92800
Oct 24 21:29:12 meteor kernel: [85943.671659]  ffff88010ee8e300 00000000000=
12800 ffff88012a539fd8 ffff88012a539fd8
Oct 24 21:29:12 meteor kernel: [85943.671671]  0000000000012800 ffff8800a5e=
1a970 0000000000012800 0000000000012800
Oct 24 21:29:12 meteor kernel: [85943.671682] Call Trace:
Oct 24 21:29:12 meteor kernel: [85943.671692]  [<ffffffff81335bb1>] ? sched=
ule_timeout+0x2d/0xd7
Oct 24 21:29:12 meteor kernel: [85943.671702]  [<ffffffff81038189>] ? test_=
tsk_need_resched+0xe/0x17
Oct 24 21:29:12 meteor kernel: [85943.671712]  [<ffffffff8133598b>] ? wait_=
for_common+0x9d/0x116
Oct 24 21:29:12 meteor kernel: [85943.671720]  [<ffffffff8103f0a4>] ? try_t=
o_wake_up+0x199/0x199
Oct 24 21:29:12 meteor kernel: [85943.671729]  [<ffffffff8105b266>] ? start=
_flush_work+0xec/0x103
Oct 24 21:29:12 meteor kernel: [85943.671738]  [<ffffffff8105b57c>] ? flush=
_work+0x24/0x2c
Oct 24 21:29:12 meteor kernel: [85943.671746]  [<ffffffff8105ae8f>] ? do_wo=
rk_for_cpu+0x1b/0x1b
Oct 24 21:29:12 meteor kernel: [85943.671755]  [<ffffffff81199092>] ? disk_=
clear_events+0x86/0xe4
Oct 24 21:29:12 meteor kernel: [85943.671766]  [<ffffffff81121ef2>] ? check=
_disk_change+0x22/0x50
Oct 24 21:29:12 meteor kernel: [85943.671778]  [<ffffffffa0a3d051>] ? cdrom=
_open+0x45/0x4aa [cdrom]
Oct 24 21:29:12 meteor kernel: [85943.671787]  [<ffffffff811a484d>] ? kobje=
ct_get+0x12/0x17
Oct 24 21:29:12 meteor kernel: [85943.671796]  [<ffffffff81197c4d>] ? get_d=
isk+0x6d/0x8d
Oct 24 21:29:12 meteor kernel: [85943.671805]  [<ffffffff8103840a>] ? shoul=
d_resched+0x5/0x24
Oct 24 21:29:12 meteor kernel: [85943.671813]  [<ffffffff813358d7>] ? _cond=
_resched+0x9/0x20
Oct 24 21:29:12 meteor kernel: [85943.671824]  [<ffffffff8124b753>] ? kobj_=
lookup+0x13a/0x174
Oct 24 21:29:12 meteor kernel: [85943.671833]  [<ffffffff811a484d>] ? kobje=
ct_get+0x12/0x17
Oct 24 21:29:12 meteor kernel: [85943.671844]  [<ffffffffa0a4485d>] ? sr_bl=
ock_open+0x93/0xbc [sr_mod]
Oct 24 21:29:12 meteor kernel: [85943.671854]  [<ffffffff81122c95>] ? __blk=
dev_get+0xe3/0x380
Oct 24 21:29:12 meteor kernel: [85943.671864]  [<ffffffff810cf9c5>] ? set_p=
te_at+0x5/0x8
Oct 24 21:29:12 meteor kernel: [85943.671872]  [<ffffffff811231d9>] ? blkde=
v_get+0x2a7/0x2a7
Oct 24 21:29:12 meteor kernel: [85943.671880]  [<ffffffff811230f9>] ? blkde=
v_get+0x1c7/0x2a7
Oct 24 21:29:12 meteor kernel: [85943.671889]  [<ffffffff811231d9>] ? blkde=
v_get+0x2a7/0x2a7
Oct 24 21:29:12 meteor kernel: [85943.671900]  [<ffffffff810fa612>] ? __den=
try_open+0x182/0x29c
Oct 24 21:29:12 meteor kernel: [85943.671910]  [<ffffffff811038c3>] ? dget+=
0x12/0x1e
Oct 24 21:29:12 meteor kernel: [85943.671918]  [<ffffffff81105b45>] ? do_la=
st+0x46d/0x584
Oct 24 21:29:12 meteor kernel: [85943.671927]  [<ffffffff81106ece>] ? path_=
openat+0xc7/0x349
Oct 24 21:29:12 meteor kernel: [85943.671936]  [<ffffffff810d0562>] ? tlb_f=
lush_mmu+0x37/0x50
Oct 24 21:29:12 meteor kernel: [85943.671945]  [<ffffffff8110717c>] ? do_fi=
lp_open+0x2c/0x72
Oct 24 21:29:12 meteor kernel: [85943.671954]  [<ffffffff813358d7>] ? _cond=
_resched+0x9/0x20
Oct 24 21:29:12 meteor kernel: [85943.671964]  [<ffffffff811aca91>] ? __str=
ncpy_from_user+0x19/0x4a
Oct 24 21:29:12 meteor kernel: [85943.671973]  [<ffffffff811104ec>] ? alloc=
_fd+0x69/0x110
Oct 24 21:29:12 meteor kernel: [85943.671983]  [<ffffffff810fb41c>] ? do_sy=
s_open+0x5f/0xe6
Oct 24 21:29:12 meteor kernel: [85943.671993]  [<ffffffff8133bd12>] ? syste=
m_call_fastpath+0x16/0x1b
Oct 24 21:29:12 meteor kernel: [85943.672023] Sched Debug Version: v0.10, 3=
.0.0-1-amd64 #1
Oct 24 21:29:12 meteor kernel: [85943.672029] ktime                        =
           : 85943672.020455
Oct 24 21:29:12 meteor kernel: [85943.672035] sched_clk                    =
           : 3956869.639252
Oct 24 21:29:12 meteor kernel: [85943.672041] cpu_clk                      =
           : 85943672.020051
Oct 24 21:29:12 meteor kernel: [85943.672046] jiffies                      =
           : 4316378213
Oct 24 21:29:12 meteor kernel: [85943.672051] sched_clock_stable           =
           : 0
Oct 24 21:29:12 meteor kernel: [85943.672055]=20
Oct 24 21:29:12 meteor kernel: [85943.672058] sysctl_sched
Oct 24 21:29:12 meteor kernel: [85943.672063]   .sysctl_sched_latency      =
              : 12.000000
Oct 24 21:29:12 meteor kernel: [85943.672069]   .sysctl_sched_min_granulari=
ty            : 1.500000
Oct 24 21:29:12 meteor kernel: [85943.672074]   .sysctl_sched_wakeup_granul=
arity         : 2.000000
Oct 24 21:29:12 meteor kernel: [85943.672079]   .sysctl_sched_child_runs_fi=
rst           : 0
Oct 24 21:29:12 meteor kernel: [85943.672084]   .sysctl_sched_features     =
              : 15471
Oct 24 21:29:12 meteor kernel: [85943.672090]   .sysctl_sched_tunable_scali=
ng            : 1 (logaritmic)
Oct 24 21:29:12 meteor kernel: [85943.672097]=20
Oct 24 21:29:12 meteor kernel: [85943.672098] cpu#0, 2526.987 MHz
Oct 24 21:29:12 meteor kernel: [85943.672103]   .nr_running                =
    : 0
Oct 24 21:29:12 meteor kernel: [85943.672108]   .load                      =
    : 0
Oct 24 21:29:12 meteor kernel: [85943.672112]   .nr_switches               =
    : 76035225
Oct 24 21:29:12 meteor kernel: [85943.672117]   .nr_load_updates           =
    : 3956102
Oct 24 21:29:12 meteor kernel: [85943.672122]   .nr_uninterruptible        =
    : 3964
Oct 24 21:29:12 meteor kernel: [85943.672127]   .next_balance              =
    : 4316.378209
Oct 24 21:29:12 meteor kernel: [85943.672132]   .curr->pid                 =
    : 0
Oct 24 21:29:12 meteor kernel: [85943.672137]   .clock                     =
    : 85943665.023849
Oct 24 21:29:12 meteor kernel: [85943.672142]   .cpu_load[0]               =
    : 0
Oct 24 21:29:12 meteor kernel: [85943.672146]   .cpu_load[1]               =
    : 0
Oct 24 21:29:12 meteor kernel: [85943.672150]   .cpu_load[2]               =
    : 0
Oct 24 21:29:12 meteor kernel: [85943.672155]   .cpu_load[3]               =
    : 0
Oct 24 21:29:12 meteor kernel: [85943.672159]   .cpu_load[4]               =
    : 0
Oct 24 21:29:12 meteor kernel: [85943.672164]=20
Oct 24 21:29:12 meteor kernel: [85943.672166] cfs_rq[0]:/
Oct 24 21:29:12 meteor kernel: [85943.672170]   .exec_clock                =
    : 0.000000
Oct 24 21:29:12 meteor kernel: [85943.672175]   .MIN_vruntime              =
    : 0.000001
Oct 24 21:29:12 meteor kernel: [85943.672181]   .min_vruntime              =
    : 6085680.660055
Oct 24 21:29:12 meteor kernel: [85943.672186]   .max_vruntime              =
    : 0.000001
Oct 24 21:29:12 meteor kernel: [85943.672191]   .spread                    =
    : 0.000000
Oct 24 21:29:12 meteor kernel: [85943.672196]   .spread0                   =
    : 0.000000
Oct 24 21:29:12 meteor kernel: [85943.672201]   .nr_spread_over            =
    : 0
Oct 24 21:29:12 meteor kernel: [85943.672205]   .nr_running                =
    : 0
Oct 24 21:29:12 meteor kernel: [85943.672209]   .load                      =
    : 0
Oct 24 21:29:12 meteor kernel: [85943.672214]   .load_avg                  =
    : 0.000000
Oct 24 21:29:12 meteor kernel: [85943.672219]   .load_period               =
    : 0.000000
Oct 24 21:29:12 meteor kernel: [85943.672224]   .load_contrib              =
    : 0
Oct 24 21:29:12 meteor kernel: [85943.672228]   .load_tg                   =
    : 0
Oct 24 21:29:12 meteor kernel: [85943.672233]=20
Oct 24 21:29:12 meteor kernel: [85943.672235] rt_rq[0]:
Oct 24 21:29:12 meteor kernel: [85943.672238]   .rt_nr_running             =
    : 0
Oct 24 21:29:12 meteor kernel: [85943.672243]   .rt_throttled              =
    : 0
Oct 24 21:29:12 meteor kernel: [85943.672248]   .rt_time                   =
    : 0.000000
Oct 24 21:29:12 meteor kernel: [85943.672253]   .rt_runtime                =
    : 950.000000
Oct 24 21:29:12 meteor kernel: [85943.672259]=20
Oct 24 21:29:12 meteor kernel: [85943.672261] runnable tasks:
Oct 24 21:29:12 meteor kernel: [85943.672263]             task   PID       =
  tree-key  switches  prio     exec-runtime         sum-exec        sum-sle=
ep
Oct 24 21:29:12 meteor kernel: [85943.672267] -----------------------------=
---------------------------------------------------------------------------=
--
Oct 24 21:29:12 meteor kernel: [85943.672302]=20
Oct 24 21:29:12 meteor kernel: [85943.672304] cpu#1, 2526.987 MHz
Oct 24 21:29:12 meteor kernel: [85943.672309]   .nr_running                =
    : 0
Oct 24 21:29:12 meteor kernel: [85943.672313]   .load                      =
    : 0
Oct 24 21:29:12 meteor kernel: [85943.672318]   .nr_switches               =
    : 72970323
Oct 24 21:29:12 meteor kernel: [85943.672322]   .nr_load_updates           =
    : 2931016
Oct 24 21:29:12 meteor kernel: [85943.672327]   .nr_uninterruptible        =
    : -3962
Oct 24 21:29:12 meteor kernel: [85943.672332]   .next_balance              =
    : 4316.378236
Oct 24 21:29:12 meteor kernel: [85943.672337]   .curr->pid                 =
    : 0
Oct 24 21:29:12 meteor kernel: [85943.672342]   .clock                     =
    : 85943605.322844
Oct 24 21:29:12 meteor kernel: [85943.672347]   .cpu_load[0]               =
    : 1024
Oct 24 21:29:12 meteor kernel: [85943.672352]   .cpu_load[1]               =
    : 512
Oct 24 21:29:12 meteor kernel: [85943.672356]   .cpu_load[2]               =
    : 256
Oct 24 21:29:12 meteor kernel: [85943.672360]   .cpu_load[3]               =
    : 128
Oct 24 21:29:12 meteor kernel: [85943.672365]   .cpu_load[4]               =
    : 64
Oct 24 21:29:12 meteor kernel: [85943.672370]=20
Oct 24 21:29:12 meteor kernel: [85943.672371] cfs_rq[1]:/
Oct 24 21:29:12 meteor kernel: [85943.672376]   .exec_clock                =
    : 0.000000
Oct 24 21:29:12 meteor kernel: [85943.672381]   .MIN_vruntime              =
    : 0.000001
Oct 24 21:29:12 meteor kernel: [85943.672386]   .min_vruntime              =
    : 7848861.840230
Oct 24 21:29:12 meteor kernel: [85943.672391]   .max_vruntime              =
    : 0.000001
Oct 24 21:29:12 meteor kernel: [85943.672396]   .spread                    =
    : 0.000000
Oct 24 21:29:12 meteor kernel: [85943.672401]   .spread0                   =
    : 1763181.180175
Oct 24 21:29:12 meteor kernel: [85943.672406]   .nr_spread_over            =
    : 0
Oct 24 21:29:12 meteor kernel: [85943.672411]   .nr_running                =
    : 0
Oct 24 21:29:12 meteor kernel: [85943.672415]   .load                      =
    : 0
Oct 24 21:29:12 meteor kernel: [85943.672420]   .load_avg                  =
    : 0.000000
Oct 24 21:29:12 meteor kernel: [85943.672425]   .load_period               =
    : 0.000000
Oct 24 21:29:12 meteor kernel: [85943.672429]   .load_contrib              =
    : 0
Oct 24 21:29:12 meteor kernel: [85943.672434]   .load_tg                   =
    : 0
Oct 24 21:29:12 meteor kernel: [85943.672438]=20
Oct 24 21:29:12 meteor kernel: [85943.672440] rt_rq[1]:
Oct 24 21:29:12 meteor kernel: [85943.672444]   .rt_nr_running             =
    : 0
Oct 24 21:29:12 meteor kernel: [85943.672448]   .rt_throttled              =
    : 0
Oct 24 21:29:12 meteor kernel: [85943.672453]   .rt_time                   =
    : 0.000000
Oct 24 21:29:12 meteor kernel: [85943.672458]   .rt_runtime                =
    : 950.000000
Oct 24 21:29:12 meteor kernel: [85943.672464]=20
Oct 24 21:29:12 meteor kernel: [85943.672466] runnable tasks:
Oct 24 21:29:12 meteor kernel: [85943.672468]             task   PID       =
  tree-key  switches  prio     exec-runtime         sum-exec        sum-sle=
ep
Oct 24 21:29:12 meteor kernel: [85943.672472] -----------------------------=
---------------------------------------------------------------------------=
--
Oct 24 21:29:12 meteor kernel: [85943.672501]=20

Gaudenz

=2D-=20
Ever tried. Ever failed. No matter.
Try again. Fail again. Fail better.
~ Samuel Beckett ~

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUBTqXJoE0yN7tZsYcyAQpGYAgAgFV/rLnzg4ld6X/4U/EfTADWIpeBYgSu
viJqJV4Q8w0Q+q7c776HGP8DBQhMExqd6he9v1h9ymKyNYTfP4vSc1Z1IrExSebr
OlztEjEfNL0p7hXzSyRlP2WXBIA314FhiG21ZYiL5GxbmBOn+SDHI3s7Um2zMqBk
Zic0iR+lTZeDgGqcaPGF5xBW8Tl8/yLJ+PC8UQ1hPDx8PQf/P+M92E+UBgSBbrBg
ggDue7qVbvOBsK1aVn3DjJi6OJ1JgSPpULcAE5/g7DPjRm1TcrUjtntg1b1Ba9/8
QUXJ0VXaeMbHlwXrtftZ480FXxo3Sp6PyDW3cw+hpX2ptyUWLRbIdQ==
=Q3d+
-----END PGP SIGNATURE-----
--=-=-=--
