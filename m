Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862Ab2C2C00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 22:26:26 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40838 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab2C2C0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 22:26:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6663"; a="176778630"
From: Laura Abbott <lauraa@codeaurora.org>
To: linux-mm@kvack.org, benh@kernel.crashing.org, yinghai@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Laura Abbott <lauraa@codeaurora.org>
Subject: [PATCH] mm/memblock.c: Correctly check whether to trim a block
Date: Wed, 28 Mar 2012 19:25:58 -0700
Message-Id: <1332987958-10766-1-git-send-email-lauraa@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently in __memblock_remove, the check to trim the top of
a block off only checks if the requested base is less than the
memblock end. If the end of the requested region is equal to
the start of a memblock, this will incorrectly try to remove
the block, possibly causing an integer underflow:

   ---------------------------------------
   |                    |                |
   |                    |                |
  base              end = rgn->base    rend

An additional check is needed to see if the end of the requested
region is greater than the memblock region:

   ----------------------
   |                     |
   |                     |
  rgn->base    base     rend      end
                |                  |
                |                  |
                --------------------

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
---
 mm/memblock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 5338237..e174ee0 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -459,7 +459,7 @@ static long __init_memblock __memblock_remove(struct memblock_type *type,
 		}
 
 		/* And check if we need to trim the top of a block */
-		if (base < rend)
+		if (base < rend && end > rend)
 			rgn->size -= rend - base;
 
 	}
-- 
1.7.8.3

