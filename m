Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab2LaSiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 13:38:23 -0500
Received: from mail-vb0-f43.google.com ([209.85.212.43]:42386 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab2LaSiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 13:38:22 -0500
MIME-Version: 1.0
Date: Mon, 31 Dec 2012 13:38:21 -0500
Message-ID: <CAGh4K3JtRit+g7Oxn_=TamjmxiAhp7RFJX2KxnNDh5ppgq6SYw@mail.gmail.com>
Subject: PATCH: Error checking page_size to see if userspace page_size_int = 2.
From: Christopher Sacchi <chris.sacchi@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is for the pagemap.h. This checks to see if the
page_size_int is 2, if not, set the value to 2, and return 1.
The code is under the double-dashed lines.

--
Signed-off-by: Christopher P. Sacchi chris.sacchi@gmail.com
--- pagemap.h	2012-12-21 20:19:00.000000000 -0500
+++ pagemap.h	2012-12-31 13:07:51.566631871 -0500
@@ -14,11 +14,15 @@
 #include <linux/bitops.h>
 #include <linux/hardirq.h> /* for in_interrupt() */
 #include <linux/hugetlb_inline.h>
-
 /*
  * Bits in mapping->flags.  The lower __GFP_BITS_SHIFT bits are the page
  * allocation mode flags.
  */
+/*
+* Here we declare the number that
+* the PAGE_SIZE should have.
+* We need it an integer for checking
+* and writing. This value should be two.
+* If not, later we'll check.
+*/
+int page_size_integer = 2;
 enum mapping_flags {
 	AS_EIO		= __GFP_BITS_SHIFT + 0,	/* IO error on async write */
 	AS_ENOSPC	= __GFP_BITS_SHIFT + 1,	/* ENOSPC on async write */
@@ -426,6 +430,18 @@ extern void add_page_wait_queue(struct p
  * This assumes that two userspace pages are always sufficient.  That's
  * not true if PAGE_CACHE_SIZE > PAGE_SIZE.
  */
+
+/*
+* Here we'll check for if the two userspace pages are not sufficient,
+* and if PAGE_CACHE_SIZE > PAGE_SIZE.
+* This will return 1 if true,
+* and will set the value back to 2 in case of a fault.
+*/
+static inline int fault_userspace_assumption_sufficient_not_true()
+{
+	if (PAGE_CACHE_SIZE > PAGE_SIZE) {
+		page_size_int = 2;
+		return 1;
+	}
+}
 static inline int fault_in_pages_writeable(char __user *uaddr, int size)
 {
 	int ret;
--

Regards,
Christopher
