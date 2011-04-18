Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab1DRHll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 03:41:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:8820 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab1DRHle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 03:41:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,231,1301900400"; 
   d="scan'208";a="630362121"
Subject: Re: [patch v3 2/3] percpu_counter: fix code for 32bit systems for
 UP
From: Shaohua Li <shaohua.li@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "tj@kernel.org" <tj@kernel.org>, "cl@linux.com" <cl@linux.com>
In-Reply-To: <1302749677.3549.26.camel@edumazet-laptop>
References: <20110414020447.979946152@sli10-conroe.sh.intel.com>
	 <20110414020747.201728372@sli10-conroe.sh.intel.com>
	 <1302748530.3549.24.camel@edumazet-laptop>
	 <1302749044.3981.183.camel@sli10-conroe>
	 <1302749677.3549.26.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Apr 2011 15:41:32 +0800
Message-ID: <1303112492.3981.189.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-14 at 10:54 +0800, Eric Dumazet wrote:
> Le jeudi 14 avril 2011 à 10:44 +0800, Shaohua Li a écrit :
> > that's true. I just want the code looks consistent and this doesn't
> > really obfuscate the code to me.
> 
> Doing so gives a false sense of security to user.
> 
> percpu_counter_init() is unsafe by nature.
I really don't think this matters, but since you insist, here is the
updated the patch.

Subject: percpu_counter: fix code for 32bit systems for UP

percpu_counter.counter is a 's64'. Accessing it in 32-bit system is racing.
we need some locking to protect it otherwise some very wrong value could be
accessed.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 include/linux/percpu_counter.h |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

Index: linux/include/linux/percpu_counter.h
===================================================================
--- linux.orig/include/linux/percpu_counter.h	2011-04-18 15:36:31.000000000 +0800
+++ linux/include/linux/percpu_counter.h	2011-04-18 15:37:35.000000000 +0800
@@ -101,14 +101,34 @@ static inline void percpu_counter_destro
 
 static inline void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
 {
+#if BITS_PER_LONG == 32
+	preempt_disable();
+	fbc->count = amount;
+	preempt_enable();
+#else
 	fbc->count = amount;
+#endif
+}
+
+static inline s64 percpu_counter_read(struct percpu_counter *fbc)
+{
+#if BITS_PER_LONG == 32
+	s64 count;
+	preempt_disable();
+	count = fbc->count;
+	preempt_enable();
+	return count;
+#else
+	return fbc->count;
+#endif
 }
 
 static inline int percpu_counter_compare(struct percpu_counter *fbc, s64 rhs)
 {
-	if (fbc->count > rhs)
+	s64 count = percpu_counter_read(fbc);
+	if (count > rhs)
 		return 1;
-	else if (fbc->count < rhs)
+	else if (count < rhs)
 		return -1;
 	else
 		return 0;
@@ -128,18 +148,13 @@ __percpu_counter_add(struct percpu_count
 	percpu_counter_add(fbc, amount);
 }
 
-static inline s64 percpu_counter_read(struct percpu_counter *fbc)
-{
-	return fbc->count;
-}
-
 /*
  * percpu_counter is intended to track positive number. In UP case, the number
  * should never be negative.
  */
 static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
 {
-	return fbc->count;
+	return percpu_counter_read(fbc);
 }
 
 static inline s64 percpu_counter_sum_positive(struct percpu_counter *fbc)



