Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161088Ab2I1UuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:50:00 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41274 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945957Ab2I1UtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:49:00 -0400
X-Sasl-enc: 7pMwCWFG1/BLGKpPZWICpF4pfbhFOIfZs9qY0rRzxn4F 1348865339
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Chris Ball <cjb@laptop.org>
Subject: [ 119/127] mmc: sd: Handle SD3.0 cards not supporting UHS-I bus speed mode
Date: Fri, 28 Sep 2012 13:34:52 -0700
Message-Id: <20120928203059.822523738@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Subhash Jadavani <subhashj@codeaurora.org>

commit f2815f68dabbb373fd1c9f0fd4a609d486697c2b upstream.

Here is Essential conditions to indicate Version 3.00 Card
(SD_SPEC=2 and SD_SPEC3=1) :
(1) The card shall support CMD6
(2) The card shall support CMD8
(3) The card shall support CMD42
(4) User area capacity shall be up to 2GB (SDSC) or 32GB (SDHC)
    User area capacity shall be more than or equal to 32GB and
    up to 2TB (SDXC)
(5) Speed Class shall be supported (SDHC or SDXC)

So even if SD card doesn't support any of the newly defined
UHS-I bus speed mode, it can advertise itself as SD3.0 cards
as long as it supports all the essential conditions of
SD3.0 cards. Given this, these type of cards should atleast
run in High Speed mode @50MHZ if it supports HS.

But current initialization sequence for SD3.0 cards is
such that these non-UHS-I SD3.0 cards runs in Default
Speed mode @25MHz.

This patch makes sure that these non-UHS-I SD3.0 cards run
in High Speed Mode @50MHz.

Tested this patch with SanDisk Extreme SDHC 8GB Class 10 card.

Reported-by: "Hiremath, Vaibhav" <hvaibhav@ti.com>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Chris Ball <cjb@laptop.org>

---
 drivers/mmc/core/sd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -306,6 +306,9 @@ static int mmc_read_switch(struct mmc_ca
 		goto out;
 	}
 
+	if (status[13] & UHS_SDR50_BUS_SPEED)
+		card->sw_caps.hs_max_dtr = 50000000;
+
 	if (card->scr.sda_spec3) {
 		card->sw_caps.sd3_bus_mode = status[13];
 
@@ -348,9 +351,6 @@ static int mmc_read_switch(struct mmc_ca
 		}
 
 		card->sw_caps.sd3_curr_limit = status[7];
-	} else {
-		if (status[13] & 0x02)
-			card->sw_caps.hs_max_dtr = 50000000;
 	}
 
 out:


