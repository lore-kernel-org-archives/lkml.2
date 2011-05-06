Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab1EFAZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:25:52 -0400
Received: from kroah.org ([198.145.64.141]:37249 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932406Ab1EFAZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:50 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:16 2011
Message-Id: <20110506002216.647860787@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bruce Allan <bruce.w.allan@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [116/143] e1000e: Reset 82577/82578 PHY before first PHY register read
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Bruce Allan <bruce.w.allan@intel.com>

commit 627c8a041f7aaaea93c766f69bd61d952a277586 upstream.

Reset the PHY before first accessing it.  Doing so, ensure that the PHY is
in a known good state before we read/write PHY registers. This fixes a
driver probe failure.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[Backported to 2.6.32 by dann frazier <dannf@debian.org>]
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/e1000e/ich8lan.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/net/e1000e/ich8lan.c
+++ b/drivers/net/e1000e/ich8lan.c
@@ -274,6 +274,16 @@ static s32 e1000_init_phy_params_pchlan(
 	phy->ops.write_phy_reg_locked = e1000_write_phy_reg_hv_locked;
 	phy->autoneg_mask             = AUTONEG_ADVERTISE_SPEED_DEFAULT;
 
+	/*
+	 * Reset the PHY before any acccess to it.  Doing so, ensures that
+	 * the PHY is in a known good state before we read/write PHY registers.
+	 * The generic reset is sufficient here, because we haven't determined
+	 * the PHY type yet.
+	 */
+	ret_val = e1000e_phy_hw_reset_generic(hw);
+	if (ret_val)
+		goto out;
+
 	phy->id = e1000_phy_unknown;
 	e1000e_get_phy_id(hw);
 	phy->type = e1000e_get_phy_type_from_id(phy->id);
@@ -287,6 +297,7 @@ static s32 e1000_init_phy_params_pchlan(
 		phy->ops.commit_phy = e1000e_phy_sw_reset;
 	}
 
+ out:
 	return ret_val;
 }
 


