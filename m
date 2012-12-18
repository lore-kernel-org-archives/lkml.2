Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab2LRID1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 03:03:27 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:38135 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab2LRIDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 03:03:25 -0500
Date: Tue, 18 Dec 2012 00:03:23 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Hillf Danton <dhillf@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [patch] x86, paravirt: fix build error when thp is disabled
In-Reply-To: <CA+55aFzedbhcuo-WObUjigrXGuG2VGLqDOvh_HFA9Cn_BRkwjQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1212180000010.29320@chino.kir.corp.google.com>
References: <20121212100338.GS1009@suse.de> <CA+55aFzedbhcuo-WObUjigrXGuG2VGLqDOvh_HFA9Cn_BRkwjQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_PARAVIRT=y and CONFIG_TRANSPARENT_HUGEPAGE=n, the build breaks 
because set_pmd_at() is undeclared:

mm/memory.c: In function 'do_pmd_numa_page':
mm/memory.c:3520: error: implicit declaration of function 'set_pmd_at'
mm/mprotect.c: In function 'change_pmd_protnuma':
mm/mprotect.c:120: error: implicit declaration of function 'set_pmd_at'

This is because paravirt defines set_pmd_at() only when 
CONFIG_TRANSPARENT_HUGEPAGE=y and such a restriction is unneeded.  The fix 
is to define it for all CONFIG_PARAVIRT configurations.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/include/asm/paravirt.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -528,7 +528,6 @@ static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
 		PVOP_VCALL4(pv_mmu_ops.set_pte_at, mm, addr, ptep, pte.pte);
 }
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 			      pmd_t *pmdp, pmd_t pmd)
 {
@@ -539,7 +538,6 @@ static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 		PVOP_VCALL4(pv_mmu_ops.set_pmd_at, mm, addr, pmdp,
 			    native_pmd_val(pmd));
 }
-#endif
 
 static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
 {
