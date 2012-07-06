Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab2GFN4O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 09:56:14 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:22311 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752884Ab2GFN4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 09:56:13 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: z5Y1Z68VM1kMOhzW8VCgJO5HL1K2fnBcBrp9E_fPhkno6vB
 .8m1ieW53cvCFGdk7vJgFJxOTD_C7dLpItEfsHLyywuVmv_9FFg1ZrPyd_PE
 4LcK2BNW2CR6O0C8Me6Y39lW1NdXJ3Pf9bjuS3lKvqhlZ4QFgMKpxUHQmpZm
 6bBHIxioR9GhkfTq56pX4zQTktge17h9O.SVECuS55oU8Fkr2RdcDCko6Aci
 BUmrEvbst8RrA8aGFlSMKWZbOAFCINk0SjIDy32JloLeFluT._XEPl2_4EWg
 OFbY3LRH15gsW3Yg5jHLceIicHNdkLUe8AnpI__8DR3NBHO6nz9XhOJckZL0
 YfdZNpD.kcAsvu1BPplQ9UOdbAo1fD07_Ot1M28T7Udyg4iwWfV1MewC6qaY
 ADFZLnfyaF9xpQu6Feyie8FbFVPiHQtWVd_I9
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 6 Jul 2012 08:56:04 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Li Zhong <zhong@linux.vnet.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm <linux-mm@kvack.org>,
        PowerPC email list <linuxppc-dev@lists.ozlabs.org>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH SLAB 1/2 v3] duplicate the cache name in SLUB's saved_alias
 list, SLAB, and SLOB
In-Reply-To: <1341561286.24895.9.camel@ThinkPad-T420>
Message-ID: <alpine.DEB.2.00.1207060855320.26441@router.home>
References: <1341561286.24895.9.camel@ThinkPad-T420>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I thought I posted this a couple of days ago. Would this not fix things
without having to change all the allocators?


Subject: slub: Dup name earlier in kmem_cache_create

Dup the name earlier in kmem_cache_create so that alias
processing is done using the copy of the string and not
the string itself.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2012-06-11 08:49:56.000000000 -0500
+++ linux-2.6/mm/slub.c	2012-07-03 15:17:37.000000000 -0500
@@ -3933,8 +3933,12 @@ struct kmem_cache *kmem_cache_create(con
 	if (WARN_ON(!name))
 		return NULL;

+	n = kstrdup(name, GFP_KERNEL);
+	if (!n)
+		goto out;
+
 	down_write(&slub_lock);
-	s = find_mergeable(size, align, flags, name, ctor);
+	s = find_mergeable(size, align, flags, n, ctor);
 	if (s) {
 		s->refcount++;
 		/*
@@ -3944,7 +3948,7 @@ struct kmem_cache *kmem_cache_create(con
 		s->objsize = max(s->objsize, (int)size);
 		s->inuse = max_t(int, s->inuse, ALIGN(size, sizeof(void *)));

-		if (sysfs_slab_alias(s, name)) {
+		if (sysfs_slab_alias(s, n)) {
 			s->refcount--;
 			goto err;
 		}
@@ -3952,31 +3956,26 @@ struct kmem_cache *kmem_cache_create(con
 		return s;
 	}

-	n = kstrdup(name, GFP_KERNEL);
-	if (!n)
-		goto err;
-
 	s = kmalloc(kmem_size, GFP_KERNEL);
 	if (s) {
 		if (kmem_cache_open(s, n,
 				size, align, flags, ctor)) {
 			list_add(&s->list, &slab_caches);
 			up_write(&slub_lock);
-			if (sysfs_slab_add(s)) {
-				down_write(&slub_lock);
-				list_del(&s->list);
-				kfree(n);
-				kfree(s);
-				goto err;
-			}
-			return s;
+			if (!sysfs_slab_add(s))
+				return s;
+
+			down_write(&slub_lock);
+			list_del(&s->list);
 		}
 		kfree(s);
 	}
-	kfree(n);
+
 err:
+	kfree(n);
 	up_write(&slub_lock);

+out:
 	if (flags & SLAB_PANIC)
 		panic("Cannot create slabcache %s\n", name);
 	else
