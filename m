Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab1LMPUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 10:20:22 -0500
Received: from lo.gmane.org ([80.91.229.12]:51168 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940Ab1LMPUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 10:20:19 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: batouzo <batouzo@gmx.com>
Subject: [3.1.4] mm slub memory corruption in drm_vblank_cleanup
Date: Tue, 13 Dec 2011 16:14:22 +0100
Message-ID: <jc7q4e$qv9$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: ip-1-141.gemini.net.pl
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, we where building 3.1.4 kernel when we noticed BUG()s on bootup.

After some debugging it seems to be use after freed memory corruption
caused by radeon driver.
With radeon + kms the bug happens around 1 in 3 boot ups, right after
the radeon is enabled (with slub debugging) or later with no debug (few
seconds later or on shutdown esp. in rmmod).

When disabling radeon and KMS the bug was not seen;


Allocated in drm_vblank_init+0x139/0x260 [drm] + Freed in
drm_vblank_cleanup+0x78/0x90 [drm]
Allocated in drm_vblank_init+0xbe/0x260 [drm] + Freed in
drm_vblank_cleanup+0x48/0x90 [drm]

It is Amd Bulldozer computer, with Radeon card:
01:00.0 VGA compatible controller: ATI Technologies Inc Cedar PRO
[Radeon HD 5450]

Debian stable. Builded with make-kpkg using gcc 4.4.5

   messages: http://pastebin.com/NXN5EPtG
config used: http://pastebin.com/AeVxEX7c

Interesting part of the messages linked above is:


[   94.401991] fb0: radeondrmfb frame buffer device
[   94.401992] drm: registered panic notifier
[   94.402033] [drm] Initialized radeon 2.11.0 20080528 for 0000:01:00.0
on minor 0
[   94.402921]
=============================================================================
[   94.402961] BUG kmalloc-16: Poison overwritten
[   94.402982]
-----------------------------------------------------------------------------
[   94.402983]
[   94.403025] INFO: 0xffff880137dbbc38-0xffff880137dbbc3b. First byte
0x0 instead of 0x6b
[   94.403066] INFO: Allocated in drm_vblank_init+0x139/0x260 [drm]
age=253 cpu=3 pid=535
[   94.403103]  set_track+0x58/0x100
[   94.403119]  alloc_debug_processing+0x160/0x170
[   94.403140]  __slab_alloc+0x26d/0x440
[   94.403160]  drm_vblank_init+0x139/0x260 [drm]
[   94.403182]  drm_debugfs_create_files+0xcb/0x1a0 [drm]
[   94.403208]  drm_vblank_init+0x139/0x260 [drm]
[   94.403228]  __kmalloc+0x100/0x180
[   94.403247]  drm_vblank_init+0x139/0x260 [drm]
[   94.403276]  radeon_irq_kms_init+0x6d/0x160 [radeon]
[   94.403303]  evergreen_init+0x11c/0x2a0 [radeon]
[   94.403337]  radeon_device_init+0x3c9/0x470 [radeon]
[   94.403367]  radeon_driver_load_kms+0xad/0x160 [radeon]
[   94.403394]  drm_get_pci_dev+0x198/0x2c0 [drm]
[   94.403416]  local_pci_probe+0x55/0xd0
[   94.403433]  pci_device_probe+0x10a/0x130
[   94.403453]  driver_sysfs_add+0x72/0xa0
[   94.403474] INFO: Freed in drm_vblank_cleanup+0x78/0x90 [drm] age=235
cpu=0 pid=535
[   94.403508]  set_track+0x58/0x100
[   94.403524]  free_debug_processing+0x1f3/0x240
[   94.403545]  __slab_free+0x1a6/0x2b0
[   94.403562]  native_read_tsc+0x2/0x20
[   94.403580]  delay_tsc+0x42/0x80
[   94.403598]  drm_vblank_cleanup+0x78/0x90 [drm]
[   94.403625]  radeon_irq_kms_fini+0xd/0x60 [radeon]
[   94.403651]  evergreen_init+0x289/0x2a0 [radeon]
[   94.403677]  radeon_device_init+0x3c9/0x470 [radeon]
[   94.403704]  radeon_driver_load_kms+0xad/0x160 [radeon]
[   94.403731]  drm_get_pci_dev+0x198/0x2c0 [drm]
[   94.403751]  local_pci_probe+0x55/0xd0
[   94.403772]  pci_device_probe+0x10a/0x130
[   94.403791]  driver_sysfs_add+0x72/0xa0
[   94.404806]  driver_probe_device+0x8e/0x1b0
[   94.405782]  __driver_attach+0x93/0xa0
[   94.406031] INFO: Slab 0xffffea0004df6e80 objects=23 used=23 fp=0x
       (null) flags=0x200000000004080
[   94.406031] INFO: Object 0xffff880137dbbc38 @offset=7224
fp=0xffff880137dbb830
[   94.406031]
[   94.406031] Bytes b4 0xffff880137dbbc28:  06 0e ff ff 00 00 00 00 5a
5a 5a 5a 5a 5a 5a 5a ..��....ZZZZZZZZ
[   94.406031]   Object 0xffff880137dbbc38:  00 00 00 00 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b a5 ....kkkkkkkkkkk�
[   94.406031]  Redzone 0xffff880137dbbc48:  bb bb bb bb bb bb bb bb
                     ��������
[   94.406031]  Padding 0xffff880137dbbd88:  5a 5a 5a 5a 5a 5a 5a 5a
                     ZZZZZZZZ
[   94.406031] Pid: 466, comm: udevd Not tainted 3.1.4-norm007+dbg #1
[   94.406031] Call Trace:
[   94.406031]  [] ? check_bytes_and_report+0x110/0x150
[   94.406031]  [] ? check_object+0x1fe/0x250
[   94.406031]  [] ? shmem_symlink+0xd4/0x220
[   94.406031]  [] ? shmem_symlink+0xd4/0x220
[   94.406031]  [] ? alloc_debug_processing+0xee/0x170
[   94.406031]  [] ? __slab_alloc+0x26d/0x440
[   94.406031]  [] ? shmem_symlink+0xd4/0x220
[   94.406031]  [] ? inode_init_always+0xfc/0x1b0
[   94.406031]  [] ? alloc_inode+0x32/0x90
[   94.406031]  [] ? shmem_symlink+0xd4/0x220
[   94.406031]  [] ? __kmalloc_track_caller+0xf8/0x180
[   94.406031]  [] ? kmemdup+0x27/0x60
[   94.406031]  [] ? shmem_symlink+0xd4/0x220
[   94.406031]  [] ? vfs_symlink+0x87/0xa0
[   94.406031]  [] ? sys_symlinkat+0xdc/0xf0
[   94.406031]  [] ? system_call_fastpath+0x16/0x1b
[   94.406031] FIX kmalloc-16: Restoring
0xffff880137dbbc38-0xffff880137dbbc3b=0x6b






