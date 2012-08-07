Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030516Ab2HGWii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:38:38 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:65028 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030495Ab2HGWic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:38:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Forest Bond <forest.bond@rapidrollout.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 037/109] rtlwifi: rtl8192de: Fix phy-based version calculation
Date: Tue,  7 Aug 2012 15:34:56 -0700
Message-Id: <20120807222046.352712041@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222043.089735600@linuxfoundation.org>
References: <20120807222043.089735600@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Forest Bond <forest.bond@rapidrollout.com>

commit f1b00f4dab29b57bdf1bc03ef12020b280fd2a72 upstream.

Commit d83579e2a50ac68389e6b4c58b845c702cf37516 incorporated some
changes from the vendor driver that made it newly important that the
calculated hardware version correctly include the CHIP_92D bit, as all
of the IS_92D_* macros were changed to depend on it.  However, this bit
was being unset for dual-mac, dual-phy devices.  The vendor driver
behavior was modified to not do this, but unfortunately this change was
not picked up along with the others.  This caused scanning in the 2.4GHz
band to be broken, and possibly other bugs as well.

This patch brings the version calculation logic in parity with the
vendor driver in this regard, and in doing so fixes the regression.
However, the version calculation code in general continues to be largely
incoherent and messy, and needs to be cleaned up.

Signed-off-by: Forest Bond <forest.bond@rapidrollout.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/phy.c
@@ -3344,21 +3344,21 @@ void rtl92d_phy_config_macphymode_info(s
 	switch (rtlhal->macphymode) {
 	case DUALMAC_SINGLEPHY:
 		rtlphy->rf_type = RF_2T2R;
-		rtlhal->version |= CHIP_92D_SINGLEPHY;
+		rtlhal->version |= RF_TYPE_2T2R;
 		rtlhal->bandset = BAND_ON_BOTH;
 		rtlhal->current_bandtype = BAND_ON_2_4G;
 		break;
 
 	case SINGLEMAC_SINGLEPHY:
 		rtlphy->rf_type = RF_2T2R;
-		rtlhal->version |= CHIP_92D_SINGLEPHY;
+		rtlhal->version |= RF_TYPE_2T2R;
 		rtlhal->bandset = BAND_ON_BOTH;
 		rtlhal->current_bandtype = BAND_ON_2_4G;
 		break;
 
 	case DUALMAC_DUALPHY:
 		rtlphy->rf_type = RF_1T1R;
-		rtlhal->version &= (~CHIP_92D_SINGLEPHY);
+		rtlhal->version &= RF_TYPE_1T1R;
 		/* Now we let MAC0 run on 5G band. */
 		if (rtlhal->interfaceindex == 0) {
 			rtlhal->bandset = BAND_ON_5G;


