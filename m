Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab3AHO6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 09:58:48 -0500
Received: from mga03.intel.com ([143.182.124.21]:18527 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756511Ab3AHO5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 09:57:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,430,1355126400"; 
   d="scan'208";a="188870171"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Stefani Seibold <stefani@seibold.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/5] kfifo: remove unnecessary type check
Date: Tue,  8 Jan 2013 22:57:49 +0800
Message-Id: <1357657073-27352-2-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1357657073-27352-1-git-send-email-yuanhan.liu@linux.intel.com>
References: <1357657073-27352-1-git-send-email-yuanhan.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Firstly, this kind of type check doesn't work. It does something similar
as following:
	void * __dummy = NULL;
	__buf = __dummy;

__dummy is defined as void *. Thus it will not trigger warnings as
expected.

Second, we don't need that kind of check. Since the prototype
of __kfifo_out is:
	unsigned int __kfifo_out(struct __kfifo *fifo,  void *buf, unsigned int len)

buf is defined as void *, so we don't need do the type check. Remove it.

v2: remove ptr and const_ptr, which were used for type checking.

LINK: https://lkml.org/lkml/2012/10/25/386
LINK: https://lkml.org/lkml/2012/10/25/584

Cc: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 include/linux/kfifo.h |   46 ++++++++++++----------------------------------
 1 files changed, 12 insertions(+), 34 deletions(-)

diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index 10308c6..7a18245 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -63,49 +63,47 @@ struct __kfifo {
 	void		*data;
 };
 
-#define __STRUCT_KFIFO_COMMON(datatype, recsize, ptrtype) \
+#define __STRUCT_KFIFO_COMMON(datatype, recsize) \
 	union { \
 		struct __kfifo	kfifo; \
 		datatype	*type; \
 		char		(*rectype)[recsize]; \
-		ptrtype		*ptr; \
-		const ptrtype	*ptr_const; \
 	}
 
-#define __STRUCT_KFIFO(type, size, recsize, ptrtype) \
+#define __STRUCT_KFIFO(type, size, recsize) \
 { \
-	__STRUCT_KFIFO_COMMON(type, recsize, ptrtype); \
+	__STRUCT_KFIFO_COMMON(type, recsize); \
 	type		buf[((size < 2) || (size & (size - 1))) ? -1 : size]; \
 }
 
 #define STRUCT_KFIFO(type, size) \
-	struct __STRUCT_KFIFO(type, size, 0, type)
+	struct __STRUCT_KFIFO(type, size, 0)
 
-#define __STRUCT_KFIFO_PTR(type, recsize, ptrtype) \
+#define __STRUCT_KFIFO_PTR(type, recsize) \
 { \
-	__STRUCT_KFIFO_COMMON(type, recsize, ptrtype); \
+	__STRUCT_KFIFO_COMMON(type, recsize); \
 	type		buf[0]; \
 }
 
 #define STRUCT_KFIFO_PTR(type) \
-	struct __STRUCT_KFIFO_PTR(type, 0, type)
+	struct __STRUCT_KFIFO_PTR(type, 0)
 
 /*
  * define compatibility "struct kfifo" for dynamic allocated fifos
  */
-struct kfifo __STRUCT_KFIFO_PTR(unsigned char, 0, void);
+struct kfifo __STRUCT_KFIFO_PTR(unsigned char, 0);
 
 #define STRUCT_KFIFO_REC_1(size) \
-	struct __STRUCT_KFIFO(unsigned char, size, 1, void)
+	struct __STRUCT_KFIFO(unsigned char, size, 1)
 
 #define STRUCT_KFIFO_REC_2(size) \
-	struct __STRUCT_KFIFO(unsigned char, size, 2, void)
+	struct __STRUCT_KFIFO(unsigned char, size, 2)
 
 /*
  * define kfifo_rec types
  */
-struct kfifo_rec_ptr_1 __STRUCT_KFIFO_PTR(unsigned char, 1, void);
-struct kfifo_rec_ptr_2 __STRUCT_KFIFO_PTR(unsigned char, 2, void);
+struct kfifo_rec_ptr_1 __STRUCT_KFIFO_PTR(unsigned char, 1);
+struct kfifo_rec_ptr_2 __STRUCT_KFIFO_PTR(unsigned char, 2);
 
 /*
  * helper macro to distinguish between real in place fifo where the fifo
@@ -390,10 +388,6 @@ __kfifo_int_must_check_helper( \
 	unsigned int __ret; \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
-	if (0) { \
-		typeof(__tmp->ptr_const) __dummy __attribute__ ((unused)); \
-		__dummy = (typeof(__val))NULL; \
-	} \
 	if (__recsize) \
 		__ret = __kfifo_in_r(__kfifo, __val, sizeof(*__val), \
 			__recsize); \
@@ -432,8 +426,6 @@ __kfifo_uint_must_check_helper( \
 	unsigned int __ret; \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
-	if (0) \
-		__val = (typeof(__tmp->ptr))0; \
 	if (__recsize) \
 		__ret = __kfifo_out_r(__kfifo, __val, sizeof(*__val), \
 			__recsize); \
@@ -473,8 +465,6 @@ __kfifo_uint_must_check_helper( \
 	unsigned int __ret; \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
-	if (0) \
-		__val = (typeof(__tmp->ptr))NULL; \
 	if (__recsize) \
 		__ret = __kfifo_out_peek_r(__kfifo, __val, sizeof(*__val), \
 			__recsize); \
@@ -512,10 +502,6 @@ __kfifo_uint_must_check_helper( \
 	unsigned long __n = (n); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
-	if (0) { \
-		typeof(__tmp->ptr_const) __dummy __attribute__ ((unused)); \
-		__dummy = (typeof(__buf))NULL; \
-	} \
 	(__recsize) ?\
 	__kfifo_in_r(__kfifo, __buf, __n, __recsize) : \
 	__kfifo_in(__kfifo, __buf, __n); \
@@ -565,10 +551,6 @@ __kfifo_uint_must_check_helper( \
 	unsigned long __n = (n); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
-	if (0) { \
-		typeof(__tmp->ptr) __dummy = NULL; \
-		__buf = __dummy; \
-	} \
 	(__recsize) ?\
 	__kfifo_out_r(__kfifo, __buf, __n, __recsize) : \
 	__kfifo_out(__kfifo, __buf, __n); \
@@ -777,10 +759,6 @@ __kfifo_uint_must_check_helper( \
 	unsigned long __n = (n); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
-	if (0) { \
-		typeof(__tmp->ptr) __dummy __attribute__ ((unused)) = NULL; \
-		__buf = __dummy; \
-	} \
 	(__recsize) ? \
 	__kfifo_out_peek_r(__kfifo, __buf, __n, __recsize) : \
 	__kfifo_out_peek(__kfifo, __buf, __n); \
-- 
1.7.7.6

