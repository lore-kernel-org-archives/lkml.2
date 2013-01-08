Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab3AHNbt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 08:31:49 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:51740 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755827Ab3AHNbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 08:31:48 -0500
From: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Tony Lindgren <tony@atomide.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Benoit Cousson <b-cousson@ti.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH] omap: DT node Timer iteration fix
Date: Tue,  8 Jan 2013 15:31:42 +0200
Message-Id: <1357651902-21966-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The iterator correctly handles of_node_put() calls.
Remove it before continue'ing the loop.
Without this patch you get:

ERROR: Bad of_node_put() on /ocp/timer@44e31000!
[<c001329c>] (unwind_backtrace+0x0/0xe0) from [<c03dd8f0>] (of_node_release+0x2c/0xa0)!
[<c03dd8f0>] (of_node_release+0x2c/0xa0) from [<c03ddea0>] (of_find_matching_node_and_match+0x78/0x90)!
[<c03ddea0>] (of_find_matching_node_and_match+0x78/0x90) from [<c06d349c>] (omap_get_timer_dt+0x78/0x90)!
[<c06d349c>] (omap_get_timer_dt+0x78/0x90) from [<c06d3664>] (omap_dm_timer_init_one.clone.2+0x34/0x2bc)!
[<c06d3664>] (omap_dm_timer_init_one.clone.2+0x34/0x2bc) from [<c06d3a2c>] (omap2_gptimer_clocksource_init.clone.4+0x24/0xa8)!
[<c06d3a2c>] (omap2_gptimer_clocksource_init.clone.4+0x24/0xa8) from [<c06cca58>] (time_init+0x20/0x30)!
[<c06cca58>] (time_init+0x20/0x30) from [<c06c9690>] (start_kernel+0x1a8/0x2fc)!

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 arch/arm/mach-omap2/timer.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index 691aa67..b8ad6e6 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -165,15 +165,11 @@ static struct device_node * __init omap_get_timer_dt(struct of_device_id *match,
 	struct device_node *np;
 
 	for_each_matching_node(np, match) {
-		if (!of_device_is_available(np)) {
-			of_node_put(np);
+		if (!of_device_is_available(np))
 			continue;
-		}
 
-		if (property && !of_get_property(np, property, NULL)) {
-			of_node_put(np);
+		if (property && !of_get_property(np, property, NULL))
 			continue;
-		}
 
 		of_add_property(np, &device_disabled);
 		return np;
-- 
1.7.12

