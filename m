Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab2JVMEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 08:04:43 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:34840 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab2JVMEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 08:04:42 -0400
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Cc: Tim Bird <tim.bird@am.sony.com>, Ezequiel Garcia <elezegarcia@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Glauber Costa <glommer@parallels.com>
Subject: [PATCH 2/2] mm/slob: Use free_page instead of put_page for page-size kmalloc allocations
Date: Mon, 22 Oct 2012 09:04:31 -0300
Message-Id: <1350907471-2236-1-git-send-email-elezegarcia@gmail.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When freeing objects, the slob allocator currently free empty pages
calling __free_pages(). However, page-size kmallocs are disposed
using put_page() instead.

It makes no sense to call put_page() for kernel pages that are provided
by the object allocator, so we shouldn't be doing this ourselves.

This is based on:
commit d9b7f22623b5fa9cc189581dcdfb2ac605933bf4
Author: Glauber Costa <glommer@parallels.com>
slub: use free_page instead of put_page for freeing kmalloc allocation

Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 mm/slob.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slob.c b/mm/slob.c
index a65e802..362632d 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -506,7 +506,7 @@ void kfree(const void *block)
 		unsigned int *m = (unsigned int *)(block - align);
 		slob_free(m, *m + align);
 	} else
-		put_page(sp);
+		__free_pages(sp, compound_order(sp));
 }
 EXPORT_SYMBOL(kfree);
 
-- 
1.7.8.6

