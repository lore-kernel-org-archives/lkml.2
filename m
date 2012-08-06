Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab2HFPGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:06:11 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:51211 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460Ab2HFPGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:06:09 -0400
Date: Mon, 6 Aug 2012 10:50:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: lenb@kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel_idle: Check cpu_idle_get_driver() for NULL before
 dereferencing it.
Message-ID: <20120806145009.GD2487@phenom.dumpdata.com>
References: <1343918341-25985-1-git-send-email-konrad.wilk@oracle.com>
 <201208042356.35884.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208042356.35884.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2012 at 11:56:35PM +0200, Rafael J. Wysocki wrote:
> On Thursday, August 02, 2012, Konrad Rzeszutek Wilk wrote:
> > If the machine is booted without any cpu_idle driver set
> > (b/c disable_cpuidle() has been called) we should follow
> > other users of cpu_idle API and check the return value
> > for NULL before using it.
> > 
> > Reported-by: Mark van Dijk <mark@internecto.net>
> > Tested-by: Mark van Dijk <mark@internecto.net>
> > Suggested-by: Jan Beulich <JBeulich@suse.com>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  drivers/idle/intel_idle.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> > index f559088..7383aa0 100644
> > --- a/drivers/idle/intel_idle.c
> > +++ b/drivers/idle/intel_idle.c
> > @@ -607,7 +607,7 @@ static int __init intel_idle_init(void)
> >  	retval = cpuidle_register_driver(&intel_idle_driver);
> >  	if (retval) {
> 
> What about:
> 
>   		struct cpuidle_driver *drv = cpuidle_get_driver();
> 
>   		printk(KERN_DEBUG PREFIX "intel_idle yielding to %s",
> 			drv ? drv->name : "none");
> 
> >  		printk(KERN_DEBUG PREFIX "intel_idle yielding to %s",
> > -			cpuidle_get_driver()->name);
> > +			cpuidle_get_driver() ? cpuidle_get_driver()->name : "none");
> >  		return retval;
> >  	}
> >  
> > 
> 
> Rafael

Here it is:

>From a8b7aa06cacb5f42a90a0d4a0a1a95e230d43fc6 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Thu, 2 Aug 2012 10:31:52 -0400
Subject: [PATCH] intel_idle: Check cpu_idle_get_driver() for NULL before
 dereferencing it.

If the machine is booted without any cpu_idle driver set
(b/c disable_cpuidle() has been called) we should follow
other users of cpu_idle API and check the return value
for NULL before using it.

Reported-by: Mark van Dijk <mark@internecto.net>
Tested-by: Mark van Dijk <mark@internecto.net>
Suggested-by: Jan Beulich <JBeulich@suse.com>
[v1: Redo per Rafael's suggestion]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/idle/intel_idle.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index d0f59c3..6b313af 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -556,8 +556,9 @@ static int __init intel_idle_init(void)
 	intel_idle_cpuidle_driver_init();
 	retval = cpuidle_register_driver(&intel_idle_driver);
 	if (retval) {
+		struct cpuidle_driver *drv = cpuidle_get_driver();
 		printk(KERN_DEBUG PREFIX "intel_idle yielding to %s",
-			cpuidle_get_driver()->name);
+			drv ? drv->name : "none");
 		return retval;
 	}
 
-- 
1.7.7.6

