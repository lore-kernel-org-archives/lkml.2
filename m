Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821Ab2EBDsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 23:48:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758177Ab2EBDsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 23:48:10 -0400
Subject: [V2 PATCH 9/9] vhost: zerocopy: poll vq in zerocopy callback
To: eric.dumazet@gmail.com, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        davem@davemloft.net
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 02 May 2012 11:42:54 +0800
Message-ID: <20120502034254.11782.27314.stgit@amd-6168-8-1.englab.nay.redhat.com>
In-Reply-To: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
References: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
User-Agent: StGit/0.16-1-g60c4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We add used and signal guest in worker thread but did not poll the virtqueue
during the zero copy callback. This may lead the missing of adding and
signalling during zerocopy. Solve this by polling the virtqueue and let it
wakeup the worker during callback.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vhost.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 947f00d..7b75fdf 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1604,6 +1604,7 @@ void vhost_zerocopy_callback(void *arg)
 	struct vhost_ubuf_ref *ubufs = ubuf->arg;
 	struct vhost_virtqueue *vq = ubufs->vq;
 
+	vhost_poll_queue(&vq->poll);
 	/* set len = 1 to mark this desc buffers done DMA */
 	vq->heads[ubuf->desc].len = VHOST_DMA_DONE_LEN;
 	kref_put(&ubufs->kref, vhost_zerocopy_done_signal);

