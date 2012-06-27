Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab2F0Hxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 03:53:49 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:39459 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756351Ab2F0Hxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 03:53:46 -0400
Message-ID: <1340783590.14360.9.camel@ThinkPad-T420>
Subject: [PATCH SLUB 1/2 v2] duplicate the cache name in saved_alias list
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm <linux-mm@kvack.org>,
        PowerPC email list <linuxppc-dev@lists.ozlabs.org>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>
Date: Wed, 27 Jun 2012 15:53:10 +0800
In-Reply-To: <1340617984.13778.37.camel@ThinkPad-T420>
References: <1340617984.13778.37.camel@ThinkPad-T420>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12062621-5490-0000-0000-000001ABE6D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SLUB duplicates the cache name string passed into kmem_cache_create().
However if the cache could be merged to others during early boot, the
name pointer is saved in saved_alias list, and the string needs to be
kept valid before slab_sysfs_init() is finished. With this patch, the
name string (if kmalloced) could be kfreed after calling
kmem_cache_create().

Some more details:

kmem_cache_create() checks whether it is mergeable before creating one.
If not mergeable, the name is duplicated: n = kstrdup(name, GFP_KERNEL);

If it is mergeable, it calls sysfs_slab_alias(). If the sysfs is ready
(slab_state == SYSFS), then the name is duplicated (or dropped if no
SYSFS support) in sysfs_create_link() for use.

For the above cases, we could safely kfree the name string after calling
cache create. 

However, during early boot, before sysfs is ready (slab_state < SYSFS),
the sysfs_slab_alias() saves the pointer of name in the alias_list.
Those entries in the list are added to sysfs later in slab_sysfs_init()
to set up the sysfs stuff, and we need keep the name string passed in
valid until it finishes. By duplicating the name string here also, we
are able to safely kfree the name string after calling cache create.

v2: removed an unnecessary assignment in v1; some changes in change log,
added more details

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 mm/slub.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8c691fa..ed9f3c5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5372,7 +5372,11 @@ static int sysfs_slab_alias(struct kmem_cache *s,
const char *name)
 		return -ENOMEM;
 
 	al->s = s;
-	al->name = name;
+	al->name = kstrdup(name, GFP_KERNEL);
+	if (!al->name) {
+		kfree(al);
+		return -ENOMEM;
+	}
 	al->next = alias_list;
 	alias_list = al;
 	return 0;
@@ -5409,6 +5413,7 @@ static int __init slab_sysfs_init(void)
 		if (err)
 			printk(KERN_ERR "SLUB: Unable to add boot slab alias"
 					" %s to sysfs\n", s->name);
+		kfree(al->name);
 		kfree(al);
 	}
 
-- 
1.7.9.5


