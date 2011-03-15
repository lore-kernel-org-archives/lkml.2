Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab1COGOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 02:14:30 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34543 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab1COGO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 02:14:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iKL9R0ZuihaROyKsLpiM1VO6IZ+o0oYNUQCSwT1fUN/mYHMhM5SHyPIs0rdHU2ES4v
         qoegztPHqvwxTKv9zsWm+dKniP439HQH/pamyNho9ZYLnZOhPBjIq6Bj8fn4Cv79BG/g
         kCBqmRpqZD+9Day3Id28CbaMeHzZDsKoNcoVk=
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, tony@atomide.com,
        nicolas.pitre@linaro.org, joe@perches.com,
        Po-Yu Chuang <ratbert@faraday-tech.com>
Subject: [PATCH v2] arm: cmpxchg syscall should data abort if page not write
Date: Tue, 15 Mar 2011 14:13:57 +0800
Message-Id: <1300169637-1628-1-git-send-email-ratbert.chuang@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1300098516-1601-1-git-send-email-ratbert.chuang@gmail.com>
References: <1300098516-1601-1-git-send-email-ratbert.chuang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Po-Yu Chuang <ratbert@faraday-tech.com>

If the page to cmpxchg is user mode read only (not write),
we should simulate a data abort first.

Signed-off-by: Po-Yu Chuang <ratbert@faraday-tech.com>
---
v2:
remove !pte_young() check

 arch/arm/kernel/traps.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 446aee9..eac7c05 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -563,7 +563,7 @@ asmlinkage int arm_syscall(int no, struct pt_regs *regs)
 		if (!pmd_present(*pmd))
 			goto bad_access;
 		pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
-		if (!pte_present(*pte) || !pte_dirty(*pte)) {
+		if (!pte_present(*pte) || !pte_write(*pte) || !pte_dirty(*pte)) {
 			pte_unmap_unlock(pte, ptl);
 			goto bad_access;
 		}
-- 
1.6.3.3

