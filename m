Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab2JLLPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 07:15:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64870 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab2JLLO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 07:14:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] ARM: s3c: mark s3c2440_clk_add as __init_refok
Date: Fri, 12 Oct 2012 11:14:52 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Mike Turquette <mturquette@linaro.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210121114.52348.arnd@arndb.de>
X-Provags-ID: V02:K0:d2cxu9anZiO0q/HsGv0tgJ+rbLEchg+DnTWfLUGxdSW
 ihjBtf2Ejzjj0jiXoAxxnNpeI8J5ZoXn/5eGM+eWMKGxVPKrMu
 72zTzekY7QMXDZEsqWoevYDqc75qflPcVrfWzbpjErxCOPiFPB
 ik1r/OsCMb2z+OX7aZzacz66XRUY4yWjh8k+4C05LmMXTGGAzp
 0TlJ4R6y/ofEjPM7bdaEPwjxH92Iqi6cM303tJBqWU/NGgXsR/
 KZ7RgIPdCjTDphZQy7jFrkbchfp2XCExHloK1IBhkZuSpYRxbu
 CoXKusGgtd2SAgtF6oQPlXeLBOZynuy+/Cy5sKqsUztrtU2Amk
 pL41Gh6HLtoL9R6WozHE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s3c2440_clk_add is a subsys_interface method and calls clkdev_add_table,
which is marked as __init. The modpost script complains about this
because we must not call an __init function from a function in the .text
section, and we cannot reference an __init function from a subsys_interface
pointer.

I have verified that the only code path into s3c2440_clk_add() is
from "int __init s3c2440_init(void)", so s3c2440_clk_add can be marked
__init_refok instead.

Without this patch, building mini2440_defconfig results in:

WARNING: vmlinux.o(.text+0x9848): Section mismatch in reference from the function s3c2440_clk_add() to the function .init.text:clkdev_add_table()
The function s3c2440_clk_add() references
the function __init clkdev_add_table().
This is often because s3c2440_clk_add lacks a __init
annotation or the annotation of clkdev_add_table is wrong.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
---

I'll put this into arm-soc/fixes unless I hear objections. This replaces the
earlier "clk: don't mark clkdev_add_table as init" as suggested by Russell.

diff --git a/arch/arm/mach-s3c24xx/clock-s3c2440.c b/arch/arm/mach-s3c24xx/clock-s3c2440.c
index 749220f..4407b17 100644
--- a/arch/arm/mach-s3c24xx/clock-s3c2440.c
+++ b/arch/arm/mach-s3c24xx/clock-s3c2440.c
@@ -163,7 +163,7 @@ static struct clk_lookup s3c2440_clk_lookup[] = {
 	CLKDEV_INIT(NULL, "clk_uart_baud3", &s3c2440_clk_fclk_n),
 };
 
-static int s3c2440_clk_add(struct device *dev, struct subsys_interface *sif)
+static int __init_refok s3c2440_clk_add(struct device *dev, struct subsys_interface *sif)
 {
 	struct clk *clock_upll;
 	struct clk *clock_h;
