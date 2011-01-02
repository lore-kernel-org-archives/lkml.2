Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab1ABHXr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:23:47 -0500
Received: from mail.windriver.com ([147.11.1.11]:35816 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab1ABHXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:45 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 077/260] wireless extensions: fix kernel heap content leak
Date: Sun,  2 Jan 2011 02:16:13 -0500
Message-Id: <1293952756-15010-78-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:31.0695 (UTC) FILETIME=[ADE65BF0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 42da2f948d949efd0111309f5827bf0298bcc9a4 upstream.

Wireless extensions have an unfortunate, undocumented
requirement which requires drivers to always fill
iwp->length when returning a successful status. When
a driver doesn't do this, it leads to a kernel heap
content leak when userspace offers a larger buffer
than would have been necessary.

Arguably, this is a driver bug, as it should, if it
returns 0, fill iwp->length, even if it separately
indicated that the buffer contents was not valid.

However, we can also at least avoid the memory content
leak if the driver doesn't do this by setting the iwp
length to max_tokens, which then reflects how big the
buffer is that the driver may fill, regardless of how
big the userspace buffer is.

To illustrate the point, this patch also fixes a
corresponding cfg80211 bug (since this requirement
isn't documented nor was ever pointed out by anyone
during code review, I don't trust all drivers nor
all cfg80211 handlers to implement it correctly).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/wireless/wext-compat.c |    3 +++
 net/wireless/wext-core.c   |   16 ++++++++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index a60a277..68202f9 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1415,6 +1415,9 @@ int cfg80211_wext_giwessid(struct net_device *dev,
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
+	data->flags = 0;
+	data->length = 0;
+
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_ADHOC:
 		return cfg80211_ibss_wext_giwessid(dev, info, data, ssid);
diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
index 4f5a470..f916f5a 100644
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -782,6 +782,22 @@ static int ioctl_standard_iw_point(struct iw_point *iwp, unsigned int cmd,
 		}
 	}
 
+	if (IW_IS_GET(cmd) && !(descr->flags & IW_DESCR_FLAG_NOMAX)) {
+		/*
+		 * If this is a GET, but not NOMAX, it means that the extra
+		 * data is not bounded by userspace, but by max_tokens. Thus
+		 * set the length to max_tokens. This matches the extra data
+		 * allocation.
+		 * The driver should fill it with the number of tokens it
+		 * provided, and it may check iwp->length rather than having
+		 * knowledge of max_tokens. If the driver doesn't change the
+		 * iwp->length, this ioctl just copies back max_token tokens
+		 * filled with zeroes. Hopefully the driver isn't claiming
+		 * them to be valid data.
+		 */
+		iwp->length = descr->max_tokens;
+	}
+
 	err = handler(dev, info, (union iwreq_data *) iwp, extra);
 
 	iwp->length += essid_compat;
-- 
1.7.3.3

