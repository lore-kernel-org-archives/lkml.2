Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab1BDWBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 17:01:19 -0500
Received: from mail51.messagelabs.com ([216.82.241.99]:36828 "EHLO
	mail51.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab1BDWBS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 17:01:18 -0500
X-VirusChecked: Checked
X-Env-Sender: Timothy.Sell@unisys.com
X-Msg-Ref: server-15.tower-51.messagelabs.com!1296856875!62931100!4
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [192.61.61.104]
From: "Sell, Timothy C" <Timothy.Sell@unisys.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date: Fri, 4 Feb 2011 16:00:08 -0600
Subject: [PATCH] x86: prevent faults / mysterious problems booting x86
 withOUT VGA
Thread-Topic: [PATCH] x86: prevent faults / mysterious problems booting x86
 withOUT VGA
Thread-Index: AcvEtuK84AvGted6Tfe1uEtIr6wdsQ==
Message-ID: <63D5DCACD1E9E34C89C8203C64F521C3D75ADEAD6B@USEA-EXCH7.na.uis.unisys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: BHWT CS+g QuhN Rzi2 ayLo a9GI dKHl fzk/ jWlG kyJX lZ6S
 mwgw qG6l rFBA r36M
 tXLw;4;aABwAGEAQAB6AHkAdABvAHIALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBtAGkAbgBnAG8AQAByAGUAZABoAGEAdAAuAGMAbwBtADsAdABnAGwAeABAAGwAaQBuAHUAdAByAG8AbgBpAHgALgBkAGUA;Sosha1_v1;7;{71076D48-0EB5-43F8-979F-E80707F794AA};dABpAG0AbwB0AGgAeQAuAHMAZQBsAGwAQAB1AG4AaQBzAHkAcwAuAGMAbwBtAA==;Fri,
 04 Feb 2011 22:00:08
 GMT;WwBQAEEAVABDAEgAXQAgAHgAOAA2ADoAIABwAHIAZQB2AGUAbgB0ACAAZgBhAHUAbAB0AHMAIAAvACAAbQB5AHMAdABlAHIAaQBvAHUAcwAgAHAAcgBvAGIAbABlAG0AcwAgAGIAbwBvAHQAaQBuAGcAIAB4ADgANgAgAHcAaQB0AGgATwBVAFQAIABWAEcAQQA=
x-cr-puzzleid: {71076D48-0EB5-43F8-979F-E80707F794AA}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Sell <Timothy.Sell@unisys.com>

(Patch applies to 2.6.32.12 kernel version.)
This patch guarantees correct behavior if you boot on x86 arch without VGA hardware.  It prevents faults from occurring at various places in the kernel, possibly dealing with accesses to /dev/tty0, due to assumptions that conswitchp is non-NULL.  Unisys encountered this problem while booting SLES11 Linux (2.6.32.12-0.7) in a virtualized x86 environment that does NOT provide VGA, and this patch was verified to fix the problem.

The patch guarantees that conswitchp will be initialized to a non-NULL value if you build with CONFIG_VGA_CONSOLE or CONFIG_DUMMY_CONSOLE, with the VGA console having precedence over the dummy console. 

Elsewhere in the kernel (namely in visual_init() of vt.c, where we depend on con_driver_map[0] being non-NULL, and con_driver_map[0..MAX_CONSOLES-1] are initialized to conswitchp in con_init() of vt.c), Linux assumes conswitchp to be non-NULL.  Prior to the attached patch, if you have both CONFIG_VGA_CONSOLE and CONFIG_DUMMY_CONSOLE defined, then conswitchp is still going to be left at NULL if you don't have VGA hardware.  I think it's wrong to behave that way if you also have CONFIG_DUMMY_CONSOLE defined. 

Here is an example fault that will occur when running without the patch.
  BUG: unable to handle kernel NULL pointer dereference at (null)
  IP: [<ffffffff812719f0>] visual_init+0x40/0x100
  PGD 2d752067 PUD 2d316067 PMD 0
  Oops: 0000 [#1] SMP
  last sysfs file: /sys/devices/virtual/net/lo/type
  CPU 0
  Modules linked in: ...
  Supported: Yes
  Pid: 4084, comm: console-kit-dae Tainted: G        W N  2.6.32.12-0.7-spar1 #2
  RIP: 0010:[<ffffffff812719f0>]  [<ffffffff812719f0>] visual_init+0x40/0x100
  RSP: 0018:ffff88002d0d9c98  EFLAGS: 00010246
  RAX: 0000000000000000 RBX: ffff88002b3dc200 RCX: 0000000000000000
  RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88002b3dc200
  RBP: 0000000000000000 R08: 0000000000000000 R09: ffff88002b3dc200
  R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
  R13: ffff88002b3dc200 R14: 0000000000000000 R15: ffff88002aaa6a04
  FS:  00007fa76134d700(0000) GS:ffff880001e00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 000000002d1e0000 CR4: 00000000000006f0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
  Process console-kit-dae (pid: 4084, threadinfo ffff88002d0d8000, task ffff88002d73a500)
  Stack:
   0000000000000000 0000000000000000 0000000000000000 ffffffff81272f55
  <0> ffff88002b3dc200 ffffffff81066bc6 ffff88002db29000 0000000000000000
  <0> 0000000000000000 ffff88002d48a900 0000000000000001 ffffffff81273030
  Call Trace:
   [<ffffffff81272f55>] vc_allocate+0x105/0x190
   [<ffffffff81273030>] con_open+0x50/0xf0
   [<ffffffff812625ae>] tty_open+0x21e/0x510
   [<ffffffff810fc1b5>] chrdev_open+0x125/0x1d0
   [<ffffffff810f6b5e>] __dentry_open+0xfe/0x2f0
   [<ffffffff81106b1c>] do_filp_open+0x74c/0xae0
   [<ffffffff810f6977>] do_sys_open+0x97/0x140
   [<ffffffff81002e7b>] system_call_fastpath+0x16/0x1b
   [<00007fa75fd95e1d>] 0x7fa75fd95e1d
  Code: ...
  RIP  [<ffffffff812719f0>] visual_init+0x40/0x100
   RSP <ffff88002d0d9c98>
  CR2: 0000000000000000
  ---[ end trace ab277073f9e6d739 ]---

At the time of the fault in visual_init() of vt.c, rax is con_driver_map[num], and the stack trace above shows that to be 0, which is bad.  We fault at visual_init+64:
  726                     vc->vc_sw = con_driver_map[num];
  0xffffffff812719e8 <visual_init+56>:    mov    %rax,0x38(%rbx)
  
  727     #endif
  728             __module_get(vc->vc_sw->owner);
  0xffffffff812719ec <visual_init+60>:    mov    0x38(%rbx),%rdx
  0xffffffff812719f0 <visual_init+64>:    mov    (%rdx),%rcx

Signed-off-by: Tim Sell <Timothy.Sell@unisys.com>

---

--- arch/x86/kernel/ORIG-setup.c	2011-01-12 17:05:08.000000000 -0500
+++ arch/x86/kernel/setup.c	2011-01-17 09:44:14.000000000 -0500
@@ -1035,8 +1035,10 @@ void __init setup_arch(char **cmdline_p)
 #if defined(CONFIG_VGA_CONSOLE)
 	if (!efi_enabled || (efi_mem_type(0xa0000) != EFI_CONVENTIONAL_MEMORY))
 		conswitchp = &vga_con;
-#elif defined(CONFIG_DUMMY_CONSOLE)
-	conswitchp = &dummy_con;
+#endif
+#if defined(CONFIG_DUMMY_CONSOLE)
+	if (!conswitchp)
+		conswitchp = &dummy_con;
 #endif
 #endif
 	x86_init.oem.banner();
