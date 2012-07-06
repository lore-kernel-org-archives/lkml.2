Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030277Ab2GFWqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 18:46:46 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37438 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756935Ab2GFWpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 18:45:08 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: ewust@umich.edu, zakir@umich.edu, nadiah@cs.ucsd.edu, jhalderm@umich.edu,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 09/12] random: add tracepoints for easier debugging and verification
Date: Fri,  6 Jul 2012 18:45:01 -0400
Message-Id: <1341614704-24965-10-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
In-Reply-To: <1341614704-24965-1-git-send-email-tytso@mit.edu>
References: <1341614704-24965-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c         |  26 ++++++--
 include/trace/events/random.h | 134 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 156 insertions(+), 4 deletions(-)
 create mode 100644 include/trace/events/random.h

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 79c105a..aaf4629 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -265,6 +265,9 @@
 #include <asm/irq_regs.h>
 #include <asm/io.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/random.h>
+
 /*
  * Configuration information
  */
@@ -477,8 +480,8 @@ static __u32 const twist_table[8] = {
  * it's cheap to do so and helps slightly in the expected case where
  * the entropy is concentrated in the low-order bits.
  */
-static void __mix_pool_bytes(struct entropy_store *r, const void *in,
-			     int nbytes, __u8 out[64])
+static void _mix_pool_bytes(struct entropy_store *r, const void *in,
+			    int nbytes, __u8 out[64])
 {
 	unsigned long i, j, tap1, tap2, tap3, tap4, tap5;
 	int input_rotate;
@@ -530,13 +533,21 @@ static void __mix_pool_bytes(struct entropy_store *r, const void *in,
 			((__u32 *)out)[j] = r->pool[(i - j) & wordmask];
 }
 
-static void mix_pool_bytes(struct entropy_store *r, const void *in,
+static void __mix_pool_bytes(struct entropy_store *r, const void *in,
 			     int nbytes, __u8 out[64])
 {
+	trace_mix_pool_bytes_nolock(r->name, nbytes, _RET_IP_);
+	_mix_pool_bytes(r, in, nbytes, out);
+}
+
+static void mix_pool_bytes(struct entropy_store *r, const void *in,
+			   int nbytes, __u8 out[64])
+{
 	unsigned long flags;
 
+	trace_mix_pool_bytes(r->name, nbytes, _RET_IP_);
 	spin_lock_irqsave(&r->lock, flags);
-	__mix_pool_bytes(r, in, nbytes, out);
+	_mix_pool_bytes(r, in, nbytes, out);
 	spin_unlock_irqrestore(&r->lock, flags);
 }
 
@@ -584,6 +595,7 @@ static void credit_entropy_bits(struct entropy_store *r, int nbits)
 retry:
 	entropy_count = orig = ACCESS_ONCE(r->entropy_count);
 	entropy_count += nbits;
+
 	if (entropy_count < 0) {
 		DEBUG_ENT("negative entropy/overflow\n");
 		entropy_count = 0;
@@ -598,6 +610,9 @@ retry:
 			r->initialized = 1;
 	}
 
+	trace_credit_entropy_bits(r->name, nbits, entropy_count,
+				  r->entropy_total, _RET_IP_);
+
 	/* should we wake readers? */
 	if (r == &input_pool && entropy_count >= random_read_wakeup_thresh) {
 		wake_up_interruptible(&random_read_wait);
@@ -969,6 +984,7 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 	ssize_t ret = 0, i;
 	__u8 tmp[EXTRACT_SIZE];
 
+	trace_extract_entropy(r->name, nbytes, r->entropy_count, _RET_IP_);
 	xfer_secondary_pool(r, nbytes);
 	nbytes = account(r, nbytes, min, reserved);
 
@@ -1003,6 +1019,7 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
 	ssize_t ret = 0, i;
 	__u8 tmp[EXTRACT_SIZE];
 
+	trace_extract_entropy_user(r->name, nbytes, r->entropy_count, _RET_IP_);
 	xfer_secondary_pool(r, nbytes);
 	nbytes = account(r, nbytes, 0, 0);
 
@@ -1060,6 +1077,7 @@ void get_random_bytes_arch(void *buf, int nbytes)
 {
 	char *p = buf;
 
+	trace_get_random_bytes(nbytes, _RET_IP_);
 	while (nbytes) {
 		unsigned long v;
 		int chunk = min(nbytes, (int)sizeof(unsigned long));
diff --git a/include/trace/events/random.h b/include/trace/events/random.h
new file mode 100644
index 0000000..422df19
--- /dev/null
+++ b/include/trace/events/random.h
@@ -0,0 +1,134 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM random
+
+#if !defined(_TRACE_RANDOM_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_RANDOM_H
+
+#include <linux/writeback.h>
+#include <linux/tracepoint.h>
+
+DECLARE_EVENT_CLASS(random__mix_pool_bytes,
+	TP_PROTO(const char *pool_name, int bytes, unsigned long IP),
+
+	TP_ARGS(pool_name, bytes, IP),
+
+	TP_STRUCT__entry(
+		__field( const char *,	pool_name		)
+		__field(	  int,	bytes			)
+		__field(unsigned long,	IP			)
+	),
+
+	TP_fast_assign(
+		__entry->pool_name	= pool_name;
+		__entry->bytes		= bytes;
+		__entry->IP		= IP;
+	),
+
+	TP_printk("%s pool: bytes %d caller %pF",
+		  __entry->pool_name, __entry->bytes, (void *)__entry->IP)
+);
+
+DEFINE_EVENT(random__mix_pool_bytes, mix_pool_bytes,
+	TP_PROTO(const char *pool_name, int bytes, unsigned long IP),
+
+	TP_ARGS(pool_name, bytes, IP)
+);
+
+DEFINE_EVENT(random__mix_pool_bytes, mix_pool_bytes_nolock,
+	TP_PROTO(const char *pool_name, int bytes, unsigned long IP),
+
+	TP_ARGS(pool_name, bytes, IP)
+);
+
+TRACE_EVENT(credit_entropy_bits,
+	TP_PROTO(const char *pool_name, int bits, int entropy_count,
+		 int entropy_total, unsigned long IP),
+
+	TP_ARGS(pool_name, bits, entropy_count, entropy_total, IP),
+
+	TP_STRUCT__entry(
+		__field( const char *,	pool_name		)
+		__field(	  int,	bits			)
+		__field(	  int,	entropy_count		)
+		__field(	  int,	entropy_total		)
+		__field(unsigned long,	IP			)
+	),
+
+	TP_fast_assign(
+		__entry->pool_name	= pool_name;
+		__entry->bits		= bits;
+		__entry->entropy_count	= entropy_count;
+		__entry->entropy_total	= entropy_total;
+		__entry->IP		= IP;
+	),
+
+	TP_printk("%s pool: bits %d entropy_count %d entropy_total %d "
+		  "caller %pF", __entry->pool_name, __entry->bits,
+		  __entry->entropy_count, __entry->entropy_total,
+		  (void *)__entry->IP)
+);
+
+TRACE_EVENT(get_random_bytes,
+	TP_PROTO(int nbytes, unsigned long IP),
+
+	TP_ARGS(nbytes, IP),
+
+	TP_STRUCT__entry(
+		__field(	  int,	nbytes			)
+		__field(unsigned long,	IP			)
+	),
+
+	TP_fast_assign(
+		__entry->nbytes		= nbytes;
+		__entry->IP		= IP;
+	),
+
+	TP_printk("nbytes %d caller %pF", __entry->nbytes, (void *)__entry->IP)
+);
+
+DECLARE_EVENT_CLASS(random__extract_entropy,
+	TP_PROTO(const char *pool_name, int nbytes, int entropy_count,
+		 unsigned long IP),
+
+	TP_ARGS(pool_name, nbytes, entropy_count, IP),
+
+	TP_STRUCT__entry(
+		__field( const char *,	pool_name		)
+		__field(	  int,	nbytes			)
+		__field(	  int,	entropy_count		)
+		__field(unsigned long,	IP			)
+	),
+
+	TP_fast_assign(
+		__entry->pool_name	= pool_name;
+		__entry->nbytes		= nbytes;
+		__entry->entropy_count	= entropy_count;
+		__entry->IP		= IP;
+	),
+
+	TP_printk("%s pool: nbytes %d entropy_count %d caller %pF",
+		  __entry->pool_name, __entry->nbytes, __entry->entropy_count,
+		  (void *)__entry->IP)
+);
+
+
+DEFINE_EVENT(random__extract_entropy, extract_entropy,
+	TP_PROTO(const char *pool_name, int nbytes, int entropy_count,
+		 unsigned long IP),
+
+	TP_ARGS(pool_name, nbytes, entropy_count, IP)
+);
+
+DEFINE_EVENT(random__extract_entropy, extract_entropy_user,
+	TP_PROTO(const char *pool_name, int nbytes, int entropy_count,
+		 unsigned long IP),
+
+	TP_ARGS(pool_name, nbytes, entropy_count, IP)
+);
+
+
+
+#endif /* _TRACE_RANDOM_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.11.1.108.gb129051

