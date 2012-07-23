Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab2GWBmT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:42:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53967 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752862Ab2GWBmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:12 -0400
Message-Id: <20120723010654.414283596@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:10 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [ 019/108] macvtap: zerocopy: set SKBTX_DEV_ZEROCOPY only when skb is  built successfully
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

commit 01d6657b388438def19c8baaea28e742b6ed32ec upstream.

Current the SKBTX_DEV_ZEROCOPY is set unconditionally after
zerocopy_sg_from_iovec(), this would lead NULL pointer when macvtap
fails to build zerocopy skb because destructor_arg was not
initialized. Solve this by set this flag after the skb were built
successfully.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/macvtap.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

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



