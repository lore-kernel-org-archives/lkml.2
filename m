Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab2CGKAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 05:00:34 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:19030 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab2CGKAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 05:00:33 -0500
Date: Wed, 7 Mar 2012 13:00:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] AFS: checking wrong bit in afs_readpages()
Message-ID: <20120307100020.GA25452@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090205.4F5731BB.0068,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should be testing "if (vnode->flags & (1 << 4))" instead of
"if (vnode->flags & 4) {".  The current test checks if the data was
modified instead of deleted.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/afs/file.c b/fs/afs/file.c
index 14d89fa..8f6e923 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -251,7 +251,7 @@ static int afs_readpages(struct file *file, struct address_space *mapping,
 	ASSERT(key != NULL);
 
 	vnode = AFS_FS_I(mapping->host);
-	if (vnode->flags & AFS_VNODE_DELETED) {
+	if (test_bit(AFS_VNODE_DELETED, &vnode->flags)) {
 		_leave(" = -ESTALE");
 		return -ESTALE;
 	}
