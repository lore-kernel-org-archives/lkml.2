Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab2FYJxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 05:53:15 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:44907 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab2FYJxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 05:53:14 -0400
Message-ID: <1340617984.13778.37.camel@ThinkPad-T420>
Subject: [PATCH SLUB 1/2] duplicate the cache name in saved_alias list
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm <linux-mm@kvack.org>,
        PowerPC email list <linuxppc-dev@lists.ozlabs.org>
Date: Mon, 25 Jun 2012 17:53:04 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12062509-2000-0000-0000-000008084084
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SLUB duplicates the cache name in kmem_cache_create(). However if the
cache could be merged to others during early booting, the name pointer
is saved in saved_alias list, and the string needs to be kept valid
before slab_sysfs_init() is called. 

This patch tries to duplicate the cache name in saved_alias list, so
that the cache name could be safely kfreed after calling
kmem_cache_create(), if that name is kmalloced. 

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 mm/slub.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8c691fa..3dc8ed5 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5373,6 +5373,11 @@ static int sysfs_slab_alias(struct kmem_cache *s,
const char *name)
 
 	al->s = s;
 	al->name = name;
+	al->name = kstrdup(name, GFP_KERNEL);
+	if (!al->name) {
+		kfree(al);
+		return -ENOMEM;
+	}
 	al->next = alias_list;
 	alias_list = al;
 	return 0;
@@ -5409,6 +5414,7 @@ static int __init slab_sysfs_init(void)
 		if (err)
 			printk(KERN_ERR "SLUB: Unable to add boot slab alias"
 					" %s to sysfs\n", s->name);
+		kfree(al->name);
 		kfree(al);
 	}
 
-- 
1.7.1

