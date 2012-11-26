Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934021Ab2KZR0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:26:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48146 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933928Ab2KZRO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:14:27 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Markus Kanet <dvmailing@gmx.eu>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 231/270] b43: Fix oops on unload when firmware not found
Date: Mon, 26 Nov 2012 14:58:41 -0200
Message-Id: <1353949160-26803-232-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit f89ff6441df06abc2d95f3ef67525923032d6283 upstream.

When b43 fails to find firmware when loaded, a subsequent unload will
oops due to calling ieee80211_unregister_hw() when the corresponding
register call was never made.

Commit 2d838bb608e2d1f6cb4280e76748cb812dc822e7 fixed the same problem
for b43legacy.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Markus Kanet <dvmailing@gmx.eu>
Cc: Markus Kanet <dvmailing@gmx.eu>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/b43/main.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index b80352b..c04d7b6 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -5369,6 +5369,8 @@ static void b43_bcma_remove(struct bcma_device *core)
 	cancel_work_sync(&wldev->restart_work);
 
 	B43_WARN_ON(!wl);
+	if (!wldev->fw.ucode.data)
+		return;			/* NULL if firmware never loaded */
 	if (wl->current_dev == wldev && wl->hw_registred) {
 		b43_leds_stop(wldev);
 		ieee80211_unregister_hw(wl->hw);
@@ -5443,6 +5445,8 @@ static void b43_ssb_remove(struct ssb_device *sdev)
 	cancel_work_sync(&wldev->restart_work);
 
 	B43_WARN_ON(!wl);
+	if (!wldev->fw.ucode.data)
+		return;			/* NULL if firmware never loaded */
 	if (wl->current_dev == wldev && wl->hw_registred) {
 		b43_leds_stop(wldev);
 		ieee80211_unregister_hw(wl->hw);
-- 
1.7.9.5

