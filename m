Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab2LXIPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 03:15:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:52164 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130Ab2LXIPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 03:15:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,346,1355126400"; 
   d="scan'208";a="266436096"
Subject: Re: [PATCH] spi: Add the flag indicate to registe new device as
 children of master or not.
From: Jun Chen <jun.d.chen@intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Bi Chao <chao.bi@intel.com>,
        spi-devel-general@lists.sourceforge.net, jun.zhang@intel.com
In-Reply-To: <20121221190618.6D6D03E0C98@localhost>
References: <1355848174.1435.25.camel@chenjun-workstation>
	 <20121218152623.GA26077@sirena.org.uk>
	 <1355910243.1435.39.camel@chenjun-workstation>
	 <20121219090416.GK4985@opensource.wolfsonmicro.com>
	 <20121219162142.9E1123E0B72@localhost>
	 <1356111592.731.4.camel@chenjun-workstation>
	 <20121221190618.6D6D03E0C98@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Dec 2012 11:16:52 -0500
Message-ID: <1356365812.6818.24.camel@chenjun-workstation>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-21 at 19:06 +0000, Grant Likely wrote:
> On Fri, 21 Dec 2012 12:39:52 -0500, Jun Chen <jun.d.chen@intel.com> wrote:
> > On Wed, 2012-12-19 at 16:21 +0000, Grant Likely wrote:
> > > On Wed, 19 Dec 2012 09:04:16 +0000, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> > > > On Wed, Dec 19, 2012 at 04:44:03AM -0500, Jun Chen wrote:
> > > > 
> > > > > This spi_alloc_device function will be called in the spi_new_device
> > > > > function to alloc new device as the master. But other way, it is called
> > > > > by the of_register_spi_devices function to register new device as the
> > > > > children of the master. I will update changlog to add it. 
> > > > 
> > > > But why is this a bad thing?  You've said what's happening but not why
> > > > it's a problem.
> > > 
> > > spi_devices should always be children of the spi_master. If that is not
> > > the case then it is a bug to be fixed.
> > > 
> > 
> > When many boards initializing, boards will call function
> > spi_register_board_info to create bi->board_info,Then spi driver probe
> > to call spi_register_master to register the driver and in the function
> > spi_match_master_to_boardinfo To create new spi device, and this cases
> > the spi_devices are not children of the spi_master.
> > Many drivers do these steps. If all spi_devices must be children of the
> > spi_master, Do spi core have plan to delete this way? 
> > Or spi core can hold this way for many drivers. 
> 
> Let me make sure I understand what you're saying...
> 
> Right now, every spi_device object is registered as a child of an
> spi_master object.
> 
> With this proposed patch, spi_devices registered via spi_register_board_info
> will be siblings of the spi_master instead of children.
> 
> Do I understand correctly so far?
> 
Yes, 

> The problem is that I don't understand why this change is necessary.
> spi_devices should always be children of an spi_master, not siblings.
> What is the problem you're trying to solve with this change?
> 
When spi drivers try to use the core function(spi_register_master),it
will trigger error,because they use the function
spi_match_master_to_boardinfo  to create new spi device as the children
of the master.
In the old version of spi core, the new devices are registered as
siblings of the spi_master. My spi driver based on the old version runs
normal.

But after applying for this patch:
{
    spi: Fix device unregistration when unregistering the bus master
    
    Device are added as children of the bus master's parent device, but
    spi_unregister_master() looks for devices to unregister in the bus
    master's children. This results in the child devices not being
    unregistered.
    
    Fix this by registering devices as direct children of the bus
master.


-	spi->dev.parent = dev;
+	spi->dev.parent = &master->dev;
}

Then my driver will be crash.
Maybe I have mistake on this issue, thank for your more explanation and
detail replay. 

> g.
> 


