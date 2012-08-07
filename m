Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711Ab2HGDyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:54:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59629 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757283Ab2HGDiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:12 -0400
Message-Id: <20120807032757.155880179@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:02 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Liang Li <liang.li@windriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [ 07/70] cfg80211: fix interface combinations check for  ADHOC(IBSS)
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/wireless/util.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index b5b6890..88bd89e 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -974,6 +974,9 @@ int cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
 	}
 	mutex_unlock(&rdev->devlist_mtx);
 
+	if (total == 1)
+		return 0;
+
 	for (i = 0; i < rdev->wiphy.n_iface_combinations; i++) {
 		const struct ieee80211_iface_combination *c;
 		struct ieee80211_iface_limit *limits;


