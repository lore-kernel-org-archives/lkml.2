Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab2EVWhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:37:11 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60398 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531Ab2EVWhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:37:08 -0400
X-Originating-IP: 99.61.165.181
Message-Id: <6.2.5.6.2.20120522153050.0284ee38@roeck-us.net>
X-Mailer: QUALCOMM Windows Eudora Version 6.2.5.6
Date: Tue, 22 May 2012 15:37:04 -0700
To: Wim Van Sebroeck <wim@iguana.be>
From: Guenter Roeck <guenter@roeck-us.net>
Subject: Re: linux-next: manual merge of the watchdog tree with the mfd
  tree
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Sierra <asierra@xes-inc.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-watchdog@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>
In-Reply-To: <20120522163559.GD3074@spo001.leaseweb.com>
References: <20120518152348.1e5070cdc16cfdf00682546d@canb.auug.org.au>
 <20120518083234.GW3074@spo001.leaseweb.com>
 <6.2.5.6.2.20120518181141.028c8090@roeck-us.net>
 <20120522163559.GD3074@spo001.leaseweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 09:35 AM 5/22/2012, Wim Van Sebroeck wrote:
>Hi Guenter,
>
> > >> Today's linux-next merge of the watchdog tree got a conflict in
> > >> drivers/watchdog/iTCO_wdt.c between commit 887c8ec7219f ("watchdog:
> > >> Convert iTCO_wdt driver to mfd model") from the  tree and commit
> > >> c3614aa19d3e ("watchdog: iTCO_wdt.c: fix printk format warnings") from
> > >> the watchdog tree.
> > >>
> > >> I fixed it up (see below) and can carry the fix as necessary.
> > >
> > >Thanks for fixing this up.
> > >
> > >But I'm a bit surprised: I wasn't Cc'ed about this patch to Convert
> > >the iTCO_wdt driver to the mfd model...
> > Oh my. Kind of embarrassing to forget one of the maintainers in all
> > the discussions which tree this patch set should go through. Even
> > though I didn't much of the code, my sign-off is there, and I should
> > have made sure that you are on the Cc: list. Sorry for that, and I
> > owe you a beer or two if we ever meet in person.
>
>The maintainer and the writer of the driver: that's at least two 
>beers indeed :-).

Make it three. Going to be a happy night.

> > Hope you are ok with the changes - the patch set already missed the
> > last commit window because of the which-tree-to-use issue, and it
> > would be sad to miss another one. And Jean is really waiting for it
> > to go in to be able to push some related patches which need the 
> gpio driver.
>
>I'm OK with it (although this means I can't go ahead yet with a watchdog core
>conversion of the iTCO_wdt driver), except for the comile warning 
>that the patch
>introduces (as reported by Randy).
>
>The original driver printed addresses as %04lx, this new driver uses 
>%04llx but
>doesn't typecast the values correctly. See message from Randy below.
>Wether or not %04lx or %04llx is the best to use is off-course 
>another question.
>I don't think we have a clear standard yet, but I'm fine with either 
>one of them.

Me too, though %04lx and typecast to long should really be sufficient.

I'd guess the change was made because resource_size_t is sometimes a long
and sometimes a long long, depending on the platform. I hit that 
problem a couple of times myself.

How do we make sure that Randy's patch makes it upstream ? The iTCO 
patch is currently in Sam's tree.

Thanks,
Guenter

>Kind regards,
>Wim.
>---
>Date: Mon, 14 May 2012 13:15:20 -0700
>From: Randy Dunlap <rdunlap@xenotime.net>
>To: Stephen Rothwell <sfr@canb.auug.org.au>
>CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
>  Wim Van Sebroeck <wim@iguana.be>,
>  linux-watchdog@vger.kernel.org
>Subject: [PATCH -next] wdt: fix iTCO printk format warnings
>
>From: Randy Dunlap <rdunlap@xenotime.net>
>
>Fix printk format warnings:
>
>drivers/watchdog/iTCO_wdt.c:577:3: warning: format '%04llx' expects 
>type 'long long unsigned int', but argument 2 has type 'resource_size_t'
>drivers/watchdog/iTCO_wdt.c:594:3: warning: format '%04llx' expects 
>type 'long long unsigned int', but argument 2 has type 'resource_size_t'
>drivers/watchdog/iTCO_wdt.c:600:2: warning: format '%04llx' expects 
>type 'long long unsigned int', but argument 4 has type 'resource_size_t'
>
>Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
>Cc:     Wim Van Sebroeck <wim@iguana.be>
>---
>  drivers/watchdog/iTCO_wdt.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
>--- linux-next-20120514.orig/drivers/watchdog/iTCO_wdt.c
>+++ linux-next-20120514/drivers/watchdog/iTCO_wdt.c
>@@ -575,7 +575,7 @@ static int __devinit iTCO_wdt_probe(stru
>         if (!request_region(iTCO_wdt_private.smi_res->start,
>                         resource_size(iTCO_wdt_private.smi_res), 
> dev->name)) {
>                 pr_err("I/O address 0x%04llx already in use, device 
> disabled\n",
>-                      SMI_EN);
>+                      (u64)SMI_EN);
>                 ret = -EBUSY;
>                 goto unmap_gcs;
>         }
>@@ -592,13 +592,13 @@ static int __devinit iTCO_wdt_probe(stru
>         if (!request_region(iTCO_wdt_private.tco_res->start,
>                         resource_size(iTCO_wdt_private.tco_res), 
> dev->name)) {
>                 pr_err("I/O address 0x%04llx already in use, device 
> disabled\n",
>-                      TCOBASE);
>+                      (u64)TCOBASE);
>                 ret = -EBUSY;
>                 goto unreg_smi;
>         }
>
>         pr_info("Found a %s TCO device (Version=%d, TCOBASE=0x%04llx)\n",
>-               ich_info->name, ich_info->iTCO_version, TCOBASE);
>+               ich_info->name, ich_info->iTCO_version, (u64)TCOBASE);
>
>         /* Clear out the (probably old) status */
>         outw(0x0008, TCO1_STS); /* Clear the Time Out Status bit */

