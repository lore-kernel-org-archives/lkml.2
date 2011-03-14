Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab1CNK2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 06:28:52 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36326 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab1CNK2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 06:28:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YvhwHT6PqiDayhibFyAr+yIa0Ey5ynSgJ7pJxzx1N/JUw1+GEXR8c0NZ5iUxNyPla1
         tHn7ko5ILtFdWsJ59yHxqrPjaY19OUBsfznlphU7Na1PPbnhgcnj1yavXU1xqytGBVF7
         Wj2FpCHTRMLk9frlILZXWLA8AmJvadJboq1kw=
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, tony@atomide.com,
        nicolas.pitre@linaro.org, joe@perches.com,
        Po-Yu Chuang <ratbert@faraday-tech.com>
Subject: [PATCH] arm: cmpxchg syscall should data abort if page not write or not young
Date: Mon, 14 Mar 2011 18:28:36 +0800
Message-Id: <1300098516-1601-1-git-send-email-ratbert.chuang@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Po-Yu Chuang <ratbert@faraday-tech.com>

If the page to cmpxchg is user mode read only (not write)
or invalid (not young), we should simulate a data abort first.

Signed-off-by: Po-Yu Chuang <ratbert@faraday-tech.com>
---
 arch/arm/kernel/traps.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 446aee9..53c8852 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -563,7 +563,8 @@ asmlinkage int arm_syscall(int no, struct pt_regs *regs)
 		if (!pmd_present(*pmd))
 			goto bad_access;
 		pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
-		if (!pte_present(*pte) || !pte_dirty(*pte)) {
+		if (!pte_present(*pte) || !pte_write(*pte) ||
+		    !pte_dirty(*pte) || !pte_young(*pte)) {
 			pte_unmap_unlock(pte, ptl);
 			goto bad_access;
 		}
-- 
1.6.3.3

