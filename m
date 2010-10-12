Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab0JLIbq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 04:31:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756621Ab0JLIbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 04:31:45 -0400
From: jcm@jonmasters.org
To: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>, Henry Ptasinski <henryp@broadcom.com>,
        Nohee Ko <noheek@broadcom.com>, Jon Masters <jcm@jonmasters.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] [staging] brcm80211: fix radio disabled on attempt to bring up interface
Date: Tue, 12 Oct 2010 04:29:58 -0400
Message-Id: <1286872198-10664-1-git-send-email-jcm@jonmasters.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The brcm80211 driver does not correctly handle the case that the wireless
radio hardware is physically disabled during interface initialization. An
attempt is made to check whether the radio is disabled, and in the case
that it is, a background worker is setup to monitor for the radio coming
online, but the interface queues are incorrectly brought up anyway. The
value BCME_RADIOOFF should be returned in wlc_up in such error case.

Signed-off-by: Jon Masters <jcm@jonmasters.org>

diff -urNp brcm80211_orig/sys/wlc_mac80211.c brcm80211/sys/wlc_mac80211.c
--- brcm80211_orig/sys/wlc_mac80211.c	2010-10-12 04:18:07.940125220 -0400
+++ brcm80211/sys/wlc_mac80211.c	2010-10-12 04:19:19.814961117 -0400
@@ -2783,7 +2783,7 @@ int BCMINITFN(wlc_up) (wlc_info_t *wlc)
 
 	if (wlc->pub->radio_disabled) {
 		wlc_radio_monitor_start(wlc);
-		return 0;
+		return BCME_RADIOOFF;
 	}
 
 	/* wlc_bmac_up_prep has done wlc_corereset(). so clk is on, set it */
