Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab1LGQzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:55:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33360 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757431Ab1LGQTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:19:00 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:28 2011
Message-Id: <20111207160828.005449411@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:07:26 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Johannes Berg <johannes.berg@intel.com>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [66/80] cfg80211: amend regulatory NULL dereference fix
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>

commit 0bac71af6e66dc798bf07d0c0dd14ee5503362f9 upstream.

Johannes' patch for "cfg80211: fix regulatory NULL dereference"
broke user regulaotry hints and it did not address the fact that
last_request was left populated even if the previous regulatory
hint was stale due to the wiphy disappearing.

Fix user reguluatory hints by only bailing out if for those
regulatory hints where a request_wiphy is expected. The stale last_request
considerations are addressed through the previous fixes on last_request
where we reset the last_request to a static world regdom request upon
reset_regdomains(). In this case though we further enhance the effect
by simply restoring reguluatory settings completely.

Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/reg.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2040,8 +2040,10 @@ static int __set_regdom(const struct iee
 	}
 
 	request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
-	if (!request_wiphy) {
-		reg_set_request_processed();
+	if (!request_wiphy &&
+	    (last_request->initiator == NL80211_REGDOM_SET_BY_DRIVER ||
+	     last_request->initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE)) {
+		schedule_delayed_work(&reg_timeout, 0);
 		return -ENODEV;
 	}
 


