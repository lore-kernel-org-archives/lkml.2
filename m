Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798Ab0DGQeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 12:34:37 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:58837 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723Ab0DGQef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 12:34:35 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
       Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>
Subject: [PATCH 2/2] slub: Fix kmem_ptr_validate() for non-kernel pointers
Date: Wed,  7 Apr 2010 19:23:41 +0300
Message-Id: <1270657421-1937-2-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1270657421-1937-1-git-send-email-penberg@cs.helsinki.fi>
References: <1270657421-1937-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Linus, fix up kmem_ptr_validate() to handle non-kernel pointers
more graciously. The patch changes kmem_ptr_validate() to use the newly
introduced kern_ptr_validate() helper to check that a pointer is a valid kernel
pointer before we attempt to convert it into a 'struct page'.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slub.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b364844..7d6c8b1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2386,6 +2386,9 @@ int kmem_ptr_validate(struct kmem_cache *s, const void *object)
 {
 	struct page *page;
 
+	if (!kern_ptr_validate(object, s->size))
+		return 0;
+
 	page = get_object_page(object);
 
 	if (!page || s != page->slab)
-- 
1.6.3.3

