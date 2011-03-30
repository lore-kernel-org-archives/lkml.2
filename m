Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965172Ab1C3VXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:23:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:37491 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965118Ab1C3VJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411278846"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: stefan.xk.nilsson@stericsson.com, ak@linux.intel.com,
        ulf.hansson@stericsson.com, pawel.wieczorkiewicz@stericsson.com,
        linus.walleij@linaro.org, cjb@laptop.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [218/275] mmc: sdio: remember new card RCA when redetecting card
Message-Id: <20110330210743.3A7633E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>

commit 0aab3995485b8a994bf29a995a008c9ea4a28054 upstream.

During redetection of a SDIO card, a request for a new card RCA
was submitted to the card, but was then overwritten by the old RCA.
This caused the card to be deselected instead of selected when using
the incorrect RCA.  This bug's been present since the "oldcard"
handling was introduced in 2.6.32.

Signed-off-by: Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: Ulf Hansson <ulf.hansson@stericsson.com>
Reviewed-by: Pawel Wieczorkiewicz <pawel.wieczorkiewicz@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/core/sdio.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6.35.y/drivers/mmc/core/sdio.c
===================================================================
--- linux-2.6.35.y.orig/drivers/mmc/core/sdio.c	2011-03-29 22:50:30.116487813 -0700
+++ linux-2.6.35.y/drivers/mmc/core/sdio.c	2011-03-29 23:03:02.787228853 -0700
@@ -309,6 +309,14 @@
 		if (err)
 			goto remove;
 
+		/*
+		 * Update oldcard with the new RCA received from the SDIO
+		 * device -- we're doing this so that it's updated in the
+		 * "card" struct when oldcard overwrites that later.
+		 */
+		if (oldcard)
+			oldcard->rca = card->rca;
+
 		mmc_set_bus_mode(host, MMC_BUSMODE_PUSHPULL);
 	}
 
