Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab1BBAoh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:44:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:8119 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab1BBAof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="653505173"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: kilroyd@googlemail.com, linville@tuxdriver.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [83/139] orinoco: fix TKIP countermeasure behaviour
Message-Id: <20110202004440.A2CEE3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: David Kilroy <kilroyd@googlemail.com>

commit 0a54917c3fc295cb61f3fb52373c173fd3b69f48 upstream.

Enable the port when disabling countermeasures, and disable it on
enabling countermeasures.

This bug causes the response of the system to certain attacks to be
ineffective.

It also prevents wpa_supplicant from getting scan results, as
wpa_supplicant disables countermeasures on startup - preventing the
hardware from scanning.

wpa_supplicant works with ap_mode=2 despite this bug because the commit
handler re-enables the port.

The log tends to look like:

State: DISCONNECTED -> SCANNING
Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 5 seconds
EAPOL: disable timer tick
EAPOL: Supplicant port status: Unauthorized
Scan timeout - try to get results
Failed to get scan results
Failed to get scan results - try scanning again
Setting scan request: 1 sec 0 usec
Starting AP scan for wildcard SSID
Scan requested (ret=-1) - scan timeout 5 seconds
Failed to initiate AP scan.

Reported by: Giacomo Comes <comes@naic.edu>
Signed-off by: David Kilroy <kilroyd@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/wireless/orinoco/wext.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/net/wireless/orinoco/wext.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/orinoco/wext.c
+++ linux-2.6.35.y/drivers/net/wireless/orinoco/wext.c
@@ -904,10 +904,10 @@ static int orinoco_ioctl_set_auth(struct
 		 */
 		if (param->value) {
 			priv->tkip_cm_active = 1;
-			ret = hermes_enable_port(hw, 0);
+			ret = hermes_disable_port(hw, 0);
 		} else {
 			priv->tkip_cm_active = 0;
-			ret = hermes_disable_port(hw, 0);
+			ret = hermes_enable_port(hw, 0);
 		}
 		break;
 
