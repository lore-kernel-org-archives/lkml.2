Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161396Ab1FAIJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:09:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161370Ab1FAIJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:09:23 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:01 2011
Message-Id: <20110601080300.555168400@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:31 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jouni Malinen <jouni.malinen@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [035/146] nl80211: Fix set_key regression with some drivers
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jouni Malinen <jouni.malinen@atheros.com>

commit 0e579d6a8f4aea346da818f13ee71401c125e639 upstream.

Commit dbd2fd656f2060abfd3a16257f8b51ec60f6d2ed added a mechanism for
user space to indicate whether a default key is being configured for
only unicast or only multicast frames instead of all frames. This
commit added a driver capability flag for indicating whether separate
default keys are supported and validation of the set_key command based
on that capability.

However, this single capability flag is not enough to cover possible
difference based on mode (AP/IBSS/STA) and the way this change was
introduced resulted in a regression with drivers that do not indicate
the new capability (i.e.., more or less any non-mac80211 driver using
cfg80211) when using a recent wpa_supplicant snapshot.

Fix the regression by removing the new check which is not strictly
speaking needed. The new separate default key functionality is needed
only for RSN IBSS which has a separate capability indication.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/nl80211.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1679,14 +1679,6 @@ static int nl80211_set_key(struct sk_buf
 		if (err)
 			goto out;
 
-		if (!(rdev->wiphy.flags &
-				WIPHY_FLAG_SUPPORTS_SEPARATE_DEFAULT_KEYS)) {
-			if (!key.def_uni || !key.def_multi) {
-				err = -EOPNOTSUPP;
-				goto out;
-			}
-		}
-
 		err = rdev->ops->set_default_key(&rdev->wiphy, dev, key.idx,
 						 key.def_uni, key.def_multi);
 


