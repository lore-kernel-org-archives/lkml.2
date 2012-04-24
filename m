Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab2DXJu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 05:50:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:41055 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab2DXJuz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 05:50:55 -0400
Message-ID: <1335261027.28150.189.camel@twins>
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
From: Peter Zijlstra <peterz@infradead.org>
To: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Cc: Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, cfriesen@nortel.com, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com
Date: Tue, 24 Apr 2012 11:50:27 +0200
In-Reply-To: <4F95E3F1.3030407@sssup.it>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	   <1333696481-3433-6-git-send-email-juri.lelli@gmail.com>
	  <1335182113.28150.132.camel@twins> <4F95CFBF.1050000@sssup.it>
	 <1335218328.28150.181.camel@twins> <4F95E3F1.3030407@sssup.it>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 00:21 +0100, Tommaso Cucinotta wrote:
> > Yes I can do it for x86_64, but people tend to get mighty upset if you
> > break the compile for all other arches...
> 
> rather than breaking compile, I was thinking more of using the 
> optimization for a more accurate comparison on archs that have 64-bit 
> mul and 128-bit cmp, and leaving the overflow on other archs. Though, 
> that would imply a difference in behavior on those borderline cases 
> (very big periods I guess).
> 
> However, I'm also puzzled from what would happen by compiling the 
> current code on mostly 16-bit micros which have very limited 32-bit 
> operations... 

We don't support 16bit archs, 32bit is almost useless as it is :-)

Anyway, how about something like this, I guess archs can go wild and add
asm/math128.h if they want etc..

Completely untested, hasn't even seen a compiler..

---
Subject: math128: Add {add,mult,cmp}_u128
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue Apr 24 11:47:12 CEST 2012


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/math128.h |   75 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

--- /dev/null
+++ b/include/linux/math128.h
@@ -0,0 +1,75 @@
+#ifndef _LINUX_MATH128_H
+#define _LINUX_MATH128_H
+
+#include <linux/types.h>
+
+typedef struct {
+	u64 hi, lo;
+} u128;
+
+u128 add_u128(u128 a, u128 b)
+{
+	u128 res;
+
+	res.hi = a.hi + b.hi;
+	res.lo = a.lo + b.lo;
+
+	if (res.lo < a.lo || res.lo < b.lo)
+		res.hi++;
+
+	return res;
+}
+
+/*
+ * a * b = (ah * 2^32 + al) * (bh * 2^32 + bl) =
+ *   ah*bh * 2^64 + (ah*bl + bh*al) * 2^32 + al*bl
+ */
+u128 mult_u128(u64 a, u64 b)
+{
+	u128 res;
+	u64 ah, al;
+	u64 bh, bl;
+	u128 t1, t2, t3, t4;
+
+	ah = a >> 32;
+	al = a & ((1ULL << 32) - 1);
+
+	bh = b >> 32;
+	bl = b & ((1ULL << 32) - 1);
+
+	t1.lo = 0;
+	t1.hi = ah * bh;
+
+	t2.lo = ah * bl;
+	t2.hi = t2.lo >> 32;
+	t2.lo <<= 32;
+
+	t3.lo = al * bh;
+	t3.hi = t3.lo >> 32;
+	t3.lo <<= 32;
+
+	t4.lo = al * bl;
+	t4.hi = 0;
+
+	res = add_u128(t1, t2);
+	res = add_u128(res, t3);
+	res = add_u128(res, t4);
+
+	return res;
+}
+
+int cmp_u128(u128 a, u128 b)
+{
+	if (a.hi > b.hi)
+		return 1;
+	if (a.hi < b.hi)
+		return -1;
+	if (a.lo > b.lo)
+		return 1;
+	if (a.lo < b.lo)
+		return -1;
+
+	return 0;
+}
+
+#endif /* _LINUX_MATH128_H */

