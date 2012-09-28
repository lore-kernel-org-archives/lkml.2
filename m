Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032830Ab2I1Uao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:30:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34785 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965024Ab2I1Uaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:30:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 170/218] macvtap: zerocopy: set SKBTX_DEV_ZEROCOPY only when skb is built successfully
Date: Fri, 28 Sep 2012 13:16:27 -0700
Message-Id: <20120928201521.045295346@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/macvtap.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -716,10 +716,9 @@ static ssize_t macvtap_get_user(struct m
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
@@ -738,8 +737,10 @@ static ssize_t macvtap_get_user(struct m
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


