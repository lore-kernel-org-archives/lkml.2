Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523Ab1BGGJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 01:09:00 -0500
Received: from ozlabs.org ([203.10.76.45]:35571 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab1BGGI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 01:08:29 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [RFC,
	PATCH 3/3] clk: add warnings for incorrect enable/prepare semantics
Message-Id: <1297058877.800990.238556019385.3.gpush@pororo>
In-Reply-To: <201102011711.31258.jeremy.kerr@canonical.com>
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
Date: Mon, 07 Feb 2011 14:07:57 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change adds warnings to check for:

 1) enabling a clock that hasn't been prepared; and

 2) unpreparing a clock that is still enabled

While the correctness can't be guaranteed, these warnings should cover
most situations.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>

---
 drivers/clk/clk.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 51dbd33..2369959 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -35,6 +35,8 @@ void clk_unprepare(struct clk *clk)
 	if (!clk->ops->unprepare)
 		return;
 
+	WARN_ON(clk->enable_count);
+
 	mutex_lock(&clk->prepare_lock);
 	if (--clk->prepare_count == 0)
 		clk->ops->unprepare(clk);
@@ -50,6 +52,8 @@ int clk_enable(struct clk *clk)
 	if (!clk->ops->enable)
 		return 0;
 
+	WARN_ON(clk->ops->prepare && clk->prepare_count);
+
 	spin_lock(&clk->enable_lock);
 	if (!clk->enable_count)
 		ret = clk->ops->enable(clk);
