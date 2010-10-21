Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab0JURqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 13:46:45 -0400
Received: from nspiron-1.llnl.gov ([128.115.41.81]:26662 "EHLO
	nspiron-1.llnl.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab0JURqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 13:46:44 -0400
X-Attachments: 0001-Fix-div64_u64-for-32bit-platforms.patch
Subject: Re: [PATCH] Make div64_u64() precise on 32bit platforms
From: Brian Behlendorf <behlendorf1@llnl.gov>
Reply-To: behlendorf1@llnl.gov
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20101014121159.GA407@redhat.com>
References: <201010121227.05735.behlendorf1@llnl.gov>
	 <20101013213746.GA27248@redhat.com>  <20101014121159.GA407@redhat.com>
Content-Type: multipart/mixed; boundary="=-Ktx8XrHJwgmO33FQafax"
Organization: LLNL
Date: Thu, 21 Oct 2010 10:46:42 -0700
Message-ID: <1287683202.16680.44.camel@pip>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ktx8XrHJwgmO33FQafax
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

> > > +	if (divisor >> 32 == 0) {
> > > +		if (dividend >> 32 < divisor) {
> > > +			return div_u64_rem(dividend, divisor, &rem);
> > > +		} else {
> > > +			u0 = dividend & 0xFFFFFFFF;
> > > +			quot1 = div_u64_rem(dividend >> 32, divisor, &rem);
> > > +			u0 += ((u64)rem << 32);
> > > +			quot0 = div_u64_rem(u0, divisor, &rem);
> > > +			return (quot1 << 32) + quot0;
> > > +		}
> >
> > Looks correct... but I can't understand these complications.
> > Looks like we can just do
> >
> > 	if ((divisor >> 32) == 0) {
> > 		div_u64(dividend, divisor);
> > 	} else {
> > 	...
> >
> > No?

The idea here, as described in the formal proof, is to cleanly handle
the overflow case.  When I implemented this I assumed the overflow case
would in fact be a problem.  To my surprise your right it doesn't seem
to be causing any trouble.  In practice I can't find any cases where it
is a problem on i386.

> > I can't understand this "dividend >> 1". It seems to me that
> >
> > 		quot1 = div_u64(dividend, (divisor << n) >> 32);
> > 		quot0 = (quot1 << n) >> 32;
> >
> > should be equally correct. Or I missed some overflow?
> 
> Thinking more about this with a fresh head, we don't event need quot1,
> unless I missed something. We can do
> 
> 		quot0 = div_u64((dividend << n) >> 32, (divisor << n) >> 32);
> 
> instead. Or, better,
> 
> 		n = 32 - __builtin_clzll(divisor);
> 		quot0 = div_u64(dividend >> n, divisor >> n);
> 
> And 32 - clzll == fls.

Once again, the extra complexity was only there to handle to overflow
case.

> So, I think it can be really trivial, see the test-case below,
> seems to work (you need 64bit machine to test).
> 
> What do you think? I do not trust my math skills.

I think we should use your simpler version.  There's no good reason to
make this more complicated than it needs to be.  I haven't been able to
find a test case where your changes get the wrong result.

The updated patch is against linux-2.6.35 and passes all the previous
test cases.

Thanks,
Brian

--=-Ktx8XrHJwgmO33FQafax
Content-Type: text/x-patch; name="0001-Fix-div64_u64-for-32bit-platforms.patch"; charset="UTF-8"
Content-Description: 
Content-Disposition: attachment; filename="0001-Fix-div64_u64-for-32bit-platforms.patch"
Content-Transfer-Encoding: 7bit

>From 35755c57cb45f7d30abcd88a8e2fc1ccc5beecfd Mon Sep 17 00:00:00 2001
From: Brian Behlendorf <behlendorf1@llnl.gov>
Date: Thu, 5 Aug 2010 14:59:11 -0700
Subject: [PATCH] Fix div64_u64 for 32bit platforms

The current implementation of div64_u64 for 32bit systems returns
an approximately correct result when the divisor exceeds 32bits.
Since doing 64bit division using 32bit hardware is a long since
solved problem we just use one of the existing proven methods.

Additionally, add a div64_s64 function to correctly handle doing
signed 64bit division.
---
 include/linux/kernel.h |    5 ++++
 include/linux/math64.h |   12 +++++++++++
 lib/div64.c            |   52 ++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 59 insertions(+), 10 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 8317ec4..ed6371c 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -162,6 +162,11 @@ extern int _cond_resched(void);
 		(__x < 0) ? -__x : __x;		\
 	})
 
+#define abs64(x) ({				\
+		s64 __x = (x);			\
+		(__x < 0) ? -__x : __x;		\
+	})
+
 #ifdef CONFIG_PROVE_LOCKING
 void might_fault(void);
 #else
