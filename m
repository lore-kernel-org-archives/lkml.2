Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161905Ab2GLWlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:41:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161766Ab2GLWlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:41:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Antonio Quartulli <ordex@autistici.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 101/187] batman-adv: fix skb->data assignment
Date: Thu, 12 Jul 2012 15:34:17 -0700
Message-Id: <20120712191531.768469004@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/batman-adv/routing.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -618,6 +618,8 @@ int recv_tt_query(struct sk_buff *skb, s
 			 * changes */
 			if (skb_linearize(skb) < 0)
 				goto out;
+			/* skb_linearize() possibly changed skb->data */
+			tt_query = (struct tt_query_packet *)skb->data;
 
 			tt_len = tt_query->tt_data * sizeof(struct tt_change);
 


