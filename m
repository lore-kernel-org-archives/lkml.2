Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab0CYPZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 11:25:16 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43436 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab0CYPZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 11:25:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=TmN6L3ysXU7f7GHjeqKYZrzS6RUoE32m0GanXUj+QzqoWZkkSt5g40x0n8sNsy5DRD
         sD7iNooXE60cY3t0S16lgIonxnXS2/vUj351i7PGla7CmuF/yBfPDxLmyhPtGwOynPFf
         KHqKTyBee7J2zE405oOosBwiPvBnFRZu7b9ig=
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Subject: [PATCH v2] MTD: Fix Orion NAND driver compilation with ARM OABI
To: dwmw2@infradead.org
Cc: nico@fluxnic.net, akpm@linux-foundation.org,
       u.kleine-koenig@pengutronix.de, simon.kagstrom@netinsight.net,
       linux-mtd@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Date: Thu, 25 Mar 2010 17:25:05 +0200
Message-ID: <20100325152505.17612.40158.stgit@pauliusz>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We must tell GCC to use even register for variable passed
to ldrd instruction. Without this patch GCC 4.2.1 puts this
variable to r2/r3 on EABI and r3/r4 on OABI, so force it to
r2/r3. This does not change anything when EABI and OABI
compilation works OK.

Without this patch and with OABI I get:
  CC      drivers/mtd/nand/orion_nand.o
/tmp/ccMkwOCs.s: Assembler messages:
/tmp/ccMkwOCs.s:63: Error: first destination register must be even -- `ldrd r3,[ip]'
make[5]: *** [drivers/mtd/nand/orion_nand.o] Error 1

Signed-off-by: Paulius Zaleckas <paulius.zaleckas@gmail.com>
---

 drivers/mtd/nand/orion_nand.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/orion_nand.c b/drivers/mtd/nand/orion_nand.c
index f59c074..d60fc57 100644
--- a/drivers/mtd/nand/orion_nand.c
+++ b/drivers/mtd/nand/orion_nand.c
@@ -60,7 +60,13 @@ static void orion_nand_read_buf(struct mtd_info *mtd, uint8_t *buf, int len)
 	}
 	buf64 = (uint64_t *)buf;
 	while (i < len/8) {
-		uint64_t x;
+		/*
+		 * Since GCC has no proper constraint (PR 43518)
+		 * force x variable to r2/r3 registers as ldrd instruction
+		 * requires first register to be even.
+		 */
+		register uint64_t x asm ("r2");
+
 		asm volatile ("ldrd\t%0, [%1]" : "=&r" (x) : "r" (io_base));
 		buf64[i++] = x;
 	}

