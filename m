Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab1DZTAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 15:00:00 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:54948 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab1DZS77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 14:59:59 -0400
Date: Tue, 26 Apr 2011 20:56:49 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: konrad.wilk@oracle.com, stefano.stabellini@eu.citrix.com,
        xen-devel@lists.xensource.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH V2] pv-grub: Fix for incorrect dom->p2m_host[] list initialization
Message-ID: <20110426185649.GA29940@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New time optimized version.

After a lot of debugging and long reading of Linux Kernel and Xen code
finally I killed deeply hidden bug in pv-grub. Details below.
Additionally, I am CC'ing this e-mail to LKML because this issue
looks like Linux Kernel problem, however, it is not.

This patch applies to Xen Ver. 4.0, Xen Ver. 4.1 and Xen unstable tree.

# HG changeset patch
# User dkiper@net-space.pl
# Date 1303843062 -7200
# Node ID c4c2919afe9727e107ad3b862619b40d4731d3e4
# Parent  dbf2ddf652dc3dd927447e79ef4bc586de55d708
Introduction of Linux Kernel git commit ceefccc93932b920a8ec6f35f596db05202a12fe
(x86: default CONFIG_PHYSICAL_START and CONFIG_PHYSICAL_ALIGN to 16 MB) revealed
deeply hidden bug in pv-grub. During kernel load stage dom->p2m_host[] list has
been incorrectly initialized.

At the beginning of kernel load stage dom->p2m_host[] list is populated with
current PFN->MFN layout. Later during memory allocation (memory is allocated
page by page in kexec_allocate()) page order is changed to establish linear
layout in new domain. It is done by exchanging subsequent MFNs with newly
allocated MFNs. dom->p2m_host[] list is indexed by currently requested PFN
(it is incremented from 0) and PFN of newly allocated paged. If PFN of newly
allocated page is less than currently requested PFN then earlier allocated
MFN is overwritten which leads to domain crash later. This patch corrects
that issue. If PFN of newly allocated page is less then currently requested
PFN then relevant PFN/MFN pair is properly calculated and usual exchange
occurs later.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>

diff -r dbf2ddf652dc -r c4c2919afe97 stubdom/grub/kexec.c
--- a/stubdom/grub/kexec.c	Thu Apr 07 15:26:58 2011 +0100
+++ b/stubdom/grub/kexec.c	Tue Apr 26 20:37:42 2011 +0200
@@ -48,6 +48,7 @@ extern void _boot(void);
 
 static unsigned long *pages;
 static unsigned long *pages_mfns;
+static xen_pfn_t *pages_moved2pfns;
 static unsigned long allocated;
 
 int pin_table(xc_interface *xc_handle, unsigned int type, unsigned long mfn,
@@ -80,6 +81,7 @@ int kexec_allocate(struct xc_dom_image *
 
     pages = realloc(pages, new_allocated * sizeof(*pages));
     pages_mfns = realloc(pages_mfns, new_allocated * sizeof(*pages_mfns));
+    pages_moved2pfns = realloc(pages_moved2pfns, new_allocated * sizeof(*pages_moved2pfns));
     for (i = allocated; i < new_allocated; i++) {
         /* Exchange old page of PFN i with a newly allocated page.  */
         xen_pfn_t old_mfn = dom->p2m_host[i];
@@ -90,6 +92,18 @@ int kexec_allocate(struct xc_dom_image *
         memset((void*) pages[i], 0, PAGE_SIZE);
         new_pfn = PHYS_PFN(to_phys(pages[i]));
         pages_mfns[i] = new_mfn = pfn_to_mfn(new_pfn);
+
+	/*
+	 * If PFN of newly allocated page (new_pfn) is less then currently
+	 * requested PFN (i) then look for relevant PFN/MFN pair. In this
+	 * situation dom->p2m_host[new_pfn] no longer contains proper MFN
+	 * because original page with new_pfn was moved earlier
+	 * to different location.
+	 */
+	for (; new_pfn < i; new_pfn = pages_moved2pfns[new_pfn]);
+
+	/* Store destination PFN of currently requested page. */
+	pages_moved2pfns[i] = new_pfn;
 
         /* Put old page at new PFN */
         dom->p2m_host[new_pfn] = old_mfn;

Daniel
