Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab0LUViN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 16:38:13 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:25147 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab0LUViH (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 21 Dec 2010 16:38:07 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, jeremy@goop.org, hpa@zytor.com
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 04/10] xen/mmu: For 1-1 mapping, automatically set _PAGE_IOMAP.
Date: Tue, 21 Dec 2010 16:37:34 -0500
Message-Id: <1292967460-15709-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This means that for PFNs (specifically: those in any E820 gaps
or non-RAM E820 regions) that have 1-1 mapping we set the
_PAGE_IOMAP flag.

Later on we could remove the _PAGE_IOMAP code handling, but
for right now lets keep this in to not introduce any bisection
failures across this patchset.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 4ba7e4e..bd02e7d 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -832,6 +832,9 @@ static pteval_t pte_pfn_to_mfn(pteval_t val)
 		pteval_t flags = val & PTE_FLAGS_MASK;
 		unsigned long mfn = pfn_to_mfn(pfn);
 
+		if (mfn == pfn)
+			flags |= _PAGE_IOMAP;
+
 		/*
 		 * If there's no mfn for the pfn, then just create an
 		 * empty non-present pte.  Unfortunately this loses
-- 
1.7.1

