Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab2GASQh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:16:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46956 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751964Ab2GASQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:34 -0400
Message-Id: <20120701172013.468545884@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:54 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Marek Lindner <lindner_marek@yahoo.de>,
        Antonio Quartulli <ordex@autistici.org>
Subject: [ 48/48] batman-adv: only drop packets of known wifi clients
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Lindner <lindner_marek@yahoo.de>

commit 5870adc68fc39d81089f1e80efdf64b97e5c37a1 upstream.

bug introduced with 59b699cdee039d75915c354da06937102d1f9a84

If the source or destination mac address of an ethernet packet
could not be found in the translation table the packet was
dropped if AP isolation was turned on. This behavior would
make it impossible to send broadcast packets over the mesh as
the broadcast address will never enter the translation table.

Signed-off-by: Marek Lindner <lindner_marek@yahoo.de>
Acked-by: Antonio Quartulli <ordex@autistici.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/batman-adv/translation-table.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index a66c2dc..660c40f 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -2031,10 +2031,10 @@ bool is_ap_isolated(struct bat_priv *bat_priv, uint8_t *src, uint8_t *dst)
 {
 	struct tt_local_entry *tt_local_entry = NULL;
 	struct tt_global_entry *tt_global_entry = NULL;
-	bool ret = true;
+	bool ret = false;
 
 	if (!atomic_read(&bat_priv->ap_isolation))
-		return false;
+		goto out;
 
 	tt_local_entry = tt_local_hash_find(bat_priv, dst);
 	if (!tt_local_entry)
@@ -2044,10 +2044,10 @@ bool is_ap_isolated(struct bat_priv *bat_priv, uint8_t *src, uint8_t *dst)
 	if (!tt_global_entry)
 		goto out;
 
-	if (_is_ap_isolated(tt_local_entry, tt_global_entry))
+	if (!_is_ap_isolated(tt_local_entry, tt_global_entry))
 		goto out;
 
-	ret = false;
+	ret = true;
 
 out:
 	if (tt_global_entry)


