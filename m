Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab1IWBKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 21:10:44 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:65294 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab1IWBKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 21:10:42 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-209.messagelabs.com!1316740237!17001267!9
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.3.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm/huge_memory.c: quiet sparse noise
Date: Thu, 22 Sep 2011 18:10:05 -0700
User-Agent: KMail/1.9.9
CC: <linux-mm@kvack.org>, <akpm@linux-foundation.org>, <aarcange@redhat.com>,
        <riel@redhat.com>, <jweiner@redhat.com>,
        <kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201109221810.05542.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quiet the sparse noise:

warning: symbol 'khugepaged_scan' was not declared. Should it be static?
warning: context imbalance in 'khugepaged_scan_mm_slot' - unexpected unlock

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6b072bd..44f5763 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -89,7 +89,8 @@ struct khugepaged_scan {
 	struct list_head mm_head;
 	struct mm_slot *mm_slot;
 	unsigned long address;
-} khugepaged_scan = {
+};
+static struct khugepaged_scan khugepaged_scan = {
 	.mm_head = LIST_HEAD_INIT(khugepaged_scan.mm_head),
 };
 
@@ -2069,6 +2070,8 @@ static void collect_mm_slot(struct mm_slot *mm_slot)
 
 static unsigned int khugepaged_scan_mm_slot(unsigned int pages,
 					    struct page **hpage)
+	__releases(&khugepaged_mm_lock)
+	__acquires(&khugepaged_mm_lock)
 {
 	struct mm_slot *mm_slot;
 	struct mm_struct *mm;
