Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808Ab0HJOat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 10:30:49 -0400
Received: from evpatoria.com.ua ([82.207.110.34]:55544 "EHLO
	mail.evpatoria.com.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab0HJOan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 10:30:43 -0400
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Aug 2010 10:30:43 EDT
Message-ID: <4C61605E.1080508@evpatoria.com.ua>
Date: Tue, 10 Aug 2010 17:21:18 +0300
From: Alexander <aledin@evpatoria.com.ua>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; ru; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] char: mxser.c, tty->driver_data is not set, kernel 2.6.33.7
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

tty->driver_data is not initialized in drivers/char/mxser.c, so it results in
something like this:


BUG: unable to handle kernel NULL pointer dereference at 0000007c
IP: [<d098753f>] mxser_change_speed+0x1f/0x5e0 [mxser]
...
Pid: 1662, comm: msterm Not tainted 2.6.33.4-smp #1 nVidia-nForce/
EIP: 0060:[<d098753f>] EFLAGS: 00010092 CPU: 0
EIP is at mxser_change_speed+0x1f/0x5e0 [mxser]
EAX: cb0b1840 EBX: 00000000 ECX: 0000c400 EDX: cb263800
ESI: 00000cbd EDI: cb263800 EBP: cf9a3dc0 ESP: cf9a3d7c
DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process msterm (pid: 1662, ti=cf9a2000 task=cf930000 task.ti=cf9a2000)
Stack:
 00000000 cb263800 cb0ec000 00000001 00000003 c16274d0 c16274cc 00000001
<0> 00000292 cf9a3dc0 c1647740 d098b5bc d098b5bc cb263800 0000c405 d098b5bc
<0> cb263800 cf9a3de8 d0987e4e d098b5a0 d098b6fc 0000c406 0000c402 00000286
Call Trace:
 [<d0987e4e>] ? mxser_activate+0x12e/0x1b0 [mxser]
 [<c129d5df>] ? tty_port_open+0x6f/0xb0
 [<d0988306>] ? mxser_open+0x76/0x80 [mxser]
 [<c12970fc>] ? tty_open+0x22c/0x510
 [<c10dee4b>] ? chrdev_open+0xbb/0x1a0
 [<c105f0aa>] ? in_group_p+0x2a/0x30
 [<c10d9e53>] ? __dentry_open+0xe3/0x290
 [<c10e3f73>] ? inode_permission+0x83/0xb0
 [<c10db04a>] ? nameidata_to_filp+0x4a/0x60
 [<c10ded90>] ? chrdev_open+0x0/0x1a0
 [<c10e732a>] ? do_filp_open+0x6fa/0x9b0
 [<c1057b5d>] ? remove_wait_queue+0x3d/0x50
 [<c129bb4d>] ? tty_ldisc_deref+0xd/0x10
 [<c12961f7>] ? tty_write+0x1b7/0x1e0
 [<c10f0de4>] ? alloc_fd+0x74/0x100
 [<c10d9c06>] ? do_sys_open+0x56/0x110
 [<c10d9d2e>] ? sys_open+0x2e/0x40
 [<c1471874>] ? syscall_call+0x7/0xb
Code: b6 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 57 56 53 83 ec 38 0f 1f 44 00
00 89 45 c0 89 c2 8b 98 3c 01 00 00 8b 40 44 8b 70 08 <8b> 43 7c 85 c0 0f 84 bc
01 00 00 8b 42 10 8b 04 85 c0 df 98 d0
EIP: [<d098753f>] mxser_change_speed+0x1f/0x5e0 [mxser] SS:ESP 0068:cf9a3d7c
CR2: 000000000000007c

In kernels 2.6.34 and up it's fixed already, but not in 2.6.33.7.

The included patch is against 2.6.33.7:



--- linux-2.6.33.7/drivers/char/mxser.c	2010-08-02 20:27:18.000000000 +0300
+++ my-linux-2.6.33.7/drivers/char/mxser.c	2010-08-10 15:14:01.000000000 +0300
@@ -1012,6 +1012,8 @@
 	if (!info->ioaddr)
 		return -ENODEV;

+	tty->driver_data = info;
+
 	return tty_port_open(&info->port, tty, filp);
 }





-- 
Alexander Pravdin
aledin@evpatoria.com.ua

