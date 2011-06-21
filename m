Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab1FUPTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 11:19:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:60054 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab1FUPTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:19:32 -0400
Date: Tue, 21 Jun 2011 15:19:24 GMT
From: "tip-bot for cpw@sgi.com" <cpw@sgi.com>
Message-ID: <tip-ae90c232be376bd8a283f3b6fb37cb5bd2635d67@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110621122243.117324443@sgi.com>
References: <20110621122243.117324443@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: Correct UV2 BAU destination timeout
Git-Commit-ID: ae90c232be376bd8a283f3b6fb37cb5bd2635d67
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 21 Jun 2011 15:19:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ae90c232be376bd8a283f3b6fb37cb5bd2635d67
Gitweb:     http://git.kernel.org/tip/ae90c232be376bd8a283f3b6fb37cb5bd2635d67
Author:     cpw@sgi.com <cpw@sgi.com>
AuthorDate: Tue, 21 Jun 2011 07:21:33 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 21 Jun 2011 14:50:34 +0200

x86, UV: Correct UV2 BAU destination timeout

Correct the UV2 broacast assist unit's destination timeout
period. And the activation status register in UV2 should be
tested for a destination timeout with a 4, not a 2.  The values
for Active versus Timeout were reversed.

This patch is critical for TLB shootdown on an Altix UV2 system
(i.e. the follow-on to the current Altix UV).

 Destination timeout period:
  The period is set in 4 bits of memory-mapped register MISC_CONTROL.
  The left bit toggles base period between 10us and 80us.
  The other 3 bits are the multiplier.
 Decimal 15, hex f, gives the maximum: 7 * 80us

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Link: http://lkml.kernel.org/r/20110621122243.117324443@sgi.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/uv/uv_bau.h |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 16ce58c..37d3698 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
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
 
