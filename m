Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965Ab1KBSoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 14:44:00 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18109 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932774Ab1KBShA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 14:37:00 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6518"; a="133706962"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 06/34] msm: clock: Support clk_[s|g]et_parent() clk_ops
Date: Wed,  2 Nov 2011 11:36:03 -0700
Message-Id: <1320258991-22325-7-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Voting clocks are linked to the clock they vote on with a parent
pointer. Add support for these functions so the upcoming clock
voter sub driver can use it to initialize clocks.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/clock.c |    7 ++++++-
 arch/arm/mach-msm/clock.h |    2 ++
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-msm/clock.c b/arch/arm/mach-msm/clock.c
index aa4a450..8508c17 100644
--- a/arch/arm/mach-msm/clock.c
+++ b/arch/arm/mach-msm/clock.c
@@ -106,13 +106,18 @@ EXPORT_SYMBOL(clk_set_max_rate);
 
 int clk_set_parent(struct clk *clk, struct clk *parent)
 {
+	if (clk->ops->set_parent)
+		return clk->ops->set_parent(clk, parent);
 	return -ENOSYS;
 }
 EXPORT_SYMBOL(clk_set_parent);
 
 struct clk *clk_get_parent(struct clk *clk)
 {
-	return ERR_PTR(-ENOSYS);
+	if (clk->ops->get_parent)
+		return clk->ops->get_parent(clk);
+
+	return NULL;
 }
 EXPORT_SYMBOL(clk_get_parent);
 
diff --git a/arch/arm/mach-msm/clock.h b/arch/arm/mach-msm/clock.h
index ab14f15..6a7cbca 100644
--- a/arch/arm/mach-msm/clock.h
+++ b/arch/arm/mach-msm/clock.h
@@ -44,6 +44,8 @@ struct clk_ops {
 	unsigned (*get_rate)(struct clk *clk);
 	unsigned (*is_enabled)(struct clk *clk);
 	long (*round_rate)(struct clk *clk, unsigned rate);
+	int (*set_parent)(struct clk *clk, struct clk *parent);
+	struct clk *(*get_parent)(struct clk *clk);
 	bool (*is_local)(struct clk *clk);
 };
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

