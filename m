Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933922Ab1ESXNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:13:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933817Ab1ESXNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:13:00 -0400
Date: Fri, 20 May 2011 02:12:37 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shirley Ma <xma@us.ibm.com>, lguest@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: [PATCHv2 13/14] virtio_test: update for 64 bit features
Message-ID: <584f1dd4b91089c9634f3dc3aff295c45b10502a.1305846412.git.mst@redhat.com>
References: <cover.1305846412.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1305846412.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the virtio_test tool so it can work with
64 bit features.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 tools/virtio/virtio_test.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index 74d3331..96cf9bf 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -55,7 +55,6 @@ void vhost_vq_setup(struct vdev_info *dev, struct vq_info *info)
 {
 	struct vhost_vring_state state = { .index = info->idx };
 	struct vhost_vring_file file = { .index = info->idx };
-	unsigned long long features = dev->vdev.features[0];
 	struct vhost_vring_addr addr = {
 		.index = info->idx,
 		.desc_user_addr = (uint64_t)(unsigned long)info->vring.desc,
@@ -63,6 +62,10 @@ void vhost_vq_setup(struct vdev_info *dev, struct vq_info *info)
 		.used_user_addr = (uint64_t)(unsigned long)info->vring.used,
 	};
 	int r;
+	unsigned long long features = dev->vdev.features[0];
+	if (sizeof features > sizeof dev->vdev.features[0])
+		features |= ((unsigned long long)dev->vdev.features[1]) << 32;
+
 	r = ioctl(dev->control, VHOST_SET_FEATURES, &features);
 	assert(r >= 0);
 	state.num = info->vring.num;
@@ -107,7 +110,8 @@ static void vdev_info_init(struct vdev_info* dev, unsigned long long features)
 	int r;
 	memset(dev, 0, sizeof *dev);
 	dev->vdev.features[0] = features;
-	dev->vdev.features[1] = features >> 32;
+	if (sizeof features > sizeof dev->vdev.features[0])
+		dev->vdev.features[1] = features >> 32;
 	dev->buf_size = 1024;
 	dev->buf = malloc(dev->buf_size);
 	assert(dev->buf);
-- 
1.7.5.53.gc233e

