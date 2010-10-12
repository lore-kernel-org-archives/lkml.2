Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788Ab0JLTgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 15:36:51 -0400
Received: from nspiron-3.llnl.gov ([128.115.41.83]:63295 "EHLO smtp.llnl.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753165Ab0JLTgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 15:36:50 -0400
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Oct 2010 15:36:49 EDT
X-Attachments: 0001-Fix-div64_u64-for-32bit-platforms.patch, div64_u64_test.c,
 div64_s64_test.c, README
From: Brian Behlendorf <behlendorf1@llnl.gov>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make div64_u64() precise on 32bit platforms
Date: Tue, 12 Oct 2010 12:26:59 -0700
User-Agent: KMail/1.9.4
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <onestero@redhat.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_JaLtM9puqmnsqEX"
Message-Id: <201010121227.05735.behlendorf1@llnl.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_JaLtM9puqmnsqEX
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


I'm resending the patch as is and adding what I hope are the right CCs.  Also 
let me explain why I opted to add abs64() and use the gcc builtin.

>Can't we just improve abs? Say,

I was reluctant to change abs() since it would have a much larger impact on 
the code base.  Using typeof() should be OK but if any of the callers 
mistakenly call abs() with an unsigned value then we could see compiler 
warnings about '__x < 0' being a useless conditional.

>This is a bit unusual. I mean, it is not that common to use gcc builtins
>in the normal code. And, it seems, we can use __fls(divisor >> 32) or
>just fls64() instead ?

I opted for the gcc builtin because I felt it made the code more readable.  I 
also suspect it will perform slightly better than __fls() on some archs.  For 
example, on powerpc __fls() in implemented using the 'cntlzw' instruction.  
It returns (BITS_PER_LONG - 1 - cntlzw) which is wasted work since my 
function would immediately undo this to get back cntlzw.  If I was lucky the 
compiler would optimize this away for me but if I use the builtin I don't 
need to take the chance.

-- 
Thanks,
Brian Behlendorf

--Boundary-00=_JaLtM9puqmnsqEX
Content-Type: text/plain;
  charset="iso-8859-1";
  name="0001-Fix-div64_u64-for-32bit-platforms.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-Fix-div64_u64-for-32bit-platforms.patch"

>From 3b30f1cf78f88b40360dd65816941cf2be9dd60d Mon Sep 17 00:00:00 2001
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
 include/linux/kernel.h |    5 +++
 include/linux/math64.h |   12 +++++++++
 lib/div64.c            |   64 +++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 70 insertions(+), 11 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 5de838b..7a00dff 100644
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
index a111eb8..e4e7fc6 100644
--- a/lib/div64.c
+++ b/lib/div64.c
@@ -77,26 +77,68 @@ s64 div_s64_rem(s64 dividend, s32 divisor, s32 *remainder)
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
-
-	high = divisor >> 32;
-	if (high) {
-		unsigned int shift = fls(high);
+	u64 u0, quot0, quot1;
+	u32 rem;
+	int n;
+
+	if (divisor >> 32 == 0) {
+		if (dividend >> 32 < divisor) {
+			return div_u64_rem(dividend, divisor, &rem);
+		} else {
+			u0 = dividend & 0xFFFFFFFF;
+			quot1 = div_u64_rem(dividend >> 32, divisor, &rem);
+			u0 += ((u64)rem << 32);
+			quot0 = div_u64_rem(u0, divisor, &rem);
+			return (quot1 << 32) + quot0;
+		}
+	} else {
+		n = __builtin_clzll(divisor);
+		quot1 = div_u64_rem(dividend >> 1, (divisor << n) >> 32, &rem);
+		quot0 = (quot1 << n) >> 31;
 
-		d = divisor >> shift;
-		dividend >>= shift;
-	} else
-		d = divisor;
+		if (quot0 != 0)
+			quot0 = quot0 - 1;
+		if ((dividend - quot0 * divisor) >= divisor)
+			quot0 = quot0 + 1;
 
-	return div_u64(dividend, d);
+		return quot0;
+	}
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
1.5.4.5


--Boundary-00=_JaLtM9puqmnsqEX
Content-Type: text/x-csrc;
  charset="iso-8859-1";
  name="div64_u64_test.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="div64_u64_test.c"

#include <linux/module.h>

/*
 * Verification test for div64_u64.
 */

#ifndef abs64
#define abs64(x) ({			\
	s64 __x = (x);			\
	(__x < 0) ? -__x : __x;		\
})
#endif

