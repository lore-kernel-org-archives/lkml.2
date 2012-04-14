Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab2DNMtI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 08:49:08 -0400
Received: from server19320154104.serverpool.info ([193.201.54.104]:56814 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab2DNMtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 08:49:06 -0400
X-Greylist: delayed 565 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Apr 2012 08:49:06 EDT
From: Hauke Mehrtens <hauke@hauke-m.de>
To: nbowler@elliptictech.com, linville@tuxdriver.com
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        arend@broadcom.com, zajec5@gmail.com,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] bcma: use fallback sprom if no on chip sprom is available
Date: Sat, 14 Apr 2012 14:38:54 +0200
Message-Id: <1334407134-22803-1-git-send-email-hauke@hauke-m.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20120414024430.GA19782@elliptictech.com>
References: <20120414024430.GA19782@elliptictech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcma should check for a fallback sprom every time it can not find a
sprom on the card itself or a normal external sprom mapped into the
memory of the chip. When otp sprom support was introduced it tried to
read out the sprom from the wireless chip also if no otp sprom was
available. This caused a Data bus error in bcma_sprom_get() when
reading out the sprom for the SoC.

This fixes a regression introduced in commit:

commit 10d8493cd9efd38b1947b7a74276dbdc8311aa1a
Author: Arend van Spriel <arend@broadcom.com>
Date:   Tue Mar 6 15:50:48 2012 +0100

    bcma: add support for on-chip OTP memory used for SPROM storage

This patch was tested on a Netgear WNDR3400 (Broadcom BCM4718 SoC).

Reported-by: Nick Bowler <nbowler@elliptictech.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---

This patch should be applied to wireless-testing and 3.4.

 drivers/bcma/sprom.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index cdcf75c..3e2a600 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -404,16 +404,19 @@ int bcma_sprom_get(struct bcma_bus *bus)
 		return -EOPNOTSUPP;
 
 	if (!bcma_sprom_ext_available(bus)) {
+		bool sprom_onchip;
+
 		/*
 		 * External SPROM takes precedence so check
 		 * on-chip OTP only when no external SPROM
 		 * is present.
 		 */
-		if (bcma_sprom_onchip_available(bus)) {
+		sprom_onchip = bcma_sprom_onchip_available(bus);
+		if (sprom_onchip) {
 			/* determine offset */
 			offset = bcma_sprom_onchip_offset(bus);
 		}
-		if (!offset) {
+		if (!offset || !sprom_onchip) {
 			/*
 			 * Maybe there is no SPROM on the device?
 			 * Now we ask the arch code if there is some sprom
-- 
1.7.5.4

