Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab1BTWpl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 17:45:41 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62564 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab1BTWpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 17:45:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=G89+8JKXeUsV1rWpuOVkuomdkoNR4Ooay5IxSZLNajHJVDtaR6Pf1THofauHNzxu61
         xvmdvivm7CRhamYxWgQbFdA3e6R9H5IRBrDIvZb5pbaQUuFMov0LgfVrD2CJ9ng7RANj
         /zWrpH4KzgUJ+Z/xw+UaMOKHC8H6iIFiuIIx4=
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: drbd-dev@lists.linbit.com
Cc: linux-kernel@vger.kernel.org, Ilia Mirkin <imirkin@alum.mit.edu>
Subject: [PATCH] lru_cache: Use correct type in sizeof for allocation
Date: Sun, 20 Feb 2011 17:45:14 -0500
Message-Id: <1298241914-1400-1-git-send-email-imirkin@alum.mit.edu>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has no actual effect, since sizeof(struct hlist_head) ==
sizeof(struct hlist_head *), but it's still the wrong type to use.

The semantic match that finds this problem:
// <smpl>
@@
type T;
identifier x;
@@
T *x;
...
* x = kzalloc(... * sizeof(T*) * ..., ...);
// </smpl>

Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>

---
 lib/lru_cache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Note that in lc_reset, there is the line

memset(lc->lc_slot, 0, sizeof(struct hlist_head) * lc->nr_elements);

So this seems correct. But otherwise untested.

diff --git a/lib/lru_cache.c b/lib/lru_cache.c
index 270de9d..b312c8f 100644
--- a/lib/lru_cache.c
+++ b/lib/lru_cache.c
@@ -84,7 +84,7 @@ struct lru_cache *lc_create(const char *name, struct kmem_cache *cache,
 	if (e_count > LC_MAX_ACTIVE)
 		return NULL;
 
-	slot = kzalloc(e_count * sizeof(struct hlist_head*), GFP_KERNEL);
+	slot = kzalloc(e_count * sizeof(struct hlist_head), GFP_KERNEL);
 	if (!slot)
 		goto out_fail;
 	element = kzalloc(e_count * sizeof(struct lc_element *), GFP_KERNEL);
-- 
1.7.3.4

