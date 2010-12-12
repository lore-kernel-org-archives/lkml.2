Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab0LLXph (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:45:37 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44589 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab0LLXpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:08 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: lrodriguez@atheros.com, linville@tuxdriver.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [12/223] cfg80211: fix regression on processing country IEs
Message-Id: <20101212234507.6BD22B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:07 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit a171fba491f54216e356efa46096171a7ed01d10 upstream.

The patch 4f366c5:

	wireless: only use alpha2 regulatory information from country IE

removed some complex intersection we were always doing between the AP's
country IE info and what we got from CRDA. When CRDA sent us back a
regulatory domain we would do some sanity checks on that regulatory
domain response we just got. Part of these sanity checks included
checking that we already had performed an intersection for the
request of NL80211_REGDOM_SET_BY_COUNTRY_IE type.

This mean that cfg80211 was only processing country IEs for cases
where we already had an intersection, but since we removed enforcing
this this is no longer required, we should just apply the country
IE country hint with the data received from CRDA.

This patch has fixes intended for kernels >= 2.6.36.
[AK: it seems to be needed for .35 too?? Kept for now]

Reported-by: Easwar Krishnan <easwar.krishnan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/wireless/reg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/net/wireless/reg.c
===================================================================
--- linux.orig/net/wireless/reg.c
+++ linux/net/wireless/reg.c
@@ -1695,7 +1695,7 @@ static int ignore_request(struct wiphy *
 				return 0;
 			return -EALREADY;
 		}
-		return REG_INTERSECT;
+		return 0;
 	case NL80211_REGDOM_SET_BY_DRIVER:
 		if (last_request->initiator == NL80211_REGDOM_SET_BY_CORE) {
 			if (regdom_changes(pending_request->alpha2))
