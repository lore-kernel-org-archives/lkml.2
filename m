Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391Ab0JPEdW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 00:33:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57080 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab0JPEdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 00:33:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=VoutuSpi+jAhcbR0+halCQQt4bQSUZuVLyJuaIWuqzRVBb0dJ0P0GEE27G12C+lr5Y
         JsjaPAnYbzTVDlWtjqRlkyLlCR3keI8NhT/CkRXsccqM0sylo/2TFjb+HAwOYWjis+el
         QhyBGtSeolKLmrKBTADN4k8+9G6nnslWjwt+E=
Date: Sat, 16 Oct 2010 12:33:31 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, kvm@vger.kernel.org
Subject: [PATCH 1/2] Add vzalloc shortcut
Message-ID: <20101016043331.GA3177@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add vzalloc for convinience of vmalloc-then-memset-zero case 

Use __GFP_ZERO in vzalloc to zero fill the allocated memory.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/vmalloc.h |    1 +
 mm/vmalloc.c            |   13 +++++++++++++
 2 files changed, 14 insertions(+)

--- linux-2.6.orig/include/linux/vmalloc.h	2010-08-22 15:31:38.000000000 +0800
+++ linux-2.6/include/linux/vmalloc.h	2010-10-16 10:50:54.739996121 +0800
@@ -53,6 +53,7 @@ static inline void vmalloc_init(void)
 #endif
 
 extern void *vmalloc(unsigned long size);
+extern void *vzalloc(unsigned long size);
 extern void *vmalloc_user(unsigned long size);
 extern void *vmalloc_node(unsigned long size, int node);
 extern void *vmalloc_exec(unsigned long size);
--- linux-2.6.orig/mm/vmalloc.c	2010-08-22 15:31:39.000000000 +0800
+++ linux-2.6/mm/vmalloc.c	2010-10-16 10:51:57.126665918 +0800
@@ -1604,6 +1604,19 @@ void *vmalloc(unsigned long size)
 EXPORT_SYMBOL(vmalloc);
 
 /**
+ *	vzalloc  -  allocate virtually contiguous memory with zero filled
+ *	@size:		allocation size
+ *	Allocate enough pages to cover @size from the page level
+ *	allocator and map them into contiguous kernel virtual space.
+ */
+void *vzalloc(unsigned long size)
+{
+	return __vmalloc_node(size, 1, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
+				PAGE_KERNEL, -1, __builtin_return_address(0));
+}
+EXPORT_SYMBOL(vzalloc);
+
+/**
  * vmalloc_user - allocate zeroed virtually contiguous memory for userspace
  * @size: allocation size
  *
