Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab2B0EIr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 23:08:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33242 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab2B0EIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 23:08:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: gregkh@linuxfoundation.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH V2] staging: r8712u: Fix regression in signal level after commit c6dc001
Date: Sun, 26 Feb 2012 22:08:36 -0600
Message-Id: <1330315716-7953-1-git-send-email-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit c6dc001 "staging: r8712u: Merging Realtek's latest (v2.6.6).
Various fixes", the returned qual.qual member of the iw_statistics
struct was changed. For strong signals, this change made no difference;
however for medium and weak signals it results in a low signal that
shows considerable fluctuation, When using wicd for a medium-strength
AP, the value reported in the status line is reduced from 100% to 60% by
this bug.

This problem is reported in https://bugzilla.kernel.org/show_bug.cgi?id=42826.

Reported-and-tested-by: Robert Crawford <wrc1944@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---

V2 - Forgot to Cc stable.
---

 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index 507584b8..ef35bc2 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -2380,13 +2380,7 @@ static struct iw_statistics *r871x_get_wireless_stats(struct net_device *dev)
 		tmp_qual = padapter->recvpriv.signal;
 		tmp_noise = padapter->recvpriv.noise;
 		piwstats->qual.level = tmp_level;
-		/*piwstats->qual.qual = tmp_qual;
-		 * The NetworkManager of Fedora 10, 13 will use the link
-		 * quality for its display.
-		 * So, use the fw_rssi on link quality variable because
-		 * fw_rssi will be updated per 2 seconds.
-		 */
-		piwstats->qual.qual = tmp_level;
+		piwstats->qual.qual = tmp_qual;
 		piwstats->qual.noise = tmp_noise;
 	}
 	piwstats->qual.updated = IW_QUAL_ALL_UPDATED;
-- 
1.7.7

