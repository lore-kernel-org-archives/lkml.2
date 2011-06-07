Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab1FGW2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 18:28:08 -0400
Received: from d1.icnet.pl ([212.160.220.21]:51417 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932581Ab1FGW2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 18:28:04 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 3.0-rc1] PM / runtime: fix broken iteration over clock ids
Date: Wed, 8 Jun 2011 00:27:13 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r5; KDE/4.4.5; i686; ; )
Cc: linux-pm@lists.linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        linux-kernel@vger.kernel.org,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
References: <201106051531.32878.jkrzyszt@tis.icnet.pl> <201106072129.26063.rjw@sisk.pl> <201106072324.54306.jkrzyszt@tis.icnet.pl>
In-Reply-To: <201106072324.54306.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106080027.14378.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 07 Jun 2011 at 23:24:53 Janusz Krzysztofik wrote:
> On Tue 07 Jun 2011 at 21:29:25 Rafael J. Wysocki wrote:
> > OK, below is an "official" version.  Can you please double check if
> > it fixes the problem for you?
> 
> Hi,
> I've tested it successfully, but only the CONFIG_PM_RUNTIME=y case,
> not the other because of still another McBSP issue, I believe,
> described elswhere.

With a patch from Kevin, I was able to test the !PM_RUNTIME case 
successfully as well.

Thanks,
Janusz

> Thanks,
> Janusz
> 
> > Rafael
> > 
> > ---
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: PM / Runtime: Fix loops in pm_runtime_clk_notify()
> > 
> > The loops over connection ID strings in pm_runtime_clk_notify()
> > should actually iterate over the strings and not over the elements
> > of the first of them, so make those loops behave as appropriate.
> > 
> > This fixes a regression introduced by commit 600b776eb39a13a28b090
> > (OMAP1 / PM: Use generic clock manipulation routines for runtime
> > PM).
> > 
> > Reported-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> > 
> >  drivers/base/power/clock_ops.c |   16 ++++++++--------
> >  1 file changed, 8 insertions(+), 8 deletions(-)
> > 
> > Index: linux-2.6/drivers/base/power/clock_ops.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/base/power/clock_ops.c
> > +++ linux-2.6/drivers/base/power/clock_ops.c
> > @@ -291,7 +291,7 @@ static int pm_runtime_clk_notify(struct
> > 
> >  {
> >  
> >  	struct pm_clk_notifier_block *clknb;
> >  	struct device *dev = data;
> > 
> > -	char *con_id;
> > +	char **con_id;
> > 
> >  	int error;
> >  	
> >  	dev_dbg(dev, "%s() %ld\n", __func__, action);
> > 
> > @@ -309,8 +309,8 @@ static int pm_runtime_clk_notify(struct
> > 
> >  		dev->pwr_domain = clknb->pwr_domain;
> >  		if (clknb->con_ids[0]) {
> > 
> > -			for (con_id = clknb->con_ids[0]; *con_id; con_id++)
> > -				pm_runtime_clk_add(dev, con_id);
> > +			for (con_id = clknb->con_ids; *con_id; con_id++)
> > +				pm_runtime_clk_add(dev, *con_id);
> > 
> >  		} else {
> >  		
> >  			pm_runtime_clk_add(dev, NULL);
> >  		
> >  		}
> > 
> > @@ -380,7 +380,7 @@ static int pm_runtime_clk_notify(struct
> > 
> >  {
> >  
> >  	struct pm_clk_notifier_block *clknb;
> >  	struct device *dev = data;
> > 
> > -	char *con_id;
> > +	char **con_id;
> > 
> >  	dev_dbg(dev, "%s() %ld\n", __func__, action);
> > 
> > @@ -389,16 +389,16 @@ static int pm_runtime_clk_notify(struct
> > 
> >  	switch (action) {
> >  	
> >  	case BUS_NOTIFY_ADD_DEVICE:
> >  		if (clknb->con_ids[0]) {
> > 
> > -			for (con_id = clknb->con_ids[0]; *con_id; con_id++)
> > -				enable_clock(dev, con_id);
> > +			for (con_id = clknb->con_ids; *con_id; con_id++)
> > +				enable_clock(dev, *con_id);
> > 
> >  		} else {
> >  		
> >  			enable_clock(dev, NULL);
> >  		
> >  		}
> >  		break;
> >  	
> >  	case BUS_NOTIFY_DEL_DEVICE:
> >  		if (clknb->con_ids[0]) {
> > 
> > -			for (con_id = clknb->con_ids[0]; *con_id; con_id++)
> > -				disable_clock(dev, con_id);
> > +			for (con_id = clknb->con_ids; *con_id; con_id++)
> > +				disable_clock(dev, *con_id);
> > 
> >  		} else {
> >  		
> >  			disable_clock(dev, NULL);
> >  		
> >  		}
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-omap" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
