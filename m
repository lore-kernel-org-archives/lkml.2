Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab2FVSYN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 14:24:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65003 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab2FVSYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 14:24:11 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 1/3] slub: prefetch next freelist pointer in __slab_alloc()
Date: Sat, 23 Jun 2012 03:22:37 +0900
Message-Id: <1340389359-2407-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <yes>
References: <yes>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0ad9500e16fe24aa55809a2b00e0d2d0e658fc71 ('slub: prefetch
next freelist pointer in slab_alloc') add prefetch instruction to
fast path of allocation.

Same benefit is also available in slow path of allocation, but it is not
large portion of overall allocation. Nevertheless we could get
some benifit from it, so prefetch next freelist pointer in __slab_alloc.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/mm/slub.c b/mm/slub.c
index f96d8bc..92f1c0e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2248,6 +2248,7 @@ load_freelist:
 	VM_BUG_ON(!c->page->frozen);
 	c->freelist = get_freepointer(s, freelist);
 	c->tid = next_tid(c->tid);
+	prefetch_freepointer(s, c->freelist);
 	local_irq_restore(flags);
 	return freelist;
 
-- 
1.7.9.5

