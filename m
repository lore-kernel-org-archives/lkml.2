Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab0EFWH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 18:07:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752280Ab0EFWHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 18:07:54 -0400
Date: Thu, 6 May 2010 15:07:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nils Radtke <lkml@Think-Future.de>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: BUG: unable to handle kernel NULL ptr Xorg, scheduling while
 atomic: Xorg/drm
Message-Id: <20100506150748.0677eba2.akpm@linux-foundation.org>
In-Reply-To: <20100504225138.GX3479@localhost>
References: <20100504225138.GX3479@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc dri-devel)

On Wed, 5 May 2010 00:51:38 +0200
Nils Radtke <lkml@Think-Future.de> wrote:

>   Hi,
> 
>  Some more kernel NULL ptr deref, a lot of scheduling while atomic 
> (probably due to first bug occurred) and again this "last sysfs file" 
> from wireless. ath5k is a real source of trouble here:
> 
>   - resume from suspend fails 7 times out of 10 and always seems the 
>     ath driver being the culprit.
>   - ath5k: when starting a blob transfer eg. ssh summer.jpg to the 
>     notebook with the ath5k driver running, the wNIC freezes almost 
>     immediately! Dead device. This is unfortunately too easily reproducible.
>     In fact, this is a blocker, wireless blob transfer via ssh (other means 
>     not tested) is not possible w/o locking it up.
> 
>   Cheers,
> 
>     Nils
> 
> 
> Four (partly lengthy) logs following, plus one more maybe-related BUG:
> 
> Apr  7 11:43:18 localhost kernel: BUG: unable to handle kernel NULL pointer dereference at 00000001
> Apr  7 11:43:18 localhost kernel: IP: [<c10c36a2>] remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: *pde = 00000000 
> Apr  7 11:43:18 localhost kernel: Oops: 0000 [#1] PREEMPT 
> Apr  7 11:43:18 localhost kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:1c.1/0000:04:00.0/net/wlan0/wireless/link
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel:
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Not tainted 2.6.33.1 #3 Columbia                       /Extensa 5220                   
> Apr  7 11:43:18 localhost kernel: EIP: 0060:[<c10c36a2>] EFLAGS: 00213292 CPU: 0
> Apr  7 11:43:18 localhost kernel: EIP is at remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: EAX: f08d98c0 EBX: ef1aa4e0 ECX: 00000001 EDX: 00000001
> Apr  7 11:43:18 localhost kernel: ESI: 00000000 EDI: 00000001 EBP: 000001d1 ESP: f55a1d08
> Apr  7 11:43:18 localhost kernel: DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Apr  7 11:43:18 localhost kernel: Process Xorg (pid: 3228, ti=f55a0000 task=f5590580 task.ti=f55a0000)
> Apr  7 11:43:18 localhost kernel: Stack:
> Apr  7 11:43:18 localhost kernel: 00000004 fa30b000 c10c4abe f0ba42c0 c13487b8 0007d521 0000001d 00000000
> Apr  7 11:43:18 localhost kernel: <0> 00000000 0000001d c134cc92 00007683 00000000 00000001 f55a1bd8 8b421215
> Apr  7 11:43:18 localhost kernel: <0> 00000028 f09f1070 00000000 00000000 00000001 01b6b001 01b6b3cc f5110740
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: Code: 90 f6 40 08 04 74 ef 89 e2 8b 58 28 81 e2 00 e0 ff ff 83 42 14 01 8b 15 7c 11 9a c1 b9 7c 11 9a c1 39 d3 74 0c 8d 74 26 00 89 d1 <8b> 12 39 d3 75 f8 8b 13 89 11 89 e2 81 e2 00 e0 ff ff 83 6a 14 
> Apr  7 11:43:18 localhost kernel: EIP: [<c10c36a2>] remove_vm_area+0x42/0x80 SS:ESP 0068:f55a1d08
> Apr  7 11:43:18 localhost kernel: CR2: 0000000000000001
> Apr  7 11:43:18 localhost kernel: ---[ end trace 9f3adc4655f00393 ]---
> Apr  7 11:43:18 localhost kernel: note: Xorg[3228] exited with preempt_count 2
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c1080af4>] ? __rcu_process_callbacks+0x44/0x390
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10b9ebf>] ? unmap_vmas+0x63f/0x650
> Apr  7 11:43:18 localhost kernel: [<c10bdf65>] ? exit_mmap+0xa5/0x160
> Apr  7 11:43:18 localhost kernel: [<c1031d47>] ? mmput+0x27/0xc0
> Apr  7 11:43:18 localhost kernel: [<c1035fc4>] ? exit_mm+0xd4/0xf0
> Apr  7 11:43:18 localhost kernel: [<c1069fe0>] ? acct_collect+0x60/0x140
> Apr  7 11:43:18 localhost kernel: [<c1037a91>] ? do_exit+0xe1/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10f0c73>] ? mntput_no_expire+0x13/0xc0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c103613f>] ? put_files_struct+0x5f/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10d039f>] ? slab_destroy+0x1f/0x70
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c103a3ac>] ? irq_exit+0x2c/0x70
> Apr  7 11:43:18 localhost kernel: [<c10031a9>] ? common_interrupt+0x29/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c103a0c8>] ? __do_softirq+0x98/0x1d0
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c103a3ac>] ? irq_exit+0x2c/0x70
> Apr  7 11:43:18 localhost kernel: [<c10193e4>] ? smp_apic_timer_interrupt+0x44/0x80
> Apr  7 11:43:18 localhost kernel: [<c16799ae>] ? apic_timer_interrupt+0x2a/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c16799ae>] ? apic_timer_interrupt+0x2a/0x30
> Apr  7 11:43:18 localhost kernel: [<c10d4abb>] ? mem_cgroup_add_lru_list+0x1b/0x70
> Apr  7 11:43:18 localhost kernel: [<c10d4a6f>] ? mem_cgroup_get_reclaim_stat_from_page+0xf/0x40
> Apr  7 11:43:18 localhost kernel: [<c10aa55d>] ? activate_page+0x13d/0x190
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10d4abb>] ? mem_cgroup_add_lru_list+0x1b/0x70
> Apr  7 11:43:18 localhost kernel: [<c10d4a6f>] ? mem_cgroup_get_reclaim_stat_from_page+0xf/0x40
> Apr  7 11:43:18 localhost kernel: [<c10aa55d>] ? activate_page+0x13d/0x190
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10031a9>] ? common_interrupt+0x29/0x30
> Apr  7 11:43:18 localhost kernel: [<c10d4abb>] ? mem_cgroup_add_lru_list+0x1b/0x70
> Apr  7 11:43:18 localhost kernel: [<c10d4a6f>] ? mem_cgroup_get_reclaim_stat_from_page+0xf/0x40
> Apr  7 11:43:18 localhost kernel: [<c10aa55d>] ? activate_page+0x13d/0x190
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c103a3ac>] ? irq_exit+0x2c/0x70
> Apr  7 11:43:18 localhost kernel: [<c10193e4>] ? smp_apic_timer_interrupt+0x44/0x80
> Apr  7 11:43:18 localhost kernel: [<c16799ae>] ? apic_timer_interrupt+0x2a/0x30
> Apr  7 11:43:18 localhost kernel: [<c10d4abb>] ? mem_cgroup_add_lru_list+0x1b/0x70
> Apr  7 11:43:18 localhost kernel: [<c10d4a6f>] ? mem_cgroup_get_reclaim_stat_from_page+0xf/0x40
> Apr  7 11:43:18 localhost kernel: [<c10aa55d>] ? activate_page+0x13d/0x190
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c16799ae>] ? apic_timer_interrupt+0x2a/0x30
> Apr  7 11:43:18 localhost kernel: [<c10d4abb>] ? mem_cgroup_add_lru_list+0x1b/0x70
> Apr  7 11:43:18 localhost kernel: [<c10d4a6f>] ? mem_cgroup_get_reclaim_stat_from_page+0xf/0x40
> Apr  7 11:43:18 localhost kernel: [<c10aa55d>] ? activate_page+0x13d/0x190
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c103a3ac>] ? irq_exit+0x2c/0x70
> Apr  7 11:43:18 localhost kernel: [<c10193e4>] ? smp_apic_timer_interrupt+0x44/0x80
> Apr  7 11:43:18 localhost kernel: [<c16799ae>] ? apic_timer_interrupt+0x2a/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c1080e5e>] ? rcu_process_callbacks+0x1e/0x20
> Apr  7 11:43:18 localhost kernel: [<c103a0c8>] ? __do_softirq+0x98/0x1d0
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c103a3ac>] ? irq_exit+0x2c/0x70
> Apr  7 11:43:18 localhost kernel: [<c10193e4>] ? smp_apic_timer_interrupt+0x44/0x80
> Apr  7 11:43:18 localhost kernel: [<c16799ae>] ? apic_timer_interrupt+0x2a/0x30
> Apr  7 11:43:18 localhost kernel: [<c10fcf30>] ? __set_page_dirty_buffers+0x0/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10d039f>] ? slab_destroy+0x1f/0x70
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10d039f>] ? slab_destroy+0x1f/0x70
> Apr  7 11:43:18 localhost kernel: [<c16799ae>] ? apic_timer_interrupt+0x2a/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c103a3ac>] ? irq_exit+0x2c/0x70
> Apr  7 11:43:18 localhost kernel: [<c10193e4>] ? smp_apic_timer_interrupt+0x44/0x80
> Apr  7 11:43:18 localhost kernel: [<c16799ae>] ? apic_timer_interrupt+0x2a/0x30
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10d0000>] ? s_show+0x260/0x2d0
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c103a3ac>] ? irq_exit+0x2c/0x70
> Apr  7 11:43:18 localhost kernel: [<c10193e4>] ? smp_apic_timer_interrupt+0x44/0x80
> Apr  7 11:43:18 localhost kernel: [<c16799ae>] ? apic_timer_interrupt+0x2a/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c103a3ac>] ? irq_exit+0x2c/0x70
> Apr  7 11:43:18 localhost kernel: [<c10193e4>] ? smp_apic_timer_interrupt+0x44/0x80
> Apr  7 11:43:18 localhost kernel: [<c16799ae>] ? apic_timer_interrupt+0x2a/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c103a3ac>] ? irq_exit+0x2c/0x70
> Apr  7 11:43:18 localhost kernel: [<c10193e4>] ? smp_apic_timer_interrupt+0x44/0x80
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c1080af4>] ? __rcu_process_callbacks+0x44/0x390
> Apr  7 11:43:18 localhost kernel: [<c1080e5e>] ? rcu_process_callbacks+0x1e/0x20
> Apr  7 11:43:18 localhost kernel: [<c103a0c8>] ? __do_softirq+0x98/0x1d0
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c103a3ac>] ? irq_exit+0x2c/0x70
> Apr  7 11:43:18 localhost kernel: [<c10031a9>] ? common_interrupt+0x29/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x10000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c10a35a2>] ? __remove_from_page_cache+0x12/0xd0
> Apr  7 11:43:18 localhost kernel: [<c102bba3>] ? __cond_resched+0x13/0x30
> Apr  7 11:43:18 localhost kernel: [<c1677aed>] ? _cond_resched+0x1d/0x30
> Apr  7 11:43:18 localhost kernel: [<c10ab12e>] ? truncate_inode_pages_range+0xfe/0x2c0
> Apr  7 11:43:18 localhost kernel: [<c10ab307>] ? truncate_inode_pages+0x17/0x20
> Apr  7 11:43:18 localhost kernel: [<c10b130a>] ? shmem_delete_inode+0x6a/0x110
> Apr  7 11:43:18 localhost kernel: [<c10b12a0>] ? shmem_delete_inode+0x0/0x110
> Apr  7 11:43:18 localhost kernel: [<c10ed78c>] ? generic_delete_inode+0xac/0x180
> Apr  7 11:43:18 localhost kernel: [<c10ec794>] ? iput+0x44/0x50
> Apr  7 11:43:18 localhost kernel: [<c10e9a43>] ? d_kill+0x33/0x60
> Apr  7 11:43:18 localhost kernel: [<c10ea1b0>] ? dput+0x70/0x130
> Apr  7 11:43:18 localhost kernel: [<c10d9e59>] ? __fput+0x149/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c133087b>] ? drm_gem_object_free+0x2b/0x50
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c129db99>] ? kref_put+0x29/0x60
> Apr  7 11:43:18 localhost kernel: [<c13307c0>] ? drm_gem_object_release_handle+0x20/0x30
> Apr  7 11:43:18 localhost kernel: [<c129b9bf>] ? idr_for_each+0x6f/0xc0
> Apr  7 11:43:18 localhost kernel: [<c13307a0>] ? drm_gem_object_release_handle+0x0/0x30
> Apr  7 11:43:18 localhost kernel: [<c13308c7>] ? drm_gem_release+0x27/0x40
> Apr  7 11:43:18 localhost kernel: [<c132fb81>] ? drm_release+0x5b1/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x00000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c1677fac>] ? schedule_timeout+0x11c/0x280
> Apr  7 11:43:18 localhost kernel: [<c1040e60>] ? process_timeout+0x0/0x10
> Apr  7 11:43:18 localhost kernel: [<c1041235>] ? msleep+0x15/0x20
> Apr  7 11:43:18 localhost kernel: [<c1359493>] ? i9xx_crtc_dpms+0x223/0x2e0
> Apr  7 11:43:18 localhost kernel: [<c10b0862>] ? shmem_truncate_range+0x3f2/0x8a0
> Apr  7 11:43:18 localhost kernel: [<c135596b>] ? intel_crtc_dpms+0x2b/0x100
> Apr  7 11:43:18 localhost kernel: [<c1328a4e>] ? drm_helper_disable_unused_functions+0x15e/0x180
> Apr  7 11:43:18 localhost kernel: [<c132a45f>] ? drm_crtc_helper_set_config+0x81f/0x8a0
> Apr  7 11:43:18 localhost kernel: [<c10ea1c4>] ? dput+0x84/0x130
> Apr  7 11:43:18 localhost kernel: [<c133a276>] ? drm_framebuffer_cleanup+0xa6/0xd0
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c1358740>] ? intel_user_framebuffer_destroy+0x20/0x50
> Apr  7 11:43:18 localhost kernel: [<c1338505>] ? drm_fb_release+0x55/0x70
> Apr  7 11:43:18 localhost kernel: [<c132fb6f>] ? drm_release+0x59f/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x00000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c1030d2e>] ? T.1328+0x2e/0xa0
> Apr  7 11:43:18 localhost kernel: [<c1677fac>] ? schedule_timeout+0x11c/0x280
> Apr  7 11:43:18 localhost kernel: [<c1040e60>] ? process_timeout+0x0/0x10
> Apr  7 11:43:18 localhost kernel: [<c1041235>] ? msleep+0x15/0x20
> Apr  7 11:43:18 localhost kernel: [<c135b472>] ? i8xx_disable_fbc+0x42/0x70
> Apr  7 11:43:18 localhost kernel: [<c13594e4>] ? i9xx_crtc_dpms+0x274/0x2e0
> Apr  7 11:43:18 localhost kernel: [<c10b0862>] ? shmem_truncate_range+0x3f2/0x8a0
> Apr  7 11:43:18 localhost kernel: [<c135596b>] ? intel_crtc_dpms+0x2b/0x100
> Apr  7 11:43:18 localhost kernel: [<c1328a4e>] ? drm_helper_disable_unused_functions+0x15e/0x180
> Apr  7 11:43:18 localhost kernel: [<c132a45f>] ? drm_crtc_helper_set_config+0x81f/0x8a0
> Apr  7 11:43:18 localhost kernel: [<c10ea1c4>] ? dput+0x84/0x130
> Apr  7 11:43:18 localhost kernel: [<c133a276>] ? drm_framebuffer_cleanup+0xa6/0xd0
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c1358740>] ? intel_user_framebuffer_destroy+0x20/0x50
> Apr  7 11:43:18 localhost kernel: [<c1338505>] ? drm_fb_release+0x55/0x70
> Apr  7 11:43:18 localhost kernel: [<c132fb6f>] ? drm_release+0x59f/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: BUG: scheduling while atomic: Xorg/3228/0x00000002
> Apr  7 11:43:18 localhost kernel: Modules linked in: tg3 libphy option usbserial usb_storage wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal [last unloaded: libphy]
> Apr  7 11:43:18 localhost kernel: Pid: 3228, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Apr  7 11:43:18 localhost kernel: Call Trace:
> Apr  7 11:43:18 localhost kernel: [<c1677929>] ? schedule+0x409/0x4e0
> Apr  7 11:43:18 localhost kernel: [<c1677fb3>] ? schedule_timeout+0x123/0x280
> Apr  7 11:43:18 localhost kernel: [<c1677fac>] ? schedule_timeout+0x11c/0x280
> Apr  7 11:43:18 localhost kernel: [<c1040e60>] ? process_timeout+0x0/0x10
> Apr  7 11:43:18 localhost kernel: [<c1040e60>] ? process_timeout+0x0/0x10
> Apr  7 11:43:18 localhost kernel: [<c1041235>] ? msleep+0x15/0x20
> Apr  7 11:43:18 localhost kernel: [<c1359493>] ? i9xx_crtc_dpms+0x223/0x2e0
> Apr  7 11:43:18 localhost kernel: [<c10b0862>] ? shmem_truncate_range+0x3f2/0x8a0
> Apr  7 11:43:18 localhost kernel: [<c135596b>] ? intel_crtc_dpms+0x2b/0x100
> Apr  7 11:43:18 localhost kernel: [<c1328a4e>] ? drm_helper_disable_unused_functions+0x15e/0x180
> Apr  7 11:43:18 localhost kernel: [<c132a45f>] ? drm_crtc_helper_set_config+0x81f/0x8a0
> Apr  7 11:43:18 localhost kernel: [<c10ea1c4>] ? dput+0x84/0x130
> Apr  7 11:43:18 localhost kernel: [<c133a276>] ? drm_framebuffer_cleanup+0xa6/0xd0
> Apr  7 11:43:18 localhost kernel: [<c1330850>] ? drm_gem_object_free+0x0/0x50
> Apr  7 11:43:18 localhost kernel: [<c1358740>] ? intel_user_framebuffer_destroy+0x20/0x50
> Apr  7 11:43:18 localhost kernel: [<c1338505>] ? drm_fb_release+0x55/0x70
> Apr  7 11:43:18 localhost kernel: [<c132fb6f>] ? drm_release+0x59f/0x6b0
> Apr  7 11:43:18 localhost kernel: [<c10d9dd7>] ? __fput+0xc7/0x1e0
> Apr  7 11:43:18 localhost kernel: [<c10d67d7>] ? filp_close+0x47/0x80
> Apr  7 11:43:18 localhost kernel: [<c103613a>] ? put_files_struct+0x5a/0xb0
> Apr  7 11:43:18 localhost kernel: [<c1037ab7>] ? do_exit+0x107/0x740
> Apr  7 11:43:18 localhost kernel: [<c1005a1c>] ? oops_end+0x5c/0x90
> Apr  7 11:43:18 localhost kernel: [<c1677403>] ? printk+0x17/0x1a
> Apr  7 11:43:18 localhost kernel: [<c101fd32>] ? no_context+0xc2/0x150
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
> Apr  7 11:43:18 localhost kernel: [<c1679bd2>] ? error_code+0x5e/0x64
> Apr  7 11:43:18 localhost kernel: [<c1020070>] ? do_page_fault+0x0/0x300
> Apr  7 11:43:18 localhost kernel: [<c10c36a2>] ? remove_vm_area+0x42/0x80
> Apr  7 11:43:18 localhost kernel: [<c10c4abe>] ? __vunmap+0x1e/0xe0
> Apr  7 11:43:18 localhost kernel: [<c13487b8>] ? i915_gem_object_move_to_active+0x88/0xb0
> Apr  7 11:43:18 localhost kernel: [<c134cc92>] ? i915_gem_do_execbuffer+0x832/0x12b0
> Apr  7 11:43:18 localhost kernel: [<c134952c>] ? i915_gem_object_set_to_gtt_domain+0x5c/0x100
> Apr  7 11:43:18 localhost kernel: [<c134d951>] ? i915_gem_execbuffer+0x61/0x500
> Apr  7 11:43:18 localhost kernel: [<c134db15>] ? i915_gem_execbuffer+0x225/0x500
> Apr  7 11:43:18 localhost kernel: [<c1348708>] ? i915_gem_sw_finish_ioctl+0x78/0xa0
> Apr  7 11:43:18 localhost kernel: [<c132ee80>] ? drm_ioctl+0x1f0/0x360
> Apr  7 11:43:18 localhost kernel: [<c134d8f0>] ? i915_gem_execbuffer+0x0/0x500
> Apr  7 11:43:18 localhost kernel: [<c10d877d>] ? do_sync_read+0xad/0xf0
> Apr  7 11:43:18 localhost kernel: [<c132ec90>] ? drm_ioctl+0x0/0x360
> Apr  7 11:43:18 localhost kernel: [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
> Apr  7 11:43:18 localhost kernel: [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
> Apr  7 11:43:18 localhost kernel: [<c10535dd>] ? __remove_hrtimer+0x2d/0x90
> Apr  7 11:43:18 localhost kernel: [<c1038585>] ? do_setitimer+0xd5/0x220
> Apr  7 11:43:18 localhost kernel: [<c10e73c6>] ? sys_ioctl+0x76/0x90
> Apr  7 11:43:18 localhost kernel: [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Apr  7 11:43:18 localhost kernel: [drm:drm_release] *ERROR* Device busy: 1
> Apr  7 11:43:18 localhost kdm[3217]: X server for display :0 terminated unexpectedly
> 
> 
> 
> 2010-04-07:
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000044
> IP: [<c134815a>] i915_gem_object_move_to_inactive+0x1a/0xb0
> *pde = 00000000 
> Oops: 0000 [#1] PREEMPT 
> last sysfs file: /sys/devices/pci0000:00/0000:00:1c.0/0000:02:00.0/net/eth0/address
> Modules linked in: tg3 libphy option usbserial usb_storage snd_usb_audio snd_usb_lib snd_seq_midi snd_rawmidi uvcvideo [last unloaded: usbserial]
> 
> Pid: 9704, comm: Xorg Not tainted 2.6.33.1 #3 Columbia                       /Extensa 5220                   
> EIP: 0060:[<c134815a>] EFLAGS: 00213282 CPU: 0
> EIP is at i915_gem_object_move_to_inactive+0x1a/0xb0
> EAX: e322a2c0 EBX: e322a2c0 ECX: 00000000 EDX: 00000000
> ESI: eff63300 EDI: f731a000 EBP: 00000000 ESP: f5cf5de0
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process Xorg (pid: 9704, ti=f5cf4000 task=f5ce0580 task.ti=f5cf4000)
> Stack:
>  e322a2c0 eff63300 f731a000 c1348976 f731ae00 f731a000 f7394000 007aaad3
> <0> f731ae28 f7394000 f5cf5e70 e13704c0 f7394010 c1348a77 ffffffa1 f5ce0580
> <0> 00000000 f5e5e7c0 f7394000 c0086457 00000057 c132ee80 00000001 c17c3363
> Call Trace:
>  [<c1348976>] ? i915_gem_retire_requests+0x196/0x260
>  [<c1348a77>] ? i915_gem_busy_ioctl+0x37/0xa0
>  [<c132ee80>] ? drm_ioctl+0x1f0/0x360
>  [<c1348a40>] ? i915_gem_busy_ioctl+0x0/0xa0
>  [<c105d0f5>] ? tick_handle_oneshot_broadcast+0x75/0xc0
>  [<c1004f6a>] ? timer_interrupt+0x3a/0x50
>  [<c107d805>] ? handle_IRQ_event+0x45/0x180
>  [<c10531f3>] ? hrtimer_forward+0x163/0x1b0
>  [<c107f2cb>] ? handle_edge_irq+0xbb/0x150
>  [<c1004aa5>] ? handle_irq+0x15/0x30
>  [<c132ec90>] ? drm_ioctl+0x0/0x360
>  [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
>  [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
>  [<c10031a9>] ? common_interrupt+0x29/0x30
>  [<c103a0c8>] ? __do_softirq+0x98/0x1d0
>  [<c10e73c6>] ? sys_ioctl+0x76/0x90
>  [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Code: ff ff eb 0d 90 90 90 90 90 90 90 90 90 90 90 90 90 83 ec 0c 89 1c 24 89 74 24 04 89 7c 24 08 8b 50 08 8b 8a 14 02 00 00 8b 50 50 <8b> 72 44 85 f6 74 5f 8b 72 08 8d 4a 08 8b 5a 0c 89 5e 04 89 33 
> EIP: [<c134815a>] i915_gem_object_move_to_inactive+0x1a/0xb0 SS:ESP 0068:f5cf5de0
> CR2: 0000000000000044
> ---[ end trace 61bdac1bfaeb94e7 ]---
> note: Xorg[9704] exited with preempt_count 2
> BUG: scheduling while atomic: Xorg/9704/0x10000002
> Modules linked in: tg3 libphy option usbserial usb_storage snd_usb_audio snd_usb_lib snd_seq_midi snd_rawmidi uvcvideo [last unloaded: usbserial]
> Pid: 9704, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Call Trace:
>  [<c1677929>] ? schedule+0x409/0x4e0
>  [<c102bba3>] ? __cond_resched+0x13/0x30
>  [<c1677aed>] ? _cond_resched+0x1d/0x30
>  [<c10b9ebf>] ? unmap_vmas+0x63f/0x650
>  [<c10bdf65>] ? exit_mmap+0xa5/0x160
>  [<c1031d47>] ? mmput+0x27/0xc0
>  [<c1035fc4>] ? exit_mm+0xd4/0xf0
>  [<c1069fe0>] ? acct_collect+0x60/0x140
>  [<c1037a91>] ? do_exit+0xe1/0x740
>  [<c1005a1c>] ? oops_end+0x5c/0x90
>  [<c1677403>] ? printk+0x17/0x1a
>  [<c101fd32>] ? no_context+0xc2/0x150
>  [<c1020070>] ? do_page_fault+0x0/0x300
>  [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
>  [<c1679bd2>] ? error_code+0x5e/0x64
>  [<c10e007b>] ? free_pipe_info+0xb/0x20
>  [<c1020070>] ? do_page_fault+0x0/0x300
>  [<c134815a>] ? i915_gem_object_move_to_inactive+0x1a/0xb0
>  [<c1348976>] ? i915_gem_retire_requests+0x196/0x260
>  [<c1348a77>] ? i915_gem_busy_ioctl+0x37/0xa0
>  [<c132ee80>] ? drm_ioctl+0x1f0/0x360
>  [<c1348a40>] ? i915_gem_busy_ioctl+0x0/0xa0
>  [<c105d0f5>] ? tick_handle_oneshot_broadcast+0x75/0xc0
>  [<c1004f6a>] ? timer_interrupt+0x3a/0x50
>  [<c107d805>] ? handle_IRQ_event+0x45/0x180
>  [<c10531f3>] ? hrtimer_forward+0x163/0x1b0
>  [<c107f2cb>] ? handle_edge_irq+0xbb/0x150
>  [<c1004aa5>] ? handle_irq+0x15/0x30
>  [<c132ec90>] ? drm_ioctl+0x0/0x360
>  [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
>  [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
>  [<c10031a9>] ? common_interrupt+0x29/0x30
>  [<c103a0c8>] ? __do_softirq+0x98/0x1d0
>  [<c10e73c6>] ? sys_ioctl+0x76/0x90
>  [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> BUG: scheduling while atomic: Xorg/9704/0x10000002
> Modules linked in: tg3 libphy option usbserial usb_storage snd_usb_audio snd_usb_lib snd_seq_midi snd_rawmidi uvcvideo [last unloaded: usbserial]
> Pid: 9704, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Call Trace:
>  [<c1677929>] ? schedule+0x409/0x4e0
>  [<c102bba3>] ? __cond_resched+0x13/0x30
>  [<c1677aed>] ? _cond_resched+0x1d/0x30
>  [<c10b9ebf>] ? unmap_vmas+0x63f/0x650
>  [<c10bdf65>] ? exit_mmap+0xa5/0x160
>  [<c1031d47>] ? mmput+0x27/0xc0
>  [<c1035fc4>] ? exit_mm+0xd4/0xf0
>  [<c1069fe0>] ? acct_collect+0x60/0x140
>  [<c1037a91>] ? do_exit+0xe1/0x740
>  [<c1005a1c>] ? oops_end+0x5c/0x90
>  [<c1677403>] ? printk+0x17/0x1a
>  [<c101fd32>] ? no_context+0xc2/0x150
>  [<c1020070>] ? do_page_fault+0x0/0x300
>  [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
>  [<c1679bd2>] ? error_code+0x5e/0x64
>  [<c10e007b>] ? free_pipe_info+0xb/0x20
>  [<c1020070>] ? do_page_fault+0x0/0x300
>  [<c134815a>] ? i915_gem_object_move_to_inactive+0x1a/0xb0
>  [<c1348976>] ? i915_gem_retire_requests+0x196/0x260
>  [<c1348a77>] ? i915_gem_busy_ioctl+0x37/0xa0
>  [<c132ee80>] ? drm_ioctl+0x1f0/0x360
>  [<c1348a40>] ? i915_gem_busy_ioctl+0x0/0xa0
>  [<c105d0f5>] ? tick_handle_oneshot_broadcast+0x75/0xc0
>  [<c1004f6a>] ? timer_interrupt+0x3a/0x50
>  [<c107d805>] ? handle_IRQ_event+0x45/0x180
>  [<c10531f3>] ? hrtimer_forward+0x163/0x1b0
>  [<c107f2cb>] ? handle_edge_irq+0xbb/0x150
>  [<c1004aa5>] ? handle_irq+0x15/0x30
>  [<c132ec90>] ? drm_ioctl+0x0/0x360
>  [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
>  [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
>  [<c10031a9>] ? common_interrupt+0x29/0x30
>  [<c103a0c8>] ? __do_softirq+0x98/0x1d0
>  [<c10e73c6>] ? sys_ioctl+0x76/0x90
>  [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> BUG: scheduling while atomic: Xorg/9704/0x10000002
> Modules linked in: tg3 libphy option usbserial usb_storage snd_usb_audio snd_usb_lib snd_seq_midi snd_rawmidi uvcvideo [last unloaded: usbserial]
> Pid: 9704, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Call Trace:
>  [<c1677929>] ? schedule+0x409/0x4e0
>  [<c102bba3>] ? __cond_resched+0x13/0x30
>  [<c1677aed>] ? _cond_resched+0x1d/0x30
>  [<c10b9ebf>] ? unmap_vmas+0x63f/0x650
>  [<c10bdf65>] ? exit_mmap+0xa5/0x160
>  [<c1031d47>] ? mmput+0x27/0xc0
>  [<c1035fc4>] ? exit_mm+0xd4/0xf0
>  [<c1069fe0>] ? acct_collect+0x60/0x140
>  [<c1037a91>] ? do_exit+0xe1/0x740
>  [<c1005a1c>] ? oops_end+0x5c/0x90
>  [<c1677403>] ? printk+0x17/0x1a
>  [<c101fd32>] ? no_context+0xc2/0x150
>  [<c1020070>] ? do_page_fault+0x0/0x300
>  [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
>  [<c1679bd2>] ? error_code+0x5e/0x64
>  [<c10e007b>] ? free_pipe_info+0xb/0x20
>  [<c1020070>] ? do_page_fault+0x0/0x300
>  [<c134815a>] ? i915_gem_object_move_to_inactive+0x1a/0xb0
>  [<c1348976>] ? i915_gem_retire_requests+0x196/0x260
>  [<c1348a77>] ? i915_gem_busy_ioctl+0x37/0xa0
>  [<c132ee80>] ? drm_ioctl+0x1f0/0x360
>  [<c1348a40>] ? i915_gem_busy_ioctl+0x0/0xa0
>  [<c105d0f5>] ? tick_handle_oneshot_broadcast+0x75/0xc0
>  [<c1004f6a>] ? timer_interrupt+0x3a/0x50
>  [<c107d805>] ? handle_IRQ_event+0x45/0x180
>  [<c10531f3>] ? hrtimer_forward+0x163/0x1b0
>  [<c107f2cb>] ? handle_edge_irq+0xbb/0x150
>  [<c1004aa5>] ? handle_irq+0x15/0x30
>  [<c132ec90>] ? drm_ioctl+0x0/0x360
>  [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
>  [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
>  [<c10031a9>] ? common_interrupt+0x29/0x30
>  [<c103a0c8>] ? __do_softirq+0x98/0x1d0
>  [<c10e73c6>] ? sys_ioctl+0x76/0x90
>  [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> BUG: scheduling while atomic: Xorg/9704/0x10000002
> Modules linked in: tg3 libphy option usbserial usb_storage snd_usb_audio snd_usb_lib snd_seq_midi snd_rawmidi uvcvideo [last unloaded: usbserial]
> Pid: 9704, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Call Trace:
>  [<c1677929>] ? schedule+0x409/0x4e0
>  [<c102bba3>] ? __cond_resched+0x13/0x30
>  [<c1677aed>] ? _cond_resched+0x1d/0x30
>  [<c10b9ebf>] ? unmap_vmas+0x63f/0x650
>  [<c10bdf65>] ? exit_mmap+0xa5/0x160
>  [<c1031d47>] ? mmput+0x27/0xc0
>  [<c1035fc4>] ? exit_mm+0xd4/0xf0
>  [<c1069fe0>] ? acct_collect+0x60/0x140
>  [<c1037a91>] ? do_exit+0xe1/0x740
>  [<c1005a1c>] ? oops_end+0x5c/0x90
>  [<c1677403>] ? printk+0x17/0x1a
>  [<c101fd32>] ? no_context+0xc2/0x150
>  [<c1020070>] ? do_page_fault+0x0/0x300
>  [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
>  [<c1679bd2>] ? error_code+0x5e/0x64
>  [<c10e007b>] ? free_pipe_info+0xb/0x20
>  [<c1020070>] ? do_page_fault+0x0/0x300
>  [<c134815a>] ? i915_gem_object_move_to_inactive+0x1a/0xb0
>  [<c1348976>] ? i915_gem_retire_requests+0x196/0x260
>  [<c1348a77>] ? i915_gem_busy_ioctl+0x37/0xa0
>  [<c132ee80>] ? drm_ioctl+0x1f0/0x360
>  [<c1348a40>] ? i915_gem_busy_ioctl+0x0/0xa0
>  [<c105d0f5>] ? tick_handle_oneshot_broadcast+0x75/0xc0
>  [<c1004f6a>] ? timer_interrupt+0x3a/0x50
>  [<c107d805>] ? handle_IRQ_event+0x45/0x180
>  [<c10531f3>] ? hrtimer_forward+0x163/0x1b0
>  [<c107f2cb>] ? handle_edge_irq+0xbb/0x150
>  [<c1004aa5>] ? handle_irq+0x15/0x30
>  [<c132ec90>] ? drm_ioctl+0x0/0x360
>  [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
>  [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
>  [<c10031a9>] ? common_interrupt+0x29/0x30
>  [<c103a0c8>] ? __do_softirq+0x98/0x1d0
>  [<c10e73c6>] ? sys_ioctl+0x76/0x90
>  [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> BUG: scheduling while atomic: Xorg/9704/0x10000002
> Modules linked in: tg3 libphy option usbserial usb_storage snd_usb_audio snd_usb_lib snd_seq_midi snd_rawmidi uvcvideo [last unloaded: usbserial]
> Pid: 9704, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Call Trace:
>  [<c1677929>] ? schedule+0x409/0x4e0
>  [<c102bba3>] ? __cond_resched+0x13/0x30
>  [<c1677aed>] ? _cond_resched+0x1d/0x30
>  [<c10b9ebf>] ? unmap_vmas+0x63f/0x650
>  [<c10bdf65>] ? exit_mmap+0xa5/0x160
>  [<c1031d47>] ? mmput+0x27/0xc0
>  [<c1035fc4>] ? exit_mm+0xd4/0xf0
>  [<c1069fe0>] ? acct_collect+0x60/0x140
>  [<c1037a91>] ? do_exit+0xe1/0x740
>  [<c1005a1c>] ? oops_end+0x5c/0x90
>  [<c1677403>] ? printk+0x17/0x1a
>  [<c101fd32>] ? no_context+0xc2/0x150
>  [<c1020070>] ? do_page_fault+0x0/0x300
>  [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
>  [<c1679bd2>] ? error_code+0x5e/0x64
>  [<c10e007b>] ? free_pipe_info+0xb/0x20
>  [<c1020070>] ? do_page_fault+0x0/0x300
>  [<c134815a>] ? i915_gem_object_move_to_inactive+0x1a/0xb0
>  [<c1348976>] ? i915_gem_retire_requests+0x196/0x260
>  [<c1348a77>] ? i915_gem_busy_ioctl+0x37/0xa0
>  [<c132ee80>] ? drm_ioctl+0x1f0/0x360
>  [<c1348a40>] ? i915_gem_busy_ioctl+0x0/0xa0
>  [<c105d0f5>] ? tick_handle_oneshot_broadcast+0x75/0xc0
>  [<c1004f6a>] ? timer_interrupt+0x3a/0x50
>  [<c107d805>] ? handle_IRQ_event+0x45/0x180
>  [<c10531f3>] ? hrtimer_forward+0x163/0x1b0
>  [<c107f2cb>] ? handle_edge_irq+0xbb/0x150
>  [<c1004aa5>] ? handle_irq+0x15/0x30
>  [<c132ec90>] ? drm_ioctl+0x0/0x360
>  [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
>  [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
>  [<c10031a9>] ? common_interrupt+0x29/0x30
>  [<c103a0c8>] ? __do_softirq+0x98/0x1d0
>  [<c10e73c6>] ? sys_ioctl+0x76/0x90
>  [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> BUG: scheduling while atomic: Xorg/9704/0x10000002
> Modules linked in: tg3 libphy option usbserial usb_storage snd_usb_audio snd_usb_lib snd_seq_midi snd_rawmidi uvcvideo [last unloaded: usbserial]
> Pid: 9704, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Call Trace:
>  [<c1677929>] ? schedule+0x409/0x4e0
>  [<c102bba3>] ? __cond_resched+0x13/0x30
>  [<c1677aed>] ? _cond_resched+0x1d/0x30
>  [<c10b9ebf>] ? unmap_vmas+0x63f/0x650
>  [<c10bdf65>] ? exit_mmap+0xa5/0x160
>  [<c1031d47>] ? mmput+0x27/0xc0
>  [<c1035fc4>] ? exit_mm+0xd4/0xf0
>  [<c1069fe0>] ? acct_collect+0x60/0x140
>  [<c1037a91>] ? do_exit+0xe1/0x740
>  [<c1005a1c>] ? oops_end+0x5c/0x90
>  [<c1677403>] ? printk+0x17/0x1a
>  [<c101fd32>] ? no_context+0xc2/0x150
>  [<c1020070>] ? do_page_fault+0x0/0x300
>  [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
>  [<c1679bd2>] ? error_code+0x5e/0x64
>  [<c10e007b>] ? free_pipe_info+0xb/0x20
>  [<c1020070>] ? do_page_fault+0x0/0x300
>  [<c134815a>] ? i915_gem_object_move_to_inactive+0x1a/0xb0
>  [<c1348976>] ? i915_gem_retire_requests+0x196/0x260
>  [<c1348a77>] ? i915_gem_busy_ioctl+0x37/0xa0
>  [<c132ee80>] ? drm_ioctl+0x1f0/0x360
>  [<c1348a40>] ? i915_gem_busy_ioctl+0x0/0xa0
>  [<c105d0f5>] ? tick_handle_oneshot_broadcast+0x75/0xc0
>  [<c1004f6a>] ? timer_interrupt+0x3a/0x50
>  [<c107d805>] ? handle_IRQ_event+0x45/0x180
>  [<c10531f3>] ? hrtimer_forward+0x163/0x1b0
>  [<c107f2cb>] ? handle_edge_irq+0xbb/0x150
>  [<c1004aa5>] ? handle_irq+0x15/0x30
>  [<c132ec90>] ? drm_ioctl+0x0/0x360
>  [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
>  [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
>  [<c10031a9>] ? common_interrupt+0x29/0x30
>  [<c103a0c8>] ? __do_softirq+0x98/0x1d0
>  [<c10e73c6>] ? sys_ioctl+0x76/0x90
>  [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> BUG: scheduling while atomic: Xorg/9704/0x10000002
> Modules linked in: tg3 libphy option usbserial usb_storage snd_usb_audio snd_usb_lib snd_seq_midi snd_rawmidi uvcvideo [last unloaded: usbserial]
> Pid: 9704, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Call Trace:
>  [<c1677929>] ? schedule+0x409/0x4e0
>  [<c102bba3>] ? __cond_resched+0x13/0x30
>  [<c1677aed>] ? _cond_resched+0x1d/0x30
>  [<c10b9ebf>] ? unmap_vmas+0x63f/0x650
>  [<c10bdf65>] ? exit_mmap+0xa5/0x160
>  [<c1031d47>] ? mmput+0x27/0xc0
>  [<c1035fc4>] ? exit_mm+0xd4/0xf0
>  [<c1069fe0>] ? acct_collect+0x60/0x140
>  [<c1037a91>] ? do_exit+0xe1/0x740
>  [<c1005a1c>] ? oops_end+0x5c/0x90
>  [<c1677403>] ? printk+0x17/0x1a
>  [<c101fd32>] ? no_context+0xc2/0x150
>  [<c1020070>] ? do_page_fault+0x0/0x300
>  [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
>  [<c1679bd2>] ? error_code+0x5e/0x64
>  [<c10e007b>] ? free_pipe_info+0xb/0x20
>  [<c1020070>] ? do_page_fault+0x0/0x300
>  [<c134815a>] ? i915_gem_object_move_to_inactive+0x1a/0xb0
>  [<c1348976>] ? i915_gem_retire_requests+0x196/0x260
>  [<c1348a77>] ? i915_gem_busy_ioctl+0x37/0xa0
>  [<c132ee80>] ? drm_ioctl+0x1f0/0x360
>  [<c1348a40>] ? i915_gem_busy_ioctl+0x0/0xa0
>  [<c105d0f5>] ? tick_handle_oneshot_broadcast+0x75/0xc0
>  [<c1004f6a>] ? timer_interrupt+0x3a/0x50
>  [<c107d805>] ? handle_IRQ_event+0x45/0x180
>  [<c10531f3>] ? hrtimer_forward+0x163/0x1b0
>  [<c107f2cb>] ? handle_edge_irq+0xbb/0x150
>  [<c1004aa5>] ? handle_irq+0x15/0x30
>  [<c132ec90>] ? drm_ioctl+0x0/0x360
>  [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
>  [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
>  [<c10031a9>] ? common_interrupt+0x29/0x30
>  [<c103a0c8>] ? __do_softirq+0x98/0x1d0
>  [<c10e73c6>] ? sys_ioctl+0x76/0x90
>  [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> BUG: scheduling while atomic: Xorg/9704/0x10000002
> Modules linked in: tg3 libphy option usbserial usb_storage snd_usb_audio snd_usb_lib snd_seq_midi snd_rawmidi uvcvideo [last unloaded: usbserial]
> Pid: 9704, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Call Trace:
>  [<c1677929>] ? schedule+0x409/0x4e0
>  [<c102bba3>] ? __cond_resched+0x13/0x30
>  [<c1677aed>] ? _cond_resched+0x1d/0x30
>  [<c10b9ebf>] ? unmap_vmas+0x63f/0x650
>  [<c10bdf65>] ? exit_mmap+0xa5/0x160
>  [<c1031d47>] ? mmput+0x27/0xc0
>  [<c1035fc4>] ? exit_mm+0xd4/0xf0
>  [<c1069fe0>] ? acct_collect+0x60/0x140
>  [<c1037a91>] ? do_exit+0xe1/0x740
>  [<c1005a1c>] ? oops_end+0x5c/0x90
>  [<c1677403>] ? printk+0x17/0x1a
>  [<c101fd32>] ? no_context+0xc2/0x150
>  [<c1020070>] ? do_page_fault+0x0/0x300
>  [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
>  [<c1679bd2>] ? error_code+0x5e/0x64
>  [<c10e007b>] ? free_pipe_info+0xb/0x20
>  [<c1020070>] ? do_page_fault+0x0/0x300
>  [<c134815a>] ? i915_gem_object_move_to_inactive+0x1a/0xb0
>  [<c1348976>] ? i915_gem_retire_requests+0x196/0x260
>  [<c1348a77>] ? i915_gem_busy_ioctl+0x37/0xa0
>  [<c132ee80>] ? drm_ioctl+0x1f0/0x360
>  [<c1348a40>] ? i915_gem_busy_ioctl+0x0/0xa0
>  [<c105d0f5>] ? tick_handle_oneshot_broadcast+0x75/0xc0
>  [<c1004f6a>] ? timer_interrupt+0x3a/0x50
>  [<c107d805>] ? handle_IRQ_event+0x45/0x180
>  [<c10531f3>] ? hrtimer_forward+0x163/0x1b0
>  [<c107f2cb>] ? handle_edge_irq+0xbb/0x150
>  [<c1004aa5>] ? handle_irq+0x15/0x30
>  [<c132ec90>] ? drm_ioctl+0x0/0x360
>  [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
>  [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
>  [<c10031a9>] ? common_interrupt+0x29/0x30
>  [<c103a0c8>] ? __do_softirq+0x98/0x1d0
>  [<c10e73c6>] ? sys_ioctl+0x76/0x90
>  [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> BUG: scheduling while atomic: Xorg/9704/0x10000002
> Modules linked in: tg3 libphy option usbserial usb_storage snd_usb_audio snd_usb_lib snd_seq_midi snd_rawmidi uvcvideo [last unloaded: usbserial]
> Pid: 9704, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Call Trace:
>  [<c1677929>] ? schedule+0x409/0x4e0
>  [<c102bba3>] ? __cond_resched+0x13/0x30
>  [<c1677aed>] ? _cond_resched+0x1d/0x30
>  [<c10b9ebf>] ? unmap_vmas+0x63f/0x650
>  [<c10bdf65>] ? exit_mmap+0xa5/0x160
>  [<c1031d47>] ? mmput+0x27/0xc0
>  [<c1035fc4>] ? exit_mm+0xd4/0xf0
>  [<c1069fe0>] ? acct_collect+0x60/0x140
>  [<c1037a91>] ? do_exit+0xe1/0x740
>  [<c1005a1c>] ? oops_end+0x5c/0x90
>  [<c1677403>] ? printk+0x17/0x1a
>  [<c101fd32>] ? no_context+0xc2/0x150
>  [<c1020070>] ? do_page_fault+0x0/0x300
>  [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
>  [<c1679bd2>] ? error_code+0x5e/0x64
>  [<c10e007b>] ? free_pipe_info+0xb/0x20
>  [<c1020070>] ? do_page_fault+0x0/0x300
>  [<c134815a>] ? i915_gem_object_move_to_inactive+0x1a/0xb0
>  [<c1348976>] ? i915_gem_retire_requests+0x196/0x260
>  [<c1348a77>] ? i915_gem_busy_ioctl+0x37/0xa0
>  [<c132ee80>] ? drm_ioctl+0x1f0/0x360
>  [<c1348a40>] ? i915_gem_busy_ioctl+0x0/0xa0
>  [<c105d0f5>] ? tick_handle_oneshot_broadcast+0x75/0xc0
>  [<c1004f6a>] ? timer_interrupt+0x3a/0x50
>  [<c107d805>] ? handle_IRQ_event+0x45/0x180
>  [<c10531f3>] ? hrtimer_forward+0x163/0x1b0
>  [<c107f2cb>] ? handle_edge_irq+0xbb/0x150
>  [<c1004aa5>] ? handle_irq+0x15/0x30
>  [<c132ec90>] ? drm_ioctl+0x0/0x360
>  [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
>  [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
>  [<c10031a9>] ? common_interrupt+0x29/0x30
>  [<c103a0c8>] ? __do_softirq+0x98/0x1d0
>  [<c10e73c6>] ? sys_ioctl+0x76/0x90
>  [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> BUG: scheduling while atomic: Xorg/9704/0x10000002
> Modules linked in: tg3 libphy option usbserial usb_storage snd_usb_audio snd_usb_lib snd_seq_midi snd_rawmidi uvcvideo [last unloaded: usbserial]
> Pid: 9704, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Call Trace:
>  [<c1677929>] ? schedule+0x409/0x4e0
>  [<c102bba3>] ? __cond_resched+0x13/0x30
>  [<c1677aed>] ? _cond_resched+0x1d/0x30
>  [<c10b9ebf>] ? unmap_vmas+0x63f/0x650
>  [<c10bdf65>] ? exit_mmap+0xa5/0x160
>  [<c1031d47>] ? mmput+0x27/0xc0
>  [<c1035fc4>] ? exit_mm+0xd4/0xf0
>  [<c1069fe0>] ? acct_collect+0x60/0x140
>  [<c1037a91>] ? do_exit+0xe1/0x740
>  [<c1005a1c>] ? oops_end+0x5c/0x90
>  [<c1677403>] ? printk+0x17/0x1a
>  [<c101fd32>] ? no_context+0xc2/0x150
>  [<c1020070>] ? do_page_fault+0x0/0x300
>  [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
>  [<c1679bd2>] ? error_code+0x5e/0x64
>  [<c10e007b>] ? free_pipe_info+0xb/0x20
>  [<c1020070>] ? do_page_fault+0x0/0x300
>  [<c134815a>] ? i915_gem_object_move_to_inactive+0x1a/0xb0
>  [<c1348976>] ? i915_gem_retire_requests+0x196/0x260
>  [<c1348a77>] ? i915_gem_busy_ioctl+0x37/0xa0
>  [<c132ee80>] ? drm_ioctl+0x1f0/0x360
>  [<c1348a40>] ? i915_gem_busy_ioctl+0x0/0xa0
>  [<c105d0f5>] ? tick_handle_oneshot_broadcast+0x75/0xc0
>  [<c1004f6a>] ? timer_interrupt+0x3a/0x50
>  [<c107d805>] ? handle_IRQ_event+0x45/0x180
>  [<c10531f3>] ? hrtimer_forward+0x163/0x1b0
>  [<c107f2cb>] ? handle_edge_irq+0xbb/0x150
>  [<c1004aa5>] ? handle_irq+0x15/0x30
>  [<c132ec90>] ? drm_ioctl+0x0/0x360
>  [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
>  [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
>  [<c10031a9>] ? common_interrupt+0x29/0x30
>  [<c103a0c8>] ? __do_softirq+0x98/0x1d0
>  [<c10e73c6>] ? sys_ioctl+0x76/0x90
>  [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> BUG: scheduling while atomic: Xorg/9704/0x00000002
> Modules linked in: tg3 libphy option usbserial usb_storage snd_usb_audio snd_usb_lib snd_seq_midi snd_rawmidi uvcvideo [last unloaded: usbserial]
> Pid: 9704, comm: Xorg Tainted: G      D    2.6.33.1 #3
> Call Trace:
>  [<c1677929>] ? schedule+0x409/0x4e0
>  [<c1678529>] ? __mutex_lock_slowpath+0x99/0x130
>  [<c16783f9>] ? mutex_lock+0x9/0x10
>  [<c133077a>] ? drm_gem_vm_close+0x1a/0x40
>  [<c10bde89>] ? remove_vma+0x19/0x50
>  [<c10bdfcf>] ? exit_mmap+0x10f/0x160
>  [<c1031d47>] ? mmput+0x27/0xc0
>  [<c1035fc4>] ? exit_mm+0xd4/0xf0
>  [<c1069fe0>] ? acct_collect+0x60/0x140
>  [<c1037a91>] ? do_exit+0xe1/0x740
>  [<c1005a1c>] ? oops_end+0x5c/0x90
>  [<c1677403>] ? printk+0x17/0x1a
>  [<c101fd32>] ? no_context+0xc2/0x150
>  [<c1020070>] ? do_page_fault+0x0/0x300
>  [<c101ff2f>] ? bad_area_nosemaphore+0xf/0x20
>  [<c1679bd2>] ? error_code+0x5e/0x64
>  [<c10e007b>] ? free_pipe_info+0xb/0x20
>  [<c1020070>] ? do_page_fault+0x0/0x300
>  [<c134815a>] ? i915_gem_object_move_to_inactive+0x1a/0xb0
>  [<c1348976>] ? i915_gem_retire_requests+0x196/0x260
>  [<c1348a77>] ? i915_gem_busy_ioctl+0x37/0xa0
>  [<c132ee80>] ? drm_ioctl+0x1f0/0x360
>  [<c1348a40>] ? i915_gem_busy_ioctl+0x0/0xa0
>  [<c105d0f5>] ? tick_handle_oneshot_broadcast+0x75/0xc0
>  [<c1004f6a>] ? timer_interrupt+0x3a/0x50
>  [<c107d805>] ? handle_IRQ_event+0x45/0x180
>  [<c10531f3>] ? hrtimer_forward+0x163/0x1b0
>  [<c107f2cb>] ? handle_edge_irq+0xbb/0x150
>  [<c1004aa5>] ? handle_irq+0x15/0x30
>  [<c132ec90>] ? drm_ioctl+0x0/0x360
>  [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
>  [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
>  [<c10031a9>] ? common_interrupt+0x29/0x30
>  [<c103a0c8>] ? __do_softirq+0x98/0x1d0
>  [<c10e73c6>] ? sys_ioctl+0x76/0x90
>  [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> 
> 
> 
> 2010-04-12:
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000044
> IP: [<c134815a>] i915_gem_object_move_to_inactive+0x1a/0xb0
> *pde = 00000000 
> Oops: 0000 [#1] PREEMPT 
> last sysfs file: /sys/devices/pci0000:00/0000:00:1c.0/0000:02:00.0/net/eth0/address
> Modules linked in: tg3 libphy option usbserial usb_storage snd_usb_audio snd_usb_lib snd_seq_midi snd_rawmidi uvcvideo [last unloaded: usbserial]
> 
> Pid: 9704, comm: Xorg Not tainted 2.6.33.1 #3 Columbia                       /Extensa 5220                   
> EIP: 0060:[<c134815a>] EFLAGS: 00213282 CPU: 0
> EIP is at i915_gem_object_move_to_inactive+0x1a/0xb0
> EAX: e322a2c0 EBX: e322a2c0 ECX: 00000000 EDX: 00000000
> ESI: eff63300 EDI: f731a000 EBP: 00000000 ESP: f5cf5de0
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process Xorg (pid: 9704, ti=f5cf4000 task=f5ce0580 task.ti=f5cf4000)
> Stack:
>  e322a2c0 eff63300 f731a000 c1348976 f731ae00 f731a000 f7394000 007aaad3
> <0> f731ae28 f7394000 f5cf5e70 e13704c0 f7394010 c1348a77 ffffffa1 f5ce0580
> <0> 00000000 f5e5e7c0 f7394000 c0086457 00000057 c132ee80 00000001 c17c3363
> Call Trace:
>  [<c1348976>] ? i915_gem_retire_requests+0x196/0x260
>  [<c1348a77>] ? i915_gem_busy_ioctl+0x37/0xa0
>  [<c132ee80>] ? drm_ioctl+0x1f0/0x360
>  [<c1348a40>] ? i915_gem_busy_ioctl+0x0/0xa0
>  [<c105d0f5>] ? tick_handle_oneshot_broadcast+0x75/0xc0
>  [<c1004f6a>] ? timer_interrupt+0x3a/0x50
>  [<c107d805>] ? handle_IRQ_event+0x45/0x180
>  [<c10531f3>] ? hrtimer_forward+0x163/0x1b0
>  [<c107f2cb>] ? handle_edge_irq+0xbb/0x150
>  [<c1004aa5>] ? handle_irq+0x15/0x30
>  [<c132ec90>] ? drm_ioctl+0x0/0x360
>  [<c10e6beb>] ? vfs_ioctl+0x2b/0xa0
>  [<c10e6dd9>] ? do_vfs_ioctl+0x79/0x5f0
>  [<c10031a9>] ? common_interrupt+0x29/0x30
>  [<c103a0c8>] ? __do_softirq+0x98/0x1d0
>  [<c10e73c6>] ? sys_ioctl+0x76/0x90
>  [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Code: ff ff eb 0d 90 90 90 90 90 90 90 90 90 90 90 90 90 83 ec 0c 89 1c 24 89 74 24 04 89 7c 24 08 8b 50 08 8b 8a 14 02 00 00 8b 50 50 <8b> 72 44 85 f6 74 5f 8b 72 08 8d 4a 08 8b 5a 0c 89 5e 04 89 33 
> EIP: [<c134815a>] i915_gem_object_move_to_inactive+0x1a/0xb0 SS:ESP 0068:f5cf5de0
> CR2: 0000000000000044
> ---[ end trace 61bdac1bfaeb94e7 ]---
> 
> 
> 2010-04-08:
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000003
> IP: [<c129dc15>] plist_del+0x25/0x70
> *pde = 00000000 
> Oops: 0002 [#1] PREEMPT 
> last sysfs file: /sys/devices/pci0000:00/0000:00:1c.0/0000:02:00.0/net/eth0/address
> Modules linked in: option usbserial usb_storage tg3 libphy [last unloaded: ath_hal]
> 
> Pid: 9131, comm: firefox-bin Not tainted 2.6.33.1 #3 Columbia                       /Extensa 5220                   
> EIP: 0060:[<c129dc15>] EFLAGS: 00210286 CPU: 0
> EIP is at plist_del+0x25/0x70
> EAX: eacefea8 EBX: ffffffff ECX: c197c52c EDX: eacefeac
> ESI: c197c530 EDI: ffffffff EBP: c1975c38 ESP: f63a7edc
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process firefox-bin (pid: 9131, ti=f63a6000 task=f7102a90 task.ti=f63a6000)
> Stack:
>  f5bffe40 eacefea8 00000001 c105f43a c197c52c 00000001 c1061613 f7102a90
> <0> c1018a03 c105c620 55654362 00000000 00000000 c1040962 0000092a b71b3388
> <0> 04000001 c1975c30 00000000 c1975550 00000000 00000001 00000004 00000000
> Call Trace:
>  [<c105f43a>] ? wake_futex+0x1a/0x60
>  [<c1061613>] ? do_futex+0x513/0xa60
>  [<c1018a03>] ? lapic_next_event+0x13/0x20
>  [<c105c620>] ? clockevents_program_event+0xa0/0x160
>  [<c1040962>] ? run_timer_softirq+0x12/0x350
>  [<c1061c06>] ? sys_futex+0xa6/0x140
>  [<c103a3ac>] ? irq_exit+0x2c/0x70
>  [<c1679839>] ? syscall_call+0x7/0xb
> Code: d9 ff eb eb 90 90 83 ec 0c 8d 50 04 3b 50 04 89 1c 24 89 74 24 04 89 7c 24 08 74 33 8b 70 0c 8d 4e f4 83 ee 08 8b 59 08 8b 79 04 <89> 5f 04 89 3b 8b 58 08 89 70 08 89 51 04 89 59 08 89 33 8b 58 
> EIP: [<c129dc15>] plist_del+0x25/0x70 SS:ESP 0068:f63a7edc
> CR2: 0000000000000003
> ---[ end trace a8b535a8077857ba ]---
> note: firefox-bin[9131] exited with preempt_count 2
> 
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000003
> IP: [<c129dc15>] plist_del+0x25/0x70
> *pde = 00000000 
> Oops: 0002 [#1] PREEMPT 
> last sysfs file: /sys/devices/pci0000:00/0000:00:1c.0/0000:02:00.0/net/eth0/addr
> ess
> Modules linked in: option usbserial usb_storage tg3 libphy [last unloaded: ath_h
> al]
> 
> Pid: 9131, comm: firefox-bin Not tainted 2.6.33.1 #3 Columbia                   
>     /Extensa 5220                   
> EIP: 0060:[<c129dc15>] EFLAGS: 00210286 CPU: 0
> EIP is at plist_del+0x25/0x70
> EAX: eacefea8 EBX: ffffffff ECX: c197c52c EDX: eacefeac
> ESI: c197c530 EDI: ffffffff EBP: c1975c38 ESP: f63a7edc
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process firefox-bin (pid: 9131, ti=f63a6000 task=f7102a90 task.ti=f63a6000)
> Stack:
>  f5bffe40 eacefea8 00000001 c105f43a c197c52c 00000001 c1061613 f7102a90
> <0> c1018a03 c105c620 55654362 00000000 00000000 c1040962 0000092a b71b3388
> <0> 04000001 c1975c30 00000000 c1975550 00000000 00000001 00000004 00000000
> Call Trace:
>  [<c105f43a>] ? wake_futex+0x1a/0x60
>  [<c1061613>] ? do_futex+0x513/0xa60
>  [<c1018a03>] ? lapic_next_event+0x13/0x20
>  [<c105c620>] ? clockevents_program_event+0xa0/0x160
>  [<c1040962>] ? run_timer_softirq+0x12/0x350
>  [<c1061c06>] ? sys_futex+0xa6/0x140
>  [<c103a3ac>] ? irq_exit+0x2c/0x70
>  [<c1679839>] ? syscall_call+0x7/0xb
> Code: d9 ff eb eb 90 90 83 ec 0c 8d 50 04 3b 50 04 89 1c 24 89 74 24 04 89 7c 24 08 74 33 8b 70 0c 8d 4e f4 83 ee 08 8b 59 08 8b 79 04 <89> 5f 04 89 3b 8b 58 08 89 70 08 89 51 04 89 59 08 89 33 8b 58 
> EIP: [<c129dc15>] plist_del+0x25/0x70 SS:ESP 0068:f63a7edc
> CR2: 0000000000000003
> ---[ end trace a8b535a8077857ba ]---
> note: firefox-bin[9131] exited with preempt_count 2
> BUG: unable to handle kernel NULL pointer dereference at 00000003
> IP: [<c129dc15>] plist_del+0x25/0x70
> *pde = 00000000 
> Oops: 0002 [#2] PREEMPT 
> last sysfs file: /sys/devices/pci0000:00/0000:00:1c.0/0000:02:00.0/net/eth0/address
> Modules linked in: option usbserial usb_storage tg3 libphy [last unloaded: ath_hal]
> 
> Pid: 9140, comm: firefox-bin Tainted: G      D    2.6.33.1 #3 Columbia                       /Extensa 5220                   
> EIP: 0060:[<c129dc15>] EFLAGS: 00210286 CPU: 0
> EIP is at plist_del+0x25/0x70
> EAX: eacefea8 EBX: ffffffff ECX: c197c52c EDX: eacefeac
> ESI: c197c530 EDI: ffffffff EBP: f5bfc540 ESP: eacefe38
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process firefox-bin (pid: 9140, ti=eacee000 task=f5bfc540 task.ti=eacee000)
> Stack:
>  eacefe64 eacefea8 00000000 c105f217 eacefea8 eacefee0 eacefeb4 b71b3388
> <0> 00000000 0000162b eacefee0 c185fd80 00000000 00000000 d878cdac 0000092a
> <0> d8780a5c 0000092a c10532e0 c185f72c 00000000 000023b4 c10543f0 65726966
> Call Trace:
>  [<c105f217>] ? futex_wait+0x127/0x2c0
>  [<c10532e0>] ? hrtimer_wakeup+0x0/0x20
>  [<c10543f0>] ? hrtimer_start_range_ns+0x20/0x30
>  [<c106121d>] ? do_futex+0x11d/0xa60
>  [<c10538cd>] ? __run_hrtimer+0xad/0x200
>  [<c10d8826>] ? rw_verify_area+0x66/0xe0
>  [<c1058dab>] ? ktime_get+0x5b/0xf0
>  [<c1061c06>] ? sys_futex+0xa6/0x140
>  [<c1002c0c>] ? sysenter_do_call+0x12/0x22
> Code: d9 ff eb eb 90 90 83 ec 0c 8d 50 04 3b 50 04 89 1c 24 89 74 24 04 89 7c 24 08 74 33 8b 70 0c 8d 4e f4 83 ee 08 8b 59 08 8b 79 04 <89> 5f 04 89 3b 8b 58 08 89 70 08 89 51 04 89 59 08 89 33 8b 58 
> EIP: [<c129dc15>] plist_del+0x25/0x70 SS:ESP 0068:eacefe38
> CR2: 0000000000000003
> ---[ end trace a8b535a8077857bb ]---
> note: firefox-bin[9140] exited with preempt_count 1
> 
> 
> 
> 
> Previous message also regarding NULL ptr deref w/ Xorg and "last sysfs file" was the wireless file:
> 
>   Hi,
> 
> It happens quite often that X crashes for unknown reasons but this time
> there it's left us a note, this BUG:
> 
> BUG: unable to handle kernel NULL pointer dereference at 000001e4
> IP: [<c134ddbc>] i915_gem_object_move_to_active+0x1c/0xa0
> *pde = 00000000
> Oops: 0000 [#4] PREEMPT
> last sysfs file: /sys/devices/pci0000:00/0000:00:1c.1/0000:04:00.0/net/wlan0/wireless/link
> Modules linked in: wlan_scan_sta ath_rate_sample ath_pci ath_hal option usbserial usb_storage
> +snd_usb_audio snd_usb_lib snd_seq_midi snd_rawmidi uvcvideo wlan_ccmp video1394 raw1394 dv1394
> +firewire_ohci firewire_core wlan ohci1394 tg3 libphy ieee1394 [last unloaded: ath_hal]
> 
> Pid: 3328, comm: Xorg Tainted: G      D    2.6.33 #1 Columbia                       /Extensa 5220
> EIP: 0060:[<c134ddbc>] EFLAGS: 00213282 CPU: 0
> EIP is at i915_gem_object_move_to_active+0x1c/0xa0
> EAX: 00000000 EBX: c6679450 ECX: c679fd50 EDX: 00b10a13
> ESI: 00000000 EDI: 00000000 EBP: 00b10a13 ESP: f51c1cb0
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process Xorg (pid: 3328, ti=f51c0000 task=f6be5bf0 task.ti=f51c0000)
> Stack:
>  c6679450 00000004 00000000 c679fd50 c134e83f 00000002 c17d42ab c16e3b29
> <0> c17d71ee 00b10a13 00000004 f7395800 f7318000 f7318e10 c1326450 f7318df8
> <0> f6baff20 00b10a13 f7318de8 f7318e10 f7318000 00000004 00000001 f7395800
> Call Trace:
>  [<c134e83f>] ? i915_add_request+0x25f/0x370
>  [<c1326450>] ? agp_flush_chipset+0x10/0x20
>  [<c1352d55>] ? i915_gem_do_execbuffer+0x1325/0x13a0
>  [<c102e087>] ? check_preempt_wakeup+0x87/0x160
>  [<c13530ae>] ? i915_gem_execbuffer+0xee/0x4b0
>  [<c13531fb>] ? i915_gem_execbuffer+0x23b/0x4b0
>  [<c1334056>] ? drm_ioctl+0x186/0x380
>  [<c1352fc0>] ? i915_gem_execbuffer+0x0/0x4b0
>  [<c10d79dd>] ? do_sync_read+0xad/0xf0
>  [<c1333ed0>] ? drm_ioctl+0x0/0x380
>  [<c10e5fcb>] ? vfs_ioctl+0x2b/0xa0
>  [<c10e61a3>] ? do_vfs_ioctl+0x73/0x5f0
>  [<c1038229>] ? do_setitimer+0xd9/0x220
>  [<c1058a93>] ? ktime_get_ts+0xe3/0x100
>  [<c104e1e0>] ? posix_ktime_get_ts+0x0/0x10
>  [<c10e6786>] ? sys_ioctl+0x66/0x70
>  [<c1002c8c>] ? sysenter_do_call+0x12/0x22
> Code: 8a 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 83 ec 10 89 c1 89 6c 24 0c 89 d5 89 1c 24 89
> +74 24 04 89 7c 24 08 8b 40 08 8b 71 50 <8b> b8 e4 01 00 00 8b 46 20 85 c0 74 5f 89 e1 81 e1 00
> +e0 ff ff
> EIP: [<c134ddbc>] i915_gem_object_move_to_active+0x1c/0xa0 SS:ESP 0068:f51c1cb0
> CR2: 00000000000001e4
> ---[ end trace 13931f32db9a26c3 ]---
> 
> 
> - Is there any particular meaning for "last sysfs file" shown? I mean, could there
>   be some link between the crash and "last sysfs file"?
> 
> - X crashing happens actually a lot on this specific notebook. If it's not X crashing,
>   then unmotivated kde log-offs or frequent firefox crashes contribute their share.
>   It's most probably not faulty RAM, it's new, it's been tested thoroughly.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
