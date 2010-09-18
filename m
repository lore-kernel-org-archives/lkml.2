Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab0IRTWb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:22:31 -0400
Received: from kroah.org ([198.145.64.141]:43767 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757144Ab0IRTQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:16:05 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:05 2010
Message-Id: <20100918191305.654200111@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [097/129] wireless extensions: fix kernel heap content leak
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/wext-compat.c |    3 +++
 net/wireless/wext-core.c   |   16 ++++++++++++++++
 2 files changed, 19 insertions(+)

--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1420,6 +1420,9 @@ int cfg80211_wext_giwessid(struct net_de
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
+	data->flags = 0;
+	data->length = 0;
+
 	switch (wdev->iftype) {
 	case NL80211_IFTYPE_ADHOC:
 		return cfg80211_ibss_wext_giwessid(dev, info, data, ssid);
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -782,6 +782,22 @@ static int ioctl_standard_iw_point(struc
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


