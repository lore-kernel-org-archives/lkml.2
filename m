Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab2GESUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 14:20:17 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:37062 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766Ab2GESUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 14:20:13 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu, zakir@umich.edu,
        greg@kroah.com, mpm@selenic.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 09/10] random: add tracepoints for easier debugging and verification
Date: Thu,  5 Jul 2012 14:12:12 -0400
Message-Id: <1341511933-11169-10-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.11.1.108.gb129051
In-Reply-To: <1341511933-11169-1-git-send-email-tytso@mit.edu>
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c         |  11 ++++
 include/trace/events/random.h | 132 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 143 insertions(+)
 create mode 100644 include/trace/events/random.h

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 0423254..8f20e3d 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -265,6 +265,9 @@
 #include <asm/ptrace.h>
 #include <asm/io.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/random.h>
+
 /*
  * Configuration information
  */
@@ -487,6 +490,7 @@ static void mix_pool_bytes(struct entropy_store *r, const void *in,
 	__u32 w;
 	unsigned long flags;
 
+	trace_mix_pool_bytes(r->name, nbytes, _RET_IP_);
 	tap1 = r->poolinfo->tap1;
 	tap2 = r->poolinfo->tap2;
 	tap3 = r->poolinfo->tap3;
@@ -584,6 +588,7 @@ static void credit_entropy_bits(struct entropy_store *r, int nbits, int fl)
 	DEBUG_ENT("added %d entropy credits to %s\n", nbits, r->name);
 	entropy_count = r->entropy_count;
 	entropy_count += nbits;
+
 	if (entropy_count < 0) {
 		DEBUG_ENT("negative entropy/overflow\n");
 		entropy_count = 0;
@@ -597,6 +602,9 @@ static void credit_entropy_bits(struct entropy_store *r, int nbits, int fl)
 			r->initialized = 1;
 	}
 
+	trace_credit_entropy_bits(r->name, nbits, entropy_count,
+				  r->entropy_total, _RET_IP_);
+
 	/* should we wake readers? */
 	if (r == &input_pool && entropy_count >= random_read_wakeup_thresh) {
 		wake_up_interruptible(&random_read_wait);
@@ -952,6 +960,7 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 	__u8 tmp[EXTRACT_SIZE];
 	unsigned long flags;
 
+	trace_extract_entropy(r->name, nbytes, r->entropy_count, _RET_IP_);
 	xfer_secondary_pool(r, nbytes);
 	nbytes = account(r, nbytes, min, reserved);
 
@@ -984,6 +993,7 @@ static ssize_t extract_entropy_user(struct entropy_store *r, void __user *buf,
 	ssize_t ret = 0, i;
 	__u8 tmp[EXTRACT_SIZE];
 
+	trace_extract_entropy_user(r->name, nbytes, r->entropy_count, _RET_IP_);
 	xfer_secondary_pool(r, nbytes);
 	nbytes = account(r, nbytes, 0, 0);
 
@@ -1041,6 +1051,7 @@ void get_random_bytes_arch(void *buf, int nbytes)
 {
 	char *p = buf;
 
+	trace_get_random_bytes(nbytes, _RET_IP_);
 	while (nbytes) {
 		unsigned long v;
 		int chunk = min(nbytes, (int)sizeof(unsigned long));
diff --git a/include/trace/events/random.h b/include/trace/events/random.h
new file mode 100644
index 0000000..754754d
--- /dev/null
+++ b/include/trace/events/random.h
@@ -0,0 +1,132 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM random
+
+#if !defined(_TRACE_RANDOM_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_RANDOM_H
+
+#include <linux/writeback.h>
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(mix_pool_bytes,
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
+	TP_printk("pool %s bytes %d caller %pF",
+		  __entry->pool_name, __entry->bytes, (void *)__entry->IP)
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
+	TP_printk("pool %s bits %d entropy_count %d entropy_total %d "
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
+TRACE_EVENT(extract_entropy,
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
+	TP_printk("pool %s nbytes %d entropy_count %d caller %pF",
+		  __entry->pool_name, __entry->nbytes, __entry->entropy_count,
+		  (void *)__entry->IP)
+);
+
+TRACE_EVENT(extract_entropy_user,
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
+	TP_printk("pool %s nbytes %d entropy_count %d caller %pF",
+		  __entry->pool_name, __entry->nbytes, __entry->entropy_count,
+		  (void *)__entry->IP)
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

