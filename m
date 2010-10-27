Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877Ab0J0IuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 04:50:22 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:62976 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab0J0IuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 04:50:19 -0400
X-IronPort-AV: E=Sophos;i="4.58,245,1286164800"; 
   d="scan'208";a="119873294"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Ian Campbell <ian.campbell@citrix.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH] x86: use pgd accessors when cloning a pgd range.
Date: Wed, 27 Oct 2010 09:50:13 +0100
Message-Id: <1288169413-29065-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 27 Oct 2010 08:50:18.0480 (UTC) FILETIME=[FB3BFF00:01CB75B3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Page tables should always be updated using the proper accessor
methods. Not doing so bypasses the paravirt infrastructure.

In this case the failure to do so was exposed under Xen by
b40827fa7268 "x86-32, mm: Add an initial page table for core
bootstrapping".

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/x86/include/asm/pgtable.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index ada823a..0b4c514 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -619,7 +619,10 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm,
  */
 static inline void clone_pgd_range(pgd_t *dst, pgd_t *src, int count)
 {
-       memcpy(dst, src, count * sizeof(pgd_t));
+	int i;
+
+	for (i=0; i<count; i++)
+		set_pgd(&dst[i], src[i]);
 }
 
 
-- 
1.5.6.5

