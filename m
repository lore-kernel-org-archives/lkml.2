Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab2LMOwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:52:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44349 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498Ab2LMOFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:05:48 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 082/241] mac80211: don't send null data packet when not associated
Date: Thu, 13 Dec 2012 11:57:27 -0200
Message-Id: <1355407206-17100-83-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 20f544eea03db4b498942558b882d463ce575c3e upstream.

On resume or firmware recovery, mac80211 sends a null
data packet to see if the AP is still around and hasn't
disconnected us. However, it always does this even if
it wasn't even connected before, leading to a warning
in the new channel context code. Fix this by checking
that it's associated.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/mac80211/util.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 9ff0a85..4d83d11 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1400,6 +1400,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		list_for_each_entry(sdata, &local->interfaces, list) {
 			if (sdata->vif.type != NL80211_IFTYPE_STATION)
 				continue;
+			if (!sdata->u.mgd.associated)
+				continue;
 
 			ieee80211_send_nullfunc(local, sdata, 0);
 		}
-- 
1.7.9.5

