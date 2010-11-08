Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990Ab0KHAxy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 19:53:54 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35926 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab0KHAxx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 19:53:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=m25/iIbLvOsEqXdN4dQq7WFX0q/yX4HBPQgMQF12BXy/HFpLUblOZwOJcKrBC48BFa
         vgmVZRiRCI6pJqteemHgm4gKnyNCxGoy5vKqZBWfYqjLaEZjAhtczh00LszRQOQpjtOu
         CiwIPuTx40hz93E+OV1QafKeRRpNjEF5TTDJU=
MIME-Version: 1.0
In-Reply-To: <AANLkTikZ2cGGVnVai108VSQrL9yHSa5myKMEDZOgkDCe@mail.gmail.com>
References: <AANLkTikZ2cGGVnVai108VSQrL9yHSa5myKMEDZOgkDCe@mail.gmail.com>
Date: Sun, 7 Nov 2010 16:53:52 -0800
Message-ID: <AANLkTi=rFCaDCMz3woo=ABtM7TesZK2_cKghnwv4B_Jv@mail.gmail.com>
Subject: INFO: possible circular locking dependency detected [v2.6.37-rc1-152-g6c88078]
From: Uwe Helm <uwe.helm@googlemail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I've been seeing these lately, Xorg version is 1.9.0 with latest git kernel.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.37-rc1-uwe1+ #4
-------------------------------------------------------
Xorg/1401 is trying to acquire lock:
 (&mm->mmap_sem){++++++}, at: [<c01e4ddb>] might_fault+0x4b/0xa0

but task is already holding lock:
 (&dev->struct_mutex){+.+.+.}, at: [<f869c3ac>]
i915_mutex_lock_interruptible+0x3c/0x60 [i915]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&dev->struct_mutex){+.+.+.}:
       [<c01738ec>] lock_acquire+0x7c/0x120
       [<c04d3560>] mutex_lock_nested+0x60/0x330
       [<f810c7aa>] drm_gem_mmap+0x3a/0x140 [drm]
       [<c01ec202>] mmap_region+0x2e2/0x430
       [<c01ec59f>] do_mmap_pgoff+0x24f/0x2f0
       [<c01ec6bb>] sys_mmap_pgoff+0x7b/0x110
       [<c0102f97>] sysenter_do_call+0x12/0x36

-> #0 (&mm->mmap_sem){++++++}:
       [<c0173549>] __lock_acquire+0x14a9/0x17d0
       [<c01738ec>] lock_acquire+0x7c/0x120
       [<c01e4e0c>] might_fault+0x7c/0xa0
       [<c032dfad>] _copy_from_user+0x3d/0x130
       [<f869cdec>] i915_gem_pwrite_ioctl+0x18c/0xb20 [i915]
       [<f810afd2>] drm_ioctl+0x1e2/0x440 [drm]
       [<c0216dcd>] do_vfs_ioctl+0x9d/0x6c0
       [<c0217457>] sys_ioctl+0x67/0x80
       [<c0102f97>] sysenter_do_call+0x12/0x36

other info that might help us debug this:

1 lock held by Xorg/1401:
 #0:  (&dev->struct_mutex){+.+.+.}, at: [<f869c3ac>]
i915_mutex_lock_interruptible+0x3c/0x60 [i915]

stack backtrace:
Pid: 1401, comm: Xorg Not tainted 2.6.37-rc1-uwe1+ #4
Call Trace:
 [<c04d12de>] ? printk+0x1d/0x1f
 [<c01714f2>] print_circular_bug+0xc2/0xd0
 [<c0173549>] __lock_acquire+0x14a9/0x17d0
 [<c04d82c9>] ? sub_preempt_count+0x9/0x50
 [<c01738ec>] lock_acquire+0x7c/0x120
 [<c01e4ddb>] ? might_fault+0x4b/0xa0
 [<c01e4e0c>] might_fault+0x7c/0xa0
 [<c01e4ddb>] ? might_fault+0x4b/0xa0
 [<c032dfad>] _copy_from_user+0x3d/0x130
 [<f869cdec>] i915_gem_pwrite_ioctl+0x18c/0xb20 [i915]
 [<c01e4ddb>] ? might_fault+0x4b/0xa0
 [<f810afd2>] drm_ioctl+0x1e2/0x440 [drm]
 [<f869cc60>] ? i915_gem_pwrite_ioctl+0x0/0xb20 [i915]
 [<c02f36d3>] ? smk_access+0xb3/0x1f0
 [<c02f3914>] ? smk_curacc+0x74/0xa0
 [<f810adf0>] ? drm_ioctl+0x0/0x440 [drm]
 [<c0216dcd>] do_vfs_ioctl+0x9d/0x6c0
 [<c0217457>] sys_ioctl+0x67/0x80
[<c0102f97>] sysenter_do_call+0x12/0x36

thanks,
Uwe
