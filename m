Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab2KVVbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:31:35 -0500
Received: from mail.kernel.org ([198.145.19.201]:49627 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056Ab2KVSki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@dreamhost.com>, Sage Weil <sage@newdream.net>
Subject: [ 088/171] rbd: dont hold spinlock during messenger flush
Date: Wed, 21 Nov 2012 16:40:34 -0800
Message-Id: <20121122004042.200738895@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@dreamhost.com>

(cherry picked from commit cd9d9f5df6098c50726200d4185e9e8da32785b3)

A recent change made changes to the rbd_client_list be protected by
a spinlock.  Unfortunately in rbd_put_client(), the lock is taken
before possibly dropping the last reference to an rbd_client, and on
the last reference that eventually calls flush_workqueue() which can
sleep.

The problem was flagged by a debug spinlock warning:
    BUG: spinlock wrong CPU on CPU#3, rbd/27814

The solution is to move the spinlock acquisition and release inside
rbd_client_release(), which is the spot where it's really needed for
protecting the removal of the rbd_client from the client list.

Signed-off-by: Alex Elder <elder@dreamhost.com>
Reviewed-by: Sage Weil <sage@newdream.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -450,7 +450,9 @@ static void rbd_client_release(struct kr
 	struct rbd_client *rbdc = container_of(kref, struct rbd_client, kref);
 
 	dout("rbd_release_client %p\n", rbdc);
+	spin_lock(&rbd_client_list_lock);
 	list_del(&rbdc->node);
+	spin_unlock(&rbd_client_list_lock);
 
 	ceph_destroy_client(rbdc->client);
 	kfree(rbdc->rbd_opts);
@@ -463,9 +465,7 @@ static void rbd_client_release(struct kr
  */
 static void rbd_put_client(struct rbd_device *rbd_dev)
 {
-	spin_lock(&rbd_client_list_lock);
 	kref_put(&rbd_dev->rbd_client->kref, rbd_client_release);
-	spin_unlock(&rbd_client_list_lock);
 	rbd_dev->rbd_client = NULL;
 }
 


