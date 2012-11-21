Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab2KUSeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 13:34:10 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56654 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755571Ab2KUSeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 13:34:07 -0500
Date: Wed, 21 Nov 2012 10:34:03 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] of: use platform_device_add
Message-ID: <20121121183403.GA7657@kroah.com>
References: <1353521759-28263-1-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353521759-28263-1-git-send-email-grant.likely@secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 06:15:59PM +0000, Grant Likely wrote:
> This allows platform_device_add a chance to call insert_resource on all
> of the resources from OF. At a minimum this fills in proc/iomem and
> presumably makes resource tracking and conflict detection work better.
> However, it has the side effect of moving all OF generated platform
> devices from /sys/devices to /sys/devices/platform/. It /shouldn't/
> break userspace because userspace is not supposed to depend on the full
> path (because userspace always does what it is supposed to, right?).
> 
> It also has a backup call to of_device_add() when running on PowerPC to
> catch any devices that have overlapping regions. It will complain about
> them, but it will not fail to register the device.
> 
> Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
> 
> Greg, do you mind taking a look at this? The reason the OF code hasn't been
> calling platform_device_add() directly to this point is:
> a) there are some trees with resource overlays
> b) I want the devices in /sys/devices not /sys/devices/platform.

Putting the devices all in the "flat" location of /sys/devices/ is a bit
worrisome to me.  What's wrong with platform/ ?  That is what they are,
right?  Why change this?

> I could easily add exceptions to platform_device_add() for both those cases, but
> I don't like adding DT exceptions to the common code. However, I still need to
> support the platforms that unfortunately have overlapping resources. This patch
> does that by still calling the old path if platform_device_add() fails, but it
> isn't nice either because of_device_add() has to duplicate
> platform_device_add(). Blech. Plus the exception only applies for PowerPC.
> 
> So, how do you feel about having a 'relaxed' mode for platform_device_add()
> which means it won't fail if resources overlap and maybe won't do the silly
> platform_bus parent thing. Thoughts?

I have no objection for the resource issue, if you assure me it will not
be abused :)

But the sysfs location is still an issue, sorry.

thanks,

greg k-h
