Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab1AYGx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 01:53:27 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64352 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab1AYGx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 01:53:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=s4rHZNEri1m/iVgo4uf9GDrKpC+H6Ot2TAr5hX6GOZ7sPnsAYqkhNNFvKFZ+1GpqW9
         lGQHAM40O4BTMJySLpmEMT0rE26ipJDw1A77K5fAfs2KX09Vnh9Uq9BRwOJAskdHmrt8
         Sm7PCuDpGCZDzKK4ucOPOAH0Iye85Ysham+Pc=
From: "Anoop P.A" <anoop.pa@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: Anoop P A <anoop.pa@gmail.com>
Subject: [PATCH] Fix build error for non-malta VSMP kernel.
Date: Tue, 25 Jan 2011 12:39:15 +0530
Message-Id: <1295939355-7281-1-git-send-email-anoop.pa@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anoop P A <anoop.pa@gmail.com>

VSMP kernel build for non-malta platforms fails with following error

  LD      init/built-in.o
  LD      .tmp_vmlinux1
arch/mips/built-in.o: In function `vsmp_init_secondary':
smp-mt.c:(.cpuinit.text+0x23cc): undefined reference to `gic_present'
smp-mt.c:(.cpuinit.text+0x23d0): undefined reference to `gic_present'
make: *** [.tmp_vmlinux1] Error 1

gic_present variable is declared only if IRQ_GIC is selected.

Signed-off-by: Anoop P A <anoop.pa@gmail.com>
---
 arch/mips/kernel/smp-mt.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/mips/kernel/smp-mt.c b/arch/mips/kernel/smp-mt.c
index c0e8141..54235b5 100644
--- a/arch/mips/kernel/smp-mt.c
+++ b/arch/mips/kernel/smp-mt.c
@@ -151,6 +151,7 @@ static void vsmp_send_ipi_mask(const struct cpumask *mask, unsigned int action)
 
 static void __cpuinit vsmp_init_secondary(void)
 {
+#ifdef CONFIG_IRQ_GIC
 	extern int gic_present;
 
 	/* This is Malta specific: IPI,performance and timer interrupts */
@@ -158,6 +159,7 @@ static void __cpuinit vsmp_init_secondary(void)
 		change_c0_status(ST0_IM, STATUSF_IP3 | STATUSF_IP4 |
 					 STATUSF_IP6 | STATUSF_IP7);
 	else
+#endif
 		change_c0_status(ST0_IM, STATUSF_IP0 | STATUSF_IP1 |
 					 STATUSF_IP6 | STATUSF_IP7);
 }
-- 
1.7.0.4

