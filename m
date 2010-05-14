Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab0ENOTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 10:19:55 -0400
Received: from imap.ru.mvista.com ([213.79.90.228]:34180 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751937Ab0ENOTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 10:19:53 -0400
Date: Fri, 14 May 2010 18:19:49 +0400
From: Anton Vorontsov <avorontsov@mvista.com>
To: David Miller <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kristoffer Glembo <kristoffer@gaisler.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] serial: apbuart: Let boards without apbuart boot
Message-ID: <20100514141949.GA9244@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following oops:

  Unable to handle kernel paging request for data at address 0x00000000
  Faulting instruction address: 0xc016dea8
  Oops: Kernel access of bad area, sig: 11 [#1]
  P1020 RDB
  last sysfs file:
  NIP: c016dea8 LR: c016dea0 CTR: c0010948
  REGS: c033fea0 TRAP: 0300   Not tainted  (2.6.34-rc7-00108-g83b5177-dirty)
  [...]
  NIP [c016dea8] grlib_apbuart_configure+0xd0/0x3bc
  LR [c016dea0] grlib_apbuart_configure+0xc8/0x3bc
  Call Trace:
  [c033ff50] [c016dea0] grlib_apbuart_configure+0xc8/0x3bc (unreliable)
  [c033ffa0] [c0316144] apbuart_console_init+0x10/0x34
  [c033ffb0] [c0314a10] console_init+0x40/0x5c

There's no apbuart on P1020 boards, and what's worse, there's no
clock-frequency property for it. The driver didn't handle this
case, which resulted in the oops above. Once we fix this, the
next oops pops up:

  Unable to handle kernel paging request for data at address 0x00000030
  Faulting instruction address: 0xc0166ecc
  Oops: Kernel access of bad area, sig: 11 [#1]
  P1020 RDB
  [...]
  NIP [c0166ecc] uart_set_options+0xd0/0x164
  LR [c0166e38] uart_set_options+0x3c/0x164
  Call Trace:
  [c033fef0] [c0330000] 0xc0330000 (unreliable)
  [c033ff50] [c03160dc] apbuart_console_setup+0xa8/0x100
  [c033ff70] [c003d668] register_console+0x338/0x3ec
  [c033ffa0] [c0316154] apbuart_console_init+0x20/0x34
  [c033ffb0] [c0314a10] console_init+0x40/0x5c
  [c033ffc0] [c0300968] start_kernel+0x12c/0x234
  [c033fff0] [c0000398] skpinv+0x2b0/0x2ec

And that one is because the driver tries to register the console
even if there were no matches in grlib_apbuart_configure().

While at it, also annotate grlib_apbuart_configure() with __init,
that fixes several section mismatches:

  Section mismatch in reference from the function
  grlib_apbuart_configure() to the variable .init.data:apbuart_match
  The function grlib_apbuart_configure() references the variable
  __initdata apbuart_match.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
---
 drivers/serial/apbuart.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/serial/apbuart.c b/drivers/serial/apbuart.c
index fe91319..c908734 100644
--- a/drivers/serial/apbuart.c
+++ b/drivers/serial/apbuart.c
@@ -520,11 +520,16 @@ static struct console grlib_apbuart_console = {
 };
 
 
-static void grlib_apbuart_configure(void);
+static int __init grlib_apbuart_configure(void);
 
 static int __init apbuart_console_init(void)
 {
-	grlib_apbuart_configure();
+	int ret;
+
+	ret = grlib_apbuart_configure();
+	if (ret)
+		return ret;
+
 	register_console(&grlib_apbuart_console);
 	return 0;
 }
@@ -593,7 +598,7 @@ static struct of_platform_driver grlib_apbuart_of_driver = {
 };
 
 
-static void grlib_apbuart_configure(void)
+static int __init grlib_apbuart_configure(void)
 {
 	static int enum_done;
 	struct device_node *np, *rp;
@@ -606,12 +611,14 @@ static void grlib_apbuart_configure(void)
 	struct amba_prom_registers *regs;
 
 	if (enum_done)
-		return;
+		return -ENODEV;
 
 	/* Get bus frequency */
 	rp = of_find_node_by_path("/");
 	rp = of_get_next_child(rp, NULL);
 	prop = of_get_property(rp, "clock-frequency", NULL);
+	if (!prop)
+		return -ENODEV;
 	freq_khz = *prop;
 
 	line = 0;
@@ -629,7 +636,7 @@ static void grlib_apbuart_configure(void)
 			d = *device;
 
 		if (!irqs || !regs)
-			return;
+			return -ENODEV;
 
 		grlib_apbuart_nodes[line] = np;
 
@@ -658,6 +665,8 @@ static void grlib_apbuart_configure(void)
 	enum_done = 1;
 
 	grlib_apbuart_driver.nr = grlib_apbuart_port_nr = line;
+
+	return line ? 0 : -ENODEV;
 }
 
 static int __init grlib_apbuart_init(void)
-- 
1.7.0.5
