Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab2G0TVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 15:21:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34733 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237Ab2G0TVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 15:21:47 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Joonsoo Kim <js1304@gmail.com>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>
Subject: [RESEND PATCH] slub: reduce failure of this_cpu_cmpxchg in put_cpu_partial() after unfreezing
Date: Sat, 28 Jul 2012 04:20:29 +0900
Message-Id: <1343416829-3496-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation, after unfreezing, we doesn't touch oldpage,
so it remain 'NOT NULL'. When we call this_cpu_cmpxchg()
with this old oldpage, this_cpu_cmpxchg() is mostly be failed.

We can change value of oldpage to NULL after unfreezing,
because unfreeze_partial() ensure that all the cpu partial slabs is removed
from cpu partial list. In this time, we could expect that
this_cpu_cmpxchg is mostly succeed.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Acked-by: Christoph Lameter <cl@linux.com>
---
Change log: Just add "Acked-by: Christoph Lameter <cl@linux.com>"
Resend as ping for Penberg

diff --git a/mm/slub.c b/mm/slub.c
index e517d43..ca778e5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1952,6 +1952,7 @@ int put_cpu_partial(struct kmem_cache *s, struct page *page, int drain)
 				local_irq_save(flags);
 				unfreeze_partials(s);
 				local_irq_restore(flags);
+				oldpage = NULL;
 				pobjects = 0;
 				pages = 0;
 				stat(s, CPU_PARTIAL_DRAIN);
-- 
1.7.9.5

