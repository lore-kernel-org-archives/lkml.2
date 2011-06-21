Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab1FUMXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 08:23:48 -0400
Received: from relay3.sgi.com ([192.48.152.1]:35679 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755108Ab1FUMWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 08:22:44 -0400
Message-Id: <20110621122243.117324443@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 21 Jun 2011 07:21:33 -0500
From: cpw@sgi.com
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, x86@kernel.org
Subject: [patch 8/8 v5] x86, UV: correct UV2 BAU destination timeout
References: <20110621122125.688884227@sgi.com>
Content-Disposition: inline; filename=tlb_uv_uv2timeout
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct the UV2 broacast assist unit's destination timeout period.
And the activation status register in UV2 should be tested for a destination
timeout with a 4, not a 2.  The values for Active versus Timeout were reversed.

This patch is critical for TLB shootdown on an Altix UV2 system (i.e. the
follow-on to the current Altix UV).

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---

 Destination timeout period:
  The period is set in 4 bits of memory-mapped register MISC_CONTROL.
  The left bit toggles base period between 10us and 80us.
  The other 3 bits are the multiplier.
 Decimal 15, hex f, gives the maximum: 7 * 80us

 arch/x86/include/asm/uv/uv_bau.h |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

Index: linux/arch/x86/include/asm/uv/uv_bau.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_bau.h
+++ linux/arch/x86/include/asm/uv/uv_bau.h
@@ -67,7 +67,7 @@
  *  we're using 655us, similar to UV1: 65 units of 10us
  */
 #define UV1_INTD_SOFT_ACK_TIMEOUT_PERIOD (9UL)
-#define UV2_INTD_SOFT_ACK_TIMEOUT_PERIOD (65*10UL)
+#define UV2_INTD_SOFT_ACK_TIMEOUT_PERIOD (15UL)
 
 #define UV_INTD_SOFT_ACK_TIMEOUT_PERIOD	(is_uv1_hub() ?			\
 		UV1_INTD_SOFT_ACK_TIMEOUT_PERIOD :			\
@@ -106,12 +106,20 @@
 #define DS_SOURCE_TIMEOUT		3
 /*
  * bits put together from HRP_LB_BAU_SB_ACTIVATION_STATUS_0/1/2
- * values 1 and 5 will not occur
+ * values 1 and 3 will not occur
+ *        Decoded meaning              ERROR  BUSY    AUX ERR
+ * -------------------------------     ----   -----   -------
+ * IDLE                                 0       0        0
+ * BUSY (active)                        0       1        0
+ * SW Ack Timeout (destination)         1       0        0
+ * SW Ack INTD rejected (strong NACK)   1       0        1
+ * Source Side Time Out Detected        1       1        0
+ * Destination Side PUT Failed          1       1        1
  */
 #define UV2H_DESC_IDLE			0
-#define UV2H_DESC_DEST_TIMEOUT		2
-#define UV2H_DESC_DEST_STRONG_NACK	3
-#define UV2H_DESC_BUSY			4
+#define UV2H_DESC_BUSY			2
+#define UV2H_DESC_DEST_TIMEOUT		4
+#define UV2H_DESC_DEST_STRONG_NACK	5
 #define UV2H_DESC_SOURCE_TIMEOUT	6
 #define UV2H_DESC_DEST_PUT_ERR		7
 