int div64_u64_test(void)
{
	u64 uu, vu, qu, ru;
	int n, i, j, errors = 0;
	const u64 tabu[] = {
	    0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
	    10, 11, 12, 13, 14, 15, 16, 1000, 2003,
	    32765, 32766, 32767, 32768, 32769, 32760,
	    65533, 65534, 65535, 65536, 65537, 65538,
	    0x7ffffffeULL, 0x7fffffffULL, 0x80000000ULL, 0x80000001ULL,
	    0x7000000000000000ULL, 0x7000000080000000ULL, 0x7000000080000001ULL,
	    0x7fffffffffffffffULL, 0x7fffffff8fffffffULL, 0x7fffffff8ffffff1ULL,
	    0x7fffffff00000000ULL, 0x7fffffff80000000ULL, 0x7fffffff00000001ULL,
	    0x8000000000000000ULL, 0x8000000080000000ULL, 0x8000000080000001ULL,
	    0xc000000000000000ULL, 0xc000000080000000ULL, 0xc000000080000001ULL,
	    0xfffffffffffffffdULL, 0xfffffffffffffffeULL, 0xffffffffffffffffULL,
	};

	printk("%s", "Testing unsigned 64-bit division.\n");
	n = sizeof(tabu) / sizeof(tabu[0]);
	for (i = 0; i < n; i++) {
		for (j = 1; j < n; j++) {
			uu = tabu[i];
			vu = tabu[j];
			qu = div64_u64(uu, vu);
			ru = uu - qu * vu;
			if (qu > uu || ru >= vu) {
				printk("%016llx/%016llx != %016llx "
				   "rem %016llx\n", uu, vu, qu, ru);
				errors++;
			}
		}
	}

	if (errors) {
		printk("Failed %d/%d tests\n", errors, n * (n - 1));
	} else {
		printk("Passed all %d tests\n", n * (n - 1));
	}

	return 0;
}

void div64_u64_exit(void) { }

module_init(div64_u64_test);
module_exit(div64_u64_exit);

--Boundary-00=_JaLtM9puqmnsqEX
Content-Type: text/x-csrc;
  charset="iso-8859-1";
  name="div64_s64_test.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="div64_s64_test.c"

#include <linux/module.h>

/*
 * Verification test for div64_s64.
 */

#ifndef abs64
#define abs64(x) ({			\
	s64 __x = (x);			\
	(__x < 0) ? -__x : __x;		\
})
#endif

