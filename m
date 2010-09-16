Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab0IPGej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 02:34:39 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51595 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab0IPGei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 02:34:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH] smaps: fix dirty pages accounting
Cc: kosaki.motohiro@jp.fujitsu.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Matt Mackall <mpm@selenic.com>, Richard Guenther <rguenther@suse.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Matz <matz@novell.com>, linux-kernel@vger.kernel.org
In-Reply-To: <201009161135.00129.knikanth@suse.de>
References: <20100916125147.CA08.A69D9226@jp.fujitsu.com> <201009161135.00129.knikanth@suse.de>
Message-Id: <20100916153420.3BBD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 16 Sep 2010 15:34:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, /proc/<pid>/smaps have wrong dirty pages accounting.
Shared_Dirty and Private_Dirty output only pte dirty pages and
ignore PG_dirty page flag. It is difference against documentation,
but also inconsistent against Referenced field. (Referenced checks
both pte and page flags)

This patch fixes it.

Test program:

 large-array.c
 ---------------------------------------------------
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>

 char array[1*1024*1024*1024L];

 int main(void)
 {
         memset(array, 1, sizeof(array));
         pause();

         return 0;
 }
 ---------------------------------------------------

Test case:
 1. run ./large-array
 2. cat /proc/`pidof large-array`/smaps
 3. swapoff -a
 4. cat /proc/`pidof large-array`/smaps again

Test result:
 <before patch>

00601000-40601000 rw-p 00000000 00:00 0
Size:            1048576 kB
Rss:             1048576 kB
Pss:             1048576 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:    218992 kB   <-- showed pages as clean incorrectly
Private_Dirty:    829584 kB
Referenced:       388364 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB

 <after patch>

00601000-40601000 rw-p 00000000 00:00 0
Size:            1048576 kB
Rss:             1048576 kB
Pss:             1048576 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:   1048576 kB  <-- fixed
Referenced:       388480 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/proc/task_mmu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 439fc1f..7415f13 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -362,13 +362,13 @@ static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			mss->referenced += PAGE_SIZE;
 		mapcount = page_mapcount(page);
 		if (mapcount >= 2) {
-			if (pte_dirty(ptent))
+			if (pte_dirty(ptent) || PageDirty(page))
 				mss->shared_dirty += PAGE_SIZE;
 			else
 				mss->shared_clean += PAGE_SIZE;
 			mss->pss += (PAGE_SIZE << PSS_SHIFT) / mapcount;
 		} else {
-			if (pte_dirty(ptent))
+			if (pte_dirty(ptent) || PageDirty(page))
 				mss->private_dirty += PAGE_SIZE;
 			else
 				mss->private_clean += PAGE_SIZE;
-- 
1.6.5.2



