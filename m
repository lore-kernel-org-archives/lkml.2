Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab1DVVZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 17:25:58 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:48111 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab1DVVZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 17:25:57 -0400
Date: Fri, 22 Apr 2011 23:25:45 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: konrad.wilk@oracle.com, stefano.stabellini@eu.citrix.com,
        xen-devel@lists.xensource.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH REPOST] pv-grub: Fix for incorrect dom->p2m_host[] list initialization
Message-ID: <20110422212545.GA22846@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added missed Signed-off-by line.

After a lot of debugging and long reading of Linux Kernel and Xen code
finally I killed deeply hidden bug in pv-grub. Details below.
Additionally, I am CC'ing this e-mail to LKML because this issue
looks like Linux Kernel problem, however, it is not.

This patch applies to Xen Ver. 4.0, Xen Ver. 4.1 and unstable tree.

# HG changeset patch
# User dkiper@net-space.pl
# Date 1303474763 -7200
# Node ID b33bf24be129b7b9cd2248460beb1298088c6af5
# Parent  dbf2ddf652dc3dd927447e79ef4bc586de55d708
Introduction of Linux Kernel git commit ceefccc93932b920a8ec6f35f596db05202a12fe
(x86: default CONFIG_PHYSICAL_START and CONFIG_PHYSICAL_ALIGN to 16 MB) revealed
deeply hidden bug in pv-grub. During kernel load stage dom->p2m_host[] list has
been incorrectly initialized.

At the beginning of kernel load stage dom->p2m_host[] list is populated with
current pfn->mfn layout. Later during memory allocation (memory is allocated
page by page in kexec_allocate()) page order is changed to establish linear
layout in new domain. It is done by exchanging subsequent mfns with newly
allocated mfns. dom->p2m_host[] list is indexed by currently requested pfn
(it is incremented from 0) and pfn of newly allocated paged. If pfn of newly
allocated page is less than currently requested pfn then relevant earlier
allocated mfn is overwritten which leads to domain crash later. This patch
fix that issue. If pfn of newly allocated page is less then currently
requested pfn then relevant pfn/mfn pair is properly calculated and usual
exchange occurs later.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>

diff -r dbf2ddf652dc -r b33bf24be129 stubdom/grub/kexec.c
--- a/stubdom/grub/kexec.c	Thu Apr 07 15:26:58 2011 +0100
+++ b/stubdom/grub/kexec.c	Fri Apr 22 14:19:23 2011 +0200
@@ -91,6 +91,11 @@ int kexec_allocate(struct xc_dom_image *
         new_pfn = PHYS_PFN(to_phys(pages[i]));
         pages_mfns[i] = new_mfn = pfn_to_mfn(new_pfn);
 
+	if (new_pfn < i)
+		for (new_pfn = i; new_pfn < dom->total_pages; ++new_pfn)
+			if (dom->p2m_host[new_pfn] == new_mfn)
+				break;
+
         /* Put old page at new PFN */
         dom->p2m_host[new_pfn] = old_mfn;
 
Daniel
