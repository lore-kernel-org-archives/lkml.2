Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab0I2MC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 08:02:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50126 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab0I2MCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 08:02:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NzD32ljZFO/ZoCtKpjyX0mVNyVOMcUoGFNerouuj063ClnWCI9DXPnQP+x0eydJ/Nd
         reNzBzLjEu1u2ZvytviUYmm9TBb+TWToisKN9JStRq97EFXWrVGgGbbz6i+8lvgjO0/g
         b7vxxZ1ssDgkhgg4XCJL3OovThuAwfwRwlhio=
From: Namhyung Kim <namhyung@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] slub: Fix signedness warnings
Date: Wed, 29 Sep 2010 21:02:13 +0900
Message-Id: <1285761735-31499-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bit-ops routines require its arg to be a pointer to unsigned long.
This leads sparse to complain about different signedness as follows:

 mm/slub.c:2425:49: warning: incorrect type in argument 2 (different signedness)
 mm/slub.c:2425:49:    expected unsigned long volatile *addr
 mm/slub.c:2425:49:    got long *map

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 mm/slub.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 13fffe1..e137688 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2414,9 +2414,8 @@ static void list_slab_objects(struct kmem_cache *s, struct page *page,
 #ifdef CONFIG_SLUB_DEBUG
 	void *addr = page_address(page);
 	void *p;
-	long *map = kzalloc(BITS_TO_LONGS(page->objects) * sizeof(long),
-			    GFP_ATOMIC);
-
+	unsigned long *map = kzalloc(BITS_TO_LONGS(page->objects) *
+				     sizeof(long), GFP_ATOMIC);
 	if (!map)
 		return;
 	slab_err(s, page, "%s", text);
@@ -3635,7 +3634,7 @@ static int add_location(struct loc_track *t, struct kmem_cache *s,
 
 static void process_slab(struct loc_track *t, struct kmem_cache *s,
 		struct page *page, enum track_item alloc,
-		long *map)
+		unsigned long *map)
 {
 	void *addr = page_address(page);
 	void *p;
-- 
1.7.2.2

