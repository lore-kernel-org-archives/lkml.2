Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab0EKLDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 07:03:12 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:40599 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757891Ab0EKLDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 07:03:04 -0400
X-Sasl-enc: hD0Phcq8JN/rNZTXR0BcH0A6dXu73h2cipfLC52pfex9 1273575781
Message-ID: <4BE93963.5070200@ladisch.de>
Date: Tue, 11 May 2010 13:02:59 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: fb+drm: possible circular locking dependency detected
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With radeon KMS, after using a program accessing the framebuffer,
I started X and got this:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.34-rc6 #117
-------------------------------------------------------
X/1846 is trying to acquire lock:
 (&mm->mmap_sem){++++++}, at: [<ffffffff8108d36f>] might_fault+0x57/0xa4

but task is already holding lock:
 (&dev->mode_config.mutex){+.+.+.}, at: [<ffffffff8125f258>] drm_mode_getresources+0x33/0x54d

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&dev->mode_config.mutex){+.+.+.}:
       [<ffffffff8105d185>] __lock_acquire+0x1408/0x1747
       [<ffffffff8105d51e>] lock_acquire+0x5a/0x71
       [<ffffffff8143284a>] mutex_lock_nested+0x58/0x2b1
       [<ffffffff8124e1d8>] drm_fb_helper_set_par+0x9c/0xf2
       [<ffffffff811de45f>] fb_set_var+0x1de/0x2d9
       [<ffffffff811de694>] do_fb_ioctl+0x13a/0x46e
       [<ffffffff811dede2>] fb_ioctl+0x21/0x23
       [<ffffffff810b3c80>] vfs_ioctl+0x2a/0x9e
       [<ffffffff810b4235>] do_vfs_ioctl+0x4b7/0x4f4
       [<ffffffff810b42b4>] sys_ioctl+0x42/0x65
       [<ffffffff81001feb>] system_call_fastpath+0x16/0x1b

-> #1 (&fb_info->lock){+.+.+.}:
       [<ffffffff8105d185>] __lock_acquire+0x1408/0x1747
       [<ffffffff8105d51e>] lock_acquire+0x5a/0x71
       [<ffffffff8143284a>] mutex_lock_nested+0x58/0x2b1
       [<ffffffff811dd60a>] fb_release+0x1c/0x54
       [<ffffffff810a8585>] __fput+0x120/0x1e3
       [<ffffffff810a8660>] fput+0x18/0x1a
       [<ffffffff81093287>] remove_vma+0x51/0x76
       [<ffffffff81094245>] do_munmap+0x30a/0x32e
       [<ffffffff810942a4>] sys_munmap+0x3b/0x54
       [<ffffffff81001feb>] system_call_fastpath+0x16/0x1b

-> #0 (&mm->mmap_sem){++++++}:
       [<ffffffff8105ceaa>] __lock_acquire+0x112d/0x1747
       [<ffffffff8105d51e>] lock_acquire+0x5a/0x71
       [<ffffffff8108d39c>] might_fault+0x84/0xa4
       [<ffffffff8125f4a5>] drm_mode_getresources+0x280/0x54d
       [<ffffffff8125519f>] drm_ioctl+0x255/0x34b
       [<ffffffff810b3c80>] vfs_ioctl+0x2a/0x9e
       [<ffffffff810b4235>] do_vfs_ioctl+0x4b7/0x4f4
       [<ffffffff810b42b4>] sys_ioctl+0x42/0x65
       [<ffffffff81001feb>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

1 lock held by X/1846:
 #0:  (&dev->mode_config.mutex){+.+.+.}, at: [<ffffffff8125f258>] drm_mode_getresources+0x33/0x54d

stack backtrace:
Pid: 1846, comm: X Not tainted 2.6.34-rc6 #117
Call Trace:
 [<ffffffff8105b82f>] print_circular_bug+0xb3/0xc2
 [<ffffffff8105ceaa>] __lock_acquire+0x112d/0x1747
 [<ffffffff8105aef4>] ? mark_held_locks+0x4d/0x6b
 [<ffffffff81432a88>] ? mutex_lock_nested+0x296/0x2b1
 [<ffffffff8105d51e>] lock_acquire+0x5a/0x71
 [<ffffffff8108d36f>] ? might_fault+0x57/0xa4
 [<ffffffff8108d39c>] might_fault+0x84/0xa4
 [<ffffffff8108d36f>] ? might_fault+0x57/0xa4
 [<ffffffff8125f4a5>] drm_mode_getresources+0x280/0x54d
 [<ffffffff8125519f>] drm_ioctl+0x255/0x34b
 [<ffffffff8125f225>] ? drm_mode_getresources+0x0/0x54d
 [<ffffffff8104f629>] ? up_read+0x1e/0x35
 [<ffffffff810b3c80>] vfs_ioctl+0x2a/0x9e
 [<ffffffff810b4235>] do_vfs_ioctl+0x4b7/0x4f4
 [<ffffffff8100201c>] ? sysret_check+0x27/0x62
 [<ffffffff810b42b4>] sys_ioctl+0x42/0x65
 [<ffffffff81001feb>] system_call_fastpath+0x16/0x1b
