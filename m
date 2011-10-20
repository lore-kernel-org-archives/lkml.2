Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab1JTLml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 07:42:41 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:44872 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959Ab1JTLmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 07:42:38 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-m68k@vger.kernel.org,
        "Christian T. Steigies" <cts@debian.org>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ingo=20J=C3=BCrgensmann?= <ij@2011.bluespice.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 4/4] fbdev/cirrusfb: Add support for "64 MiB" version of Picasso IV
Date: Thu, 20 Oct 2011 13:42:25 +0200
Message-Id: <1319110945-25684-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1319110945-25684-1-git-send-email-geert@linux-m68k.org>
References: <1319110945-25684-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Village Tronic Picasso IV graphics cards identify as a 64 MiB Zorro
device in Zorro III mode.

While the total graphics memory size is the same on such cards, the offset
of the graphics memory differs. Add a quirk to handle this.

Based on src/sys/arch/amiga/dev/grf_cl.c from NetBSD.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
--
Untested, due to lack of hardware
---
 drivers/video/cirrusfb.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/video/cirrusfb.c b/drivers/video/cirrusfb.c
index 816433f..6ea505c 100644
--- a/drivers/video/cirrusfb.c
+++ b/drivers/video/cirrusfb.c
@@ -314,7 +314,7 @@ static const struct zorrocl zcl_picasso4_z3 __devinitconst = {
 	.type		= BT_PICASSO4,
 	.regoffset	= 0x00600000,
 	.ramsize	= 4 * MB_,
-	.ramoffset	= 0x01000000,
+	.ramoffset	= 0x01000000,	/* 0x02000000 for 64 MiB boards */
 };
 
 static const struct zorrocl zcl_picasso4_z2 __devinitconst = {
@@ -2259,6 +2259,10 @@ static int __devinit cirrusfb_zorro_register(struct zorro_dev *z,
 	ramsize = zcl->ramsize;
 	if (ramsize) {
 		rambase = zorro_resource_start(z) + zcl->ramoffset;
+		if (zorro_resource_len(z) == 64 * MB_) {
+			/* Quirk for 64 MiB Picasso IV */
+			rambase += zcl->ramoffset;
+		}
 	} else {
 		struct zorro_dev *ram = zorro_find_device(zcl->ramid, NULL);
 		if (!ram || !zorro_resource_len(ram)) {
-- 
1.7.0.4

