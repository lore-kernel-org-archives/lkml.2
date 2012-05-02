Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767Ab2EBDrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 23:47:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758594Ab2EBDrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 23:47:40 -0400
Subject: [V2 PATCH 6/9] vhost_net: zerocopy: fix possible NULL pointer
 dereference of vq->bufs
To: eric.dumazet@gmail.com, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        davem@davemloft.net
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 02 May 2012 11:42:23 +0800
Message-ID: <20120502034223.11782.31222.stgit@amd-6168-8-1.englab.nay.redhat.com>
In-Reply-To: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
References: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
User-Agent: StGit/0.16-1-g60c4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we want to disable vhost_net backend while there's a tx work, a possible
NULL pointer defernece may happen we we try to deference the vq->bufs after
vhost_net_set_backend() assign a NULL to it.

As suggested by Michael, fix this by checking the vq->bufs instead of
vhost_sock_zcopy().
---
 drivers/vhost/net.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index f0da2c3..ffdc0d8 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -166,7 +166,7 @@ static void handle_tx(struct vhost_net *net)
 	if (wmem < sock->sk->sk_sndbuf / 2)
 		tx_poll_stop(net);
 	hdr_size = vq->vhost_hlen;
-	zcopy = vhost_sock_zcopy(sock);
+	zcopy = vq->ubufs;
 
 	for (;;) {
 		/* Release DMAs done buffers first */

