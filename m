Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab1AKWRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 17:17:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756305Ab1AKWRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 17:17:17 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTikMMG1S6qp0-jKnQUcR5DgC+WWVfgOo2PExFA2w@mail.gmail.com>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie>
 <AANLkTinW8Yp1K1w+G+BgLa-fPaFANkGsRjqH_W8N+9VL@mail.gmail.com>
 <AANLkTim5oVZqMBtan5_TMOxaWbqkF=aDcBYFNYy55kt_@mail.gmail.com>
 <0aea052d-70ff-41ea-8776-c6d974c10337@email.android.com> <AANLkTim0rn7Vem6YJM5tVKM0PX4YdnNmaeqmpS=Vp7rc@mail.gmail.com>
 <AANLkTi=eRHbgerpdPYdoOo45LruNTk0rNsWvOO-kYxyQ@mail.gmail.com>
 <20110111111203.279eae50@jbarnes-desktop> <AANLkTikMMG1S6qp0-jKnQUcR5DgC+WWVfgOo2PExFA2w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 11 Jan 2011 14:16:54 -0800
Message-ID: <AANLkTinLmrSQ9cYvdu-pfEHizOjNGL5df4HfcSigvYpX@mail.gmail.com>
Subject: Re: [git pull] drm for rc1
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
        Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 11:25 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Maybe the screen just has to be inactive for a longer time: do you do
> some dynamic "let's power things down if nothing is changing"?

So since this is _almost_ reproducible for me, I tried bisecting it.

The bisection is a bit iffy, since it's not entirely clear how long I
need to wait for the screen saver to cause the problem, but sine I hit
a very similar issue while bisecting, I think it's a pretty solid
(partial) bisect.

What _seems_ to go on is that after commit b5ba177d8d71 ("drm/i915:
Poll for seqno completion if IRQ is disabled") I get that "very chunky
behavior". And _before_ that commit I actually get a BUG_ON(), and in
fact that bug-on does not happen during normal use, but does trigger
when the screen saver runs. So I think the old BUG_ON() is actually
the exact same case that then causes the jerky problem for me.

NOTE! I didn't do a full bisect. I did verify that commit b5ba177d8d71
does expose the bad behavior, and I also verified that a few commits
before that gets the BUG_ON, but there's something like three or four
commits in between that I didn't test. But we're literally talking
just three commits or so (eg commit 8d5203ca6253 gets that BUG_ON(),
and 71f4566084eb is marked as "good" too for me, so the only untested
commits are 9097eef024db and b13c2b96bf15).

I'll test the merge, but I thought I'd send out this note already at
this point, because I'm pretty sure this is it.

The BUG_ON() that triggers is appended. And as mentioned, the jerky
thing really seems to start happening in the exact same circumstance
when this BUG_ON triggered.

                            Linus

---
[  330.023447] ------------[ cut here ]------------
[  330.025136] kernel BUG at drivers/gpu/drm/i915/intel_ringbuffer.c:354!
[  330.026758] invalid opcode: 0000 [#1] PREEMPT SMP
[  330.028396] last sysfs file:
/sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
[  330.030040] CPU 2
[  330.030049] Modules linked in: [last unloaded: scsi_wait_scan]
[  330.033313]
[  330.034929] Pid: 2723, comm: Xorg Not tainted
2.6.37-rc4-00295-g0cdab21 #16 P7H57D-V EVO/System Product Name
[  330.036581] RIP: 0010:[<ffffffff812f1cbd>]  [<ffffffff812f1cbd>]
render_ring_put_irq+0x20/0x88
[  330.038266] RSP: 0018:ffff88023e001cf8  EFLAGS: 00010246
[  330.039937] RAX: 0000000000000000 RBX: ffff88023fcdc030 RCX: 0000000000000000
[  330.041607] RDX: 0000000000003736 RSI: 0000000000000001 RDI: ffff88023fcdc030
[  330.043277] RBP: ffff88023e001d18 R08: ffff88023fcdd84c R09: 0000000000000000
[  330.044917] R10: ffff88023e001cb8 R11: ffff88023e001cc8 R12: ffff88023fcdc000
[  330.046571] R13: ffff88023ff69000 R14: ffff88023fcdd84c R15: ffff88023fcdc118
[  330.048193] FS:  00007fe1b6342860(0000) GS:ffff8800bd900000(0000)
knlGS:0000000000000000
[  330.049822] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  330.051450] CR2: 00007f4379961000 CR3: 0000000229d41000 CR4: 00000000000006e0
[  330.053088] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  330.054726] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  330.056364] Process Xorg (pid: 2723, threadinfo ffff88023e000000,
task ffff880229db2c40)
[  330.057991] Stack:
[  330.059610]  ffff88023fcdc030 ffff88023fcdc000 00000000000026b7
ffff88023fcdd84c
[  330.061255]  ffff88023e001d98 ffffffff812da704 ffff88023e001e18
ffff880200000000
[  330.062908]  0000000000000000 ffff880229db2c40 ffffffff81051e35
ffff88023e001d50
[  330.064566] Call Trace:
[  330.066202]  [<ffffffff812da704>] i915_gem_throttle_ioctl+0x163/0x1ac
[  330.067863]  [<ffffffff81051e35>] ? autoremove_wake_function+0x0/0x34
[  330.069510]  [<ffffffff812ba08f>] drm_ioctl+0x290/0x35c
[  330.071136]  [<ffffffff81054f24>] ? lock_hrtimer_base.clone.29+0x24/0x48
[  330.072769]  [<ffffffff812da5a1>] ? i915_gem_throttle_ioctl+0x0/0x1ac
[  330.074397]  [<ffffffff81054f24>] ? lock_hrtimer_base.clone.29+0x24/0x48
[  330.076025]  [<ffffffff8153c02c>] ? _raw_spin_unlock_irq+0x2b/0x53
[  330.077651]  [<ffffffff810d2ed9>] do_vfs_ioctl+0x4c1/0x502
[  330.079252]  [<ffffffff810c56cd>] ? fget_light+0x13a/0x31a
[  330.080845]  [<ffffffff8100202c>] ? sysret_check+0x27/0x62
[  330.082416]  [<ffffffff810d2f6b>] sys_ioctl+0x51/0x76
[  330.083964]  [<ffffffff81001ffb>] system_call_fastpath+0x16/0x1b
[  330.085501] Code: d7 f3 ab 5b 5b 41 5c 41 5d c9 c3 55 48 89 e5 41
56 41 55 41 54 53 4c 8b 6f 18 41 83 bd e0 02 00 00 00 74 66 8b 47 60
85 c0 75 02 <0f> 0b ff c8 89 47 60 85 c0 75 54 49 8b 9d 98 05 00 00 4c
8d a3
[  330.087351] RIP  [<ffffffff812f1cbd>] render_ring_put_irq+0x20/0x88
[  330.089039]  RSP <ffff88023e001cf8>
[  330.099760] ---[ end trace acfb1e4669bf8ace ]---
[  330.376659] [drm:drm_release] *ERROR* Device busy: 1
