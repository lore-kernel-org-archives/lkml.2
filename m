Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab2HZQD5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 12:03:57 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:56799
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753579Ab2HZQBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 12:01:16 -0400
X-IronPort-AV: E=Sophos;i="4.80,315,1344204000"; 
   d="scan'208";a="153852293"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Russell King <linux@arm.linux.org.uk>
Cc: kernel-janitors@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/13] arch/arm: use clk_prepare_enable and clk_disable_unprepare
Date: Sun, 26 Aug 2012 18:00:57 +0200
Message-Id: <1345996865-32082-6-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345996865-32082-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1345996865-32082-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Clk_prepare_enable and clk_disable_unprepare combine clk_prepare and
clk_enable, and clk_disable and clk_unprepare.  They make the code more
concise, and ensure that clk_unprepare is called when clk_enable fails.

A simplified version of the semantic patch that introduces calls to these
functions is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
@@

- clk_prepare(e);
- clk_enable(e);
+ clk_prepare_enable(e);

@@
expression e;
@@

- clk_disable(e);
- clk_unprepare(e);
+ clk_disable_unprepare(e);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 arch/arm/common/sa1111.c   |    3 +--
 arch/arm/common/timer-sp.c |   16 ++++------------
 arch/arm/kernel/smp_twd.c  |   13 +++----------
 3 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
index 9173d11..bd58414 100644
--- a/arch/arm/common/sa1111.c
+++ b/arch/arm/common/sa1111.c
@@ -834,8 +834,7 @@ static void __sa1111_remove(struct sa1111 *sachip)
 	sa1111_writel(0, irqbase + SA1111_WAKEEN0);
 	sa1111_writel(0, irqbase + SA1111_WAKEEN1);
 
-	clk_disable(sachip->clk);
-	clk_unprepare(sachip->clk);
+	clk_disable_unprepare(sachip->clk);
 
 	if (sachip->irq != NO_IRQ) {
 		irq_set_chained_handler(sachip->irq, NULL);
diff --git a/arch/arm/common/timer-sp.c b/arch/arm/common/timer-sp.c
index df13a3f..af1a4ab 100644
--- a/arch/arm/common/timer-sp.c
+++ b/arch/arm/common/timer-sp.c
@@ -42,17 +42,10 @@ static long __init sp804_get_clock_rate(const char *name)
 		return PTR_ERR(clk);
 	}
 
-	err = clk_prepare(clk);
+	err = clk_prepare_enable(clk);
 	if (err) {
-		pr_err("sp804: %s clock failed to prepare: %d\n", name, err);
-		clk_put(clk);
-		return err;
-	}
-
-	err = clk_enable(clk);
-	if (err) {
-		pr_err("sp804: %s clock failed to enable: %d\n", name, err);
-		clk_unprepare(clk);
+		pr_err("sp804: %s clock failed to prepare or to enable: %d\n",
+		       name, err);
 		clk_put(clk);
 		return err;
 	}
@@ -60,8 +53,7 @@ static long __init sp804_get_clock_rate(const char *name)
 	rate = clk_get_rate(clk);
 	if (rate < 0) {
 		pr_err("sp804: %s clock failed to get rate: %ld\n", name, rate);
-		clk_disable(clk);
-		clk_unprepare(clk);
+		clk_disable_unprepare(clk);
 		clk_put(clk);
 	}
 
diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index fef42b2..8c94b8b 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -204,17 +204,10 @@ static struct clk *twd_get_clock(void)
 		return clk;
 	}
 
-	err = clk_prepare(clk);
+	err = clk_prepare_enable(clk);
 	if (err) {
-		pr_err("smp_twd: clock failed to prepare: %d\n", err);
-		clk_put(clk);
-		return ERR_PTR(err);
-	}
-
-	err = clk_enable(clk);
-	if (err) {
-		pr_err("smp_twd: clock failed to enable: %d\n", err);
-		clk_unprepare(clk);
+		pr_err("smp_twd: clock failed to prepare or to enable: %d\n",
+		       err);
 		clk_put(clk);
 		return ERR_PTR(err);
 	}

