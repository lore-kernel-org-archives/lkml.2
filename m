Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab1FPHh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:37:59 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:57008 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755600Ab1FPHAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:47 -0400
X-Sasl-enc: Z9z/skfmpeeUOW5VW5Q4r6cSg6wgTYktu55FGJ34ymsi 1308207646
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:32 2011
Message-Id: <20110616000232.144446356@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Luciano Coelho <coelho@ti.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [32/89] nl80211: fix check for valid SSID size in scan operations
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

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
@@ -3239,12 +3239,12 @@ static int nl80211_trigger_scan(struct s
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


