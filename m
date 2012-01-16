Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab2APSts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:49:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43049 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755820Ab2APStp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:49:45 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 16 10:45:19 2012
Message-Id: <20120116184519.345383502@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Mon, 16 Jan 2012 10:45:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>
Subject: [43/48] slub: fix a possible memleak in __slab_alloc()
In-Reply-To: <20120116184527.GA11972@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/slub.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2077,6 +2077,11 @@ static void *__slab_alloc(struct kmem_ca
 		goto new_slab;
 	}
 
+	/* must check again c->freelist in case of cpu migration or IRQ */
+	object = c->freelist;
+	if (object)
+		goto load_freelist;
+
 	stat(s, ALLOC_SLOWPATH);
 
 	do {


