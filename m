Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab0INSsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 14:48:35 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:34778 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab0INSs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 14:48:26 -0400
From: Pekka Enberg <penberg@kernel.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>
Subject: [PATCH v2 2/2] SLUB: Mark merged slab caches in /proc/slabinfo
Date: Tue, 14 Sep 2010 21:48:21 +0300
Message-Id: <1284490101-2362-2-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1284490101-2362-1-git-send-email-penberg@kernel.org>
References: <1284490101-2362-1-git-send-email-penberg@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SLUB uses the name of the first slab cache for all merged slab caches. To make
the output of /proc/slabinfo more obvious, append the name of each merged slab
cache to s->name.

An example output of /proc/slabinfo with this patch looks like this:

  kmalloc-8192         544    544   8192    4    8 : tunables    0
  kmalloc-4096+names_cache+biovec-256+sgpool-128+ecryptfs_headers
  kmalloc-2048+biovec-128+sgpool-64    400    416   2048   16    8
  kmalloc-1024+biovec-64+sgpool-32    436    496   1024   16    4 :
  kmalloc-512+task_xstate+skbuff_fclone_cache+sgpool-16   1060   10
  kmalloc-256+mnt_cache+skbuff_head_cache+biovec-16+sgpool-8+arp_   [ snip ]
  kmalloc-128+pid+bip-1+eventpoll_epi+request_sock_TCP+ip_mrt_cac
  kmalloc-64+fs_cache+biovec-4+blkdev_ioc+inet_peer_cache+tcp_bin
  kmalloc-32+ip_fib_alias+dnotify_struct+inotify_event_private_da
  kmalloc-16+biovec-1+ecryptfs_file_cache+dm_rq_clone_bio_info+dm
  kmalloc-8           5119   5120      8  512    1 : tunables    0
  kmalloc-192+cred_jar+key_jar+filp+bip-4+bio-0+request_sock_TCPv
  kmalloc-96           924   1008     96   42    1 : tunables    0
  kmem_cache_node      128    128     64   64    1 : tunables    0

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 mm/slub.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a31c033..77e4438 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3161,6 +3161,40 @@ void __init kmem_cache_init_late(void)
 }
 
 /*
+ * This limit is part of /proc/slabinfo ABI. It has never been enforced by the
+ * kernel but userspace programs such as "slabtop" expect it.
+ */
+#define MAX_SLAB_NAME_LEN	63
+
+static int kmem_merge_names(struct kmem_cache *s, const char *name)
+{
+	size_t new_size;
+	char *new_name;
+
+	if (strlen(s->name) >= MAX_SLAB_NAME_LEN)
+		return 0;
+
+	/* Don't append name to merged name more than once */
+	if (strstr(s->name, name))
+		return 0;
+
+	new_size = strlen(s->name) + strlen(name) + 2;
+	if (new_size > (MAX_SLAB_NAME_LEN + 1))
+		new_size = MAX_SLAB_NAME_LEN + 1;	/* NULL terminate */
+
+	new_name = kmalloc(new_size, GFP_KERNEL);
+	if (!new_name)
+		return -ENOMEM;
+
+	snprintf(new_name, new_size, "%s+%s", s->name, name);
+
+	kfree(s->name);
+	s->name = new_name;
+
+	return 0;
+}
+
+/*
  * Find a mergeable slab cache
  */
 static int slab_unmergeable(struct kmem_cache *s)
@@ -3233,6 +3267,9 @@ struct kmem_cache *kmem_cache_create(const char *name, size_t size,
 	down_write(&slub_lock);
 	s = find_mergeable(size, align, flags, name, ctor);
 	if (s) {
+		if (kmem_merge_names(s, name))
+			goto err;
+
 		s->refcount++;
 		/*
 		 * Adjust the object sizes so that we clear
-- 
1.6.3.3

