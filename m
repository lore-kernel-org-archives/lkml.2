Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761379Ab2J2ViD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:38:03 -0400
Received: from mail.kernel.org ([198.145.19.201]:47929 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761357Ab2J2Vh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Markus Kanet <dvmailing@gmx.eu>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 081/101] b43: Fix oops on unload when firmware not found
Date: Mon, 29 Oct 2012 14:35:34 -0700
Message-Id: <20121029213249.288010784@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/b43/main.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -5374,6 +5374,8 @@ static void b43_bcma_remove(struct bcma_
 	cancel_work_sync(&wldev->restart_work);
 
 	B43_WARN_ON(!wl);
+	if (!wldev->fw.ucode.data)
+		return;			/* NULL if firmware never loaded */
 	if (wl->current_dev == wldev && wl->hw_registred) {
 		b43_leds_stop(wldev);
 		ieee80211_unregister_hw(wl->hw);
@@ -5448,6 +5450,8 @@ static void b43_ssb_remove(struct ssb_de
 	cancel_work_sync(&wldev->restart_work);
 
 	B43_WARN_ON(!wl);
+	if (!wldev->fw.ucode.data)
+		return;			/* NULL if firmware never loaded */
 	if (wl->current_dev == wldev && wl->hw_registred) {
 		b43_leds_stop(wldev);
 		ieee80211_unregister_hw(wl->hw);


