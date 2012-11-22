Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab2KVWCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:02:33 -0500
Received: from mail.kernel.org ([198.145.19.201]:49604 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876Ab2KVSkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>
Subject: [ 082/171] libceph: fix pg_temp updates
Date: Wed, 21 Nov 2012 16:40:28 -0800
Message-Id: <20121122004041.600564111@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

(cherry picked from commit 6bd9adbdf9ca6a052b0b7455ac67b925eb38cfad)

Usually, we are adding pg_temp entries or removing them.  Occasionally they
update.  In that case, osdmap_apply_incremental() was failing because the
rbtree entry already exists.

Fix by removing the existing entry before inserting a new one.

Fixes http://tracker.newdream.net/issues/2446

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ceph/osdmap.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -890,8 +890,12 @@ struct ceph_osdmap *osdmap_apply_increme
 		pglen = ceph_decode_32(p);
 
 		if (pglen) {
-			/* insert */
 			ceph_decode_need(p, end, pglen*sizeof(u32), bad);
+
+			/* removing existing (if any) */
+			(void) __remove_pg_mapping(&map->pg_temp, pgid);
+
+			/* insert */
 			pg = kmalloc(sizeof(*pg) + sizeof(u32)*pglen, GFP_NOFS);
 			if (!pg) {
 				err = -ENOMEM;


