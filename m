Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab2GMXZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 19:25:49 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38296 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab2GMXZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 19:25:48 -0400
From: Emil Goode <emilgoode@gmail.com>
To: gregkh@linuxfoundation.org, dan.carpenter@oracle.com,
        krzysztof.wilczynski@linux.com, devendra.aaru@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] staging: wlan-ng: Fix problem with wrong arguments
Date: Sat, 14 Jul 2012 01:28:08 +0200
Message-Id: <1342222089-5930-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function pointer scan in struct cfg80211_ops is not
supposed to be assigned	a function with a struct net_device
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

