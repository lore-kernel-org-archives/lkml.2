Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935470Ab2C3Wlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:41:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935263Ab2C3VHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:07:54 -0400
Message-Id: <20120330195735.334705775@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:58:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sasha Levin <levinsasha928@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>
Subject: [ 092/108] slub: Do not hold slub_lock when calling sysfs_slab_add()
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Lameter <cl@linux.com>

commit 66c4c35c6bc5a1a452b024cf0364635b28fd94e4 upstream.

sysfs_slab_add() calls various sysfs functions that actually may
end up in userspace doing all sorts of things.

Release the slub_lock after adding the kmem_cache structure to the list.
At that point the address of the kmem_cache is not known so we are
guaranteed exlusive access to the following modifications to the
kmem_cache structure.

If the sysfs_slab_add fails then reacquire the slub_lock to
remove the kmem_cache structure from the list.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/slub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3439,13 +3439,14 @@ struct kmem_cache *kmem_cache_create(con
 		if (kmem_cache_open(s, n,
 				size, align, flags, ctor)) {
 			list_add(&s->list, &slab_caches);
+			up_write(&slub_lock);
 			if (sysfs_slab_add(s)) {
+				down_write(&slub_lock);
 				list_del(&s->list);
 				kfree(n);
 				kfree(s);
 				goto err;
 			}
-			up_write(&slub_lock);
 			return s;
 		}
 		kfree(n);


