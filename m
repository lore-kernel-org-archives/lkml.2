Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab2AWXux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:50:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210Ab2AWXut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:50:49 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 15:40:27 2012
Message-Id: <20120123234027.555209334@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 15:39:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nick Bowler <nbowler@elliptictech.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [54/90] ah: Read nexthdr value before overwriting it in ahash input callback.
In-Reply-To: <20120123234211.GA19504@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Bowler <nbowler@elliptictech.com>

commit b7ea81a58adc123a4e980cb0eff9eb5c144b5dc7 upstream.

The AH4/6 ahash input callbacks read out the nexthdr field from the AH
header *after* they overwrite that header.  This is obviously not going
to end well.  Fix it up.

Signed-off-by: Nick Bowler <nbowler@elliptictech.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/ah4.c |    4 ++--
 net/ipv6/ah6.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -262,12 +262,12 @@ static void ah_input_done(struct crypto_
 	if (err)
 		goto out;
 
+	err = ah->nexthdr;
+
 	skb->network_header += ah_hlen;
 	memcpy(skb_network_header(skb), work_iph, ihl);
 	__skb_pull(skb, ah_hlen + ihl);
 	skb_set_transport_header(skb, -ihl);
-
-	err = ah->nexthdr;
 out:
 	kfree(AH_SKB_CB(skb)->tmp);
 	xfrm_input_resume(skb, err);
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -464,12 +464,12 @@ static void ah6_input_done(struct crypto
 	if (err)
 		goto out;
 
+	err = ah->nexthdr;
+
 	skb->network_header += ah_hlen;
 	memcpy(skb_network_header(skb), work_iph, hdr_len);
 	__skb_pull(skb, ah_hlen + hdr_len);
 	skb_set_transport_header(skb, -hdr_len);
-
-	err = ah->nexthdr;
 out:
 	kfree(AH_SKB_CB(skb)->tmp);
 	xfrm_input_resume(skb, err);


