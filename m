Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab0LHBNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:13:41 -0500
Received: from kroah.org ([198.145.64.141]:33754 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932753Ab0LHBDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:36 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:45 2010
Message-Id: <20101208005745.690787061@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steven Rostedt <rostedt@goodmis.org>, Dave Hansen <dave@sr71.net>,
        Richard Purdie <rpurdie@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [243/289] leds: fix bug with reading NAS SS4200 dmi code
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 50d431e8a15701b599c98afe2b464eb33c952477 upstream.

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

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Dave Hansen <dave@sr71.net>
Acked-by: Richard Purdie <rpurdie@linux.intel.com>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/leds/leds-ss4200.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/leds/leds-ss4200.c
+++ b/drivers/leds/leds-ss4200.c
@@ -102,6 +102,7 @@ static struct dmi_system_id __initdata n
 			DMI_MATCH(DMI_PRODUCT_VERSION, "1.00.00")
 		}
 	},
+	{}
 };
 
 /*


