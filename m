Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab0GGBNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 21:13:44 -0400
Received: from mail.gmx.net ([213.165.64.20]:60770 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753624Ab0GGBNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 21:13:42 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+dk9wHc4ade6GVg9NSSM5wHsntfHileh/PQItP1E
	5RQrNKsmqe0lUD
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: devel@driverdev.osuosl.org
Subject: Oops after unloading staging/panel/panel.ko
Date: Wed, 7 Jul 2010 03:13:38 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007070313.38814.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just tried to get the driver working with my lcd display (hd44780 
compatible) and the kernel oops'ed - but unfortunately I can't figure out why.

Steps to reproduce:
1) compile panel driver with
CONFIG_PANEL=m
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=0
CONFIG_PANEL_KEYPAD=0
CONFIG_PANEL_LCD=1
CONFIG_PANEL_LCD_HEIGHT=2
CONFIG_PANEL_LCD_WIDTH=20
CONFIG_PANEL_LCD_BWIDTH=40
CONFIG_PANEL_LCD_HWIDTH=64
CONFIG_PANEL_LCD_CHARSET=1
CONFIG_PANEL_LCD_PROTO=0
CONFIG_PANEL_LCD_PIN_E=6
CONFIG_PANEL_LCD_PIN_RS=4
CONFIG_PANEL_LCD_PIN_RW=5
CONFIG_PANEL_LCD_PIN_BL=0
CONFIG_PANEL_CHANGE_MESSAGE=y
CONFIG_PANEL_BOOT_MESSAGE="TEST"

2) modprobe ppdev; modprobe parport_pc; insmod panel.ko #nothing is displayed 
on lcd :/
3) echo "abc" > /dev/lcd
4) rmmod panel.ko
5) wait approximately 20sec -> kernel oops

I managed to get a (atleast partial) trace of the oops using netconsole:

parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
Panel driver version 0.9.5 registered on parport0 (io=0x378).
parport0: panel tried to release parport when not owner
BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
IP: [<ffffffff8110213b>] __journal_clean_checkpoint_list+0x31/0x89
PGD 13ba35067 PUD 13bf67067 PMD 0 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/platform/w83627ehf.656/in8_input
CPU 1 
Modules linked in: parport_pc ppdev netconsole parport w83627ehf vboxnetflt 
vboxnetadp vboxdrv fglrx(P) i2c_piix4 [last unloaded: panel]

Pid: 1992, comm: kjournald Tainted: P           2.6.34 #1 939A785GMH/128M/To 
Be Filled By O.E.M.
RIP: 0010:[<ffffffff8110213b>]  [<ffffffff8110213b>] 
__journal_clean_checkpoint_list+0x31/0x89
RSP: 0000:ffff88010af47d20  EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88013fe00cf0 RSI: ffff88010af47d34 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffff88010af46000 R09: ffff88013fc8a6a0
R10: 00007fffeda29c30 R11: 0000000000000001 R12: ffff88010af47fd8
R13: 0000000000000000 R14: 0000000000000000 R15: ffff88010af47d34
FS:  00007f888881a700(0000) GS:ffff880001900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000040 CR3: 0000000135cb5000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kjournald (pid: 1992, threadinfo ffff88010af46000, task 
ffff88013fe00cf0)
Stack:
 0000000000000000 0000000000000000 0000000000000400 ffff880105afc3e8
 [<ffffffff81104036>] ? kjournald+0xde/0x222
 [<ffffffff8104673c>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff81103f58>] ? kjournald+0x0/0x222
 [<ffffffff81046379>] ? kthread+0x79/0x81
 [<ffffffff81002c14>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81046300>] ? kthread+0x0/0x81
 [<ffffffff81002c10>] ? kernel_thread_helper+0x0/0x10
Code: 31 ec 60 5f 80 8d 89 24 00 4c 6b fe 41  [<ffffffff8110213b>] 
__journal_clean_checkpoint_list+0x31/0x89
 RSP <ffff88010af47d20>
CR2: 0000000000000040
---[ end trace e7cd6b60c2caaf05 ]---
 vboxnetadp vboxdrv fglrx(P) i2c_piix4 [last unloaded: panel]

Pid: 5559, comm: firefox Tainted: P      D    2.6.34 #1 939A785GMH/128M/To Be 
Filled By O.E.M.
RIP: 0010:[<ffffffff813b3feb>]  [<ffffffff813b3feb>] _raw_spin_lock+0xa/0x15
RSP: 0018:ffff8801155bfc60  EFLAGS: 00000297
RAX: 0000000000003837 RBX: ffff88013e29c400 RCX: 0000000000002000
RDX: ffff88011571c050 RSI: ffff880129d0c3d8 RDI: ffff88013e29c424
RBP: ffffffff810027ce R08: fffffffffffffff4 R09: 0000000000000000
R10: ffff8801155bfe48 R11: 0000000000000000 R12: 000000000000000b
R13: ffff880132466a78 R14: 0000000000000001 R15: 0000000000000000
FS:  00007fa56ee49720(0000) GS:ffff880001800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1a7d4f0000 CR3: 000000011c0c1000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process firefox (pid: 5559, threadinfo ffff8801155be000, task 
ffff88011571c050)
Stack:
 ffffffff81100435 ffff8801155bfcb0

Seems like the driver registers something that gets called periodically, but 
forgets to unregister this?


Would be great if anyone can help me fixing this issue.

Thanks,
Peter






