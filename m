Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab1HAVJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 17:09:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab1HAVJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 17:09:15 -0400
Date: Mon, 1 Aug 2011 17:09:06 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: edwin_rong <edwin_rong@realsil.com.cn>, wwang <wei_wang@realsil.com.cn>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: ums-realtek driver uses stack memory for DMA
Message-ID: <20110801210905.GC2096@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We have a report that the ums-realtek driver is generating a backtrace
due to using stack variables for DMA buffers.  The backtrace is below
and you can view the bug report here:
https://bugzilla.redhat.com/show_bug.cgi?id=720054

Looking through the code, it seems that every call to rts51x_read_mem,
rts51x_write_mem, and rts51x_read_status passes a stack variable to
rts51x_bulk_transport, which then calls usb_stor_bulk_transfer_buf with
this and generates the backtrace.  It is my understanding that the
driver should be passing variables that are not on the stack and have
been allocated with memory that will be suitable for the DMA api (e.g.
kmalloc).

Was this missed during the initial review and is anyone working on
adapting the driver to be compliant?

josh

[   12.979109] ------------[ cut here ]------------
[   12.981226] WARNING: at lib/dma-debug.c:875 check_for_stack+0x95/0xd3()
[   12.983340] Hardware name: TOSHIBA NB555D
[   12.985511] ehci_hcd 0000:00:13.2: DMA-API: device driver maps memory fromstack [addr=ffff88002dfa9ca4]
[   12.988088] Modules linked in: ums_realtek(+) usb_storage video radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
[   12.990453] Pid: 234, comm: modprobe Not tainted 3.0-0.rc6.git0.1.fc16.x86_64 #1
[   12.992729] Call Trace:
[   12.995051]  [<ffffffff81057b0c>] warn_slowpath_common+0x83/0x9b
[   12.997563]  [<ffffffff81057bc7>] warn_slowpath_fmt+0x46/0x48
[   12.999945]  [<ffffffff8126c2c0>] check_for_stack+0x95/0xd3
[   13.002261]  [<ffffffff8126c517>] debug_dma_map_page+0xc8/0xf1
[   13.004943]  [<ffffffff8137d47e>] dma_map_single_attrs.constprop.7+0xa7/0xba
[   13.007263]  [<ffffffff8100ee82>] ? sched_clock+0x9/0xd
[   13.009622]  [<ffffffff8137d6e7>] usb_hcd_map_urb_for_dma+0x256/0x2e1
[   13.011938]  [<ffffffff8137dd80>] usb_hcd_submit_urb+0x60e/0x6eb
[   13.014280]  [<ffffffff810917c0>] ? __module_address+0x61/0xa0
[   13.016570]  [<ffffffff81094aa3>] ? is_module_address+0xe/0x16
[   13.018908]  [<ffffffff8137eb81>] usb_submit_urb+0x301/0x313
[   13.021567]  [<ffffffff81074d3b>] ? __init_waitqueue_head+0x3a/0x4b
[   13.023955]  [<ffffffffa011acb9>] usb_stor_msg_common+0xb4/0x14b [usb_storage]
[   13.026350]  [<ffffffff814f149f>] ? wait_for_common+0xbb/0x10a
[   13.028782]  [<ffffffffa006507e>] ? kzalloc.constprop.2+0x13/0x15 [ums_realtek]
[   13.031183]  [<ffffffffa011b02c>] usb_stor_bulk_transfer_buf+0x5c/0x9e [usb_storage]
[   13.033636]  [<ffffffffa006515a>] rts51x_bulk_transport.constprop.4+0xda/0x162 [ums_realtek]
[   13.036454]  [<ffffffffa00655ef>] init_realtek_cr+0x13f/0x484 [ums_realtek]
[   13.038930]  [<ffffffff8137ecb3>] ? usb_alloc_urb+0x1b/0x43
[   13.041355]  [<ffffffffa011c217>] usb_stor_probe2+0x19e/0x305 [usb_storage]
[   13.043804]  [<ffffffffa0065050>] realtek_cr_probe+0x50/0x52 [ums_realtek]
[   13.046210]  [<ffffffff81382936>] usb_probe_interface+0x150/0x1bd
[   13.048695]  [<ffffffff81322c3b>] driver_probe_device+0x131/0x213
[   13.051087]  [<ffffffff81322d7b>] __driver_attach+0x5e/0x82
[   13.053833]  [<ffffffff81322d1d>] ? driver_probe_device+0x213/0x213
[   13.056130]  [<ffffffff81321c7c>] bus_for_each_dev+0x59/0x8f
[   13.058412]  [<ffffffff8132280f>] driver_attach+0x1e/0x20
[   13.060617]  [<ffffffff81322427>] bus_add_driver+0xd4/0x22a
[   13.062845]  [<ffffffff8132320a>] driver_register+0x98/0x105
[   13.065034]  [<ffffffff81381a63>] usb_register_driver+0xb8/0x17c
[   13.067245]  [<ffffffffa006a000>] ? 0xffffffffa0069fff
[   13.069738]  [<ffffffffa006a01e>] realtek_cr_init+0x1e/0x1000 [ums_realtek]
[   13.071930]  [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
[   13.074034]  [<ffffffffa006a000>] ? 0xffffffffa0069fff
[   13.076086]  [<ffffffff810943bc>] sys_init_module+0x114/0x268
[   13.078033]  [<ffffffff814fa242>] system_call_fastpath+0x16/0x1b
[   13.079946] ---[ end trace 5f1c6a899311190a ]---
