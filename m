Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab2JFIUf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 04:20:35 -0400
Received: from 1wt.eu ([62.212.114.60]:35984 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453Ab2JFIU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 04:20:28 -0400
Date: Sat, 6 Oct 2012 10:20:16 +0200
From: Willy Tarreau <w@1wt.eu>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>
Subject: Re: 3.5 regression on i915
Message-ID: <20121006082016.GA22618@1wt.eu>
References: <20121005234218.GC21163@1wt.eu> <b94cdc$6rvjl8@fmsmga001.fm.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b94cdc$6rvjl8@fmsmga001.fm.intel.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On Sat, Oct 06, 2012 at 09:04:34AM +0100, Chris Wilson wrote:
> > The crash happens here in i915_gem_entervt_ioctl() :
> > 
> >     3659          BUG_ON(!list_empty(&dev_priv->mm.active_list));
> >     3660          BUG_ON(!list_empty(&dev_priv->mm.flushing_list));
> >  -> 3661          BUG_ON(!list_empty(&dev_priv->mm.inactive_list));
> >     3662          mutex_unlock(&dev->struct_mutex);
> 
> That BUG_ON there is silly and can simply be removed. The check is to
> verify that no batches were submitted to the kernel whilst the UMS/GEM
> client was suspended - to which the BUG_ONs are a crude approximation.
> Furthermore, the checks are too late, since it means we attempted to
> program the hardware whilst it was in an invalid state, the BUG_ONs are
> the least of your concerns at that point.

Excellent, that fixed it ! X still segfaults when KMS is used, but
I expect more of a pure user-space issue here since there is nothing
in dmesg.

Would some of you accept the following patch and tag it for -stable ?

Thanks,
Willy

---

>From 3450cb7b7bd0b8fe1eab59d09e6852c4e3b22001 Mon Sep 17 00:00:00 2001
From: Willy Tarreau <w@1wt.eu>
Date: Sat, 6 Oct 2012 10:09:00 +0200
Subject: drm/i915: remove useless BUG_ON which caused a regression in 3.5.

starting an old X server causes a kernel BUG since commit 1b50247a8d:

------------[ cut here ]------------
kernel BUG at drivers/gpu/drm/i915/i915_gem.c:3661!
invalid opcode: 0000 [#1] SMP
Modules linked in: snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss uvcvideo videobuf2_core videodev videobuf2_vmalloc videobuf2_memops uhci_hcd ath9k mac80211 snd_hda_codec_realtek ath9k_common microcode ath9k_hw psmouse serio_raw sg ath cfg80211 atl1c lpc_ich mfd_core ehci_hcd snd_hda_intel snd_hda_codec snd_hwdep snd_pcm rtc_cmos snd_timer snd evdev eeepc_laptop snd_page_alloc sparse_keymap

Pid: 2866, comm: X Not tainted 3.5.6-rc1-eeepc #1 ASUSTeK Computer INC. 1005HA/1005HA
EIP: 0060:[<c12dc291>] EFLAGS: 00013297 CPU: 0
EIP is at i915_gem_entervt_ioctl+0xf1/0x110
EAX: f5941df4 EBX: f5940000 ECX: 00000000 EDX: 00020000
ESI: f5835400 EDI: 00000000 EBP: f51d7e38 ESP: f51d7e20
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
CR0: 8005003b CR2: b760e0a0 CR3: 351b6000 CR4: 000007d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process X (pid: 2866, ti=f51d6000 task=f61af8d0 task.ti=f51d6000)
Stack:
 00000001 00000000 f5835414 f51d7e84 f5835400 f54f85c0 f51d7f10 c12b530b
 00000001 c151b139 c14751b6 c152e030 00000b32 00006459 00000059 0000e200
 00000001 00000000 00006459 c159ddd0 c12dc1a0 ffffffea 00000000 00000000
Call Trace:
 [<c12b530b>] drm_ioctl+0x2eb/0x440
 [<c12dc1a0>] ? i915_gem_init+0xe0/0xe0
 [<c1052b2b>] ? enqueue_hrtimer+0x1b/0x50
 [<c1053321>] ? __hrtimer_start_range_ns+0x161/0x330
 [<c10530b3>] ? lock_hrtimer_base+0x23/0x50
 [<c1053163>] ? hrtimer_try_to_cancel+0x33/0x70
 [<c12b5020>] ? drm_version+0x90/0x90
 [<c10ca171>] vfs_ioctl+0x31/0x50
 [<c10ca2e4>] do_vfs_ioctl+0x64/0x510
 [<c10535de>] ? hrtimer_nanosleep+0x8e/0x100
 [<c1052c20>] ? update_rmtp+0x80/0x80
 [<c10ca7c9>] sys_ioctl+0x39/0x60
 [<c1433949>] syscall_call+0x7/0xb
Code: 83 c4 0c 5b 5e 5f 5d c3 c7 44 24 04 2c 05 53 c1 c7 04 24 6f ef 47 c1 e8 6e e0 fd ff c7 83 38 1e 00 00 00 00 00 00 e9 3f ff ff ff <0f> 0b eb fe 0f 0b eb fe 8d b4 26 00 00 00 00 0f 0b eb fe 8d b6
EIP: [<c12dc291>] i915_gem_entervt_ioctl+0xf1/0x110 SS:ESP 0068:f51d7e20
---[ end trace dd332ec083cbd513 ]---

The crash happens here in i915_gem_entervt_ioctl() :

    3659          BUG_ON(!list_empty(&dev_priv->mm.active_list));
    3660          BUG_ON(!list_empty(&dev_priv->mm.flushing_list));
 -> 3661          BUG_ON(!list_empty(&dev_priv->mm.inactive_list));
    3662          mutex_unlock(&dev->struct_mutex);

Quoting Chris :
  "That BUG_ON there is silly and can simply be removed. The check is to
   verify that no batches were submitted to the kernel whilst the UMS/GEM
   client was suspended - to which the BUG_ONs are a crude approximation.
   Furthermore, the checks are too late, since it means we attempted to
   program the hardware whilst it was in an invalid state, the BUG_ONs are
   the least of your concerns at that point."

Cc: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/gpu/drm/i915/i915_gem.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 35926ad..fc6683a 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -3658,7 +3658,6 @@ i915_gem_entervt_ioctl(struct drm_device *dev, void *data,
 
 	BUG_ON(!list_empty(&dev_priv->mm.active_list));
 	BUG_ON(!list_empty(&dev_priv->mm.flushing_list));
-	BUG_ON(!list_empty(&dev_priv->mm.inactive_list));
 	mutex_unlock(&dev->struct_mutex);
 
 	ret = drm_irq_install(dev);
-- 
1.7.2.1.45.g54fbc

