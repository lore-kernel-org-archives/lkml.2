Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab0HXWXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:23:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932347Ab0HXWXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:23:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] NOMMU: Stub out vm_get_page_prot() if there's no MMU
To: vapier@gentoo.org
Cc: linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org,
        konrad.wilk@oracle.com, dgdegra@tycho.nsa.gov, hugh@veritas.com,
        airlied@linux.ie, davej@redhat.com,
        David Howells <dhowells@redhat.com>
Date: Tue, 24 Aug 2010 23:22:38 +0100
Message-ID: <20100824222238.6372.8897.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stub out vm_get_page_prot() if there's no MMU.

This was added by commit:

	commit 804af2cf6e7af31d2e664b54e657dddd9b531dbd
	Author: Hugh Dickins <hugh@veritas.com>
	Date:   Wed Jul 26 21:39:49 2006 +0100
	Subject: [AGPGART] remove private page protection map

and is used in commit:

	commit c07fbfd17e614a76b194f371c5331e21e6cffb54
	Author: Daniel De Graaf <dgdegra@tycho.nsa.gov>
	Date:   Tue Aug 10 18:02:45 2010 -0700
	Subject: fbmem: VM_IO set, but not propagated

in the fbmem video driver, but the function doesn't exist on NOMMU, resulting
in an undefined symbol at link time.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/mm.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 709f672..6b258c5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1357,7 +1357,15 @@ static inline unsigned long vma_pages(struct vm_area_struct *vma)
 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 }
 
+#ifdef CONFIG_MMU
 pgprot_t vm_get_page_prot(unsigned long vm_flags);
+#else
+static inline pgprot_t vm_get_page_prot(unsigned long vm_flags)
+{
+	return __pgprot(0);
+}
+#endif
+
 struct vm_area_struct *find_extend_vma(struct mm_struct *, unsigned long addr);
 int remap_pfn_range(struct vm_area_struct *, unsigned long addr,
 			unsigned long pfn, unsigned long size, pgprot_t);

