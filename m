Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758444Ab2EIIEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:04:23 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:26634 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab2EIIEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:04:16 -0400
X-RZG-AUTH: :KXokZlStbvrPCC8w2n2KADUjx90tFpDbrwvi3rISAmCHBWiKTAoKIqY5gZEywA==
X-RZG-CLASS-ID: mo05
Message-Id: <201205090803.q4983lYa013593@gatekeeper.vosshq.de>
From: Nikolaus Voss <n.voss@weinmann.de>
Date: Wed, 9 May 2012 08:30:44 +0200
Subject: [PATCH] drivers/power/sbs-battery.c: don't trigger false
 supply_changed event
To: linux-kernel@vger.kernel.org
Cc: cbouatmailru@gmail.com, rklein@nvidia.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

power_supply_changed() events are triggerd based on the return value
of a get_property() call. However the property TECHNOLOGY is
hard-coded to LION in this driver, thus always succeeds.

So, with the battery removed, this triggers a false battery present
uevent. This uevent triggers a new query via power_supply_uevent()
which again starts to query all known properties and thus leads to
an infinite loop of battery present/not-present uevents.

This patch skips the battery presence detection for the hard-coded
property TECHNOLOGY.

Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
---
 drivers/power/sbs-battery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/sbs-battery.c b/drivers/power/sbs-battery.c
index 182d2ed..ef142f8 100644
--- a/drivers/power/sbs-battery.c
+++ b/drivers/power/sbs-battery.c
@@ -469,7 +469,7 @@ static int sbs_get_property(struct power_supply *psy,
 
 	case POWER_SUPPLY_PROP_TECHNOLOGY:
 		val->intval = POWER_SUPPLY_TECHNOLOGY_LION;
-		break;
+		goto done; /* don't trigger power_supply_changed()! */
 
 	case POWER_SUPPLY_PROP_ENERGY_NOW:
 	case POWER_SUPPLY_PROP_ENERGY_FULL:
-- 
1.7.9.5

