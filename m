Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab1GEQFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 12:05:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52514 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab1GEQFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 12:05:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
Date: Tue, 5 Jul 2011 18:05:00 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "David S. Miller" <davem@davemloft.net>
References: <20110704170949.11059.92774.stgit@ponder> <201107051721.02079.arnd@arndb.de> <20110705155040.GB16682@suse.de>
In-Reply-To: <20110705155040.GB16682@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107051805.00696.arnd@arndb.de>
X-Provags-ID: V02:K0:x4TyV+mWMO0Ts2lk8NvBNLSowNY8S5CbhMYm2nluoEb
 CTbYxQfEQjLIkU0r4ec0uq+VUje8vBI8Zvnsc6udhAzMeg/wq8
 pPuC/hLlmMpLfwbNMxWeWAO/iXjVhIyfw3OFaTsDnsYKc/GQCy
 rJm9JXCfvKJdlJjUHKOxR9ZlRE0Fh72mSBNpMxzkMyGTGw7aso
 UbkAGpyLYTlm+Dkb0Hkog==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 July 2011, Greg KH wrote:
> > * go through all initcalls, record any devices that are not yet ready
> > * retry all devices on the list as long as at least one of them has
> >   succeeded.
> > * when a new device gets matched from a module load, do that loop again
> 
> You don't know when init calls are finished, or if a module is loaded,
> the driver core isn't that smart at all.

We know when most initcalls are finished (at late_initcall time), and
after that we don't need to know when a module gets loaded, only 
when a device gets matched, and that's something we do know and
that Grant's patch uses already.

> > late_initcall(retry_devices);
> 
> I wonder if doing this all from a workqueue in the first place is going
> to cause problems as probe isn't normally done this way at all.

True. It will definitely cause problems for any driver that calls
flush_work() in its probe function. We would need a private
singlethread_workqueue to avoid that.

	Arnd
