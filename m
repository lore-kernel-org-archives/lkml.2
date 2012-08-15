Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab2HOTtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:49:17 -0400
Received: from mail.windriver.com ([147.11.1.11]:36387 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab2HOTtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:09 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Luciano Coelho <coelho@ti.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 002/165] nl80211: fix overflow in ssid_len
Date: Wed, 15 Aug 2012 15:45:46 -0400
Message-ID: <1345060109-9187-3-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luciano Coelho <coelho@ti.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 57a27e1d6a3bb9ad4efeebd3a8c71156d6207536 upstream.

When one of the SSID's length passed in a scan or sched_scan request
is larger than 255, there will be an overflow in the u8 that is used
to store the length before checking.  This causes the check to fail
and we overrun the buffer when copying the SSID.

Fix this by checking the nl80211 attribute length before copying it to
the struct.

This is a follow up for the previous commit
208c72f4fe44fe09577e7975ba0e7fa0278f3d03, which didn't fix the problem
entirely.

Reported-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[PG: 34 codebase does not have nl80211_start_sched_scan part]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/wireless/nl80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0ba104f..56bc9b9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3072,11 +3072,11 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	i = 0;
 	if (info->attrs[NL80211_ATTR_SCAN_SSIDS]) {
 		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS], tmp) {
-			request->ssids[i].ssid_len = nla_len(attr);
-			if (request->ssids[i].ssid_len > IEEE80211_MAX_SSID_LEN) {
+			if (nla_len(attr) > IEEE80211_MAX_SSID_LEN) {
 				err = -EINVAL;
 				goto out_free;
 			}
+			request->ssids[i].ssid_len = nla_len(attr);
 			memcpy(request->ssids[i].ssid, nla_data(attr), nla_len(attr));
 			i++;
 		}
-- 
1.7.12.rc2

