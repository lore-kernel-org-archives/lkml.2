Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab3AGBoL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 20:44:11 -0500
Received: from amsterdam.lcs.mit.edu ([18.26.4.9]:10448 "EHLO
	amsterdam.lcs.mit.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab3AGBoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 20:44:10 -0500
X-Greylist: delayed 972 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Jan 2013 20:44:09 EST
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Lennert Buytenhek <buytenh@wantstofly.org>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: Nickolai Zeldovich <nickolai@csail.mit.edu>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/net/wireless/mwl8k.c: avoid use-after-free
Date: Sun,  6 Jan 2013 20:27:22 -0500
Message-Id: <1357522042-39255-1-git-send-email-nickolai@csail.mit.edu>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not dereference p->station_id after kfree(cmd) because p
points into the cmd data structure.

Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---
 drivers/net/wireless/mwl8k.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index f221b95..83564d3 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -4250,9 +4250,11 @@ static int mwl8k_cmd_update_stadb_add(struct ieee80211_hw *hw,
 	p->amsdu_enabled = 0;
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
+	if (!rc)
+		rc = p->station_id;
 	kfree(cmd);
 
-	return rc ? rc : p->station_id;
+	return rc;
 }
 
 static int mwl8k_cmd_update_stadb_del(struct ieee80211_hw *hw,
-- 
1.7.10.4

