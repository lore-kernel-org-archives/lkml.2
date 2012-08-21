Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab2HUJrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:47:15 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:41367 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab2HUJrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:47:13 -0400
Message-ID: <503358FF.3030009@linux.vnet.ibm.com>
Date: Tue, 21 Aug 2012 17:46:39 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: [PATCH] mm: mmu_notifier: fix inconsistent memory between secondary
 MMU and host
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12082109-4790-0000-0000-00000439BABC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There has a bug in set_pte_at_notify which always set the pte to the
new page before release the old page in secondary MMU, at this time,
the process will access on the new page, but the secondary MMU still
access on the old page, the memory is inconsistent between them

Below scenario shows the bug more clearly:

at the beginning: *p = 0, and p is write-protected by KSM or shared with
parent process

CPU 0                                       CPU 1
write 1 to p to trigger COW,
set_pte_at_notify will be called:
  *pte = new_page + W; /* The W bit of pte is set */

                                     *p = 1; /* pte is valid, so no #PF */

                                     return back to secondary MMU, then
                                     the secondary MMU read p, but get:
                                     *p == 0;

                         /*
                          * !!!!!!
                          * the host has already set p to 1, but the secondary
                          * MMU still get the old value 0
                          */

  call mmu_notifier_change_pte to release
  old page in secondary MMU

We can fix it by release old page first, then set the pte to the new
page.

Note, the new page will be firstly used in secondary MMU before it is
mapped into the page table of the process, but this is safe because it
is protected by the page table lock, there is no race to change the pte

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 include/linux/mmu_notifier.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 1d1b1e1..8c7435a 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -317,8 +317,8 @@ static inline void mmu_notifier_mm_destroy(struct mm_struct *mm)
 	unsigned long ___address = __address;				\
 	pte_t ___pte = __pte;						\
 									\
-	set_pte_at(___mm, ___address, __ptep, ___pte);			\
 	mmu_notifier_change_pte(___mm, ___address, ___pte);		\
+	set_pte_at(___mm, ___address, __ptep, ___pte);			\
 })

 #else /* CONFIG_MMU_NOTIFIER */
-- 
1.7.7.6

