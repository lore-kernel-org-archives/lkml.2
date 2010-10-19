Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab0JSNzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:55:14 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:45458 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab0JSNzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:55:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qtuY7F4Sr/2LNed6rsnVxj8njWgY0Zcn2USQRpKUhLw0rFvVVPtg0UBbNahwf48flf
         TrQPUBOYixwlJhmInkKnN95d88JqS9cBY/9QI7OxobyZGRlM4UwT3n5nJVYpRKJhUJGb
         CCXSITruUA+Th47IjcFvOqp8gz+y+nfO/ZNzI=
Date: Tue, 19 Oct 2010 21:55:12 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] Add vzalloc shortcut
Message-ID: <20101019135512.GA31193@darkstar>
References: <20101016043331.GA3177@darkstar>
 <20101018164647.bc928c78.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101018164647.bc928c78.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 04:46:47PM -0700, Andrew Morton wrote:
> On Sat, 16 Oct 2010 12:33:31 +0800
> Dave Young <hidave.darkstar@gmail.com> wrote:
> 
> > Add vzalloc for convinience of vmalloc-then-memset-zero case 
> > 
> > Use __GFP_ZERO in vzalloc to zero fill the allocated memory.
> > 
> > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> > ---
> >  include/linux/vmalloc.h |    1 +
> >  mm/vmalloc.c            |   13 +++++++++++++
> >  2 files changed, 14 insertions(+)
> > 
> > --- linux-2.6.orig/include/linux/vmalloc.h	2010-08-22 15:31:38.000000000 +0800
> > +++ linux-2.6/include/linux/vmalloc.h	2010-10-16 10:50:54.739996121 +0800
> > @@ -53,6 +53,7 @@ static inline void vmalloc_init(void)
> >  #endif
> >  
> >  extern void *vmalloc(unsigned long size);
> > +extern void *vzalloc(unsigned long size);
> >  extern void *vmalloc_user(unsigned long size);
> >  extern void *vmalloc_node(unsigned long size, int node);
> >  extern void *vmalloc_exec(unsigned long size);
> > --- linux-2.6.orig/mm/vmalloc.c	2010-08-22 15:31:39.000000000 +0800
> > +++ linux-2.6/mm/vmalloc.c	2010-10-16 10:51:57.126665918 +0800
> > @@ -1604,6 +1604,19 @@ void *vmalloc(unsigned long size)
> >  EXPORT_SYMBOL(vmalloc);
> >  
> >  /**
> > + *	vzalloc  -  allocate virtually contiguous memory with zero filled
> 
> s/filled/fill/
> 
> > + *	@size:		allocation size
> > + *	Allocate enough pages to cover @size from the page level
> > + *	allocator and map them into contiguous kernel virtual space.
> > + */
> > +void *vzalloc(unsigned long size)
> > +{
> > +	return __vmalloc_node(size, 1, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
> > +				PAGE_KERNEL, -1, __builtin_return_address(0));
> > +}
> > +EXPORT_SYMBOL(vzalloc);
> 
> We'd need to add the same interface to nommu, please.
> 
> Also, a slightly better implementation would be
> 
> static inline void *__vmalloc_node_flags(unsigned long size, gfp_t flags)
> {
> 	return __vmalloc_node(size, 1, flags, PAGE_KERNEL, -1,
> 				__builtin_return_address(0));
> }
> 
> void *vzalloc(unsigned long size)
> {
> 	return __vmalloc_node_flags(size,
> 				GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO);
> }
> 
> void *vmalloc(unsigned long size)
> {
> 	return __vmalloc_node_flags(size, GFP_KERNEL | __GFP_HIGHMEM);
> }
> 
> just to avoid code duplication (and possible later errors derived from it).
> 
> Perhaps it should be always_inline, so the __builtin_return_address()
> can't get broken.
> 
> Or just leave it the way you had it :)
> 
> 

Hi, here is the updated version:
---

Add vzalloc and vzalloc_node for convinience of vmalloc-then-memset-zero case 

Use __GFP_ZERO in vzalloc to zero fill the allocated memory.

changes from first submit:
nommu part (Minchan kim and Andrew Morton) 
comment fixes / __vmalloc_node_flags helper for clean code (Andrew Morton)
add vzalloc_node for completeness

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/vmalloc.h |    2 +
 mm/nommu.c              |   49 +++++++++++++++++++++++++++++++++++++++++++++++-
 mm/vmalloc.c            |   46 +++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 94 insertions(+), 3 deletions(-)

--- linux-2.6.orig/include/linux/vmalloc.h	2010-10-19 20:44:20.383333459 +0800
+++ linux-2.6/include/linux/vmalloc.h	2010-10-19 20:45:07.366666782 +0800
@@ -53,8 +53,10 @@ static inline void vmalloc_init(void)
 #endif
 
 extern void *vmalloc(unsigned long size);
+extern void *vzalloc(unsigned long size);
 extern void *vmalloc_user(unsigned long size);
 extern void *vmalloc_node(unsigned long size, int node);
