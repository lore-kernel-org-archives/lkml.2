Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab0KRM4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 07:56:13 -0500
Received: from mail.windriver.com ([147.11.1.11]:53230 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897Ab0KRM4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 07:56:12 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 4/4] kgdb,ppc: Fix regression in evr register handling
Date: Thu, 18 Nov 2010 06:56:03 -0600
Message-Id: <1290084963-6376-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1290084963-6376-1-git-send-email-jason.wessel@windriver.com>
References: <1290084963-6376-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 18 Nov 2010 12:55:25.0948 (UTC) FILETIME=[DEA803C0:01CB871F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongdong Deng <dongdong.deng@windriver.com>

Commit ff10b88b5a05c8f1646dd15fb9f6093c1384ff6d (kgdb,ppc: Individual
register get/set for ppc) introduced a problem where memcpy was used
incorrectly to read and write the evr registers with a kernel that
has:

CONFIG_FSL_BOOKE=y
CONFIG_SPE=y
CONFIG_KGDB=y

This patch also fixes the following compilation problems:

arch/powerpc/kernel/kgdb.c: In function 'dbg_get_reg':
arch/powerpc/kernel/kgdb.c:341: error: passing argument 2 of 'memcpy' makes pointer from integer without a cast
arch/powerpc/kernel/kgdb.c: In function 'dbg_set_reg':
arch/powerpc/kernel/kgdb.c:366: error: passing argument 1 of 'memcpy' makes pointer from integer without a cast

[jason.wessel@windriver.com: Remove void * casts and fix patch header]
Reported-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
Acked-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
CC: linuxppc-dev@lists.ozlabs.org
---
 arch/powerpc/kernel/kgdb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index 7a9db64..42850ee 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -337,7 +337,7 @@ char *dbg_get_reg(int regno, void *mem, struct pt_regs *regs)
 		/* FP registers 32 -> 63 */
 #if defined(CONFIG_FSL_BOOKE) && defined(CONFIG_SPE)
 		if (current)
-			memcpy(mem, current->thread.evr[regno-32],
+			memcpy(mem, &current->thread.evr[regno-32],
 					dbg_reg_def[regno].size);
 #else
 		/* fp registers not used by kernel, leave zero */
@@ -362,7 +362,7 @@ int dbg_set_reg(int regno, void *mem, struct pt_regs *regs)
 	if (regno >= 32 && regno < 64) {
 		/* FP registers 32 -> 63 */
 #if defined(CONFIG_FSL_BOOKE) && defined(CONFIG_SPE)
-		memcpy(current->thread.evr[regno-32], mem,
+		memcpy(&current->thread.evr[regno-32], mem,
 				dbg_reg_def[regno].size);
 #else
 		/* fp registers not used by kernel, leave zero */
-- 
1.7.0.4

