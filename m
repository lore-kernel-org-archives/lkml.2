Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab2AYAXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 19:23:46 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:12911 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964Ab2AYAXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 19:23:45 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18qxqLmhV+UYurx7b/OIqan
Date: Tue, 24 Jan 2012 16:23:41 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Barry Song <21cnbao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH 2/4] pinctrl: Fix pinmux_hog_maps when ctrl_dev_name is
 not set
Message-ID: <20120125002340.GV22818@atomide.com>
References: <20120120161610.21955.25082.stgit@kaulin.local>
 <20120120161727.21955.7437.stgit@kaulin.local>
 <74CDBE0F657A3D45AFBB94109FB122FF1780DAB383@HQMAIL01.nvidia.com>
 <20120120173915.GP22818@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120120173915.GP22818@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [120120 09:06]:
> * Stephen Warren <swarren@nvidia.com> [120120 08:24]:
> > Tony Lindgren wrote at Friday, January 20, 2012 9:17 AM:
> > > The ctrl_dev_name is optional for struct pinmux_map assuming
> > > that ctrl_dev is set. Without this patch we can get:
> > > 
> > > Unable to handle kernel NULL pointer dereference at virtual address 00000000
> > 
> > > diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
> > 
> > 
> > > @@ -992,9 +992,12 @@ int pinmux_hog_maps(struct pinctrl_dev *pctldev)
> > > 
> > >  	for (i = 0; i < pinmux_maps_num; i++) {
> > >  		struct pinmux_map const *map = &pinmux_maps[i];
> > > +		int match_found = 0;
> > > 
> > > -		if (((map->ctrl_dev == dev) ||
> > > -		     !strcmp(map->ctrl_dev_name, devname)) &&
> > > +		if (map->ctrl_dev_name && !strcmp(map->ctrl_dev_name, devname))
> > > +				match_found = 1;
> > > +
> > > +		if (((map->ctrl_dev == dev) || match_found) &&
> > >  		    map->hog_on_boot) {
> > >  			/* OK time to hog! */
> > >  			ret = pinmux_hog_map(pctldev, map);
> > 
> > Wouldn't it be better if match_found was true for all matching cases,
> > in other words for the new code to be:
> > 
> > 		int match_found = 0;
> > 
> > 		if (map->ctrl_dev_name && !strcmp(map->ctrl_dev_name, devname))
> > 				match_found = 1;
> > 		if (map->ctrl_dev == dev)
> > 				match_found = 1;
> > 		if (match_found && map->hog_on_boot) {
> 
> OK will take a look, that would make the code easier to read.

Here's this one updated, looks like we can keep it readable
even without match_found if we continue the search early based
on !map->hog_on_boot.

Regards,

Tony


From: Tony Lindgren <tony@atomide.com>
Date: Fri, 20 Jan 2012 07:43:53 -0800
Subject: [PATCH] pinctrl: Fix pinmux_hog_maps when ctrl_dev_name is not set

The ctrl_dev_name is optional for struct pinmux_map assuming
that ctrl_dev is set. Without this patch we can get:

Unable to handle kernel NULL pointer dereference at virtual address 00000000
...
(pinmux_hog_maps+0xa4/0x20c)
(pinctrl_register+0x2a4/0x378)
...

Fix this by adding adding a test for map->ctrl_dev.
Additionally move the test for map->ctrl_dev earlier
to optimize out the loop a bit.

Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/drivers/pinctrl/pinmux.c
+++ b/drivers/pinctrl/pinmux.c
@@ -993,9 +993,12 @@ int pinmux_hog_maps(struct pinctrl_dev *pctldev)
 	for (i = 0; i < pinmux_maps_num; i++) {
 		struct pinmux_map const *map = &pinmux_maps[i];
 
-		if (((map->ctrl_dev == dev) ||
-		     !strcmp(map->ctrl_dev_name, devname)) &&
-		    map->hog_on_boot) {
+		if (!map->hog_on_boot)
+			continue;
+
+		if ((map->ctrl_dev == dev) ||
+			(map->ctrl_dev_name &&
+				!strcmp(map->ctrl_dev_name, devname))) {
 			/* OK time to hog! */
 			ret = pinmux_hog_map(pctldev, map);
 			if (ret)
