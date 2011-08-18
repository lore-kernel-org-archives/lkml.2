Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab1HRBz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 21:55:26 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:4492 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab1HRBzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 21:55:08 -0400
From: JJ Ding <jj_ding@emc.com.tw>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>, Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>, JJ Ding <jj_ding@emc.com.tw>
Subject: [PATCH 4/6] Input: elantech - work around EC buffer
Date: Thu, 18 Aug 2011 09:57:07 +0800
Message-Id: <1313632629-23603-5-git-send-email-jj_ding@emc.com.tw>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw>
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With some EC chips, when we resync due to bad packets, those bad bytes would
still remain in EC's buffer area. That makes us always get bad data back,
no matter what.

So shift packet for 1 byte when encounter bad packet, until we get rid of those
bytes.

Signed-off-by: JJ Ding <jj_ding@emc.com.tw>
---
 drivers/input/mouse/elantech.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 032181c..7b9b6e5 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -411,20 +411,25 @@ static psmouse_ret_t elantech_process_byte(struct psmouse *psmouse)
 	switch (etd->hw_version) {
 	case 1:
 		if (etd->paritycheck && !elantech_check_parity_v1(psmouse))
-			return PSMOUSE_BAD_DATA;
+			goto bad_packet;
 
 		elantech_report_absolute_v1(psmouse);
 		break;
 
 	case 2:
 		if (etd->paritycheck && !packet_simple_check_v2(psmouse))
-			return PSMOUSE_BAD_DATA;
+			goto bad_packet;
 
 		elantech_report_absolute_v2(psmouse);
 		break;
 	}
 
 	return PSMOUSE_FULL_PACKET;
+
+ bad_packet:
+	memmove(psmouse->packet, psmouse->packet + 1, psmouse->pktsize - 1);
+	psmouse->pktcnt--;
+	return PSMOUSE_GOOD_DATA;
 }
 
 /*
-- 
1.7.4.1

