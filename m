Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab0FUWao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 18:30:44 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61133 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab0FUWal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 18:30:41 -0400
Subject: [PATCH v2 2/5] of/microblaze: strip out of_irq_workarounds code
To: microblaze-uclinux@itee.uq.edu.au, devicetree-discuss@lists.ozlabs.org,
       linuxppc-dev@lists.ozlabs.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: sfr@canb.auug.org.au, monstr@monstr.eu, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org
Date: Mon, 21 Jun 2010 16:30:38 -0600
Message-ID: <20100621223027.18925.83250.stgit@angua>
In-Reply-To: <20100621222052.18925.61569.stgit@angua>
References: <20100621222052.18925.61569.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Microblaze doesn't have any legacy workaround in the device tree irq
mapping data.  All of the of_irq_workarounds stuff can be dropped

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/microblaze/include/asm/prom.h  |   10 ---------
 arch/microblaze/kernel/prom_parse.c |   41 -----------------------------------
 2 files changed, 0 insertions(+), 51 deletions(-)

diff --git a/arch/microblaze/include/asm/prom.h b/arch/microblaze/include/asm/prom.h
index e9fb2eb..4f34bc5 100644
--- a/arch/microblaze/include/asm/prom.h
+++ b/arch/microblaze/include/asm/prom.h
@@ -93,19 +93,9 @@ extern const void *of_get_mac_address(struct device_node *np);
  * OF interrupt mapping
  */
 
-/**
- * of_irq_map_init - Initialize the irq remapper
- * @flags:	flags defining workarounds to enable
- *
- * Some machines have bugs in the device-tree which require certain workarounds
- * to be applied. Call this before any interrupt mapping attempts to enable
- * those workarounds.
- */
 #define OF_IMAP_OLDWORLD_MAC	0x00000001
 #define OF_IMAP_NO_PHANDLE	0x00000002
 
-extern void of_irq_map_init(unsigned int flags);
-
 /**
  * of_irq_map_raw - Low level interrupt tree parsing
  * @parent:	the device interrupt parent
diff --git a/arch/microblaze/kernel/prom_parse.c b/arch/microblaze/kernel/prom_parse.c
index bf7e6c2..cba0581 100644
--- a/arch/microblaze/kernel/prom_parse.c
+++ b/arch/microblaze/kernel/prom_parse.c
@@ -676,47 +676,6 @@ static struct device_node *of_irq_find_parent(struct device_node *child)
 	return p;
 }
 
-/* This doesn't need to be called if you don't have any special workaround
- * flags to pass
- */
-void of_irq_map_init(unsigned int flags)
-{
-	of_irq_workarounds = flags;
-
-	/* OldWorld, don't bother looking at other things */
-	if (flags & OF_IMAP_OLDWORLD_MAC)
-		return;
-
-	/* If we don't have phandles, let's try to locate a default interrupt
-	 * controller (happens when booting with BootX). We do a first match
-	 * here, hopefully, that only ever happens on machines with one
-	 * controller.
-	 */
-	if (flags & OF_IMAP_NO_PHANDLE) {
-		struct device_node *np;
-
-		for (np = NULL; (np = of_find_all_nodes(np)) != NULL;) {
-			if (of_get_property(np, "interrupt-controller", NULL)
-				== NULL)
-				continue;
-			/* Skip /chosen/interrupt-controller */
-			if (strcmp(np->name, "chosen") == 0)
-				continue;
-			/* It seems like at least one person on this planet
-			 * wants to use BootX on a machine with an AppleKiwi
-			 * controller which happens to pretend to be an
-			 * interrupt controller too.
-			 */
-			if (strcmp(np->name, "AppleKiwi") == 0)
-				continue;
-			/* I think we found one ! */
-			of_irq_dflt_pic = np;
-			break;
-		}
-	}
-
-}
-
 int of_irq_map_raw(struct device_node *parent, const u32 *intspec, u32 ointsize,
 		const u32 *addr, struct of_irq *out_irq)
 {

