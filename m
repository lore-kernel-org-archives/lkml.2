Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab2ATIVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 03:21:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368Ab2ATIVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 03:21:02 -0500
Subject: [PATCH 2/2] virtio: correct the memory barrier in
	virtqueue_kick_prepare()
To: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mst@redhat.com
From: Jason Wang <jasowang@redhat.com>
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org
Date: Fri, 20 Jan 2012 16:17:08 +0800
Message-ID: <20120120081708.50747.60241.stgit@amd-6168-8-1.englab.nay.redhat.com>
In-Reply-To: <20120120081658.50747.10625.stgit@amd-6168-8-1.englab.nay.redhat.com>
References: <20120120081658.50747.10625.stgit@amd-6168-8-1.englab.nay.redhat.com>
User-Agent: StGit/3.1-rc9-1929-g8b3408
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use virtio_mb() to make sure the available index to be exposed before
checking the the avail event. Otherwise we may get stale value of
avail event in guest and never kick the host after.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/virtio/virtio_ring.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 78428a8..07d9360 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -308,9 +308,9 @@ bool virtqueue_kick_prepare(struct virtqueue *_vq)
 	bool needs_kick;
 
 	START_USE(vq);
-	/* Descriptors and available array need to be set before we expose the
-	 * new available array entries. */
-	virtio_wmb(vq);
+	/* We need expose available array entries before checking avail
+	 * event. */
+	virtio_mb(vq);
 
 	old = vq->vring.avail->idx - vq->num_added;
 	new = vq->vring.avail->idx;

