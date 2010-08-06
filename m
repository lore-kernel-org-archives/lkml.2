Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935710Ab0HFTAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:00:48 -0400
Received: from kroah.org ([198.145.64.141]:58581 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965094Ab0HFTAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:00:17 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 11:58:35 2010
Message-Id: <20100806185835.552418009@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 11:57:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [19/34] cfg80211: ignore spurious deauth
In-Reply-To: <20100806185853.GA28270@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 643f82e32f14faf0d0944c804203a6681b6b0a1e upstream.

Ever since mac80211/drivers are no longer
fully in charge of keeping track of the
auth status, trying to make them do so will
fail. Instead of warning and reporting the
deauthentication to userspace, cfg80211 must
simply ignore it so that spurious
deauthentications, e.g. before starting
authentication, aren't seen by userspace as
actual deauthentications.

Reported-by: Paul Stewart <pstew@google.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/mlme.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -43,10 +43,10 @@ void cfg80211_send_rx_auth(struct net_de
 		}
 	}
 
-	WARN_ON(!done);
-
-	nl80211_send_rx_auth(rdev, dev, buf, len, GFP_KERNEL);
-	cfg80211_sme_rx_auth(dev, buf, len);
+	if (done) {
+		nl80211_send_rx_auth(rdev, dev, buf, len, GFP_KERNEL);
+		cfg80211_sme_rx_auth(dev, buf, len);
+	}
 
 	wdev_unlock(wdev);
 }


