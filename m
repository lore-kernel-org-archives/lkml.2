Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934302Ab1KJEEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:04:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965726Ab1KJDpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:45:55 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:00 2011
Message-Id: <20111109213200.846920066@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:33:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <jweiner@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        David Miller <davem@davemloft.net>
Subject: [185/264] sparc: gup_pte_range() support THP based tail recounting
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Arcangeli <aarcange@redhat.com>

commit e0d85a366c2300efd230ef82a9b22110b0658331 upstream.

Up to this point the code assumed old refcounting for hugepages (pre-thp).
 This updates the code directly to the thp mapcount tail page refcounting.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/mm/gup.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/arch/sparc/mm/gup.c
+++ b/arch/sparc/mm/gup.c
@@ -12,6 +12,17 @@
 #include <linux/rwsem.h>
 #include <asm/pgtable.h>
 
+static inline void get_huge_page_tail(struct page *page)
+{
+	/*
+	 * __split_huge_page_refcount() cannot run
+	 * from under us.
+	 */
+	VM_BUG_ON(page_mapcount(page) < 0);
+	VM_BUG_ON(atomic_read(&page->_count) != 0);
+	atomic_inc(&page->_mapcount);
+}
+
 /*
  * The performance critical leaf functions are made noinline otherwise gcc
  * inlines everything into a single function which results in too much
@@ -56,6 +67,8 @@ static noinline int gup_pte_range(pmd_t
 			put_page(head);
 			return 0;
 		}
+		if (head != page)
+			get_huge_page_tail(page);
 
 		pages[*nr] = page;
 		(*nr)++;


