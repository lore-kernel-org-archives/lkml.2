Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab2JJW4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 18:56:01 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35668 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757544Ab2JJWzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 18:55:50 -0400
X-Sasl-enc: uBRGaY4y7eo/iscYJ/q+wOfjlEBJ0fPUj2WM2j/1lLRZ 1349909749
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ed Cashin <ecashin@coraid.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 057/133] net: do not disable sg for packets requiring no checksum
Date: Thu, 11 Oct 2012 07:51:23 +0900
Message-Id: <20121010224904.767625909@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010224854.313159132@linuxfoundation.org>
References: <20121010224854.313159132@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Ed Cashin <ecashin@coraid.com>

[ Upstream commit c0d680e577ff171e7b37dbdb1b1bf5451e851f04 ]

A change in a series of VLAN-related changes appears to have
inadvertently disabled the use of the scatter gather feature of
network cards for transmission of non-IP ethernet protocols like ATA
over Ethernet (AoE).  Below is a reference to the commit that
introduces a "harmonize_features" function that turns off scatter
gather when the NIC does not support hardware checksumming for the
ethernet protocol of an sk buff.

  commit f01a5236bd4b140198fbcc550f085e8361fd73fa
  Author: Jesse Gross <jesse@nicira.com>
  Date:   Sun Jan 9 06:23:31 2011 +0000

      net offloading: Generalize netif_get_vlan_features().

The can_checksum_protocol function is not equipped to consider a
protocol that does not require checksumming.  Calling it for a
protocol that requires no checksum is inappropriate.

The patch below has harmonize_features call can_checksum_protocol when
the protocol needs a checksum, so that the network layer is not forced
to perform unnecessary skb linearization on the transmission of AoE
packets.  Unnecessary linearization results in decreased performance
and increased memory pressure, as reported here:

  http://www.spinics.net/lists/linux-mm/msg15184.html

The problem has probably not been widely experienced yet, because
only recently has the kernel.org-distributed aoe driver acquired the
ability to use payloads of over a page in size, with the patchset
recently included in the mm tree:

  https://lkml.org/lkml/2012/8/28/140

The coraid.com-distributed aoe driver already could use payloads of
greater than a page in size, but its users generally do not use the
newest kernels.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2119,7 +2119,8 @@ static bool can_checksum_protocol(netdev
 static netdev_features_t harmonize_features(struct sk_buff *skb,
 	__be16 protocol, netdev_features_t features)
 {
-	if (!can_checksum_protocol(features, protocol)) {
+	if (skb->ip_summed != CHECKSUM_NONE &&
+	    !can_checksum_protocol(features, protocol)) {
 		features &= ~NETIF_F_ALL_CSUM;
 		features &= ~NETIF_F_SG;
 	} else if (illegal_highdma(skb->dev, skb)) {


