Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab2BQA7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 19:59:30 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53603 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756431Ab2BQA70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:59:26 -0500
X-Sasl-enc: dIohINepmWXiHMdm+70CN4EHJhTctGBHfaTHexuYJzeO 1329440365
X-Mailbox-Line: From gregkh@linuxfoundation.org Thu Feb 16 16:55:12 2012
Message-Id: <20120217005511.894980544@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 16 Feb 2012 16:55:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Zhihua Che <zhihua.che@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>
Subject: [15/15] slub: fix a possible memleak in __slab_alloc()
In-Reply-To: <20120217005650.GA17119@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit 73736e0387ba0e6d2b703407b4d26168d31516a7 upstream.

Zhihua Che reported a possible memleak in slub allocator on
CONFIG_PREEMPT=y builds.

It is possible current thread migrates right before disabling irqs in
__slab_alloc(). We must check again c->freelist, and perform a normal
allocation instead of scratching c->freelist.

Many thanks to Zhihua Che for spotting this bug, introduced in 2.6.39

V2: Its also possible an IRQ freed one (or several) object(s) and
populated c->freelist, so its not a CONFIG_PREEMPT only problem.

Reported-by: Zhihua Che <zhihua.che@gmail.com>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/slub.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1818,6 +1818,11 @@ static void *__slab_alloc(struct kmem_ca
 	if (unlikely(!node_match(c, node)))
 		goto another_slab;
 
+	/* must check again c->freelist in case of cpu migration or IRQ */
+	object = c->freelist;
+	if (object)
+		goto update_freelist;
+
 	stat(s, ALLOC_REFILL);
 
 load_freelist:
@@ -1827,6 +1832,7 @@ load_freelist:
 	if (kmem_cache_debug(s))
 		goto debug;
 
+update_freelist:
 	c->freelist = get_freepointer(s, object);
 	page->inuse = page->objects;
 	page->freelist = NULL;


