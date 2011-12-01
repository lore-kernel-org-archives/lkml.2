Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab1LAE1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 23:27:47 -0500
Received: from mail.windriver.com ([147.11.1.11]:64266 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab1LAE1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 23:27:46 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: JBottomley@parallels.com, linux-arm-kernel@lists.infradead.org,
        linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] arm: prevent inlining in arxescsi.c causing build failures
Date: Wed, 30 Nov 2011 23:26:51 -0500
Message-Id: <1322713611-30003-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following failure is seen in routine coverage builds:

  CC [M]  drivers/scsi/arm/arxescsi.o
/tmp/cccEyiO7.s: Assembler messages:
/tmp/cccEyiO7.s:334: Error: symbol `.loop_1' is already defined
/tmp/cccEyiO7.s:337: Error: symbol `.loop_2' is already defined
/tmp/cccEyiO7.s:343: Error: symbol `.loop_3' is already defined
/tmp/cccEyiO7.s:365: Error: symbol `.loop_1' is already defined
/tmp/cccEyiO7.s:368: Error: symbol `.loop_2' is already defined
/tmp/cccEyiO7.s:374: Error: symbol `.loop_3' is already defined
make[4]: *** [drivers/scsi/arm/arxescsi.o] Error 1

It is caused by multiple inline of arxescsi_pseudo_dma_write()
which is responsible for the above labels.  Marking the fcn
as non-inline fixes the issue.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/drivers/scsi/arm/arxescsi.c b/drivers/scsi/arm/arxescsi.c
index a750aa7..2608a9e 100644
--- a/drivers/scsi/arm/arxescsi.c
+++ b/drivers/scsi/arm/arxescsi.c
@@ -72,7 +72,8 @@ arxescsi_dma_setup(struct Scsi_Host *host, struct scsi_pointer *SCp,
 	return fasdma_pseudo;
 }
 
-static void arxescsi_pseudo_dma_write(unsigned char *addr, void __iomem *base)
+static noinline void
+arxescsi_pseudo_dma_write(unsigned char *addr, void __iomem *base)
 {
        __asm__ __volatile__(
        "               stmdb   sp!, {r0-r12}\n"
-- 
1.7.7.2

