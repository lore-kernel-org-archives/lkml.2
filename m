Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933654Ab1ESRNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:13:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756209Ab1ESRNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:13:31 -0400
Date: Thu, 19 May 2011 20:12:47 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: rusty@rustcorp.com.au, habanero@linux.vnet.ibm.com,
        Shirley Ma <mashirle@us.ibm.com>, Krishna Kumar2 <krkumar2@in.ibm.com>,
        kvm@vger.kernel.org, steved@us.ibm.com,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, borntraeger@de.ibm.com,
        avi@redhat.com
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC] virtio_ring: fix delayed enable cb implementation
Message-ID: <20110519171246.GA8650@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some signed/assigned mistakes in virtqueue_enable_cb_delayed
by using u16 math all over.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

---

I'll put this on my v1 branch as well

@@ -398,7 +397,7 @@ EXPORT_SYMBOL_GPL(virtqueue_enable_cb);
 bool virtqueue_enable_cb_delayed(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
-	int bufs;
+	u16 bufs;
 
 	START_USE(vq);
 
@@ -412,7 +411,7 @@ bool virtqueue_enable_cb_delayed(struct virtqueue *_vq)
 	bufs = (vq->vring.avail->idx - vq->last_used_idx) * 3 / 4;
 	vring_used_event(&vq->vring) = vq->last_used_idx + bufs;
 	virtio_mb();
-	if (unlikely(vq->vring.used->idx - vq->last_used_idx > bufs)) {
+	if (unlikely((u16)(vq->vring.used->idx - vq->last_used_idx) > bufs)) {
 		END_USE(vq);
 		return false;
 	}
 
-- 
1.7.5.53.gc233e
