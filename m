Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab1CVLIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 07:08:44 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50031 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab1CVLIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 07:08:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 4/5] mm: introduce wait_on_page_locked_killable
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110322194721.B05E.A69D9226@jp.fujitsu.com>
References: <20110315153801.3526.A69D9226@jp.fujitsu.com> <20110322194721.B05E.A69D9226@jp.fujitsu.com>
Message-Id: <20110322200904.B06A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 22 Mar 2011 20:08:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 2687a356 (Add lock_page_killable) introduced killable
lock_page(). Similarly this patch introdues killable
wait_on_page_locked().

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/pagemap.h |    9 +++++++++
 mm/filemap.c            |   11 +++++++++++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index e407601..49f9315 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -369,6 +369,15 @@ static inline int lock_page_or_retry(struct page *page, struct mm_struct *mm,
  */
 extern void wait_on_page_bit(struct page *page, int bit_nr);
 
+extern int wait_on_page_bit_killable(struct page *page, int bit_nr);
+
+static inline int wait_on_page_locked_killable(struct page *page)
+{
+	if (PageLocked(page))
+		return wait_on_page_bit_killable(page, PG_locked);
+	return 0;
+}
+
 /* 
  * Wait for a page to be unlocked.
  *
diff --git a/mm/filemap.c b/mm/filemap.c
index a6cfecf..f5f9ac2 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -608,6 +608,17 @@ void wait_on_page_bit(struct page *page, int bit_nr)
 }
 EXPORT_SYMBOL(wait_on_page_bit);
 
+int wait_on_page_bit_killable(struct page *page, int bit_nr)
+{
+	DEFINE_WAIT_BIT(wait, &page->flags, bit_nr);
+
+	if (!test_bit(bit_nr, &page->flags))
+		return 0;
+
+	return __wait_on_bit(page_waitqueue(page), &wait, sync_page_killable,
+							TASK_KILLABLE);
+}
+
 /**
  * add_page_wait_queue - Add an arbitrary waiter to a page's wait queue
  * @page: Page defining the wait queue of interest
-- 
1.6.5.2



