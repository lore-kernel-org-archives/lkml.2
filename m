Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab1ECRiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:38:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44624 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752856Ab1ECRiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:38:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [Update x3][PATCH 7/9] PM / Runtime: Generic clock manipulation rountines for runtime PM (v6)
Date: Tue, 3 May 2011 19:38:14 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Colin Cross <ccross@google.com>, Kevin Hilman <khilman@ti.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>
References: <201104130205.26988.rjw@sisk.pl> <201104300004.02601.rjw@sisk.pl> <4DC034CA.6000505@codeaurora.org>
In-Reply-To: <4DC034CA.6000505@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105031938.14953.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 03, 2011, Stephen Boyd wrote:
> On 04/29/2011 03:04 PM, Rafael J. Wysocki wrote:
> > +
> > +/**
> > + * enable_clock - Enable a device clock.
> > + * @dev: Device whose clock is to be enabled.
> > + * @con_id: Connection ID of the clock.
> > + */
> > +static void enable_clock(struct device *dev, const char *con_id)
> > +{
> > +	struct clk *clk;
> > +
> > +	clk = clk_get(dev, con_id);
> > +	if (!IS_ERR(clk)) {
> > +		clk_enable(clk);
> > +		clk_put(clk);
> > +		dev_info(dev, "Runtime PM disabled, clock forced on.\n");
> > +	}
> > +}
> 
> This doesn't make much sense to me. You're getting a clock and then
> enabling it and then putting the clock? How can you be so sure that
> clk_put() won't one day do some kind of lower power mode on the clock
> when clk_put() is called on it? I don't think anyone does anything
> today, but I don't think its safe to assume that clk_put() won't try to
> forcibly shut off the clock once all clk_get() callers have clk_put().
> 
> Perhaps we should document the meaning of clk_enable() followed by
> clk_put() somewhere instead?

That's coming from some existing ARM shmobile code.

There are two alternatives, one not to do any clock management at all
when CONFIG_PM_RUNTIME is unset, the other to remove the "put" from
enable_clock(), but then disable_clock() would need to do "put" twice.
I didn't think any of them was better than the current code.

> > +
> > +/**
> > + * disable_clock - Disable a device clock.
> > + * @dev: Device whose clock is to be disabled.
> > + * @con_id: Connection ID of the clock.
> > + */
> > +static void disable_clock(struct device *dev, const char *con_id)
> > +{
> > +	struct clk *clk;
> > +
> > +	clk = clk_get(dev, con_id);
> > +	if (!IS_ERR(clk)) {
> > +		clk_disable(clk);
> > +		clk_put(clk);
> > +		dev_info(dev, "Runtime PM disabled, clock forced off.\n");
> > +	}
> > +}
> 
> This might not be as bad, but it looks like a similar problem.
> 
> > -
> > -static int platform_bus_notify(struct notifier_block *nb,
> > -			       unsigned long action, void *data)
> > -{
> > -	struct device *dev = data;
> > -	struct clk *clk;
> > -
> > -	dev_dbg(dev, "platform_bus_notify() %ld !\n", action);
> > -
> > -	switch (action) {
> > -	case BUS_NOTIFY_BIND_DRIVER:
> > -		clk = clk_get(dev, NULL);
> > -		if (!IS_ERR(clk)) {
> > -			clk_enable(clk);
> > -			clk_put(clk);
> > -			dev_info(dev, "runtime pm disabled, clock forced on\n");
> > -		}
> > -		break;
> > -	case BUS_NOTIFY_UNBOUND_DRIVER:
> > -		clk = clk_get(dev, NULL);
> > -		if (!IS_ERR(clk)) {
> > -			clk_disable(clk);
> > -			clk_put(clk);
> > -			dev_info(dev, "runtime pm disabled, clock forced off\n");
> > -		}
> 
> Ah ok I see that it's coming from here.

Yes, it is.

> BTW, whatever is in linux-next is failing to compile:
> 
> drivers/base/power/clock_ops.c:391: error: 'con_id' undeclared (first
> use in this function)
> drivers/base/power/clock_ops.c:391: error: (Each undeclared identifier
> is reported only once
> drivers/base/power/clock_ops.c:391: error: for each function it appears in.)

I guess that's with CONFIG_PM_RUNTIME unset, right?

Sorry about that, the appended patch should fix the issue.

Thanks,
Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Fix build issue in clock_ops.c for CONFIG_PM_RUNTIME unset

Fix a build issue in drivers/base/power/clock_ops.c occuring when
CONFIG_PM_RUNTIME is not set.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/clock_ops.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/drivers/base/power/clock_ops.c
===================================================================
--- linux-2.6.orig/drivers/base/power/clock_ops.c
+++ linux-2.6/drivers/base/power/clock_ops.c
@@ -380,6 +380,7 @@ static int pm_runtime_clk_notify(struct
 {
 	struct pm_clk_notifier_block *clknb;
 	struct device *dev = data;
+	char *con_id;
 
 	dev_dbg(dev, "%s() %ld\n", __func__, action);
 
