Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab1BXFfy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 00:35:54 -0500
Received: from smtp-out.google.com ([74.125.121.67]:30430 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab1BXFfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 00:35:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=tszuuuMgw8VHCJ7J547wouJovgx1TsgnNh7AOVTYharIA6eTMSD7oNvsX5IDnUPd8Z
         bLqnNTQt0p98E9VPGdXg==
Date: Wed, 23 Feb 2011 21:35:51 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Nick Piggin <npiggin@kernel.dk>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>, Salman Qazi <sqazi@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] mm: don't return 0 too early from find_get_pages()
Message-ID: <alpine.LSU.2.00.1102232132080.2239@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Callers of find_get_pages(), or its wrapper pagevec_lookup() - notably
truncate_inode_pages_range() - stop looking further when it returns 0.

But if an interrupt comes just after its radix_tree_gang_lookup_slot(),
especially if we have preemptible RCU enabled, isn't it conceivable
that all 14 pages returned could be removed from the page cache by
shrink_page_list(), before find_get_pages() gets to process them?  So
causing it to return 0 although there may be plenty more pages beyond.

Make find_get_pages() and find_get_pages_tag() check for this unlikely
case, and restart should it occur; but callers of find_get_pages_contig()
have no such expectation, it's okay for that to return 0 early.

I have not seen this in practice, just worried by the possibility.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/filemap.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- 2.6.38-rc6/mm/filemap.c	2011-01-18 22:04:56.000000000 -0800
+++ linux/mm/filemap.c	2011-02-23 16:06:19.000000000 -0800
@@ -800,6 +800,13 @@ repeat:
 		pages[ret] = page;
 		ret++;
 	}
+
+	/*
+	 * If all entries were removed before we could secure them,
+	 * try again, because callers stop trying once 0 is returned.
+	 */
+	if (unlikely(!ret && nr_found))
+		goto restart;
 	rcu_read_unlock();
 	return ret;
 }
@@ -909,6 +916,13 @@ repeat:
 		pages[ret] = page;
 		ret++;
 	}
+
+	/*
+	 * If all entries were removed before we could secure them,
+	 * try again, because callers stop trying once 0 is returned.
+	 */
+	if (unlikely(!ret && nr_found))
+		goto restart;
 	rcu_read_unlock();
 
 	if (ret)
