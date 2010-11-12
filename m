Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab0KLCen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 21:34:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:42141 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab0KLCel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 21:34:41 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=lS9FhW_GDbgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=NtpouL_lAAAA:8 a=QyXUC8HyAAAA:8 a=meVymXHHAAAA:8 a=_El_dS-V1HuMqFBqbv4A:9 a=RdW5RjCLN8d2PK1wnRVaCFrlHX0A:4 a=PUjeQqilurYA:10 a=sx0aeZmlSPoA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH][BUG FIX] leds: Fix bug with reading NAS SS4200 dmi code
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dave Hansen <dave@sr71.net>, Richard Purdie <rpurdie@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 11 Nov 2010 21:34:38 -0500
Message-ID: <1289529278.12418.391.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While running randconfg with ktest.pl I stumbled upon this bug:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000003
IP: [<ffffffff815fe44f>] strstr+0x39/0x86
PGD 0 
Oops: 0000 [#1] SMP 
last sysfs file: 
CPU 0 
Modules linked in:

Pid: 1, comm: swapper Not tainted 2.6.37-rc1-test+ #6 DG965MQ/        
RIP: 0010:[<ffffffff815fe44f>]  [<ffffffff815fe44f>] strstr+0x39/0x86
RSP: 0018:ffff8800797cbd80  EFLAGS: 00010213
RAX: 0000000000000000 RBX: 0000000000000003 RCX: ffffffffffffffff
RDX: 0000000000000000 RSI: ffffffff82eb7ac9 RDI: 0000000000000003
RBP: ffff8800797cbda0 R08: ffff880000000003 R09: 0000000000030725
R10: ffff88007d294c00 R11: 0000000000014c00 R12: 0000000000000020
R13: ffffffff82eb7ac9 R14: ffffffffffffffff R15: ffffffff82eb7b08
FS:  0000000000000000(0000) GS:ffff88007d200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000003 CR3: 0000000002a1d000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff8800797ca000, task ffff8800797d0000)
Stack:
 00000000000000ba ffffffff82eb7ac9 ffffffff82eb7ab8 00000000000000ba
 ffff8800797cbdf0 ffffffff81e2050f ffff8800797cbdc0 00000000815f913b
 ffff8800797cbe00 ffffffff82eb7ab8 0000000000000000 0000000000000000
Call Trace:
 [<ffffffff81e2050f>] dmi_matches+0x117/0x154
 [<ffffffff81e205d7>] dmi_check_system+0x3d/0x8d
 [<ffffffff82e1ad25>] ? nas_gpio_init+0x0/0x2c8
 [<ffffffff82e1ad49>] nas_gpio_init+0x24/0x2c8
 [<ffffffff820d750d>] ? wm8350_led_init+0x0/0x20
 [<ffffffff82e1ad25>] ? nas_gpio_init+0x0/0x2c8
 [<ffffffff810022f7>] do_one_initcall+0xab/0x1b2
 [<ffffffff82da749c>] kernel_init+0x248/0x331
 [<ffffffff8100e624>] kernel_thread_helper+0x4/0x10
 [<ffffffff82da7254>] ? kernel_init+0x0/0x331


Found that the nas_led_whitelist dmi_system_id structure array had no
NULL end delimiter, causing the dmi_check_system() loop to read an
undefined entry.

Cc: Dave Hansen <dave@sr71.net>
Cc: Richard Purdie <rpurdie@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/drivers/leds/leds-ss4200.c b/drivers/leds/leds-ss4200.c
index a688293..614ebeb 100644
--- a/drivers/leds/leds-ss4200.c
+++ b/drivers/leds/leds-ss4200.c
@@ -102,6 +102,7 @@ static struct dmi_system_id __initdata nas_led_whitelist[] = {
 			DMI_MATCH(DMI_PRODUCT_VERSION, "1.00.00")
 		}
 	},
+	{}
 };
 
 /*


