Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934337Ab2JXDlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 23:41:42 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:38797 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934056Ab2JXDll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 23:41:41 -0400
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: akpm@linux-foundation.org, richard.weinberger@gmail.com, jkosina@suse.cz,
        stefani@seibold.net, linux-kernel@vger.kernel.org
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: [PATCH] Replace the type check code with typecheck() in kfifo_in
Date: Wed, 24 Oct 2012 11:41:14 +0800
Message-Id: <1351050074-22480-1-git-send-email-weiyang@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
x-cbid: 12102403-5490-0000-0000-00000255DF75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kfifo_in marco, one piece of code which is arounded by if(0) will check the
type of __tmp->ptr_const and __buf. If they are different type, there will
output a warning during compiling. This piece of code is not self explaining
and a little bit hard to understand.

Based on Andrew Morton's suggestion, this patch replace this with typecheck()
which will be easy to understand.

In the same file, there are several places with the same code style. This
patch change them too.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: richard -rw- weinberger <richard.weinberger@gmail.com>
---
 include/linux/kfifo.h |   22 +++++-----------------
 1 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index 10308c6..680c293 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -390,10 +390,7 @@ __kfifo_int_must_check_helper( \
 	unsigned int __ret; \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
-	if (0) { \
-		typeof(__tmp->ptr_const) __dummy __attribute__ ((unused)); \
-		__dummy = (typeof(__val))NULL; \
-	} \
+	typecheck(typeof(__tmp->ptr_const), __val); \
 	if (__recsize) \
 		__ret = __kfifo_in_r(__kfifo, __val, sizeof(*__val), \
 			__recsize); \
@@ -433,7 +430,7 @@ __kfifo_uint_must_check_helper( \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
 	if (0) \
-		__val = (typeof(__tmp->ptr))0; \
+		__val = (typeof(__tmp->ptr))NULL; \
 	if (__recsize) \
 		__ret = __kfifo_out_r(__kfifo, __val, sizeof(*__val), \
 			__recsize); \
@@ -512,10 +509,7 @@ __kfifo_uint_must_check_helper( \
 	unsigned long __n = (n); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
-	if (0) { \
-		typeof(__tmp->ptr_const) __dummy __attribute__ ((unused)); \
-		__dummy = (typeof(__buf))NULL; \
-	} \
+	typecheck(typeof(__tmp->ptr_const), __buf);\
 	(__recsize) ?\
 	__kfifo_in_r(__kfifo, __buf, __n, __recsize) : \
 	__kfifo_in(__kfifo, __buf, __n); \
@@ -565,10 +559,7 @@ __kfifo_uint_must_check_helper( \
 	unsigned long __n = (n); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
-	if (0) { \
-		typeof(__tmp->ptr) __dummy = NULL; \
-		__buf = __dummy; \
-	} \
+	typecheck(typeof(__tmp->ptr), __buf); \
 	(__recsize) ?\
 	__kfifo_out_r(__kfifo, __buf, __n, __recsize) : \
 	__kfifo_out(__kfifo, __buf, __n); \
@@ -777,10 +768,7 @@ __kfifo_uint_must_check_helper( \
 	unsigned long __n = (n); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
-	if (0) { \
-		typeof(__tmp->ptr) __dummy __attribute__ ((unused)) = NULL; \
-		__buf = __dummy; \
-	} \
+	typecheck(typeof(__tmp->ptr), __buf); \
 	(__recsize) ? \
 	__kfifo_out_peek_r(__kfifo, __buf, __n, __recsize) : \
 	__kfifo_out_peek(__kfifo, __buf, __n); \
-- 
1.7.5.4

