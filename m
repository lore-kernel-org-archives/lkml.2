Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab1ELHHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 03:07:51 -0400
Received: from nm2.access.bullet.mail.mud.yahoo.com ([66.94.237.203]:26557
	"HELO nm2.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754541Ab1ELHHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 03:07:47 -0400
X-Yahoo-Newman-Id: 295424.3076.bm@omp1029.access.mail.mud.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: W56DseEVM1l6glySAMcWv7qgsImYXCTsDaYhVVcDSjyCVju
 M1wkpmt1Eg4MlQmtsO7yw2EQP54IgZbrcT3sZZzjvh3i2CEKzjqoQwH0ZIxs
 bq03NUbsiFCoiFCtlMZHxfB4dqRFaByoBwRCY7Tr9FzkcnuW5q2d8SaaCo2x
 aqmXsuwXDb7AmUJ6SOhvcwJleko4_zEAhSEPXNT8sI0okRHUbGosEUMhg41W
 m8A1XBLLLhLbM0CHhXVSpEXJJM103eMiDuXDA7WPehyLGSqM0toiwkQpDZLH
 OrBwGB701k5T.cBfWrZVsyZa6yd28JtcRcd8ana_JGJURyVUZulw5EZtIMaG
 zRepSDcxGV._lRbC7XoaZ5jiHoBGY4RbARW.zs8aBa5rx.rKL.Ad1bUY8lIu
 tC40Og3wdfb4g9UE0qfUYPwVr88QLGA--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Svec <martin.svec@zoner.cz>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH-v3 02/14] iscsi: Add Serial Number Arithmetic LT and GT into iscsi_proto.h
Date: Thu, 12 May 2011 00:07:09 -0700
Message-Id: <1305184041-32189-3-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1305184041-32189-1-git-send-email-nab@linux-iscsi.org>
References: <1305184041-32189-1-git-send-email-nab@linux-iscsi.org>
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
 include/scsi/iscsi_proto.h |   40 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 17 deletions(-)

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
index a9c9058..4a433a5 100644
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
@@ -559,7 +597,7 @@ struct iscsi_snack {
 	uint8_t rsvd2[2];
 	uint8_t hlength;
 	uint8_t dlength[3];
-	uint8_t lun[8];
+	uint8_t lun[8];	
 	itt_t	 itt;
 	__be32  ttt;
 	uint8_t rsvd3[4];
-- 
1.7.5.1

