Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab0G0IGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 04:06:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:43301 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881Ab0G0IGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 04:06:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,266,1278313200"; 
   d="scan'208";a="304745500"
Subject: [PATCH]x86: make spurious_fault check correct pte bit
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, "Huang, Ying" <ying.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 16:06:28 +0800
Message-ID: <1280217988.32400.75.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pte_present() returns true even present bit isn't set but _PAGE_PROTNONE
(global bit) bit is set. While with CONFIG_DEBUG_PAGEALLOC, free pages have
global bit set but present bit clear. This patch makes we could catch
free pages access with CONFIG_DEBUG_PAGEALLOC enabled.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index f627779..93afd78 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -893,7 +893,7 @@ spurious_fault(unsigned long error_code, unsigned long address)
 		return spurious_fault_check(error_code, (pte_t *) pmd);
 
 	pte = pte_offset_kernel(pmd, address);
-	if (!pte_present(*pte))
+	if (!(pte_flags(*pte) & _PAGE_PRESENT))
 		return 0;
 
 	ret = spurious_fault_check(error_code, pte);