+extern void *vzalloc_node(unsigned long size, int node);
 extern void *vmalloc_exec(unsigned long size);
 extern void *vmalloc_32(unsigned long size);
 extern void *vmalloc_32_user(unsigned long size);
--- linux-2.6.orig/mm/vmalloc.c	2010-10-19 20:44:20.383333459 +0800
+++ linux-2.6/mm/vmalloc.c	2010-10-19 20:53:01.296666793 +0800
@@ -1587,6 +1587,13 @@ void *__vmalloc(unsigned long size, gfp_
 }
 EXPORT_SYMBOL(__vmalloc);
 
+static inline void *__vmalloc_node_flags(unsigned long size,
+					int node, gfp_t flags)
+{
+	return __vmalloc_node(size, 1, flags, PAGE_KERNEL,
+					node, __builtin_return_address(0));
+}
+
 /**
  *	vmalloc  -  allocate virtually contiguous memory
  *	@size:		allocation size
@@ -1598,12 +1605,28 @@ EXPORT_SYMBOL(__vmalloc);
  */
 void *vmalloc(unsigned long size)
 {
-	return __vmalloc_node(size, 1, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL,
-					-1, __builtin_return_address(0));
+	return __vmalloc_node_flags(size, -1, GFP_KERNEL | __GFP_HIGHMEM);
 }
 EXPORT_SYMBOL(vmalloc);
 
 /**
+ *	vzalloc - allocate virtually contiguous memory with zero fill
+ *	@size:	allocation size
+ *	Allocate enough pages to cover @size from the page level
+ *	allocator and map them into contiguous kernel virtual space.
+ *	The memory allocated is set to zero.
+ *
+ *	For tight control over page level allocator and protection flags
+ *	use __vmalloc() instead.
+ */
+void *vzalloc(unsigned long size)
+{
+	return __vmalloc_node_flags(size, -1,
+				GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO);
+}
+EXPORT_SYMBOL(vzalloc);
+
+/**
  * vmalloc_user - allocate zeroed virtually contiguous memory for userspace
  * @size: allocation size
  *
@@ -1644,6 +1667,25 @@ void *vmalloc_node(unsigned long size, i
 }
 EXPORT_SYMBOL(vmalloc_node);
 
+/**
+ * vzalloc_node - allocate memory on a specific node with zero fill
+ * @size:	allocation size
+ * @node:	numa node
+ *
+ * Allocate enough pages to cover @size from the page level
+ * allocator and map them into contiguous kernel virtual space.
+ * The memory allocated is set to zero.
+ *
+ * For tight control over page level allocator and protection flags
+ * use __vmalloc_node() instead.
+ */
+void *vzalloc_node(unsigned long size, int node)
+{
+	return __vmalloc_node_flags(size, node,
+			 GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO);
+}
+EXPORT_SYMBOL(vzalloc_node);
+
 #ifndef PAGE_KERNEL_EXEC
 # define PAGE_KERNEL_EXEC PAGE_KERNEL
 #endif
--- linux-2.6.orig/mm/nommu.c	2010-10-19 20:44:20.383333459 +0800
+++ linux-2.6/mm/nommu.c	2010-10-19 20:45:07.370000115 +0800
@@ -293,11 +293,58 @@ void *vmalloc(unsigned long size)
 }
 EXPORT_SYMBOL(vmalloc);
 
+/*
+ *	vzalloc - allocate virtually continguos memory with zero fill
+ *
+ *	@size:		allocation size
+ *
+ *	Allocate enough pages to cover @size from the page level
+ *	allocator and map them into continguos kernel virtual space.
+ *	The memory allocated is set to zero.
+ *
+ *	For tight control over page level allocator and protection flags
+ *	use __vmalloc() instead.
+ */
+void *vzalloc(unsigned long size)
+{
+	return __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
+			PAGE_KERNEL);
+}
+EXPORT_SYMBOL(vzalloc);
+
+/**
+ * vmalloc_node - allocate memory on a specific node
+ * @size:	allocation size
+ * @node:	numa node
+ *
+ * Allocate enough pages to cover @size from the page level
+ * allocator and map them into contiguous kernel virtual space.
+ *
+ * For tight control over page level allocator and protection flags
+ * use __vmalloc() instead.
+ */
 void *vmalloc_node(unsigned long size, int node)
 {
 	return vmalloc(size);
 }
-EXPORT_SYMBOL(vmalloc_node);
+
+/**
+ * vzalloc_node - allocate memory on a specific node with zero fill
+ * @size:	allocation size
+ * @node:	numa node
+ *
+ * Allocate enough pages to cover @size from the page level
+ * allocator and map them into contiguous kernel virtual space.
+ * The memory allocated is set to zero.
+ *
+ * For tight control over page level allocator and protection flags
+ * use __vmalloc() instead.
+ */
+void *vzalloc_node(unsigned long size, int node)
+{
+	return vzalloc(size);
+}
+EXPORT_SYMBOL(vzalloc_node);
 
 #ifndef PAGE_KERNEL_EXEC
 # define PAGE_KERNEL_EXEC PAGE_KERNEL
