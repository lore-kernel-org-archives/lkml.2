Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759119Ab1KWAhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:37:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759089Ab1KWAhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:37:23 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:25:57 2011
Message-Id: <20111123002557.517833330@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:25:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Antonio Quartulli <ordex@autistici.org>,
        Marek Lindner <lindner_marek@yahoo.de>
Subject: [49/53] batman-adv: correctly set the data field in the TT_REPONSE packet
In-Reply-To: <20111123002601.GA14467@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Quartulli <ordex@autistici.org>

commit 9d8523931f7f5eb8900077f0da0fbe6b8ad0010b upstream.

In the TT_RESPONSE packet, the number of carried entries is not correctly set.
This leads to a wrong interpretation of the packet payload on the receiver side
causing random entries to be added to the global translation table. Therefore
the latter gets always corrupted, triggering a table recovery all the time.

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
Signed-off-by: Marek Lindner <lindner_marek@yahoo.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/batman-adv/translation-table.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -999,7 +999,6 @@ static struct sk_buff *tt_response_fill_
 	tt_response = (struct tt_query_packet *)skb_put(skb,
 						     tt_query_size + tt_len);
 	tt_response->ttvn = ttvn;
-	tt_response->tt_data = htons(tt_tot);
 
 	tt_change = (struct tt_change *)(skb->data + tt_query_size);
 	tt_count = 0;
@@ -1025,6 +1024,10 @@ static struct sk_buff *tt_response_fill_
 	}
 	rcu_read_unlock();
 
+	/* store in the message the number of entries we have successfully
+	 * copied */
+	tt_response->tt_data = htons(tt_count);
+
 out:
 	return skb;
 }