diff --git a/include/linux/math64.h b/include/linux/math64.h
index c87f152..23fcdfc 100644
--- a/include/linux/math64.h
+++ b/include/linux/math64.h
@@ -35,6 +35,14 @@ static inline u64 div64_u64(u64 dividend, u64 divisor)
 	return dividend / divisor;
 }
 
+/**
+ * div64_s64 - signed 64bit divide with 64bit divisor
+ */
+static inline s64 div64_s64(s64 dividend, s64 divisor)
+{
+	return dividend / divisor;
+}
+
 #elif BITS_PER_LONG == 32
 
 #ifndef div_u64_rem
@@ -53,6 +61,10 @@ extern s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder);
 extern u64 div64_u64(u64 dividend, u64 divisor);
 #endif
 
+#ifndef div64_s64
+extern s64 div64_s64(s64 dividend, s64 divisor);
+#endif
+
 #endif /* BITS_PER_LONG */
 
 /**
diff --git a/lib/div64.c b/lib/div64.c
index a111eb8..5b49191 100644
--- a/lib/div64.c
+++ b/lib/div64.c
@@ -77,26 +77,58 @@ s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder)
 EXPORT_SYMBOL(div_s64_rem);
 #endif
 
-/* 64bit divisor, dividend and result. dynamic precision */
+/**
+ * div64_u64 - unsigned 64bit divide with 64bit divisor
+ * @dividend:	64bit dividend
+ * @divisor:	64bit divisor
+ *
+ * This implementation is a modified version of the algorithm proposed
+ * by the book 'Hacker's Delight'.  The original source and full proof
+ * can be found here and is available for use without restriction.
+ *
+ * 'http://www.hackersdelight.org/HDcode/newCode/divDouble.c'
+ */
 #ifndef div64_u64
 u64 div64_u64(u64 dividend, u64 divisor)
 {
-	u32 high, d;
+	u32 high = divisor >> 32;
+	u64 quot;
 
-	high = divisor >> 32;
-	if (high) {
-		unsigned int shift = fls(high);
+	if (high == 0) {
+		quot = div_u64(dividend, divisor);
+	} else {
+		int n = 1 + fls(high);
+		quot = div_u64(dividend >> n, divisor >> n);
 
-		d = divisor >> shift;
-		dividend >>= shift;
-	} else
-		d = divisor;
+		if (quot != 0)
+			quot--;
+		if ((dividend - quot * divisor) >= divisor)
+			quot++;
+	}
 
-	return div_u64(dividend, d);
+	return quot;
 }
 EXPORT_SYMBOL(div64_u64);
 #endif
 
+/**
+ * div64_s64 - signed 64bit divide with 64bit divisor
+ * @dividend:	64bit dividend
+ * @divisor:	64bit divisor
+ */
+#ifndef div64_s64
+s64 div64_s64(s64 dividend, s64 divisor)
+{
+	s64 quot, t;
+
+	quot = div64_u64(abs64(dividend), abs64(divisor));
+	t = (dividend ^ divisor) >> 63;
+
+	return (quot ^ t) - t;
+}
+EXPORT_SYMBOL(div64_s64);
+#endif
+
 #endif /* BITS_PER_LONG == 32 */
 
 /*
-- 
1.7.1


--=-Ktx8XrHJwgmO33FQafax--

