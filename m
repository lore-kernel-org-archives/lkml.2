Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab0CQOq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 10:46:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754822Ab0CQOq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:46:26 -0400
Date: Wed, 17 Mar 2010 16:42:50 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jiri Slaby <jirislaby@gmail.com>,
       kvm@vger.kernel.org, virtualization@lists.osdl.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vhost: fix error handling in vring ioctls
Message-ID: <20100317144249.GA3984@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found a locking problem in vhost_set_vring:
several returns from VHOST_SET_VRING_KICK, VHOST_SET_VRING_CALL,
VHOST_SET_VRING_ERR with the vq->mutex held.
Fix these up.

Reported-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 7cd55e0..7bd7a1e 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -476,8 +476,10 @@ static long vhost_set_vring(struct vhost_dev *d, int ioctl, void __user *argp)
 		if (r < 0)
 			break;
 		eventfp = f.fd == -1 ? NULL : eventfd_fget(f.fd);
-		if (IS_ERR(eventfp))
-			return PTR_ERR(eventfp);
+		if (IS_ERR(eventfp)) {
+			r = PTR_ERR(eventfp);
+			break;
+		}
 		if (eventfp != vq->kick) {
 			pollstop = filep = vq->kick;
 			pollstart = vq->kick = eventfp;
@@ -489,8 +491,10 @@ static long vhost_set_vring(struct vhost_dev *d, int ioctl, void __user *argp)
 		if (r < 0)
 			break;
 		eventfp = f.fd == -1 ? NULL : eventfd_fget(f.fd);
-		if (IS_ERR(eventfp))
-			return PTR_ERR(eventfp);
+		if (IS_ERR(eventfp)) {
+			r = PTR_ERR(eventfp);
+			break;
+		}
 		if (eventfp != vq->call) {
 			filep = vq->call;
 			ctx = vq->call_ctx;
@@ -505,8 +509,10 @@ static long vhost_set_vring(struct vhost_dev *d, int ioctl, void __user *argp)
 		if (r < 0)
 			break;
 		eventfp = f.fd == -1 ? NULL : eventfd_fget(f.fd);
-		if (IS_ERR(eventfp))
-			return PTR_ERR(eventfp);
+		if (IS_ERR(eventfp)) {
+			r = PTR_ERR(eventfp);
+			break;
+		}
 		if (eventfp != vq->error) {
 			filep = vq->error;
 			vq->error = eventfp;
-- 
1.7.0.18.g0d53a5
