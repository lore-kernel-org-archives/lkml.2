Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab1GSPEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 11:04:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab1GSPEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 11:04:37 -0400
Date: Tue, 19 Jul 2011 18:04:34 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC] vhost: optimize interrupt enable/disable
Message-ID: <20110719150434.GA3413@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we now only update used ring after enabling
the backend, we can write flags with __put_user:
as that's done on data path, it matters.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

It seems an obvious optimization so I queued this up
already.

 drivers/vhost/vhost.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index c16d225..c14c42b 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -998,7 +998,7 @@ int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
 static int vhost_update_used_flags(struct vhost_virtqueue *vq)
 {
 	void __user *used;
-	if (put_user(vq->used_flags, &vq->used->flags) < 0)
+	if (__put_user(vq->used_flags, &vq->used->flags) < 0)
 		return -EFAULT;
 	if (unlikely(vq->log_used)) {
 		/* Make sure the flag is seen before log. */
@@ -1016,7 +1016,7 @@ static int vhost_update_used_flags(struct vhost_virtqueue *vq)
 
 static int vhost_update_avail_event(struct vhost_virtqueue *vq, u16 avail_event)
 {
-	if (put_user(vq->avail_idx, vhost_avail_event(vq)))
+	if (__put_user(vq->avail_idx, vhost_avail_event(vq)))
 		return -EFAULT;
 	if (unlikely(vq->log_used)) {
 		void __user *used;
-- 
1.7.5.53.gc233e
