Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807Ab2EBDsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 23:48:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758515Ab2EBDsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 23:48:01 -0400
Subject: [V2 PATCH 8/9] vhost_net: zerocopy: adding and signalling
 immediately when fully copied
To: eric.dumazet@gmail.com, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        davem@davemloft.net
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 02 May 2012 11:42:41 +0800
Message-ID: <20120502034241.11782.9650.stgit@amd-6168-8-1.englab.nay.redhat.com>
In-Reply-To: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
References: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
User-Agent: StGit/0.16-1-g60c4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a packet were fully copied in zerocopy, we don't wait for the DMA done to
mark the done flag, so after the packet were passed to lower device, we need to
add used and signal guest immediately.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 62828aa..1dc2aeb 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -266,6 +266,8 @@ static void handle_tx(struct vhost_net *net)
 				 " len %d != %zd\n", err, len);
 		if (!zcopy)
 			vhost_add_used_and_signal(&net->dev, vq, head, 0);
+		else
+			vhost_zerocopy_signal_used(vq);
 		total_len += len;
 		if (unlikely(total_len >= VHOST_NET_WEIGHT)) {
 			vhost_poll_queue(&vq->poll);

