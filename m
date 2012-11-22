Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775Ab2KVVxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:53:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:49639 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754940Ab2KVSkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Xi Wang <xi.wang@gmail.com>, Alex Elder <elder@inktank.com>
Subject: [ 113/171] libceph: fix overflow in osdmap_apply_incremental()
Date: Wed, 21 Nov 2012 16:40:59 -0800
Message-Id: <20121122004044.694499787@linuxfoundation.org>
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

(cherry picked from commit a5506049500b30dbc5edb4d07a3577477c1f3643)

On 32-bit systems, a large `pglen' would overflow `pglen*sizeof(u32)'
and bypass the check ceph_decode_need(p, end, pglen*sizeof(u32), bad).
It would also overflow the subsequent kmalloc() size, leading to
out-of-bounds write.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osdmap.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -900,6 +900,10 @@ struct ceph_osdmap *osdmap_apply_increme
 			(void) __remove_pg_mapping(&map->pg_temp, pgid);
 
 			/* insert */
+			if (pglen > (UINT_MAX - sizeof(*pg)) / sizeof(u32)) {
+				err = -EINVAL;
+				goto bad;
+			}
 			pg = kmalloc(sizeof(*pg) + sizeof(u32)*pglen, GFP_NOFS);
 			if (!pg) {
 				err = -ENOMEM;


