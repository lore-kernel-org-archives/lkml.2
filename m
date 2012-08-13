Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab2HMWTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:19:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61337 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab2HMWT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:19:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Liang Li <liang.li@windriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [ 59/65] cfg80211: fix interface combinations check for ADHOC(IBSS)
Date: Mon, 13 Aug 2012 15:14:43 -0700
Message-Id: <20120813221420.197980038@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813221414.965154048@linuxfoundation.org>
References: <20120813221414.965154048@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Liang Li <liang.li@windriver.com>

partial of commit 8e8b41f9d8c8e63fc92f899ace8da91a490ac573 upstream.

As part of commit 463454b5dbd8 ("cfg80211: fix interface
combinations check"), this extra check was introduced:

       if ((all_iftypes & used_iftypes) != used_iftypes)
               goto cont;

However, most wireless NIC drivers did not advertise ADHOC in
wiphy.iface_combinations[i].limits[] and hence we'll get -EBUSY
when we bring up a ADHOC wlan with commands similar to:

 # iwconfig wlan0 mode ad-hoc && ifconfig wlan0 up

In commit 8e8b41f9d8c8e ("cfg80211: enforce lack of interface
combinations"), the change below fixes the issue:

       if (total == 1)
               return 0;

But it also introduces other dependencies for stable. For example,
a full cherry pick of 8e8b41f9d8c8e would introduce additional
regressions unless we also start cherry picking driver specific
fixes like the following:

  9b4760e  ath5k: add possible wiphy interface combinations
  1ae2fc2  mac80211_hwsim: advertise interface combinations
  20c8e8d  ath9k: add possible wiphy interface combinations

And the purpose of the 'if (total == 1)' is to cover the specific
use case (IBSS, adhoc) that was mentioned above. So we just pick
the specific part out from 8e8b41f9d8c8e here.

Doing so gives stable kernels a way to fix the change introduced
by 463454b5dbd8, without having to make cherry picks specific to
various NIC drivers.

Signed-off-by: Liang Li <liang.li@windriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/util.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -974,6 +974,9 @@ int cfg80211_can_change_interface(struct
 	}
 	mutex_unlock(&rdev->devlist_mtx);
 
+	if (total == 1)
+		return 0;
+
 	for (i = 0; i < rdev->wiphy.n_iface_combinations; i++) {
 		const struct ieee80211_iface_combination *c;
 		struct ieee80211_iface_limit *limits;