int div64_s64_test(void)
{
	s64 u, v, q, r;
	int n, i, j, k, errors = 0;
	const s64 tabs[] = {
	    0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
	    10, 11, 12, 13, 14, 15, 16, 1000, 2003,
	    32765, 32766, 32767, 32768, 32769, 32760,
	    65533, 65534, 65535, 65536, 65537, 65538,
	    0x7ffffffeLL, 0x7fffffffLL, 0x80000000LL, 0x80000001LL,
	    0x7000000000000000LL, 0x7000000080000000LL, 0x7000000080000001LL,
	    0x7fffffffffffffffLL, 0x7fffffff8fffffffLL, 0x7fffffff8ffffff1LL,
	    0x7fffffff00000000LL, 0x7fffffff80000000LL, 0x7fffffff00000001LL,
	    0x0123456789abcdefLL, 0x00000000abcdef01LL, 0x0000000012345678LL,
	};

	printk("%s", "Testing signed 64-bit division.\n");
	n = sizeof(tabs) / sizeof(tabs[0]);
	for (i = 0; i < n; i++) {
		for (j = 1; j < n; j++) {
			for (k = 0; k <= 3; k++) {
				u = (k & 1)  ? -tabs[i] : tabs[i];
				v = (k >= 2) ? -tabs[j] : tabs[j];

				q = div64_s64(u, v);
				r = u - q * v;
				if (abs64(q) >  abs64(u) ||
				    abs64(r) >= abs64(v) ||
				    (r != 0 && (r ^ u) < 0)) {
					printk("%016llx/%016llx != %016llx "
					    "rem %016llx\n", u, v, q, r);
					errors++;
				}
			}
		}
	}

	if (errors) {
		printk("Failed %d/%d tests\n", errors, n * (n - 1));
	} else {
		printk("Passed all %d tests\n", n * (n - 1));
	}

	return 0;
}

void div64_s64_exit(void) { }

module_init(div64_s64_test);
module_exit(div64_s64_exit);

--Boundary-00=_JaLtM9puqmnsqEX
Content-Type: text/plain;
  charset="iso-8859-1";
  name="README"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="README"

linux-2.6.35

Testing Summary     | x86_64 | x86    |
--------------------+-----------------+
linux-2.6.35        | PASS   | FAIL   |
linux-2.6.35+patch  | PASS   | PASS   |


Testing Details (x86_64)
--------------------------------------------------------------------------
* PASS - linux-2.6.35
Testing unsigned 64-bit division.
Passed all 2756 tests

* PASS - linux-2.6.35+patch
Testing unsigned 64-bit division.
Passed all 2756 tests
Testing signed 64-bit division.
Passed all 2162 tests


Testing Details (x86)
--------------------------------------------------------------------------
* FAIL - linux-2.6.35
Testing unsigned 64-bit division.
7000000080000000/7000000080000001 != 0000000000000001 rem ffffffffffffffff
7fffffff8fffffff/7fffffffffffffff != 0000000000000001 rem ffffffff90000000
7fffffff8ffffff1/7fffffffffffffff != 0000000000000001 rem ffffffff8ffffff2
7fffffff8ffffff1/7fffffff8fffffff != 0000000000000001 rem fffffffffffffff2
7fffffff00000000/7fffffff00000001 != 0000000000000001 rem ffffffffffffffff
7fffffff80000000/7fffffffffffffff != 0000000000000001 rem ffffffff80000001
7fffffff80000000/7fffffff8fffffff != 0000000000000001 rem fffffffff0000001
7fffffff80000000/7fffffff8ffffff1 != 0000000000000001 rem fffffffff000000f
8000000000000000/8000000080000000 != 0000000000000001 rem ffffffff80000000
8000000000000000/8000000080000001 != 0000000000000001 rem ffffffff7fffffff
8000000080000000/8000000080000001 != 0000000000000001 rem ffffffffffffffff
c000000000000000/c000000080000000 != 0000000000000001 rem ffffffff80000000
c000000000000000/c000000080000001 != 0000000000000001 rem ffffffff7fffffff
c000000080000000/c000000080000001 != 0000000000000001 rem ffffffffffffffff
fffffffffffffffd/7fffffffffffffff != 0000000000000002 rem ffffffffffffffff
fffffffffffffffd/fffffffffffffffe != 0000000000000001 rem ffffffffffffffff
fffffffffffffffe/ffffffffffffffff != 0000000000000001 rem ffffffffffffffff
Failed 17/2756 tests

* PASS - linux-2.6.35+patch
Testing unsigned 64-bit division.
Passed all 2756 tests
Testing signed 64-bit division.
Passed all 2162 tests


--Boundary-00=_JaLtM9puqmnsqEX--

