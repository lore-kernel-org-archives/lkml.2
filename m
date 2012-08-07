Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab2HGW3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:29:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab2HGW3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:29:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Antonio Quartulli <ordex@autistici.org>,
        Sven Eckelmann <sven@narfation.org>
Subject: [ 040/122] batman-adv: fix skb->data assignment
Date: Tue,  7 Aug 2012 15:25:28 -0700
Message-Id: <20120807221951.826510164@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Quartulli <ordex@autistici.org>

commit d2b6cc8e460494251442a877fcbc150faa175b4f upstream.

skb_linearize(skb) possibly rearranges the skb internal data and then changes
the skb->data pointer value. For this reason any other pointer in the code that
was assigned skb->data before invoking skb_linearise(skb) must be re-assigned.

In the current tt_query message handling code this is not done and therefore, in
case of skb linearization, the pointer used to handle the packet header ends up
in pointing to poisoned memory. The packet is then dropped but the
translation-table mechanism is corrupted.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/batman-adv/routing.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -626,6 +626,8 @@ int recv_tt_query(struct sk_buff *skb, s
 			if (unlikely(skb_headlen(skb) <
 				     sizeof(struct tt_query_packet) + tt_len))
 				goto out;
+			/* skb_linearize() possibly changed skb->data */
+			tt_query = (struct tt_query_packet *)skb->data;
 
 			handle_tt_response(bat_priv, tt_query);
 		} else {


