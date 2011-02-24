Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab1BXFcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 00:32:07 -0500
Received: from smtp-out.google.com ([216.239.44.51]:12156 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab1BXFcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 00:32:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=Q5SI+zWZS2xYE1WcWKF+MwOv4Eq/s8/xgtO600a7oHTyQBEtv4cjoeFStoBB3SfvG/
         /DAbo5pcKPiLOB5l3b6g==
Date: Wed, 23 Feb 2011 21:31:50 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Nick Piggin <npiggin@kernel.dk>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>, Salman Qazi <sqazi@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] mm: remove worrying dead code from find_get_pages()
Message-ID: <alpine.LSU.2.00.1102232127590.2239@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The radix_tree_deref_retry() case in find_get_pages() has a strange
little excrescence, not seen in the other gang lookups: it looks like
the start of an abandoned attempt to guarantee forward progress in a
case that cannot arise.

ret should always be 0 here: if it isn't, then going back to restart
will leak references to pages already gotten.  There used to be a
comment saying nr_found is necessarily 1 here: that's not quite true,
but the radix_tree_deref_retry() case is peculiar to the entry at index
0, when we race with it being moved out of the radix_tree root or back.

Remove the worrisome two lines, add a brief comment here and in
find_get_pages_contig() and find_get_pages_tag(), and a WARN_ON
in find_get_pages() should it ever be seen elsewhere than at 0.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/filemap.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- 2.6.38-rc6/mm/filemap.c	2011-01-18 22:04:56.000000000 -0800
+++ linux/mm/filemap.c	2011-02-23 15:45:47.000000000 -0800
@@ -782,9 +782,13 @@ repeat:
 		page = radix_tree_deref_slot((void **)pages[i]);
 		if (unlikely(!page))
 			continue;
+
+		/*
+		 * This can only trigger when the entry at index 0 moves out
+		 * of or back to the root: none yet gotten, safe to restart.
+		 */
 		if (radix_tree_deref_retry(page)) {
-			if (ret)
-				start = pages[ret-1]->index;
+			WARN_ON(start | i);
 			goto restart;
 		}
 
@@ -834,6 +838,11 @@ repeat:
 		page = radix_tree_deref_slot((void **)pages[i]);
 		if (unlikely(!page))
 			continue;
+
+		/*
+		 * This can only trigger when the entry at index 0 moves out
+		 * of or back to the root: none yet gotten, safe to restart.
+		 */
 		if (radix_tree_deref_retry(page))
 			goto restart;
 
@@ -894,6 +903,11 @@ repeat:
 		page = radix_tree_deref_slot((void **)pages[i]);
 		if (unlikely(!page))
 			continue;
+
+		/*
+		 * This can only trigger when the entry at index 0 moves out
+		 * of or back to the root: none yet gotten, safe to restart.
+		 */
 		if (radix_tree_deref_retry(page))
 			goto restart;
 
