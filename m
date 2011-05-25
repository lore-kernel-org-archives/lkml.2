Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab1EYHI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 03:08:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51285 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab1EYHI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 03:08:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDCAB01.8080700@jp.fujitsu.com>
Date: Wed, 25 May 2011 16:08:49 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: kosaki.motohiro@jp.fujitsu.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, aarcange@redhat.com,
        akpm@linux-foundation.org, n-horiguchi@ah.jp.nec.com,
        kamezawa.hiroyu@jp.fujitsu.com
Subject: [PATCH 1/4] pagewalk: Fix walk_page_range() don't check find_vma()
 result properly
References: <4DDCAAC0.20102@jp.fujitsu.com>
In-Reply-To: <4DDCAAC0.20102@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The doc of find_vma() says,

    /* Look up the first VMA which satisfies  addr < vm_end,  NULL if none. */
    struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
    {
     (snip)

Thus, caller should confirm whether the returned vma matches a desired one.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/pagewalk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index c3450d5..606bbb4 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -176,7 +176,7 @@ int walk_page_range(unsigned long addr, unsigned long end,
 		 * we can't handled it in the same manner as non-huge pages.
 		 */
 		vma = find_vma(walk->mm, addr);
-		if (vma && is_vm_hugetlb_page(vma)) {
+		if (vma && vma->vm_start <= addr && is_vm_hugetlb_page(vma)) {
 			if (vma->vm_end < next)
 				next = vma->vm_end;
 			/*
-- 
1.7.3.1



