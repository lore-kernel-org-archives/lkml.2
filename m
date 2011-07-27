Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab1G0Vsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:48:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:35829 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755549Ab1G0Vsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="30900621"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: coelho@ti.com, linville@tuxdriver.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [41/99] nl80211: fix check for valid SSID size in scan operations
Message-Id: <20110727214840.10EF42403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>


---
 net/wireless/nl80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/net/wireless/nl80211.c
===================================================================
--- linux-2.6.35.y.orig/net/wireless/nl80211.c
+++ linux-2.6.35.y/net/wireless/nl80211.c
@@ -3179,12 +3179,12 @@ static int nl80211_trigger_scan(struct s
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
