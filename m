Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab2DPGRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 02:17:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373Ab2DPGQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 02:16:59 -0400
Subject: [PATCH 4/6] macvtap: zerocopy: set SKBTX_DEV_ZEROCOPY only when skb
	is built successfully
To: netdev@vger.kernel.org, xma@us.ibm.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, mst@redhat.com
From: Jason Wang <jasowang@redhat.com>
Cc: ebiederm@xmission.com
Date: Mon, 16 Apr 2012 14:08:16 +0800
Message-ID: <20120416060816.14140.42824.stgit@intel-e5620-16-2.englab.nay.redhat.com>
In-Reply-To: <20120416060749.14140.19433.stgit@intel-e5620-16-2.englab.nay.redhat.com>
References: <20120416060749.14140.19433.stgit@intel-e5620-16-2.englab.nay.redhat.com>
User-Agent: StGit/0.15
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
index d197a78..c030468 100644
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

