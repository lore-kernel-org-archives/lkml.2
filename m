Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab0K2J57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 04:57:59 -0500
Received: from mail.sysgo.com ([195.145.229.155]:43261 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950Ab0K2J56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 04:57:58 -0500
Date: Mon, 29 Nov 2010 10:58:01 +0100
From: Pavel Machek <pma@sysgo.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
        kernel list <linux-kernel@vger.kernel.org>,
        "chunkeey@googlemail.com" <chunkeey@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "rudolf.marek@sysgo.com" <rudolf.marek@sysgo.com>,
        "cko@sysgo.com" <cko@sysgo.com>, "mfa@sysgo.com" <mfa@sysgo.com>,
        "anl@sysgo.com" <anl@sysgo.com>
Subject: [PATCH] fix endianity on ath9k_htc
Message-ID: <20101129095801.GA28833@pma.sysgo.com>
References: <20101103092431.GA21138@pma.sysgo.com>
 <20101124081616.GA30595@pma.sysgo.com>
 <20101124131320.GA2611@pma.sysgo.com>
 <4CED33E0.5040000@lwfinger.net>
 <20101126083125.GA28982@pma.sysgo.com>
 <20101126102026.GA11857@pma.sysgo.com>
 <20101126112737.GB11857@pma.sysgo.com>
 <19695.40541.335361.81396@gargle.gargle.HOWL>
 <20101126123706.GA19755@pma.sysgo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101126123706.GA19755@pma.sysgo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It seems struct eep_header lacks proper #ifdef BIG_ENDIAN_BITFIELD
markup. eep_4k_header has proper markup, but two fields were swapped.

Signed-off-by: Pavel Machek <pma@sysgo.com>

diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 3c99830..022589d 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -378,10 +374,14 @@ struct modal_eep_header {
 	u8 xatten2Margin[AR5416_MAX_CHAINS];
 	u8 ob_ch1;
 	u8 db_ch1;
-	u8 useAnt1:1,
-	    force_xpaon:1,
-	    local_bias:1,
+#ifndef __BIG_ENDIAN_BITFIELD
+	u8 useAnt1:1, force_xpaon:1, local_bias:1,
 	    femBandSelectUsed:1, xlnabufin:1, xlnaisel:2, xlnabufmode:1;
+#else
+	u8 xlnabufmode:1, xlnaisel:2, xlnabufin:1, 
+	    femBandSelectUsed:1, local_bias:1, force_xpaon:1, useAnt1:1;
+#endif
+
 	u8 miscBits;
 	u16 xpaBiasLvlFreq[3];
 	u8 futureModal[6];
@@ -443,7 +444,7 @@ struct modal_eep_4k_header {
 	u8 antdiv_ctl1:4, ob_4:4;
 	u8 db1_3:4, db1_2:4;
 	u8 antdiv_ctl2:4, db1_4:4;
-	u8 db2_2:4, db2_3:4;
+	u8 db2_3:4, db2_2:4;
 	u8 reserved:4, db2_4:4;
 #else
 	u8 ob_2:4, ob_3:4;
