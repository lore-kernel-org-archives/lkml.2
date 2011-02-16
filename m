Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab1BPBmC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:42:02 -0500
Received: from kroah.org ([198.145.64.141]:38938 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756897Ab1BPATt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:19:49 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:31 2011
Message-Id: <20110216001431.825211308@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [067/272] [S390] qdio: use proper QEBSM operand for SIGA-R and SIGA-S
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Glauber <jang@linux.vnet.ibm.com>

commit 958c0ba403cb6a693b54be2389f9ef53377fa259 upstream.

If QIOASSIST is enabled for a qdio device the SIGA instruction requires
a modified function code. This function code modifier was missing for
SIGA-R and SIGA-S which can lead to a kernel panic caused by an
operand exception.

Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/s390/cio/qdio.h      |    6 ++++++
 drivers/s390/cio/qdio_main.c |   43 ++++++++++++++++++++++++++++---------------
 2 files changed, 34 insertions(+), 15 deletions(-)

--- a/drivers/s390/cio/qdio.h
+++ b/drivers/s390/cio/qdio.h
@@ -91,6 +91,12 @@ enum qdio_irq_states {
 #define AC1_SC_QEBSM_AVAILABLE		0x02	/* available for subchannel */
 #define AC1_SC_QEBSM_ENABLED		0x01	/* enabled for subchannel */
 
+/* SIGA flags */
+#define QDIO_SIGA_WRITE		0x00
+#define QDIO_SIGA_READ		0x01
+#define QDIO_SIGA_SYNC		0x02
+#define QDIO_SIGA_QEBSM_FLAG	0x80
+
 #ifdef CONFIG_64BIT
 static inline int do_sqbs(u64 token, unsigned char state, int queue,
 			  int *start, int *count)
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -29,11 +29,12 @@ MODULE_AUTHOR("Utz Bacher <utz.bacher@de
 MODULE_DESCRIPTION("QDIO base support");
 MODULE_LICENSE("GPL");
 
-static inline int do_siga_sync(struct subchannel_id schid,
-			       unsigned int out_mask, unsigned int in_mask)
+static inline int do_siga_sync(unsigned long schid,
+			       unsigned int out_mask, unsigned int in_mask,
+			       unsigned int fc)
 {
-	register unsigned long __fc asm ("0") = 2;
-	register struct subchannel_id __schid asm ("1") = schid;
+	register unsigned long __fc asm ("0") = fc;
+	register unsigned long __schid asm ("1") = schid;
 	register unsigned long out asm ("2") = out_mask;
 	register unsigned long in asm ("3") = in_mask;
 	int cc;
@@ -47,10 +48,11 @@ static inline int do_siga_sync(struct su
 	return cc;
 }
 
-static inline int do_siga_input(struct subchannel_id schid, unsigned int mask)
+static inline int do_siga_input(unsigned long schid, unsigned int mask,
+				unsigned int fc)
 {
-	register unsigned long __fc asm ("0") = 1;
-	register struct subchannel_id __schid asm ("1") = schid;
+	register unsigned long __fc asm ("0") = fc;
+	register unsigned long __schid asm ("1") = schid;
 	register unsigned long __mask asm ("2") = mask;
 	int cc;
 
@@ -279,6 +281,8 @@ void qdio_init_buf_states(struct qdio_ir
 static inline int qdio_siga_sync(struct qdio_q *q, unsigned int output,
 			  unsigned int input)
 {
+	unsigned long schid = *((u32 *) &q->irq_ptr->schid);
+	unsigned int fc = QDIO_SIGA_SYNC;
 	int cc;
 
 	if (!need_siga_sync(q))
@@ -287,7 +291,12 @@ static inline int qdio_siga_sync(struct
 	DBF_DEV_EVENT(DBF_INFO, q->irq_ptr, "siga-s:%1d", q->nr);
 	qperf_inc(q, siga_sync);
 
-	cc = do_siga_sync(q->irq_ptr->schid, output, input);
+	if (is_qebsm(q)) {
+		schid = q->irq_ptr->sch_token;
+		fc |= QDIO_SIGA_QEBSM_FLAG;
+	}
+
+	cc = do_siga_sync(schid, output, input, fc);
 	if (cc)
 		DBF_ERROR("%4x SIGA-S:%2d", SCH_NO(q), cc);
 	return cc;
@@ -313,8 +322,8 @@ static inline int qdio_siga_sync_all(str
 
 static int qdio_siga_output(struct qdio_q *q, unsigned int *busy_bit)
 {
-	unsigned long schid;
-	unsigned int fc = 0;
+	unsigned long schid = *((u32 *) &q->irq_ptr->schid);
+	unsigned int fc = QDIO_SIGA_WRITE;
 	u64 start_time = 0;
 	int cc;
 
@@ -323,11 +332,8 @@ static int qdio_siga_output(struct qdio_
 
 	if (is_qebsm(q)) {
 		schid = q->irq_ptr->sch_token;
-		fc |= 0x80;
+		fc |= QDIO_SIGA_QEBSM_FLAG;
 	}
-	else
-		schid = *((u32 *)&q->irq_ptr->schid);
-
 again:
 	cc = do_siga_output(schid, q->mask, busy_bit, fc);
 
@@ -347,12 +353,19 @@ again:
 
 static inline int qdio_siga_input(struct qdio_q *q)
 {
+	unsigned long schid = *((u32 *) &q->irq_ptr->schid);
+	unsigned int fc = QDIO_SIGA_READ;
 	int cc;
 
 	DBF_DEV_EVENT(DBF_INFO, q->irq_ptr, "siga-r:%1d", q->nr);
 	qperf_inc(q, siga_read);
 
-	cc = do_siga_input(q->irq_ptr->schid, q->mask);
+	if (is_qebsm(q)) {
+		schid = q->irq_ptr->sch_token;
+		fc |= QDIO_SIGA_QEBSM_FLAG;
+	}
+
+	cc = do_siga_input(schid, q->mask, fc);
 	if (cc)
 		DBF_ERROR("%4x SIGA-R:%2d", SCH_NO(q), cc);
 	return cc;


