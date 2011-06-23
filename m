Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab1FWGWF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 02:22:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37056 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab1FWGWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 02:22:04 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E02DB80.10303@jp.fujitsu.com>
Date: Thu, 23 Jun 2011 15:21:52 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: tglx@linutronix.de, dvhart@linux.intel.com, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl
CC: kosaki.motohiro@jp.fujitsu.com
Subject: [RFC PATCH] futex: replace get_user_pages() with get_user_pages_fast()
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Is there any reason to take mmap_sem explicitly here?
Should we change gup_fast() to allow NULL argument (ie for avoid get_page)?

============================
  down_read(&mm->mmap_sem);
  get_user_pages(current, current->mm)
  up_read(&mm->mmap_sem);

and

  get_user_pages_fast()

make an equivalent result, And latter would be better when mamp_sem
highly contended case, because it can avoid to take mmap_sem if
the target page doesn't need a page fault.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 kernel/futex.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index fe28dc2..9f7b1ae 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -351,13 +351,11 @@ static inline void put_futex_key(union futex_key *key)
  */
 static int fault_in_user_writeable(u32 __user *uaddr)
 {
-	struct mm_struct *mm = current->mm;
 	int ret;
+	struct page *page;

-	down_read(&mm->mmap_sem);
-	ret = get_user_pages(current, mm, (unsigned long)uaddr,
-			     1, 1, 0, NULL, NULL);
-	up_read(&mm->mmap_sem);
+	ret = get_user_pages_fast((unsigned long)uaddr, 1, 1, &page);
+	put_page(page);

 	return ret < 0 ? ret : 0;
 }
-- 
1.7.3.1


