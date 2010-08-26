Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab0HZXNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 19:13:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:47475 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791Ab0HZXN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 19:13:28 -0400
Date: Thu, 26 Aug 2010 23:13:11 GMT
From: tip-bot for Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        shaohua.li@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, shaohua.li@intel.com, hpa@linux.intel.com
In-Reply-To: <1280217988.32400.75.camel@sli10-desk.sh.intel.com>
References: <1280217988.32400.75.camel@sli10-desk.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Make spurious_fault check explicitly check the PRESENT bit
Message-ID: <tip-660a293ea9be709b893d371fbc0328fcca33c33a@git.kernel.org>
Git-Commit-ID: 660a293ea9be709b893d371fbc0328fcca33c33a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 26 Aug 2010 23:13:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  660a293ea9be709b893d371fbc0328fcca33c33a
Gitweb:     http://git.kernel.org/tip/660a293ea9be709b893d371fbc0328fcca33c33a
Author:     Shaohua Li <shaohua.li@intel.com>
AuthorDate: Tue, 27 Jul 2010 16:06:28 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 26 Aug 2010 16:00:21 -0700

x86, mm: Make spurious_fault check explicitly check the PRESENT bit

pte_present() returns true even present bit isn't set but _PAGE_PROTNONE
(global bit) bit is set. While with CONFIG_DEBUG_PAGEALLOC, free pages have
global bit set but present bit clear. This patch makes we could catch
free pages access with CONFIG_DEBUG_PAGEALLOC enabled.

[ hpa: added a comment in the code as a warning to janitors ]

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
LKML-Reference: <1280217988.32400.75.camel@sli10-desk.sh.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/fault.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 51f7ee7..caec229 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -872,8 +872,14 @@ spurious_fault(unsigned long error_code, unsigned long address)
 	if (pmd_large(*pmd))
 		return spurious_fault_check(error_code, (pte_t *) pmd);
 
+	/*
+	 * Note: don't use pte_present() here, since it returns true
+	 * if the _PAGE_PROTNONE bit is set.  However, this aliases the
+	 * _PAGE_GLOBAL bit, which for kernel pages give false positives
+	 * when CONFIG_DEBUG_PAGEALLOC is used.
+	 */
 	pte = pte_offset_kernel(pmd, address);
-	if (!pte_present(*pte))
+	if (!(pte_flags(*pte) & _PAGE_PRESENT))
 		return 0;
 
 	ret = spurious_fault_check(error_code, pte);
