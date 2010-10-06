Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940Ab0JFUtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 16:49:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37494 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678Ab0JFUtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 16:49:15 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/4] HWPOISON: Stop shrinking at right page count
Date: Wed,  6 Oct 2010 22:49:01 +0200
Message-Id: <1286398141-13749-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286398141-13749-1-git-send-email-andi@firstfloor.org>
References: <1286398141-13749-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When we call the slab shrinker to free a page we need to stop at
page count one because the caller always holds a single reference, not zero.

This avoids useless looping over slab shrinkers and freeing too much
memory.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 mm/memory-failure.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 886144b..7c1af9b 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -237,7 +237,7 @@ void shake_page(struct page *p, int access)
 		int nr;
 		do {
 			nr = shrink_slab(1000, GFP_KERNEL, 1000);
-			if (page_count(p) == 0)
+			if (page_count(p) == 1)
 				break;
 		} while (nr > 10);
 	}
-- 
1.7.1

