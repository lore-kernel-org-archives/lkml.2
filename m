Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab1BXFog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 00:44:36 -0500
Received: from smtp-out.google.com ([74.125.121.67]:33070 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab1BXFof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 00:44:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=lTKh24vIcG2cHgKeLM1H4uvvCZBANRmfH6iSYam6pSeMUaflxzwNuoJku6e5yc2hby
         JZ6Qa5kP03OyuRkCMb1g==
Date: Wed, 23 Feb 2011 21:44:33 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>,
        Daisuke Nishimura <nishmura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] memcg: more mem_cgroup_uncharge batching
Message-ID: <alpine.LSU.2.00.1102232139560.2239@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems odd that truncate_inode_pages_range(), called not only when
truncating but also when evicting inodes, has mem_cgroup_uncharge_start
and _end() batching in its second loop to clear up a few leftovers, but
not in its first loop that does almost all the work: add them there too.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/truncate.c |    2 ++
 1 file changed, 2 insertions(+)

--- 2.6.38-rc6/mm/truncate.c	2011-01-21 20:54:14.000000000 -0800
+++ linux/mm/truncate.c	2011-02-23 16:12:19.000000000 -0800
@@ -225,6 +225,7 @@ void truncate_inode_pages_range(struct a
 	next = start;
 	while (next <= end &&
 	       pagevec_lookup(&pvec, mapping, next, PAGEVEC_SIZE)) {
+		mem_cgroup_uncharge_start();
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
 			pgoff_t page_index = page->index;
@@ -247,6 +248,7 @@ void truncate_inode_pages_range(struct a
 			unlock_page(page);
 		}
 		pagevec_release(&pvec);
+		mem_cgroup_uncharge_end();
 		cond_resched();
 	}
 
