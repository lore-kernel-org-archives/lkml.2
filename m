Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab1KCCDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:03:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50889 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933778Ab1KCBhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:37:55 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:59 2011
Message-Id: <20111102221459.831047236@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:15:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Luciano Coelho <coelho@ti.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [106/107] nl80211: fix overflow in ssid_len
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Luciano Coelho <coelho@ti.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/wireless/nl80211.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2995,11 +2995,11 @@ static int nl80211_trigger_scan(struct s
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


