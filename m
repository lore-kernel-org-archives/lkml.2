Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab1ERWBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 18:01:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337Ab1ERWBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 18:01:36 -0400
Date: Thu, 19 May 2011 01:01:25 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: rusty@rustcorp.com.au, habanero@linux.vnet.ibm.com,
        Shirley Ma <mashirle@us.ibm.com>, Krishna Kumar2 <krkumar2@in.ibm.com>,
        kvm@vger.kernel.org, steved@us.ibm.com,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, borntraeger@de.ibm.com,
        avi@redhat.com
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC] virtio_net: fix patch: virtio_net: limit xmit polling
Message-ID: <20110518220125.GA26835@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch  virtio_net: limit xmit polling
got the logic reversed: it polled while we had
capacity not while ring was empty.

Fix it up and clean up a bit by using a for loop.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

OK, turns out that patch was borken. Here's
a fix that survived stress test on my box.
Pushed on my branch, I'll send a rebased series
with Rusty's comments addressed ASAP.

 drivers/net/virtio_net.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 9982bd7..c8cd22d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -514,12 +514,14 @@ static bool free_old_xmit_skbs(struct virtnet_info *vi, int capacity)
 	struct sk_buff *skb;
 	unsigned int len;
 	bool c;
+	int n;
+
 	/* We try to free up at least 2 skbs per one sent, so that we'll get
 	 * all of the memory back if they are used fast enough. */
-	int n = 2;
-
-	while ((c = virtqueue_get_capacity(vi->svq) >= capacity) && --n > 0 &&
-	       (skb = virtqueue_get_buf(vi->svq, &len)) != NULL) {
+	for (n = 0;
+	     ((c = virtqueue_get_capacity(vi->svq)) < capacity || n < 2) &&
+	     ((skb = virtqueue_get_buf(vi->svq, &len)));
+	     ++n) {
 		pr_debug("Sent skb %p\n", skb);
 		vi->dev->stats.tx_bytes += skb->len;
 		vi->dev->stats.tx_packets++;
-- 
1.7.5.53.gc233e
