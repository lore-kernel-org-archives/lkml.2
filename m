Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab0JXIol (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 04:44:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63592 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206Ab0JXIoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 04:44:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=TvDtdyUtVh6zyowZkb5fi6gzFf2eT06WArI/OG5mrWRw2y32Y6nuN64ff/MyMZfMTd
         G6urmDQZyiVgy8rSBmKKSUSkY5R+Ox5XhMJEptFd75HUxKxxP9W8Ow10daNPNNxtaErd
         mkr7pJhJtawddxJq7SH41Z9JR4pCSAomhm/xU=
Message-ID: <4CC3F13B.4030107@gmail.com>
Date: Sun, 24 Oct 2010 10:41:31 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: x86@kernel.org, Tim Bird <tim.bird@am.sony.com>, andi@firstfloor.org
Subject: [PATCH] archs: add ioremap_change_write_prot
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

This patch adds a new function called ioremap_change_write_prot.
Goal of this patch is to create a general function for all archs to be
able to change a write protection of a memory mapped area. x86
has already got a similar framework, so this function is only
a wrapper. Next target will be arm and powerpc. This function
will be used by Pramfs (see its latest review).

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---

diff -Nurp linux-2.6.36-orig/arch/x86/mm/ioremap.c linux-2.6.36/arch/x86/mm/ioremap.c
--- linux-2.6.36-orig/arch/x86/mm/ioremap.c	2010-09-13 01:07:37.000000000 +0200
+++ linux-2.6.36/arch/x86/mm/ioremap.c	2010-10-24 10:03:36.000000000 +0200
@@ -50,6 +50,27 @@ int ioremap_change_attr(unsigned long va
 	return err;
 }
 
+int ioremap_change_write_prot(unsigned long vaddr, unsigned long size,
+			       unsigned int rw)
+{
+	unsigned long nrpages = size >> PAGE_SHIFT;
+	int ret;
+
+	/* Page aligned */
+	vaddr &= PAGE_MASK;
+
+	if (size & (PAGE_SIZE - 1))
+		nrpages++;
+
+	if (rw)
+		ret = set_memory_rw(vaddr, nrpages);
+	else
+		ret = set_memory_ro(vaddr, nrpages);
+
+	return ret;
+}
+EXPORT_SYMBOL(ioremap_change_write_prot);
+
 /*
  * Remap an arbitrary physical address space into the kernel virtual
  * address space. Needed when the kernel wants to access high addresses
--- linux-2.6.36-orig/arch/Kconfig	2010-09-13 01:07:37.000000000 +0200
+++ linux-2.6.36/arch/Kconfig	2010-10-23 09:29:56.000000000 +0200
@@ -83,6 +83,9 @@ config USER_RETURN_NOTIFIER
 config HAVE_IOREMAP_PROT
 	bool
 
+config HAVE_IOREMAP_CHANGE_WRITE_PROT
+	bool
+
 config HAVE_KPROBES
 	bool
 
--- linux-2.6.36-orig/arch/x86/Kconfig	2010-09-13 01:07:37.000000000 +0200
+++ linux-2.6.36/arch/x86/Kconfig	2010-10-23 09:09:06.000000000 +0200
@@ -26,6 +26,7 @@ config X86
 	select HAVE_OPROFILE
 	select HAVE_PERF_EVENTS if (!M386 && !M486)
 	select HAVE_IOREMAP_PROT
+	select HAVE_IOREMAP_CHANGE_WRITE_PROT
 	select HAVE_KPROBES
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_WANT_FRAME_POINTERS
diff -Nurp linux-2.6.36-orig/arch/x86/include/asm/io.h linux-2.6.36/arch/x86/include/asm/io.h
--- linux-2.6.36-orig/arch/x86/include/asm/io.h	2010-09-13 01:07:37.000000000 +0200
+++ linux-2.6.36/arch/x86/include/asm/io.h	2010-10-23 09:11:37.000000000 +0200
@@ -333,6 +333,8 @@ extern void unxlate_dev_mem_ptr(unsigned
 
 extern int ioremap_change_attr(unsigned long vaddr, unsigned long size,
 				unsigned long prot_val);
+extern int ioremap_change_write_prot(unsigned long vaddr, unsigned long size,
+				unsigned int rw);
 extern void __iomem *ioremap_wc(resource_size_t offset, unsigned long size);
 
 /*

