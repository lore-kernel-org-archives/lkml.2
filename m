Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab2GASVF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:21:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47031 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756007Ab2GASQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:43 -0400
Message-Id: <20120701172010.660658441@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:34 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Antonio Quartulli <ordex@autistici.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 28/48] batman-adv: fix skb->data assignment
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Quartulli <ordex@autistici.org>

commit 2c995ff892313009e336ecc8ec3411022f5b1c39 upstream.

skb_linearize(skb) possibly rearranges the skb internal data and then changes
the skb->data pointer value. For this reason any other pointer in the code that
was assigned skb->data before invoking skb_linearise(skb) must be re-assigned.

In the current tt_query message handling code this is not done and therefore, in
case of skb linearization, the pointer used to handle the packet header ends up
in pointing to free'd memory.

This bug was introduced by a73105b8d4c765d9ebfb664d0a66802127d8e4c7
(batman-adv: improved client announcement mechanism)

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
[This patch is a backport for kernel versions 3.1 and 3.2 - Antonio]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/batman-adv/routing.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -619,6 +619,8 @@
 		/* packet needs to be linearized to access the TT changes */
 		if (skb_linearize(skb) < 0)
 			goto out;
+		/* skb_linearize() possibly changed skb->data */
+		tt_query = (struct tt_query_packet *)skb->data;
 
 		if (is_my_mac(tt_query->dst))
 			handle_tt_response(bat_priv, tt_query);


