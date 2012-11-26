Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719Ab2KZRFm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:05:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47451 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684Ab2KZRFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:05:36 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Xi Wang <xi.wang@gmail.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 093/270] libceph: fix overflow in osdmap_decode()
Date: Mon, 26 Nov 2012 14:56:23 -0200
Message-Id: <1353949160-26803-94-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Wang <xi.wang@gmail.com>

commit e91a9b639a691e0982088b5954eaafb5a25c8f1c upstream.

On 32-bit systems, a large `n' would overflow `n * sizeof(u32)' and bypass
the check ceph_decode_need(p, end, n * sizeof(u32), bad).  It would also
overflow the subsequent kmalloc() size, leading to out-of-bounds write.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/ceph/osdmap.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index 95b2762..bc73341 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -667,6 +667,9 @@ struct ceph_osdmap *osdmap_decode(void **p, void *end)
 		ceph_decode_need(p, end, sizeof(u32) + sizeof(u64), bad);
 		ceph_decode_copy(p, &pgid, sizeof(pgid));
 		n = ceph_decode_32(p);
+		err = -EINVAL;
+		if (n > (UINT_MAX - sizeof(*pg)) / sizeof(u32))
+			goto bad;
 		ceph_decode_need(p, end, n * sizeof(u32), bad);
 		err = -ENOMEM;
 		pg = kmalloc(sizeof(*pg) + n*sizeof(u32), GFP_NOFS);
-- 
1.7.9.5

