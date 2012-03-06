Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab2CFQX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:23:56 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14856 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab2CFQTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:19:47 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=vyvJPxWudBYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=kvsxnPoieNdUProKZmEA:9 a=qMeiwk0Q6oP8lV9D-wQA:7 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120306161945.770871645@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 06 Mar 2012 11:16:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 04/25][RFC 3.0.23-rt39-rc1] revert-seqlock-remove-unused-functions
References: <20120306161636.491172179@goodmis.org>
Content-Disposition: inline; filename=0004-revert-seqlock-remove-unused-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

revert: seqlock-remove-unused-functions.patch

Revert:

Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Sat Jul 16 18:38:22 2011 +0200

    seqlock-remove-unused-functions.patch

    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/seqlock.h |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index b990f6e..c6db9fb 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -69,6 +69,17 @@ static inline void write_sequnlock(seqlock_t *sl)
 	spin_unlock(&sl->lock);
 }
 
+static inline int write_tryseqlock(seqlock_t *sl)
+{
+	int ret = spin_trylock(&sl->lock);
+
+	if (ret) {
+		++sl->sequence;
+		smp_wmb();
+	}
+	return ret;
+}
+
 /* Start of read calculation -- fetch last complete writer token */
 static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
 {
@@ -237,4 +248,14 @@ static inline void write_seqcount_barrier(seqcount_t *s)
 #define write_sequnlock_bh(lock)					\
 	do { write_sequnlock(lock); local_bh_enable(); } while(0)
 
+#define read_seqbegin_irqsave(lock, flags)				\
+	({ local_irq_save(flags);   read_seqbegin(lock); })
+
+#define read_seqretry_irqrestore(lock, iv, flags)			\
+	({								\
+		int ret = read_seqretry(lock, iv);			\
+		local_irq_restore(flags);				\
+		ret;							\
+	})
+
 #endif /* __LINUX_SEQLOCK_H */
-- 
1.7.8.3


