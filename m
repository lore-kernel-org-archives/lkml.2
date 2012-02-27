Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab2B0ECl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 23:02:41 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:33636 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753263Ab2B0ECj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 23:02:39 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of larry.finger@gmail.com designates 10.50.156.225 as permitted sender) smtp.mail=larry.finger@gmail.com; dkim=pass header.i=larry.finger@gmail.com
From: Larry Finger <Larry.Finger@lwfinger.net>
To: gregkh@linuxfoundation.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH] staging: r8712u: Fix regression in signal level after commit c6dc001
Date: Sun, 26 Feb 2012 22:02:27 -0600
Message-Id: <1330315347-7904-1-git-send-email-Larry.Finger@lwfinger.net>
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

