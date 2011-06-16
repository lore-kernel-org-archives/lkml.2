Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab1FPHRK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:17:10 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:46617 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756832Ab1FPHLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:11:07 -0400
X-Sasl-enc: n+iJvPNyP/dW0LjcunvBBNivmlDjBReEnwJW8fwHf4sB 1308208267
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:09 2011
Message-Id: <20110616002909.831843482@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:28:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Luciano Coelho <coelho@ti.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [60/85] nl80211: fix check for valid SSID size in scan operations
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Luciano Coelho <coelho@ti.com>

commit 208c72f4fe44fe09577e7975ba0e7fa0278f3d03 upstream.

In both trigger_scan and sched_scan operations, we were checking for
the SSID length before assigning the value correctly.  Since the
memory was just kzalloc'ed, the check was always failing and SSID with
over 32 characters were allowed to go through.

This was causing a buffer overflow when copying the actual SSID to the
proper place.

This bug has been there since 2.6.29-rc4.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 net/wireless/nl80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3078,12 +3078,12 @@ static int nl80211_trigger_scan(struct s
 	i = 0;
 	if (info->attrs[NL80211_ATTR_SCAN_SSIDS]) {
 		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS], tmp) {
+			request->ssids[i].ssid_len = nla_len(attr);
 			if (request->ssids[i].ssid_len > IEEE80211_MAX_SSID_LEN) {
 				err = -EINVAL;
 				goto out_free;
 			}
 			memcpy(request->ssids[i].ssid, nla_data(attr), nla_len(attr));
-			request->ssids[i].ssid_len = nla_len(attr);
 			i++;
 		}
 	}


