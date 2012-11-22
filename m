Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab2KVWEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:04:05 -0500
Received: from mail.kernel.org ([198.145.19.201]:49648 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870Ab2KVSkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Xi Wang <xi.wang@gmail.com>, Alex Elder <elder@inktank.com>
Subject: [ 111/171] libceph: fix overflow in __decode_pool_names()
Date: Wed, 21 Nov 2012 16:40:57 -0800
Message-Id: <20121122004044.492086863@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Wang <xi.wang@gmail.com>

(cherry picked from commit ad3b904c07dfa88603689bf9a67bffbb9b99beb5)

`len' is read from network and thus needs validation.  Otherwise a
large `len' would cause out-of-bounds access via the memcpy() call.
In addition, len = 0xffffffff would overflow the kmalloc() size,
leading to out-of-bounds write.

This patch adds a check of `len' via ceph_decode_need().  Also use
kstrndup rather than kmalloc/memcpy.

[elder@inktank.com: added -ENOMEM return for null kstrndup() result]

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osdmap.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -495,15 +495,16 @@ static int __decode_pool_names(void **p,
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


