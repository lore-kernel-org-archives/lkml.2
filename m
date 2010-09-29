Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab0I2MCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:02:30 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45686 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab0I2MC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:02:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BoMUn5flkaOePGCLHuvDzD7Y2qYLdCm9jr6MDCLX1gtfoO9vkX9FO/Aln17oqBcVMc
         XwSN8W4bPFHeeeNeufDZcTwAIngMHpYPz/14f4Mj2gTyK0xMUemCB7uROWo/5EKoKAVC
         sPOa6GmO1YAsL2fVjHUseQMS4DIKTcmLmFaDc=
From: Namhyung Kim <namhyung@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] slub: Add lock release annotation
Date: Wed, 29 Sep 2010 21:02:14 +0900
Message-Id: <1285761735-31499-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285761735-31499-1-git-send-email-namhyung@gmail.com>
References: <1285761735-31499-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unfreeze_slab() releases page's PG_locked bit but was missing
proper annotation. The deactivate_slab() needs to be marked also
since it calls unfreeze_slab() without grabbing the lock.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 mm/slub.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index e137688..f0684a9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1405,6 +1405,7 @@ static struct page *get_partial(struct kmem_cache *s, gfp_t flags, int node)
  * On exit the slab lock will have been dropped.
  */
 static void unfreeze_slab(struct kmem_cache *s, struct page *page, int tail)
+	__releases(bitlock)
 {
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
 
@@ -1447,6 +1448,7 @@ static void unfreeze_slab(struct kmem_cache *s, struct page *page, int tail)
  * Remove the cpu slab
  */
 static void deactivate_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
+	__releases(bitlock)
 {
 	struct page *page = c->page;
 	int tail = 1;
-- 
1.7.2.2

