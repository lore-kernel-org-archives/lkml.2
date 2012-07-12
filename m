Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161938Ab2GLWlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:41:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54985 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161893Ab2GLWlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:41:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marek Lindner <lindner_marek@yahoo.de>,
        Antonio Quartulli <ordex@autistici.org>
Subject: [ 102/187] batman-adv: only drop packets of known wifi clients
Date: Thu, 12 Jul 2012 15:34:18 -0700
Message-Id: <20120712191531.858175888@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/batman-adv/translation-table.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -1803,10 +1803,10 @@ bool is_ap_isolated(struct bat_priv *bat
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
@@ -1816,10 +1816,10 @@ bool is_ap_isolated(struct bat_priv *bat
 	if (!tt_global_entry)
 		goto out;
 
-	if (_is_ap_isolated(tt_local_entry, tt_global_entry))
+	if (!_is_ap_isolated(tt_local_entry, tt_global_entry))
 		goto out;
 
-	ret = false;
+	ret = true;
 
 out:
 	if (tt_global_entry)


