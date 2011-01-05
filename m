Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab1AEWRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 17:17:04 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41888 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751176Ab1AEWRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 17:17:02 -0500
Date: Wed, 5 Jan 2011 17:16:59 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Module parameters and __initdata
Message-ID: <Pine.LNX.4.44L0.1101051708520.1657-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is the proper use of "__initdata" with module parameters documented 
anywhere?

I'm running into problems with drivers/usb/gadget/printer.c, which 
includes code such as this:


static ushort __initdata bcdDevice;
module_param(bcdDevice, ushort, S_IRUGO);
MODULE_PARM_DESC(bcdDevice, "USB Device version (BCD)");

static char *__initdata iManufacturer;
module_param(iManufacturer, charp, S_IRUGO);
MODULE_PARM_DESC(iManufacturer, "USB Manufacturer string");


In 2.6.37, when the module is unloaded the rmmod process gets an
invalid access trying to free the charp parameter:

[   60.763734] BUG: unable to handle kernel paging request at f0547594
[   60.763960] IP: [<c1036d80>] param_free_charp+0x1/0xc
[   60.764014] *pde = 29e58067 *pte = 00000000 
[   60.764014] Oops: 0000 [#1] PREEMPT SMP 
[   60.764014] last sysfs file: /sys/devices/platform/dummy_hcd/usb9/9-1/9-1:1.0/ieee1284_id
[   60.764014] Modules linked in: usblp dummy_hcd i915 drm_kms_helper drm fb fbdev i2c_algo_bit cfbcopyarea i2c_core video backlight output cfbimgblt cfbfillrect pcspkr e100 ohci_hcd ehci_hcd mii uhci_hcd evdev processor fan button thermal_sys usbcore [last unloaded: g_printer]
[   60.764014] 
[   60.764014] Pid: 1707, comm: rmmod Not tainted 2.6.37 #1 08FCh/HP dx2000 MT (EE004AA)
[   60.764014] EIP: 0060:[<c1036d80>] EFLAGS: 00010282 CPU: 0
[   60.764014] EIP is at param_free_charp+0x1/0xc
[   60.764014] EAX: f0547594 EBX: f0542f1c ECX: c1036d7f EDX: 00000008
[   60.764014] ESI: 00000001 EDI: 00000008 EBP: ed9c5f30 ESP: ed9c5f1c
[   60.764014]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   60.764014] Process rmmod (pid: 1707, ti=ed9c4000 task=ed82d8c0 task.ti=ed9c4000)
[   60.764014] Stack:
[   60.764014]  ed9c5f30 c1037581 f0543560 edba0640 00000050 ed9c5f48 c104c5b9 f05435a8
[   60.764014]  f0543560 00000880 00000000 ed9c5fac c104cfaf 72705f67 65746e69 00000072
[   60.764014]  ed9c5f6c c10747f2 ed538000 00000246 ed9c5f74 00000046 ed9c5f90 00000246
[   60.764014] Call Trace:
[   60.764014]  [<c1037581>] ? destroy_params+0x1d/0x2c
[   60.764014]  [<c104c5b9>] ? free_module+0x131/0x178
[   60.764014]  [<c104cfaf>] ? sys_delete_module+0x1a6/0x1c1
[   60.764014]  [<c10747f2>] ? remove_vma+0x52/0x58
[   60.764014]  [<c11e06a0>] ? restore_all_notrace+0x0/0x18
[   60.764014]  [<c1002850>] ? sysenter_do_call+0x12/0x36
[   60.764014] Code: 8d 4b 08 39 c8 75 10 89 d8 e8 55 89 0c 00 89 d8 e8 01 90 04 00 eb 10 89 d3 8b 13 0f 18 02 90 81 fb 7c c3 2f c1 75 d9 5b 5d c3 55 <8b> 00 89 e5 e8 c0 ff ff ff 5d c3 55 89 e5 57 89 d7 56 53 8b 72 
[   60.764014] EIP: [<c1036d80>] param_free_charp+0x1/0xc SS:ESP 0068:ed9c5f1c
[   60.764014] CR2: 00000000f0547594
[   60.764014] ---[ end trace 1c4f6a8c3969118f ]---

What's going on?  Is the kernel trying to free data that was released
when the module finished initializing?

Thanks for any help.

Alan Stern

