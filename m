Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647Ab2KVWj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:39:26 -0500
Received: from mail.kernel.org ([198.145.19.201]:49013 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab2KVSdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Josh Durgin <josh.durgin@dreamhost.com>,
        Alex Elder <elder@dreamhost.com>,
        Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: [ 089/171] rbd: protect read of snapshot sequence number
Date: Wed, 21 Nov 2012 16:40:35 -0800
Message-Id: <20121122004042.293678656@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Durgin <josh.durgin@dreamhost.com>

(cherry picked from commit 403f24d3d51760a8b9368d595fa5f48c309f1a0f)

This is updated whenever a snapshot is added or deleted, and the
snapc pointer is changed with every refresh of the header.

Signed-off-by: Josh Durgin <josh.durgin@dreamhost.com>
Reviewed-by: Alex Elder <elder@dreamhost.com>
Reviewed-by: Yehuda Sadeh <yehuda@hq.newdream.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1683,7 +1683,9 @@ static int rbd_header_add_snap(struct rb
 	if (ret < 0)
 		return ret;
 
-	dev->header.snapc->seq =  new_snapid;
+	down_write(&dev->header_rwsem);
+	dev->header.snapc->seq = new_snapid;
+	up_write(&dev->header_rwsem);
 
 	return 0;
 bad:


