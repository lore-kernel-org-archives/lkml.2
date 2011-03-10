Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab1CKACI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:02:08 -0500
Received: from kroah.org ([198.145.64.141]:46843 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438Ab1CJX5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 18:57:19 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Mar 10 15:55:37 2011
Message-Id: <20110310235537.042357423@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 10 Mar 2011 15:54:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mohammed Shafi <mshajakhan@atheros.com>,
        =?ISO-8859-15?q?Thomas=20B=E4chler?= <thomas@archlinux.org>,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        Mohammed Shajakhan <Mohammed.Shajakhan@atheros.com>
Subject: [patch 10/29] ath9k: Fix ath9k prevents CPU to enter C3 states
In-Reply-To: <20110310235548.GA10103@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

This is a backport of upstream commit 0f5cd45960173ba5b36727decbb4a241cbd35ef9.

The DMA latency issue is observed only in Intel pinetrail platforms
but in the driver we had a default PM-QOS value of 55. This caused
unnecessary power consumption and battery drain in other platforms.

Remove the pm-qos thing in the driver code and address the throughput
issue in Intel pinetrail platfroms in user space using any one of
the scripts in below links:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/scripts/cpudmalatency.c
http://johannes.sipsolutions.net/files/netlatency.c.txt

More details can be found in the following bugzilla link:

https://bugzilla.kernel.org/show_bug.cgi?id=27532

Signed-off-by: Thomas Bächler <thomas@archlinux.org>
Acked-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/ath9k.h |    3 ---
 drivers/net/wireless/ath/ath9k/init.c  |    4 ----
 drivers/net/wireless/ath/ath9k/main.c  |    4 ----
 3 files changed, 11 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -21,7 +21,6 @@
 #include <linux/device.h>
 #include <linux/leds.h>
 #include <linux/completion.h>
-#include <linux/pm_qos_params.h>
 
 #include "debug.h"
 #include "common.h"
@@ -647,8 +646,6 @@ struct ath_softc {
 	struct ath_descdma txsdma;
 
 	struct ath_ant_comb ant_comb;
-
-	struct pm_qos_request_list pm_qos_req;
 };
 
 struct ath_wiphy {
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -758,9 +758,6 @@ int ath9k_init_device(u16 devid, struct
 	ath_init_leds(sc);
 	ath_start_rfkill_poll(sc);
 
-	pm_qos_add_request(&sc->pm_qos_req, PM_QOS_CPU_DMA_LATENCY,
-			   PM_QOS_DEFAULT_VALUE);
-
 	return 0;
 
 error_world:
@@ -829,7 +826,6 @@ void ath9k_deinit_device(struct ath_soft
 	}
 
 	ieee80211_unregister_hw(hw);
-	pm_qos_remove_request(&sc->pm_qos_req);
 	ath_rx_cleanup(sc);
 	ath_tx_cleanup(sc);
 	ath9k_deinit_softc(sc);
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1245,8 +1245,6 @@ static int ath9k_start(struct ieee80211_
 			ath9k_btcoex_timer_resume(sc);
 	}
 
-	pm_qos_update_request(&sc->pm_qos_req, 55);
-
 mutex_unlock:
 	mutex_unlock(&sc->mutex);
 
@@ -1425,8 +1423,6 @@ static void ath9k_stop(struct ieee80211_
 
 	sc->sc_flags |= SC_OP_INVALID;
 
-	pm_qos_update_request(&sc->pm_qos_req, PM_QOS_DEFAULT_VALUE);
-
 	mutex_unlock(&sc->mutex);
 
 	ath_print(common, ATH_DBG_CONFIG, "Driver halt\n");


