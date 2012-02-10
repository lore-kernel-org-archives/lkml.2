Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760046Ab2BJTwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:52:19 -0500
Received: from gw.danplanet.com ([50.43.125.66]:41942 "EHLO mail.danplanet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759958Ab2BJTwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:52:18 -0500
X-Greylist: delayed 731 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Feb 2012 14:52:18 EST
From: Dan Smith <danms@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Ensure that walk_page_range()'s start and end are page-aligned
Date: Fri, 10 Feb 2012 11:39:56 -0800
Message-Id: <1328902796-30389-1-git-send-email-danms@us.ibm.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The inner function walk_pte_range() increments "addr" by PAGE_SIZE after
each pte is processed, and only exits the loop if the result is equal to
"end". Current, if either (or both of) the starting or ending addresses
passed to walk_page_range() are not page-aligned, then we will never
satisfy that exit condition and begin calling the pte_entry handler with
bad data.

To be sure that we will land in the right spot, this patch checks that
both "addr" and "end" are page-aligned in walk_page_range() before starting
the traversal.

Signed-off-by: Dan Smith <danms@us.ibm.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/pagewalk.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 2f5cf10..9242bfc 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -196,6 +196,8 @@ int walk_page_range(unsigned long addr, unsigned long end,
 	if (addr >= end)
 		return err;
 
+	VM_BUG_ON((addr & ~PAGE_MASK) || (end & ~PAGE_MASK));
+
 	if (!walk->mm)
 		return -EINVAL;
 
-- 
1.7.9

