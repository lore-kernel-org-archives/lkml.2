Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab0E1I3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 04:29:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62628 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab0E1I3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 04:29:16 -0400
Date: Fri, 28 May 2010 11:29:09 +0300
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Tim Gardner <tim.gardner@canonical.com>,
       Russell King <linux@arm.linux.org.uk>,
       Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] arm: mxc: utilise usecount field in clock
 operations
Message-ID: <20100528082909.GA3122@matterhorn.lan>
Mail-Followup-To: Sascha Hauer <s.hauer@pengutronix.de>,
	Tim Gardner <tim.gardner@canonical.com>,
	Russell King <linux@arm.linux.org.uk>,
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <d501dcf8dbe98ed7f5aa9e7b34e68f0e1076ac84.1271968118.git.amit.kucheria@verdurent.com>
 <4BD0D4F0.9090605@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4BD0D4F0.9090605@canonical.com>
X-URL: http://www.verdurent.com/
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 Apr 22, Tim Gardner wrote:
> On 04/22/2010 02:30 PM, Amit Kucheria wrote:
> >From: Amit Kucheria<amit.kucheria@canonical.com>
> >
> >This patch fixes the clock refcounting when reparenting is used.
> >
> >Sascha just pointed out a good explanation of refcounting here:
> >http://www.spinics.net/lists/arm-kernel/msg85879.html
> >
> >Signed-off-by: Amit Kucheria<amit.kucheria@canonical.com>
> >---
> >  arch/arm/plat-mxc/clock.c |   34 ++++++++++++++++++++++------------
> >  1 files changed, 22 insertions(+), 12 deletions(-)
> >
> >diff --git a/arch/arm/plat-mxc/clock.c b/arch/arm/plat-mxc/clock.c
> >index 323ff8c..14781cc 100644
> >--- a/arch/arm/plat-mxc/clock.c
> >+++ b/arch/arm/plat-mxc/clock.c
> >@@ -50,15 +50,16 @@ static DEFINE_MUTEX(clocks_mutex);
> >
> >  static void __clk_disable(struct clk *clk)
> >  {
> >-	if (clk == NULL || IS_ERR(clk))
> >+	WARN_ON(!clk->usecount);
> >+	if (clk == NULL || IS_ERR(clk) || !clk->usecount)
> >  		return;
> >
> 
> The clk==NULL check seem superfluous if WARN_ON(!clk->usecount) has
> already dereferenced clk (and possibly crashed). You might need two
> statements if its likely that clk could be NULL.
> 

Tim, You're right. 

Sascha, updated patch to fix that issue and correspond more closely to
Russell's explanation follows.

Cheers,
Amit


>From 3b125ff8668917c7969b2cdf733f94cb415c83bd Mon Sep 17 00:00:00 2001
Message-Id: <3b125ff8668917c7969b2cdf733f94cb415c83bd.1275034568.git.amit.kucheria@verdurent.com>
From: Amit Kucheria <amit.kucheria@canonical.com>
Date: Fri, 4 Dec 2009 01:02:41 +0200
Subject: [PATCH] arm: mxc: utilise usecount field in clock operations

This patch fixes the clock refcounting when reparenting is used.

Boot-tested on imx51 babbage board.

Sascha pointed out a good explanation of refcounting here:
http://www.spinics.net/lists/arm-kernel/msg85879.html

Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
---
 arch/arm/plat-mxc/clock.c |   37 +++++++++++++++++++++++++------------
 1 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/arch/arm/plat-mxc/clock.c b/arch/arm/plat-mxc/clock.c
index 323ff8c..2ed3ab1 100644
--- a/arch/arm/plat-mxc/clock.c
+++ b/arch/arm/plat-mxc/clock.c
@@ -52,13 +52,14 @@ static void __clk_disable(struct clk *clk)
 {
 	if (clk == NULL || IS_ERR(clk))
 		return;
-
-	__clk_disable(clk->parent);
-	__clk_disable(clk->secondary);
-
 	WARN_ON(!clk->usecount);
-	if (!(--clk->usecount) && clk->disable)
-		clk->disable(clk);
+
+	if (!(--clk->usecount)) {
+		if (clk->disable)
+			clk->disable(clk);
+		__clk_disable(clk->parent);
+		__clk_disable(clk->secondary);
+	}
 }
 
 static int __clk_enable(struct clk *clk)
@@ -66,12 +67,13 @@ static int __clk_enable(struct clk *clk)
 	if (clk == NULL || IS_ERR(clk))
 		return -EINVAL;
 
-	__clk_enable(clk->parent);
-	__clk_enable(clk->secondary);
-
-	if (clk->usecount++ == 0 && clk->enable)
-		clk->enable(clk);
+	if (clk->usecount++ == 0) {
+		__clk_enable(clk->parent);
+		__clk_enable(clk->secondary);
 
+		if (clk->enable)
+			clk->enable(clk);
+	}
 	return 0;
 }
 
@@ -160,17 +162,28 @@ EXPORT_SYMBOL(clk_set_rate);
 int clk_set_parent(struct clk *clk, struct clk *parent)
 {
 	int ret = -EINVAL;
+	struct clk *old;
 
 	if (clk == NULL || IS_ERR(clk) || parent == NULL ||
 	    IS_ERR(parent) || clk->set_parent == NULL)
 		return ret;
 
+	if (clk->usecount)
+		clk_enable(parent);
+
 	mutex_lock(&clocks_mutex);
 	ret = clk->set_parent(clk, parent);
-	if (ret == 0)
+	if (ret == 0) {
+		old = clk->parent;
 		clk->parent = parent;
+	} else {
+		old = parent;
+	}
 	mutex_unlock(&clocks_mutex);
 
+	if (clk->usecount)
+		clk_disable(old);
+
 	return ret;
 }
 EXPORT_SYMBOL(clk_set_parent);
-- 
1.7.0.4

