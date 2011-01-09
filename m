Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553Ab1AIK1H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 05:27:07 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:58245 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab1AIK1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 05:27:05 -0500
Date: Sun, 9 Jan 2011 11:27:02 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux/m68k <linux-m68k@vger.kernel.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] m68k/amiga: Fix "debug=mem"
Message-ID: <alpine.DEB.2.00.1101091124290.473@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`debug=mem' on Amiga has been broken for a while.
early_param() processing is done very/too early, i.e. before
amiga_identify() / amiga_chip_init(), causing amiga_savekmsg_setup() not
to find any Chip RAM.

As we don't plan to free this memory anyway, just steal it from the initial
Chip RAM memory block instead.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
This is patch is meant to replace commit
f58c0050517b02b8143f13a98730ba4a14f4e1c5 ("m68k: Fix debug=mem on Amiga") in
linux-m68k.git.

 arch/m68k/amiga/config.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/m68k/amiga/config.c b/arch/m68k/amiga/config.c
index b1577f7..82a4bb5 100644
--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -610,17 +610,17 @@ static void amiga_mem_console_write(struct console *co, const char *s,
 
 static int __init amiga_savekmsg_setup(char *arg)
 {
-	static struct resource debug_res = { .name = "Debug" };
-
 	if (!MACH_IS_AMIGA || strcmp(arg, "mem"))
-		goto done;
+		return 0;
 
-	if (!AMIGAHW_PRESENT(CHIP_RAM)) {
-		printk("Warning: no chipram present for debugging\n");
-		goto done;
+	if (amiga_chip_size < SAVEKMSG_MAXMEM) {
+		pr_err("Not enough chipram for debugging\n");
+		return -ENOMEM;
 	}
 
-	savekmsg = amiga_chip_alloc_res(SAVEKMSG_MAXMEM, &debug_res);
+	/* Just steal the block, the chipram allocator isn't functional yet */
+	amiga_chip_size -= SAVEKMSG_MAXMEM;
+	savekmsg = (void *)ZTWO_VADDR(CHIP_PHYSADDR + amiga_chip_size);
 	savekmsg->magic1 = SAVEKMSG_MAGIC1;
 	savekmsg->magic2 = SAVEKMSG_MAGIC2;
 	savekmsg->magicptr = ZTWO_PADDR(savekmsg);
@@ -628,8 +628,6 @@ static int __init amiga_savekmsg_setup(char *arg)
 
 	amiga_console_driver.write = amiga_mem_console_write;
 	register_console(&amiga_console_driver);
-
-done:
 	return 0;
 }
 
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
