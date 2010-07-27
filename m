Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab0G0Xx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:53:27 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:29502 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab0G0XwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:52:01 -0400
From: dann frazier <dannf@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, Thomas Mingarelli <thomas.mingarelli@hp.com>,
        dann frazier <dannf@hp.com>
Subject: [PATCH 11/15] Make x86 assembly ifdef guard more strict
Date: Tue, 27 Jul 2010 17:50:59 -0600
Message-Id: <1280274663-9160-12-git-send-email-dannf@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280274663-9160-1-git-send-email-dannf@hp.com>
References: <1280274663-9160-1-git-send-email-dannf@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32-bit assembly is guarded by an #ifndef CONFIG_X86_64. Kconfig prevents
us from building this driver on !X86, so that happens to suffice - but we
should really lock it down to #ifdef CONFIG_X86_32.

Signed-off-by: dann frazier <dannf@hp.com>
---
 drivers/watchdog/hpwdt.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index a6b37fe..f46e4f2 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -136,7 +136,7 @@ static struct cmn_registers cmn_regs;
 extern asmlinkage void asminline_call(struct cmn_registers *pi86Regs,
 						unsigned long *pRomEntry);
 
-#ifndef CONFIG_X86_64
+#ifdef CONFIG_X86_32
 /* --32 Bit Bios------------------------------------------------------------ */
 
 #define HPWDT_ARCH	32
@@ -325,8 +325,9 @@ static int __devinit detect_cru_service(void)
 	iounmap(p);
 	return rc;
 }
-
-#else
+/* ------------------------------------------------------------------------- */
+#endif /* CONFIG_X86_32 */
+#ifdef CONFIG_X86_64
 /* --64 Bit Bios------------------------------------------------------------ */
 
 #define HPWDT_ARCH	64
@@ -404,10 +405,7 @@ static int __devinit detect_cru_service(void)
 	/* if cru_rom_addr has been set then we found a CRU service */
 	return ((cru_rom_addr != NULL) ? 0 : -ENODEV);
 }
-
-/* ------------------------------------------------------------------------- */
-
-#endif
+#endif /* CONFIG_X86_64 */
 
 /*
  *	Watchdog operations
-- 
1.7.1

