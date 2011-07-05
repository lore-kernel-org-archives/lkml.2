Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab1GEPwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 11:52:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48318 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124Ab1GEPwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 11:52:33 -0400
Date: Tue, 5 Jul 2011 08:50:40 -0700
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
Message-ID: <20110705155040.GB16682@suse.de>
References: <20110704170949.11059.92774.stgit@ponder>
 <20110704180159.GA11278@ponder.secretlab.ca>
 <20110705142149.GA3498@suse.de>
 <201107051721.02079.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107051721.02079.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 05:21:01PM +0200, Arnd Bergmann wrote:
> On Tuesday 05 July 2011, Greg KH wrote:
> > So the driver core is just going to sit and spin and continue to try to
> > probe drivers for as long as it gets that error value returned?  What is
> > going to ever cause that loop to terminate?  It seems a bit hacky to
> > just keep looping over and over and hoping that sometime everything will
> > all settle down so that we can go to sleep again.
> 
> Well, it only needs to try as long as there are still new devices
> succeeding to get probed. The order that I think this should happen
> in is:
> 
> * go through all initcalls, record any devices that are not yet ready
> * retry all devices on the list as long as at least one of them has
>   succeeded.
> * when a new device gets matched from a module load, do that loop again

You don't know when init calls are finished, or if a module is loaded,
the driver core isn't that smart at all.

> If I read the patch correctly, the workqueue would be scheduled
> every time a new device gets added, which retries the devices
> more often than necessary and can have significant boot time
> impact, and it also introduces more asynchronicity that may expose
> new bugs.
> 
> Maybe we can have a late_initcall that enables the automatic retry
> and probes everything once:
> 
> static bool deferred_probe;
> static int __init deferred_probe_start(void)
> {
> 	deferred_probe = true;
> 	mutex_lock(&deferred_probe_mutex);
> 	if (!list_empty(&deferred_probe_list))
> 		schedule_work(&deferred_probe_work);
> 	mutex_unlock(&deferred_probe_mutex);
> 	flush_work_sync(&deferred_probe_work);
> }
> late_initcall(retry_devices);

I wonder if doing this all from a workqueue in the first place is going
to cause problems as probe isn't normally done this way at all.

greg k-h
