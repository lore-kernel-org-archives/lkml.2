Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564Ab0GAUuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:50:19 -0400
Received: from kroah.org ([198.145.64.141]:47325 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932603Ab0GAUt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:49:58 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:30 2010
Message-Id: <20100701173430.639716853@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:33:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jouni Malinen <j@w1.fi>, "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 045/164] mac80211: Fix robust management frame handling (MFP)
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Malinen <j@w1.fi>

commit d211e90e28a074447584729018a39910d691d1a8 upstream.

Commit e34e09401ee9888dd662b2fca5d607794a56daf2 incorrectly removed
use of ieee80211_has_protected() from the management frame case and in
practice, made this validation drop all Action frames when MFP is
enabled. This should have only been done for frames with Protected
field set to zero.

Signed-off-by: Jouni Malinen <j@w1.fi>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/rx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1399,7 +1399,8 @@ ieee80211_drop_unencrypted(struct ieee80
 		     (rx->key || rx->sdata->drop_unencrypted)))
 		return -EACCES;
 	if (rx->sta && test_sta_flags(rx->sta, WLAN_STA_MFP)) {
-		if (unlikely(ieee80211_is_unicast_robust_mgmt_frame(rx->skb) &&
+		if (unlikely(!ieee80211_has_protected(fc) &&
+			     ieee80211_is_unicast_robust_mgmt_frame(rx->skb) &&
 			     rx->key))
 			return -EACCES;
 		/* BIP does not use Protected field, so need to check MMIE */


