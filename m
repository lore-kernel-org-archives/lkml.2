Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744Ab2EBDrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 23:47:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758667Ab2EBDrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 23:47:22 -0400
Subject: [V2 PATCH 4/9] macvtap: zerocopy: set SKBTX_DEV_ZEROCOPY only when
 skb is built successfully
To: eric.dumazet@gmail.com, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        davem@davemloft.net
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 02 May 2012 11:42:06 +0800
Message-ID: <20120502034206.11782.91643.stgit@amd-6168-8-1.englab.nay.redhat.com>
In-Reply-To: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
References: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>
User-Agent: StGit/0.16-1-g60c4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current the SKBTX_DEV_ZEROCOPY is set unconditionally after
zerocopy_sg_from_iovec(), this would lead NULL pointer when macvtap
fails to build zerocopy skb because destructor_arg was not
initialized. Solve this by set this flag after the skb were built
successfully.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/macvtap.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 9ab182a..a4ff694 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -699,10 +699,9 @@ static ssize_t macvtap_get_user(struct macvtap_queue *q, struct msghdr *m,
 	if (!skb)
 		goto err;
 
-	if (zerocopy) {
+	if (zerocopy)
 		err = zerocopy_sg_from_iovec(skb, iv, vnet_hdr_len, count);
-		skb_shinfo(skb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
-	} else
+	else
 		err = skb_copy_datagram_from_iovec(skb, 0, iv, vnet_hdr_len,
 						   len);
 	if (err)
@@ -721,8 +720,10 @@ static ssize_t macvtap_get_user(struct macvtap_queue *q, struct msghdr *m,
 	rcu_read_lock_bh();
 	vlan = rcu_dereference_bh(q->vlan);
 	/* copy skb_ubuf_info for callback when skb has no error */
-	if (zerocopy)
+	if (zerocopy) {
 		skb_shinfo(skb)->destructor_arg = m->msg_control;
+		skb_shinfo(skb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
+	}
 	if (vlan)
 		macvlan_start_xmit(skb, vlan->dev);
 	else

