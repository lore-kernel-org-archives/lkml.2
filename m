Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab0IWEe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 00:34:59 -0400
Received: from ozlabs.org ([203.10.76.45]:56454 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab0IWEe6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 00:34:58 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: =?iso-8859-1?q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Subject: Re: [PATCH v4 2/2] bsearch: prevent overflow when computing middle comparison element
Date: Thu, 23 Sep 2010 10:56:10 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
        Tim Abbott <tabbott@ksplice.com>
References: <cover.1257864802.git.andre.goddard@gmail.com> <200911141012.19050.rusty@rustcorp.com.au> <AANLkTinhg-ZgQRQ5KUXR-FeTa9zo+cUF+3vZykzeaHwE@mail.gmail.com>
In-Reply-To: <AANLkTinhg-ZgQRQ5KUXR-FeTa9zo+cUF+3vZykzeaHwE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009231056.11938.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010 12:12:13 am André Goddard Rosa wrote:
> On Fri, Nov 13, 2009 at 8:42 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > On Sat, 14 Nov 2009 01:33:04 am Thiago Farina wrote:
> >> Hi Rusty,
> >>
> >> On Thu, Nov 12, 2009 at 11:06 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> >> > On Wed, 11 Nov 2009 01:30:25 am André Goddard Rosa wrote:
> >> >> It's really difficult to occur in practice because the sum of the lower
> >> >> and higher limits must overflow an int variable, but it can occur when
> >> >> working with large arrays. We'd better safe than sorry by avoiding this
> >> >> overflow situation when computing the middle element for comparison.
> >> >
> >> > I applied all these, after testing.  In future would have been nice for you
> >> > to have posted a test patch so I didn't have make my own...
> >>
> >> Where did you apply this patch?
> >
> > To my kernel series, which means it is now in linux-next.
> >
> > Hope that helps,
> > Rusty.
> >
> 
> Hi, Rusty!
> 
>     Is there any chance that this patchset will land into mainline anytime soon?
> 
>     Here we have another use for the binary search function:
>         http://marc.info/?l=linux-kernel&m=128515012817787&w=2

"Unused code is buggy code".  Can we have some users please?  Do people
care that uninlining means an indirect fn call now for cmp?

Nonetheless, I've merged all the fixes together:

From: Tim Abbott <tabbott@ksplice.com>
Subject: lib: Add generic binary search function to the kernel.

There a large number hand-coded binary searches in the kernel (run
"git grep search | grep binary" to find many of them).  Since in my
experience, hand-coding binary searches can be error-prone, it seems
worth cleaning this up by providing a generic binary search function.

This generic binary search implementation comes from Ksplice.  It has
the same basic API as the C library bsearch() function.  Ksplice uses
it in half a dozen places with 4 different comparison functions, and I
think our code is substantially cleaner because of this.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Extra-bikeshedding-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Extra-bikeshedding-by: André Goddard Rosa <andre.goddard@gmail.com>
Extra-bikeshedding-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/bsearch.h |    9 ++++++++
 lib/Makefile            |    2 -
 lib/bsearch.c           |   53 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/include/linux/bsearch.h b/include/linux/bsearch.h
new file mode 100644
--- /dev/null
+++ b/include/linux/bsearch.h
@@ -0,0 +1,9 @@
+#ifndef _LINUX_BSEARCH_H
+#define _LINUX_BSEARCH_H
+
+#include <linux/types.h>
+
+void *bsearch(const void *key, const void *base, size_t num, size_t size,
+	      int (*cmp)(const void *key, const void *elt));
+
+#endif /* _LINUX_BSEARCH_H */
diff --git a/lib/Makefile b/lib/Makefile
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -21,7 +21,7 @@ lib-y	+= kobject.o kref.o klist.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
-	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o
+	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o bsearch.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
diff --git a/lib/bsearch.c b/lib/bsearch.c
new file mode 100644
--- /dev/null
+++ b/lib/bsearch.c
@@ -0,0 +1,53 @@
+/*
+ * A generic implementation of binary search for the Linux kernel
+ *
+ * Copyright (C) 2008-2009 Ksplice, Inc.
+ * Author: Tim Abbott <tabbott@ksplice.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; version 2.
+ */
+
+#include <linux/module.h>
+#include <linux/bsearch.h>
+
+/*
+ * bsearch - binary search an array of elements
+ * @key: pointer to item being searched for
+ * @base: pointer to data to sort
+ * @num: number of elements
+ * @size: size of each element
+ * @cmp: pointer to comparison function
+ *
+ * This function does a binary search on the given array.  The
+ * contents of the array should already be in ascending sorted order
+ * under the provided comparison function.
+ *
+ * Note that the key need not have the same type as the elements in
+ * the array, e.g. key could be a string and the comparison function
+ * could compare the string with the struct's name field.  However, if
+ * the key and elements in the array are of the same type, you can use
+ * the same comparison function for both sort() and bsearch().
+ */
+void *bsearch(const void *key, const void *base, size_t num, size_t size,
+	      int (*cmp)(const void *key, const void *elt))
+{
+	size_t start = 0, end = num;
+	int result;
+
+	while (start < end) {
+		size_t mid = start + (end - start) / 2;
+
+		result = cmp(key, base + mid * size);
+		if (result < 0)
+			end = mid;
+		else if (result > 0)
+			start = mid + 1;
+		else
+			return (void *)base + mid * size;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(bsearch);

