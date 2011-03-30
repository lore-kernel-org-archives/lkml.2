Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271Ab1C3Vev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:34:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:26918 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964948Ab1C3VId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:08:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621237896"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: bruce.w.allan@intel.com, jeffrey.t.kirsher@intel.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [168/275] e1000e: disable broken PHY wakeup for ICH10 LOMs, use MAC wakeup instead
Message-Id: <20110330210650.9C03A3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:06:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Bruce Allan <bruce.w.allan@intel.com>

commit 4def99bbfd46e05c5e03b5b282cb4ee30e27ff19 upstream.

When support for 82577/82578 was added[1] in 2.6.31, PHY wakeup was in-
advertently enabled (even though it does not function properly) on ICH10
LOMs.  This patch makes it so that the ICH10 LOMs use MAC wakeup instead
as was done with the initial support for those devices (i.e. 82567LM-3,
82567LF-3 and 82567V-4).

[1] commit a4f58f5455ba0efda36fb33c37074922d1527a10

Reported-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/e1000e/netdev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/net/e1000e/netdev.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/e1000e/netdev.c	2011-03-29 22:50:57.340791211 -0700
+++ linux-2.6.35.y/drivers/net/e1000e/netdev.c	2011-03-29 23:03:01.745255514 -0700
@@ -5678,7 +5678,8 @@
 		/* APME bit in EEPROM is mapped to WUC.APME */
 		eeprom_data = er32(WUC);
 		eeprom_apme_mask = E1000_WUC_APME;
-		if (eeprom_data & E1000_WUC_PHY_WAKE)
+		if ((hw->mac.type > e1000_ich10lan) &&
+		    (eeprom_data & E1000_WUC_PHY_WAKE))
 			adapter->flags2 |= FLAG2_HAS_PHY_WAKEUP;
 	} else if (adapter->flags & FLAG_APME_IN_CTRL3) {
 		if (adapter->flags & FLAG_APME_CHECK_PORT_B &&
