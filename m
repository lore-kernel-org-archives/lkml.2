Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789Ab2KZSCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:02:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47447 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509Ab2KZRFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:05:33 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Xi Wang <xi.wang@gmail.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 092/270] libceph: fix overflow in __decode_pool_names()
Date: Mon, 26 Nov 2012 14:56:22 -0200
Message-Id: <1353949160-26803-93-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Wang <xi.wang@gmail.com>

commit ad3b904c07dfa88603689bf9a67bffbb9b99beb5 upstream.

`len' is read from network and thus needs validation.  Otherwise a
large `len' would cause out-of-bounds access via the memcpy() call.
In addition, len = 0xffffffff would overflow the kmalloc() size,
leading to out-of-bounds write.

This patch adds a check of `len' via ceph_decode_need().  Also use
kstrndup rather than kmalloc/memcpy.

[elder@inktank.com: added -ENOMEM return for null kstrndup() result]

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/osdmap.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index 81e3b84..95b2762 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -488,15 +488,16 @@ static int __decode_pool_names(void **p, void *end, struct ceph_osdmap *map)
 		ceph_decode_32_safe(p, end, pool, bad);
 		ceph_decode_32_safe(p, end, len, bad);
 		dout("  pool %d len %d\n", pool, len);
+		ceph_decode_need(p, end, len, bad);
 		pi = __lookup_pg_pool(&map->pg_pools, pool);
 		if (pi) {
+			char *name = kstrndup(*p, len, GFP_NOFS);
+
+			if (!name)
+				return -ENOMEM;
 			kfree(pi->name);
-			pi->name = kmalloc(len + 1, GFP_NOFS);
-			if (pi->name) {
-				memcpy(pi->name, *p, len);
-				pi->name[len] = '\0';
-				dout("  name is %s\n", pi->name);
-			}
+			pi->name = name;
+			dout("  name is %s\n", pi->name);
 		}
 		*p += len;
 	}
-- 
1.7.9.5

