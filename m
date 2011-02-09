Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab1BIGlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 01:41:47 -0500
Received: from ozlabs.org ([203.10.76.45]:44458 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906Ab1BIGlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 01:41:44 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [RFC,
	PATCH 3/3] clk: add warnings for incorrect enable/prepare semantics
Message-Id: <1297233693.243373.411051105619.3.gpush@pororo>
In-Reply-To: <1297233693.241680.897691111624.0.gpush@pororo>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Dima Zavin <dmitriyz@google.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        <linux-sh@vger.kernel.org>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Russell King <linux@arm.linux.org.uk>
From: Jeremy Kerr <jeremy.kerr@canonical.com>
Date: Wed, 09 Feb 2011 14:41:33 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds warnings to check for:

 1) enabling a clock that hasn't been prepared; and

 2) unpreparing a clock that is still enabled

While the correctness can't be guaranteed, the warnings should cover
most situations, and won't indicate false positives.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>

---
 drivers/clk/clk.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index bbbdb0d..8c96623 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -29,6 +29,8 @@ EXPORT_SYMBOL_GPL(clk_prepare);
 
 void clk_unprepare(struct clk *clk)
 {
+	WARN_ON(clk->enable_count != 0);
+
 	mutex_lock(&clk->prepare_lock);
 
 	WARN_ON(clk->prepare_count == 0);
@@ -45,6 +47,8 @@ int clk_enable(struct clk *clk)
 	unsigned long flags;
 	int ret = 0;
 
+	WARN_ON(clk->prepare_count == 0);
+
 	spin_lock_irqsave(&clk->enable_lock, flags);
 	if (clk->enable_count == 0 && clk->ops->enable)
 		ret = clk->ops->enable(clk);
