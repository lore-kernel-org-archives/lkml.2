Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab2GRAJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:09:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48276 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465Ab2GRAEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:04:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Pawel Moll <pawel.moll@arm.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: [ 28/37] clk: Check parent for NULL in clk_change_rate
Date: Tue, 17 Jul 2012 17:03:05 -0700
Message-Id: <20120717232433.716856099@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232431.399005532@linuxfoundation.org>
References: <20120717232455.GA5994@kroah.com>
 <20120717232431.399005532@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Moll <pawel.moll@arm.com>

commit bf47b4fd8f9f81cd5ce40e1945c6334d088226d1 upstream.

clk_change_rate() is accessing parent's rate without checking
if the parent exists at all. In case of root clocks this will
cause NULL pointer dereference.

This patch follows what clk_calc_new_rates() does in such
situation.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/clk.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -834,18 +834,21 @@ static void clk_change_rate(struct clk *
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
 		clk->ops->set_rate(clk->hw, clk->new_rate);
 
 	if (clk->ops->recalc_rate)
-		clk->rate = clk->ops->recalc_rate(clk->hw,
-				clk->parent->rate);
+		clk->rate = clk->ops->recalc_rate(clk->hw, best_parent_rate);
 	else
-		clk->rate = clk->parent->rate;
+		clk->rate = best_parent_rate;
 
 	if (clk->notifier_count && old_rate != clk->rate)
 		__clk_notify(clk, POST_RATE_CHANGE, old_rate, clk->rate);


