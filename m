Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab2FFQTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:19:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40739 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab2FFQTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:19:07 -0400
Date: Wed, 6 Jun 2012 09:18:48 -0700
From: tip-bot for Shai Fultheim <shai@scalemp.com>
Message-ID: <tip-d2956406fb61e15ad2b47eda823288db4996acf1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        shai@scalemp.com, akpm@linux-foundation.org, tglx@linutronix.de,
        ido@wizery.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        shai@scalemp.com, akpm@linux-foundation.org, tglx@linutronix.de,
        ido@wizery.com
In-Reply-To: <1334873492-31255-1-git-send-email-ido@wizery.com>
References: <1334873492-31255-1-git-send-email-ido@wizery.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/pat: Avoid contention on cpa_lock if possible
Git-Commit-ID: d2956406fb61e15ad2b47eda823288db4996acf1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 09:18:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d2956406fb61e15ad2b47eda823288db4996acf1
Gitweb:     http://git.kernel.org/tip/d2956406fb61e15ad2b47eda823288db4996acf1
Author:     Shai Fultheim <shai@scalemp.com>
AuthorDate: Fri, 20 Apr 2012 01:11:32 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 17:42:59 +0200

x86/pat: Avoid contention on cpa_lock if possible

Some architectures (e.g. vSMP) do not require to serialize cpa,
for instance, by guaranteeing that the most recent TLB entry
will always be used.

To avoid needless contention on cpa_lock, do not lock/unlock it
on such architectures.

Signed-off-by: Shai Fultheim <shai@scalemp.com>
[ Added should_serialize_cpa, handled potential race, and reworded the commit message ]
Signed-off-by: Ido Yariv <ido@wizery.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1334873492-31255-1-git-send-email-ido@wizery.com
[ I absolutely hate these locking patterns ... yet I have no better idea. Maybe the gents on Cc: ... ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/pageattr.c |   36 ++++++++++++++++++++++++++++--------
 1 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index e1ebde3..4d606ee 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -501,7 +501,7 @@ out_unlock:
 	return do_split;
 }
 
-static int split_large_page(pte_t *kpte, unsigned long address)
+static int split_large_page(pte_t *kpte, unsigned long address, bool cpa_locked)
 {
 	unsigned long pfn, pfninc = 1;
 	unsigned int i, level;
@@ -509,10 +509,10 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	pgprot_t ref_prot;
 	struct page *base;
 
-	if (!debug_pagealloc)
+	if (cpa_locked)
 		spin_unlock(&cpa_lock);
 	base = alloc_pages(GFP_KERNEL | __GFP_NOTRACK, 0);
-	if (!debug_pagealloc)
+	if (cpa_locked)
 		spin_lock(&cpa_lock);
 	if (!base)
 		return -ENOMEM;
@@ -624,7 +624,8 @@ static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
 	}
 }
 
-static int __change_page_attr(struct cpa_data *cpa, int primary)
+static int __change_page_attr(struct cpa_data *cpa, int primary,
+			      bool cpa_locked)
 {
 	unsigned long address;
 	int do_split, err;
@@ -693,7 +694,7 @@ repeat:
 	/*
 	 * We have to split the large page:
 	 */
-	err = split_large_page(kpte, address);
+	err = split_large_page(kpte, address, cpa_locked);
 	if (!err) {
 		/*
 	 	 * Do a global flush tlb after splitting the large page
@@ -787,9 +788,20 @@ static int cpa_process_alias(struct cpa_data *cpa)
 	return 0;
 }
 
+static inline bool should_serialize_cpa(void)
+{
+	/*
+	 * Some architectures do not require cpa() to be serialized, for
+	 * instance, by guaranteeing that the most recent TLB entry will be
+	 * used.
+	 */
+	return !debug_pagealloc && !is_vsmp_box();
+}
+
 static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
 {
 	int ret, numpages = cpa->numpages;
+	bool cpa_locked = false;
 
 	while (numpages) {
 		/*
@@ -801,10 +813,18 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
 		if (cpa->flags & (CPA_ARRAY | CPA_PAGES_ARRAY))
 			cpa->numpages = 1;
 
-		if (!debug_pagealloc)
+		if (should_serialize_cpa()) {
 			spin_lock(&cpa_lock);
-		ret = __change_page_attr(cpa, checkalias);
-		if (!debug_pagealloc)
+			/*
+			 * In order to avoid any race conditions in which
+			 * should_serialize_cpa() returns a different value
+			 * after the lock was acquired, make sure locking is
+			 * consitent and don't ever leave the lock acquired.
+			 */
+			cpa_locked = true;
+		}
+		ret = __change_page_attr(cpa, checkalias, cpa_locked);
+		if (cpa_locked)
 			spin_unlock(&cpa_lock);
 		if (ret)
 			return ret;
