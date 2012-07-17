Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270Ab2GQWFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:05:34 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49204 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164Ab2GQWF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:05:29 -0400
From: Emil Goode <emilgoode@gmail.com>
To: johannes.berg@intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH Resend] staging: wlan-ng: Fix problem with wrong arguments
Date: Wed, 18 Jul 2012 00:07:59 +0200
Message-Id: <1342562879-23212-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function pointer scan in struct cfg80211_ops is not
supposed to be assigned a function with a struct net_device
pointer as an argument. Instead access the net_device struct
in the following way:

struct net_device *dev = request->wdev->netdev;

sparse gives these warnings:

drivers/staging/wlan-ng/cfg80211.c:726:17: warning:
        incorrect type in initializer (incompatible argument 2
        (different base types))
        expected int ( *scan )( ... )
        got int ( extern [toplevel] *<noident> )( ... )

drivers/staging/wlan-ng/cfg80211.c:726:2: warning:
        initialization from incompatible pointer type [enabled by default]

drivers/staging/wlan-ng/cfg80211.c:726:2: warning:
        (near initialization for ‘prism2_usb_cfg_ops.scan’)
        [enabled by default]

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
Hello Johannes,

Your commit fd014284 introduced the sparse warnings that 
this patch fixes. Because your changes are not in the staging
tree or in the net-next tree my patch fails the build on both 
of these trees, so I'm sending the patch to you instead.

Best regards, Emil

 drivers/staging/wlan-ng/cfg80211.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
index fabff4d..0970127 100644
--- a/drivers/staging/wlan-ng/cfg80211.c
+++ b/drivers/staging/wlan-ng/cfg80211.c
@@ -327,9 +327,9 @@ int prism2_get_station(struct wiphy *wiphy, struct net_device *dev,
 	return result;
 }
 
-int prism2_scan(struct wiphy *wiphy, struct net_device *dev,
-		struct cfg80211_scan_request *request)
+int prism2_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 {
+	struct net_device *dev = request->wdev->netdev;
 	struct prism2_wiphy_private *priv = wiphy_priv(wiphy);
 	wlandevice_t *wlandev = dev->ml_priv;
 	struct p80211msg_dot11req_scan msg1;
-- 
1.7.10.4

