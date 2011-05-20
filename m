Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934350Ab1ETDim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 23:38:42 -0400
Received: from nm14-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.15]:42637
	"HELO nm14-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933761Ab1ETDi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 23:38:28 -0400
X-Yahoo-Newman-Id: 864221.88569.bm@omp1022.access.mail.mud.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: Vn9Vp1gVM1krtmiBI3vh2n9QfyHijvH7oXHkNGPsAJDYp2N
 aE3hr2UMbtP6bgfCeb16sgoo2PnNV8w2aH0jM2Md8gTWnQOKlv_LviYJEDec
 wet7mTnA.IIi17Q1yv1n.n0VBjPeNW9ajFPP2eP73.gVbJOidP6plIqXN4y0
 Vdx3tj4bKVVl_22d9R_6QdVj36v1lwuJqITG_7zoVY1q5eTMZ9T5Pe1wDdLn
 5UP90FA3sp3nyLMNoV_RWPiiZVBTwj75LcTnaN15QBgnOpQogTEVBhTxEN7i
 1qEJO1WdNtYzTOJaz_XPhIHyU1z83n0KoB1bRCErzgePzuQo-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Svec <martin.svec@zoner.cz>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH-v5 02/13] iscsi: Add Serial Number Arithmetic LT and GT into iscsi_proto.h
Date: Thu, 19 May 2011 20:37:47 -0700
Message-Id: <1305862678-30150-3-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1305862678-30150-1-git-send-email-nab@linux-iscsi.org>
References: <1305862678-30150-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch moves the iscsi_sna_lt() and iscsi_sna_lte(), along with
iscsi_sna_gt() and iscsi_sna_gte() from iscsi_target_mod into
static inlines inside of include/scsi/iscsi_proto.h

This patch also includes the ISCSI_HDR_LEN and ISCSI_CRC_LEN
definitions.

Reported-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/libiscsi.c    |   16 ----------------
 include/scsi/iscsi_proto.h |   38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 9c3cb4e..3461a03 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -84,22 +84,6 @@ MODULE_PARM_DESC(debug_libiscsi_eh,
 					     __func__, ##arg);		\
 	} while (0);
 
-/* Serial Number Arithmetic, 32 bits, less than, RFC1982 */
-#define SNA32_CHECK 2147483648UL
-
-static int iscsi_sna_lt(u32 n1, u32 n2)
-{
-	return n1 != n2 && ((n1 < n2 && (n2 - n1 < SNA32_CHECK)) ||
-			    (n1 > n2 && (n2 - n1 < SNA32_CHECK)));
-}
-
-/* Serial Number Arithmetic, 32 bits, less than, RFC1982 */
-static int iscsi_sna_lte(u32 n1, u32 n2)
-{
-	return n1 == n2 || ((n1 < n2 && (n2 - n1 < SNA32_CHECK)) ||
-			    (n1 > n2 && (n2 - n1 < SNA32_CHECK)));
-}
-
 inline void iscsi_conn_queue_work(struct iscsi_conn *conn)
 {
 	struct Scsi_Host *shost = conn->session->host;
diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
index a9c9058..455b03a 100644
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -29,10 +29,48 @@
 /* default iSCSI listen port for incoming connections */
 #define ISCSI_LISTEN_PORT	3260
 
+/* iSCSI header length */
+#define ISCSI_HDR_LEN		48
+
+/* iSCSI CRC32C length */
+#define ISCSI_CRC_LEN		4
+
 /* Padding word length */
 #define ISCSI_PAD_LEN		4
 
 /*
+ * Serial Number Arithmetic, 32 bits, RFC1982
+ */
+
+static inline int iscsi_sna_lt(u32 n1, u32 n2)
+{
+	s32 diff = n1 - n2;
+
+	return diff < 0;
+}
+
+static inline int iscsi_sna_lte(u32 n1, u32 n2)
+{
+	s32 diff = n1 - n2;
+
+	return diff <= 0;
+}
+
+static inline int iscsi_sna_gt(u32 n1, u32 n2)
+{
+	s32 diff = n1 - n2;
+
+	return diff > 0;
+}
+
+static inline int iscsi_sna_gte(u32 n1, u32 n2)
+{
+	s32 diff = n1 - n2;
+
+	return diff >= 0;
+}
+
+/*
  * useful common(control and data pathes) macro
  */
 #define ntoh24(p) (((p)[0] << 16) | ((p)[1] << 8) | ((p)[2]))
-- 
1.7.5.1

