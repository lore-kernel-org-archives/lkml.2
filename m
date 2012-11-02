Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763142Ab2KBRQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 13:16:15 -0400
Received: from mail.kernel.org ([198.145.19.201]:33139 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762949Ab2KBRHE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 13:07:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Markus Kanet <dvmailing@gmx.eu>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 06/11] b43: Fix oops on unload when firmware not found
Date: Fri,  2 Nov 2012 10:06:41 -0700
Message-Id: <20121102170314.673624996@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121102170314.204845540@linuxfoundation.org>
References: <20121102170314.204845540@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/wireless/b43/main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -5430,6 +5430,8 @@ static void b43_ssb_remove(struct ssb_de
 	cancel_work_sync(&wldev->restart_work);
 
 	B43_WARN_ON(!wl);
+	if (!wldev->fw.ucode.data)
+		return;			/* NULL if firmware never loaded */
 	if (wl->current_dev == wldev) {
 		/* Restore the queues count before unregistering, because firmware detect
 		 * might have modified it. Restoring is important, so the networking


