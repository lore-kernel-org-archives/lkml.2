Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab2DNTP7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 15:15:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53219 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab2DNTPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 15:15:23 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        peterz@infradead.org, mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
        srivatsa.bhat@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>
Subject: [RFC 3/3] kernel.h: use new typechecking macros in min()/max() and friends
Date: Sat, 14 Apr 2012 18:14:45 -0400
Message-Id: <1334441685-4438-4-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1334441685-4438-1-git-send-email-levinsasha928@gmail.com>
References: <1334441685-4438-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to using new typechecking macros in kernel.h. This prevents code
duplication and makes the modified macros (easily) readable again.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 include/linux/kernel.h |   47 +++++++++++++++--------------------------------
 1 files changed, 15 insertions(+), 32 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 645231c..ec509cc 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -555,34 +555,22 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
  * "unnecessary" pointer comparison.
  */
 #define min(x, y) ({				\
-	typeof(x) _min1 = (x);			\
-	typeof(y) _min2 = (y);			\
-	(void) (&_min1 == &_min2);		\
-	_min1 < _min2 ? _min1 : _min2; })
+	typecmp2((x), (y));				\
+	(x) < (y) ? (x) : (y); })
 
 #define max(x, y) ({				\
-	typeof(x) _max1 = (x);			\
-	typeof(y) _max2 = (y);			\
-	(void) (&_max1 == &_max2);		\
-	_max1 > _max2 ? _max1 : _max2; })
+	typecmp2((x), (y));				\
+	(x) > (y) ? (x) : (y); }) 
 
 #define min3(x, y, z) ({			\
-	typeof(x) _min1 = (x);			\
-	typeof(y) _min2 = (y);			\
-	typeof(z) _min3 = (z);			\
-	(void) (&_min1 == &_min2);		\
-	(void) (&_min1 == &_min3);		\
-	_min1 < _min2 ? (_min1 < _min3 ? _min1 : _min3) : \
-		(_min2 < _min3 ? _min2 : _min3); })
+	typecmp3((x), (y), (z));			\
+	(x) < (y) ? ((x) < (z) ? (x) : (z)) :	\
+	((y) < (z) ? (y) : (z)); })
 
 #define max3(x, y, z) ({			\
-	typeof(x) _max1 = (x);			\
-	typeof(y) _max2 = (y);			\
-	typeof(z) _max3 = (z);			\
-	(void) (&_max1 == &_max2);		\
-	(void) (&_max1 == &_max3);		\
-	_max1 > _max2 ? (_max1 > _max3 ? _max1 : _max3) : \
-		(_max2 > _max3 ? _max2 : _max3); })
+	typecmp3((x), (y), (z));                      \
+	(x) > (y) ? ((x) > (z) ? (x) : (z)) :   \
+		((y) > (z) ? (y) : (z)); })
 
 /**
  * min_not_zero - return the minimum that is _not_ zero, unless both are zero
@@ -590,9 +578,8 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
  * @y: value2
  */
 #define min_not_zero(x, y) ({			\
-	typeof(x) __x = (x);			\
-	typeof(y) __y = (y);			\
-	__x == 0 ? __y : ((__y == 0) ? __x : min(__x, __y)); })
+	typecmp2((x), (y));			\
+	(x) == 0 ? (y) : ((y) == 0 ? (x) : min((x), (y))); })
 
 /**
  * clamp - return a value clamped to a given range with strict typechecking
@@ -604,13 +591,9 @@ static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
  * same type as val.  See the unnecessary pointer comparisons.
  */
 #define clamp(val, min, max) ({			\
-	typeof(val) __val = (val);		\
-	typeof(min) __min = (min);		\
-	typeof(max) __max = (max);		\
-	(void) (&__val == &__min);		\
-	(void) (&__val == &__max);		\
-	__val = __val < __min ? __min: __val;	\
-	__val > __max ? __max: __val; })
+	typecmp3((val), (min), (max));		\
+	((val) > (max) ? (max) : (val)) < (min) ? \
+	(min) : ((val) > (max) ? (max) : (val)); })
 
 /*
  * ..and if you can't take the strict
-- 
1.7.8.5

