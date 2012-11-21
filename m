Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab2KURo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 12:44:58 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:36203 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab2KURo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 12:44:57 -0500
Date: Wed, 21 Nov 2012 10:44:53 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] of: Have of_device_add call platform_device_add rather
 than device_add
Message-ID: <20121121174453.GD6406@obsidianresearch.com>
References: <20121121072448.GG19837@obsidianresearch.com>
 <20121121155104.726B83E0AE2@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121121155104.726B83E0AE2@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 03:51:04PM +0000, Grant Likely wrote:
> On Wed, 21 Nov 2012 00:24:48 -0700, Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
> > This allows platform_device_add a chance to call insert_resource
> > on all of the resources from OF. At a minimum this fills in proc/iomem
> > and presumably makes resource tracking and conflict detection work
> > better.
> > 
> > Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> >  drivers/of/device.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > Tested on PPC32 and ARM32 embedded kernels.
> > 
> > diff --git a/drivers/of/device.c b/drivers/of/device.c
> > index 4c74e4f..a5b67dc 100644
> > +++ b/drivers/of/device.c
> > @@ -62,7 +62,7 @@ int of_device_add(struct platform_device *ofdev)
> >  	if (!ofdev->dev.parent)
> >  		set_dev_node(&ofdev->dev, of_node_to_nid(ofdev->dev.of_node));
> >  
> > -	return device_add(&ofdev->dev);
> > +	return platform_device_add(ofdev);
> >  }
> >  
> >  int of_device_register(struct platform_device *pdev)
> 
> This has the side effect of moving all devices at the root of the tree
> from /sys/devices/ to /sys/devices/platform. It also has the possibility
> of breaking if any devices get registered with overlapping regions. I
> think there are some powerpc 5200 boards that do this, and I'm not sure
> about the larger Power boxen.

Okay, I'll try to test your patch.

I know sensible overlapping seems to work:

e0000000-e7ffffff : PCIe 0 MEM
  e0000000-e000ffff : 0000:00:01.0
    e0000000-e0000fff : /pex@e0000000/chip@0/chip_control@0
      e0000008-e000000b : dat
        e0000008-e000000b : dat
      e000000c-e000000f : set
        e000000c-e000000f : set
      e0000010-e0000013 : dirin
        e0000010-e0000013 : dirin

Which is nesting the generic gpio driver under a larger region..

And:
f1010100-f101013f : /internal@f1000000/gpio@10100
  f1010100-f1010103 : /internal@f1000000/chip_cfg@0

Which is nesting a register set for one OF platform_device under
another.

It seems to be handled automatically.

My motivations are two fold:
 - Having a mostly empty /proc/iomem isn't great for diagnostics
 - I'll send a patch today that adds some more code to
   platform_device_add

Thanks Grant,
Jason
