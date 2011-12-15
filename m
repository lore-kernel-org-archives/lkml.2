Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab1LOH2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 02:28:53 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:44111 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373Ab1LOH2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 02:28:49 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentincj@iksaif.net>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] samsung-laptop: fix seclinux rfkill and us it as fallback
Date: Thu, 15 Dec 2011 08:27:39 +0100
Message-Id: <1323934059-1221-10-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323934059-1221-1-git-send-email-corentincj@iksaif.net>
References: <1323934059-1221-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/samsung-laptop.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index 573e94b..dae1244 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -541,7 +541,8 @@ static const struct backlight_ops backlight_ops = {
 
 static int seclinux_rfkill_set(void *data, bool blocked)
 {
-	struct samsung_laptop *samsung = data;
+	struct samsung_rfkill *srfkill = data;
+	struct samsung_laptop *samsung = srfkill->samsung;
 	const struct sabi_commands *commands = &samsung->config->commands;
 
 	return sabi_set_commandb(samsung, commands->set_wireless_button,
@@ -889,8 +890,13 @@ static int __init samsung_rfkill_init_swsmi(struct samsung_laptop *samsung)
 	int ret;
 
 	ret = swsmi_wireless_status(samsung, &data);
-	if (ret)
+	if (ret) {
+		/* Some swsmi laptops use the old seclinux way to control
+		 * wireless devices */
+		if (ret == -EINVAL)
+			ret = samsung_rfkill_init_seclinux(samsung);
 		return ret;
+	}
 
 	/* 0x02 seems to mean that the device is no present/available */
 
-- 
1.7.5.4

