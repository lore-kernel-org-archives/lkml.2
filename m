Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab0LBXpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 18:45:07 -0500
Received: from smtp-out.google.com ([216.239.44.51]:28909 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758555Ab0LBXpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 18:45:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=EeJcuX/4KGIjf+HwgjuRBSzZK83Y4Q0wEPgE7mPiVnzFB+zQr1iX2o/z4St6sSe8ph
         xSbA8PxCynNKa80F1oqw==
Date: Thu, 2 Dec 2010 15:44:57 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Paul Mundt <lethal@linux-sh.org>, Alex Bennee <kernel-hacker@bennee.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [patch v2] flex_array: export symbols to modules
In-Reply-To: <20101202063054.GB3367@linux-sh.org>
Message-ID: <alpine.DEB.2.00.1012021544510.8285@chino.kir.corp.google.com>
References: <AANLkTik_TQfQDERdRQaQek3S7280sQBmHGKOnhJwU5EE@mail.gmail.com> <alpine.DEB.2.00.1012011714510.22420@chino.kir.corp.google.com> <20101202063054.GB3367@linux-sh.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add EXPORT_SYMBOL() for all publically accessible flex array functions
and move to obj-y so that modules may use this library.

Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 v2: moved to obj-y per Paul Mundt's feedback, thanks!

 lib/Makefile     |    4 ++--
 lib/flex_array.c |   10 ++++++++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/lib/Makefile b/lib/Makefile
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -12,7 +12,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o prio_heap.o ratelimit.o show_mem.o \
-	 is_single_threaded.o plist.o decompress.o flex_array.o
+	 is_single_threaded.o plist.o decompress.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
@@ -21,7 +21,7 @@ lib-y	+= kobject.o kref.o klist.o
 
 obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
 	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
-	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o
+	 string_helpers.o gcd.o lcm.o list_sort.o uuid.o flex_array.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
diff --git a/lib/flex_array.c b/lib/flex_array.c
--- a/lib/flex_array.c
+++ b/lib/flex_array.c
@@ -23,6 +23,7 @@
 #include <linux/flex_array.h>
 #include <linux/slab.h>
 #include <linux/stddef.h>
+#include <linux/module.h>
 
 struct flex_array_part {
 	char elements[FLEX_ARRAY_PART_SIZE];
@@ -103,6 +104,7 @@ struct flex_array *flex_array_alloc(int element_size, unsigned int total,
 						FLEX_ARRAY_BASE_BYTES_LEFT);
 	return ret;
 }
+EXPORT_SYMBOL(flex_array_alloc);
 
 static int fa_element_to_part_nr(struct flex_array *fa,
 					unsigned int element_nr)
@@ -126,12 +128,14 @@ void flex_array_free_parts(struct flex_array *fa)
 	for (part_nr = 0; part_nr < FLEX_ARRAY_NR_BASE_PTRS; part_nr++)
 		kfree(fa->parts[part_nr]);
 }
+EXPORT_SYMBOL(flex_array_free_parts);
 
 void flex_array_free(struct flex_array *fa)
 {
 	flex_array_free_parts(fa);
 	kfree(fa);
 }
+EXPORT_SYMBOL(flex_array_free);
 
 static unsigned int index_inside_part(struct flex_array *fa,
 					unsigned int element_nr)
@@ -196,6 +200,7 @@ int flex_array_put(struct flex_array *fa, unsigned int element_nr, void *src,
 	memcpy(dst, src, fa->element_size);
 	return 0;
 }
+EXPORT_SYMBOL(flex_array_put);
 
 /**
  * flex_array_clear - clear element in array at @element_nr
@@ -223,6 +228,7 @@ int flex_array_clear(struct flex_array *fa, unsigned int element_nr)
 	memset(dst, FLEX_ARRAY_FREE, fa->element_size);
 	return 0;
 }
+EXPORT_SYMBOL(flex_array_clear);
 
 /**
  * flex_array_prealloc - guarantee that array space exists
@@ -259,6 +265,7 @@ int flex_array_prealloc(struct flex_array *fa, unsigned int start,
 	}
 	return 0;
 }
+EXPORT_SYMBOL(flex_array_prealloc);
 
 /**
  * flex_array_get - pull data back out of the array
@@ -288,6 +295,7 @@ void *flex_array_get(struct flex_array *fa, unsigned int element_nr)
 	}
 	return &part->elements[index_inside_part(fa, element_nr)];
 }
+EXPORT_SYMBOL(flex_array_get);
 
 /**
  * flex_array_get_ptr - pull a ptr back out of the array
@@ -308,6 +316,7 @@ void *flex_array_get_ptr(struct flex_array *fa, unsigned int element_nr)
 
 	return *tmp;
 }
+EXPORT_SYMBOL(flex_array_get_ptr);
 
 static int part_is_free(struct flex_array_part *part)
 {
@@ -348,3 +357,4 @@ int flex_array_shrink(struct flex_array *fa)
 	}
 	return ret;
 }
+EXPORT_SYMBOL(flex_array_shrink);
