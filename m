Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab0LSWT1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 17:19:27 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11471 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238Ab0LSWT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 17:19:26 -0500
Date: Sun, 19 Dec 2010 23:10:20 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-mm@kvack.org
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Close mem leak in error path in
 mm/hugetlb.c::nr_hugepages_store_common()
Message-ID: <alpine.LNX.2.00.1012192305260.6486@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The NODEMASK_ALLOC macro dynamically allocates memory for its second 
argument ('nodes_allowed' in this context).
In nr_hugepages_store_common() we may abort early if strict_strtoul() 
fails, but in that case we do not free the memory already allocated to 
'nodes_allowed', causing a memory leak.
This patch closes the leak by freeing the memory in the error path.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 hugetlb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

  compile tested only

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8585524..9fdcc35 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1439,8 +1439,10 @@ static ssize_t nr_hugepages_store_common(bool obey_mempolicy,
 	NODEMASK_ALLOC(nodemask_t, nodes_allowed, GFP_KERNEL | __GFP_NORETRY);
 
 	err = strict_strtoul(buf, 10, &count);
-	if (err)
+	if (err) {
+		kfree(nodes_allowed);
 		return 0;
+	}
 
 	h = kobj_to_hstate(kobj, &nid);
 	if (nid == NUMA_NO_NODE) {



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

