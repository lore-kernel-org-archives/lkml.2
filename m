Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab1BPAXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:23:30 -0500
Received: from kroah.org ([198.145.64.141]:49341 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757562Ab1BPAXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:23:09 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:42 2011
Message-Id: <20110216001442.904882723@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [178/272] slub: Avoid use of slub_lock in show_slab_objects()
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christoph Lameter <cl@linux.com>

commit 04d94879c8a4973b5499dc26b9d38acee8928791 upstream.

The purpose of the locking is to prevent removal and additions
of nodes when statistics are gathered for a slab cache. So we
need to avoid racing with memory hotplug functionality.

It is enough to take the memory hotplug locks there instead
of the slub_lock.

online_pages() currently does not acquire the memory_hotplug
lock. Another patch will be submitted by the memory hotplug
authors to take the memory hotplug lock and describe the
uses of the memory hotplug lock to protect against
adding and removal of nodes from non hotplug data structures.

Reported-and-tested-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/slub.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3821,7 +3821,7 @@ static ssize_t show_slab_objects(struct
 		}
 	}
 
-	down_read(&slub_lock);
+	lock_memory_hotplug();
 #ifdef CONFIG_SLUB_DEBUG
 	if (flags & SO_ALL) {
 		for_each_node_state(node, N_NORMAL_MEMORY) {
@@ -3862,7 +3862,7 @@ static ssize_t show_slab_objects(struct
 			x += sprintf(buf + x, " N%d=%lu",
 					node, nodes[node]);
 #endif
-	up_read(&slub_lock);
+	unlock_memory_hotplug();
 	kfree(nodes);
 	return x + sprintf(buf + x, "\n");
 }


