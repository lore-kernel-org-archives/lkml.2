Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab3ADJLs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 04:11:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:44717 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752719Ab3ADJLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 04:11:46 -0500
X-IronPort-AV: E=Sophos;i="4.84,409,1355068800"; 
   d="scan'208";a="6521578"
From: Lin Feng <linfeng@cn.fujitsu.com>
To: akpm@linux-foundation.org, tj@kernel.org
Cc: mingo@kernel.org, yinghai@kernel.org, liwanp@linux.vnet.ibm.com,
        benh@kernel.crashing.org, tangchen@cn.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Lin Feng <linfeng@cn.fujitsu.com>
Subject: [RFC PATCH] mm: memblock: fix wrong memmove size in memblock_merge_regions()
Date: Fri, 4 Jan 2013 17:10:50 +0800
Message-Id: <1357290650-25544-1-git-send-email-linfeng@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/04 17:11:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/04 17:11:18,
	Serialize complete at 2013/01/04 17:11:18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memmove span covers from (next+1) to the end of the array, and the index
of next is (i+1), so the index of (next+1) is (i+2). So the size of remaining
array elements is (type->cnt - (i + 2)).

PS. It seems that memblock_merge_regions() could be made some improvement:
we need't memmove the remaining array elements until we find a none-mergable
element, but now we memmove everytime we find a neighboring compatible region.
I'm not sure if the trial is worth though.

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
---
 mm/memblock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 6259055..85ce056 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -314,7 +314,7 @@ static void __init_memblock memblock_merge_regions(struct memblock_type *type)
 		}
 
 		this->size += next->size;
-		memmove(next, next + 1, (type->cnt - (i + 1)) * sizeof(*next));
+		memmove(next, next + 1, (type->cnt - (i + 2)) * sizeof(*next));
 		type->cnt--;
 	}
 }
-- 
1.7.11.7

