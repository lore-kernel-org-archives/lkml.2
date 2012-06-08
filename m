Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab2FHNEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 09:04:21 -0400
Received: from service87.mimecast.com ([91.220.42.44]:53090 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab2FHNES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 09:04:18 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH] clk: Check parent for NULL in clk_change_rate
Date: Fri,  8 Jun 2012 14:04:06 +0100
Message-Id: <1339160646-32664-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 08 Jun 2012 13:04:43.0254 (UTC) FILETIME=[45782960:01CD4577]
X-MC-Unique: 112060814041607501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id q58D4QNN026139

clk_change_rate() is accessing parent's rate without checking
if the parent exists at all. In case of root clocks this will
cause NULL pointer dereference.

This patch follows what clk_calc_new_rates() does in such
situation.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---

Hi Mike,

This is something I had to workaround to get Versatile Express
working with the common clock framework - my root clocks aren't
are variable (as in: non fixed).

I'm told that this might have been already fixed - if that's the
case simply ignore this patch. Also I'm not saying it's the best
way of solving the issue :-)

Cheers!

Pawel

 drivers/clk/clk.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 687b00d..cf53069 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -850,18 +850,21 @@ static void clk_change_rate(struct clk *clk)
 {
 	struct clk *child;
 	unsigned long old_rate;
+	unsigned long best_parent_rate = 0;
 	struct hlist_node *tmp;
 
 	old_rate = clk->rate;
 
+	if (clk->parent)
+		best_parent_rate = clk->parent->rate;
+
 	if (clk->ops->set_rate)
-		clk->ops->set_rate(clk->hw, clk->new_rate, clk->parent->rate);
+		clk->ops->set_rate(clk->hw, clk->new_rate, best_parent_rate);
 
 	if (clk->ops->recalc_rate)
-		clk->rate = clk->ops->recalc_rate(clk->hw,
-				clk->parent->rate);
+		clk->rate = clk->ops->recalc_rate(clk->hw, best_parent_rate);
 	else
-		clk->rate = clk->parent->rate;
+		clk->rate = best_parent_rate;
 
 	if (clk->notifier_count && old_rate != clk->rate)
 		__clk_notify(clk, POST_RATE_CHANGE, old_rate, clk->rate);
-- 
1.7.9.5


