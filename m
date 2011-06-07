Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab1FGT2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 15:28:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35914 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754409Ab1FGT2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 15:28:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: Re: [PATCH 3.0-rc1] PM / runtime: fix broken iteration over clock ids
Date: Tue, 7 Jun 2011 21:29:25 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        linux-kernel@vger.kernel.org,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
References: <201106051531.32878.jkrzyszt@tis.icnet.pl> <201106061947.36238.rjw@sisk.pl> <201106062118.18734.jkrzyszt@tis.icnet.pl>
In-Reply-To: <201106062118.18734.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106072129.26063.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 06, 2011, Janusz Krzysztofik wrote:
> On Mon 06 Jun 2011 at 19:47:36 Rafael J. Wysocki wrote:
> > Hi,
> > 
> > On Sunday, June 05, 2011, Janusz Krzysztofik wrote:
> > > In its current form, pm_runtime_clk_notify() iterates through sub-
> > > strings of pm_clk_notifier_block.con_ids[0] rather than consecutive
> > > pm_clk_notifier_block.con_ids[] elements. As a noticeable result,
> > > McBSP1 port no longer worked for me on updated
> > > arch/arm/mach-omap1/pm_bus.c (commit
> > > 600b776eb39a13a28b090ba9efceb0c69d4508aa, "OMAP1 / PM: Use generic
> > > clock manipulation routines for runtime PM"), not being able to
> > > activate "fck" when required.
> > > 
> > > Tested on Amstrad Delta.
> > > 
> > > Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> > > ---
> > > 
> > >  drivers/base/power/clock_ops.c |    6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > --- git/drivers/base/power/clock_ops.c.orig	2011-05-30
> > > 22:16:35.000000000 +0200 +++
> > > git/drivers/base/power/clock_ops.c	2011-06-05 15:19:55.000000000
> > > +0200 @@ -291,7 +291,7 @@ static int pm_runtime_clk_notify(struct
> > > 
> > >  {
> > >  
> > >  	struct pm_clk_notifier_block *clknb;
> > >  	struct device *dev = data;
> > > 
> > > -	char *con_id;
> > > +	char **con_id;
> > > 
> > >  	int error;
> > >  	
> > >  	dev_dbg(dev, "%s() %ld\n", __func__, action);
> > > 
> > > @@ -309,8 +309,8 @@ static int pm_runtime_clk_notify(struct
> > > 
> > >  		dev->pwr_domain = clknb->pwr_domain;
> > >  		if (clknb->con_ids[0]) {
> > > 
> > > -			for (con_id = clknb->con_ids[0]; *con_id; con_id++)
> > > -				pm_runtime_clk_add(dev, con_id);
> > > +			for (con_id = &clknb->con_ids[0]; *con_id; con_id++)
> > > +				pm_runtime_clk_add(dev, *con_id);
> > > 
> > >  		} else {
> > >  		
> > >  			pm_runtime_clk_add(dev, NULL);
> > >  		
> > >  		}
> > 
> > First off, sorry for the breakage.  Second, while the patch is
> > correct in the part is covered, it is incomplete (it also should
> > cover the !CONFIG_PM_RUNTIME case.  So, I think the appended patch
> > would be better.
> 
> That's right, please take it over.

OK, below is an "official" version.  Can you please double check if it fixes
the problem for you?

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Runtime: Fix loops in pm_runtime_clk_notify()

The loops over connection ID strings in pm_runtime_clk_notify()
should actually iterate over the strings and not over the elements
of the first of them, so make those loops behave as appropriate.

This fixes a regression introduced by commit 600b776eb39a13a28b090
(OMAP1 / PM: Use generic clock manipulation routines for runtime PM).

Reported-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/clock_ops.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/base/power/clock_ops.c
===================================================================
--- linux-2.6.orig/drivers/base/power/clock_ops.c
+++ linux-2.6/drivers/base/power/clock_ops.c
@@ -291,7 +291,7 @@ static int pm_runtime_clk_notify(struct
 {
 	struct pm_clk_notifier_block *clknb;
 	struct device *dev = data;
-	char *con_id;
+	char **con_id;
 	int error;
 
 	dev_dbg(dev, "%s() %ld\n", __func__, action);
@@ -309,8 +309,8 @@ static int pm_runtime_clk_notify(struct
 
 		dev->pwr_domain = clknb->pwr_domain;
 		if (clknb->con_ids[0]) {
-			for (con_id = clknb->con_ids[0]; *con_id; con_id++)
-				pm_runtime_clk_add(dev, con_id);
+			for (con_id = clknb->con_ids; *con_id; con_id++)
+				pm_runtime_clk_add(dev, *con_id);
 		} else {
 			pm_runtime_clk_add(dev, NULL);
 		}
@@ -380,7 +380,7 @@ static int pm_runtime_clk_notify(struct
 {
 	struct pm_clk_notifier_block *clknb;
 	struct device *dev = data;
-	char *con_id;
+	char **con_id;
 
 	dev_dbg(dev, "%s() %ld\n", __func__, action);
 
@@ -389,16 +389,16 @@ static int pm_runtime_clk_notify(struct
 	switch (action) {
 	case BUS_NOTIFY_ADD_DEVICE:
 		if (clknb->con_ids[0]) {
-			for (con_id = clknb->con_ids[0]; *con_id; con_id++)
-				enable_clock(dev, con_id);
+			for (con_id = clknb->con_ids; *con_id; con_id++)
+				enable_clock(dev, *con_id);
 		} else {
 			enable_clock(dev, NULL);
 		}
 		break;
 	case BUS_NOTIFY_DEL_DEVICE:
 		if (clknb->con_ids[0]) {
-			for (con_id = clknb->con_ids[0]; *con_id; con_id++)
-				disable_clock(dev, con_id);
+			for (con_id = clknb->con_ids; *con_id; con_id++)
+				disable_clock(dev, *con_id);
 		} else {
 			disable_clock(dev, NULL);
 		}
