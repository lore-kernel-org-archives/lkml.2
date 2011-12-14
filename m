Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234Ab1LOFBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 00:01:46 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:54826 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab1LOFBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 00:01:44 -0500
From: jhbird.choi@samsung.com
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, jhbird.choi@gmail.com,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [RESEND PATCH] ARM: SAMSUNG: Add s3c_setparent_clksrc in s3c_set_clksrc
Date: Wed, 14 Dec 2011 11:20:21 +0900
Message-Id: <1323829221-14171-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwan Choi <jhbird.choi@samsung.com>

Currently we have to run clk_set_parent to change clock source.
But if there are sources & parent defined, it means we will select a parent
in multiple clock sources. So sources & parent are already defined,
set the parent clock int s3c_set_clksrc.
Then we can reduce many clk_set_parent function in driver or setup_clock function.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 arch/arm/plat-samsung/clock-clksrc.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/arm/plat-samsung/clock-clksrc.c b/arch/arm/plat-samsung/clock-clksrc.c
index ae8b850..61dfe0d 100644
--- a/arch/arm/plat-samsung/clock-clksrc.c
+++ b/arch/arm/plat-samsung/clock-clksrc.c
@@ -140,6 +140,14 @@ void __init_or_cpufreq s3c_set_clksrc(struct clksrc_clk *clk, bool announce)
 		return;
 	}
 
+	if (clk->sources && clk->clk.parent) {
+		if (s3c_setparent_clksrc(&clk->clk, clk->clk.parent)) {
+			printk(KERN_ERR "%s: bad source is %s\n",
+					clk->clk.name, clk->clk.parent->name);
+			return;
+		}
+	}
+
 	clksrc = __raw_readl(clk->reg_src.reg);
 	clksrc &= mask;
 	clksrc >>= clk->reg_src.shift;
-- 
1.7.1

