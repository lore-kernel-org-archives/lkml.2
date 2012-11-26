Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820Ab2KZSBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:01:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47456 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530Ab2KZRFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:05:40 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Xi Wang <xi.wang@gmail.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 094/270] libceph: fix overflow in osdmap_apply_incremental()
Date: Mon, 26 Nov 2012 14:56:24 -0200
Message-Id: <1353949160-26803-95-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Wang <xi.wang@gmail.com>

commit a5506049500b30dbc5edb4d07a3577477c1f3643 upstream.

On 32-bit systems, a large `pglen' would overflow `pglen*sizeof(u32)'
and bypass the check ceph_decode_need(p, end, pglen*sizeof(u32), bad).
It would also overflow the subsequent kmalloc() size, leading to
out-of-bounds write.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/osdmap.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index bc73341..9600674 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -893,6 +893,10 @@ struct ceph_osdmap *osdmap_apply_incremental(void **p, void *end,
 			(void) __remove_pg_mapping(&map->pg_temp, pgid);
 
 			/* insert */
+			if (pglen > (UINT_MAX - sizeof(*pg)) / sizeof(u32)) {
+				err = -EINVAL;
+				goto bad;
+			}
 			pg = kmalloc(sizeof(*pg) + sizeof(u32)*pglen, GFP_NOFS);
 			if (!pg) {
 				err = -ENOMEM;
-- 
1.7.9.5

