Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab1ACQbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 11:31:09 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:43570 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab1ACQbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 11:31:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IKrL/ttoFD1jxXvFlBltZINKnnIOfBDa0E6qwC03399teLdLRJjMjr0aBpEuZ+1Qk2
         szoas3mc8PBoYtXHtXYpMySB1hMpIi1rm7VlnnOdgWNvxaEtIyYNUtIAvIDKkAraXxEq
         /qgVeSvlWL4MxhAK86ZcPQT/mJnO2q9W1p6Qw=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] writeback: avoid unnecessary determine_dirtyable_memory call
Date: Tue,  4 Jan 2011 01:30:49 +0900
Message-Id: <1294072249-2916-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think determine_dirtyable_memory is rather costly function since
it need many atomic reads for gathering zone/global page state.
But when we use vm_dirty_bytes && dirty_background_bytes, we don't
need that costly calculation.

This patch eliminates such unnecessary overhead.

NOTE : newly added if condition might add overhead in normal path.
       But it should be _really_ small because anyway we need the
       access both vm_dirty_bytes and dirty_background_bytes so it is
       likely to hit the cache.

Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/page-writeback.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index fc93802..c340536 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -390,9 +390,12 @@ void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty)
 {
 	unsigned long background;
 	unsigned long dirty;
-	unsigned long available_memory = determine_dirtyable_memory();
+	unsigned long available_memory;
 	struct task_struct *tsk;
 
+	if (!vm_dirty_bytes || !dirty_background_bytes)
+		available_memory = determine_dirtyable_memory();
+
 	if (vm_dirty_bytes)
 		dirty = DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE);
 	else
-- 
1.7.0.4

