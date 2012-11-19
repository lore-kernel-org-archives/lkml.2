Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab2KSPb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:31:27 -0500
Received: from xes-mad.com ([216.165.139.218]:25661 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825Ab2KSPb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:31:26 -0500
Message-ID: <1353339031.27201.7.camel@petert>
Subject: Re: mfd: lpc_ich: NULL pointer dereference at (second) module
 removal
From: Peter Tyser <ptyser@xes-inc.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org
Date: Mon, 19 Nov 2012 09:30:31 -0600
In-Reply-To: <20121119002404.GD18738@sortiz-mobl>
References: <1352467148.1895.20.camel@x61.thuisdomein>
	 <1352741475.6008.16.camel@petert> <20121119002404.GD18738@sortiz-mobl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

> > On Fri, 2012-11-09 at 14:19 +0100, Paul Bolle wrote:
> > > 0) I can trigger a NULL pointer dereference if I remove the lpc_ich
> > > module. This seems to only happen if I remove it for the second time
> > > (ie, remove the module, insert it and remove it again). This happens
> > > both on i686 and x86_64 (different setups, as inserting the module
> > > triggers different messages about the initialization of the MFD cells on
> > > these machines). Both machines are running v3.6.6.
> > 
> > I believe this is caused by the fact that non-MFD devices get attached
> > to the same parent as the iTCO_wdt driver, which is an MFD.  When the
> > MFD code attempts unregister the MFD drivers, it oops when the non-MFD
> > devices are accessed since they don't have the mfd_cell node.
> That's probably correct. I just merged commit
> 5dc4dda91c86ef82bd53d77e5de50ec095b33e46 into my for-next branch and that one
> could fix that issue. Could you guys please give it a go ? This is the actual
> patch:
> 
> From 5dc4dda91c86ef82bd53d77e5de50ec095b33e46 Mon Sep 17 00:00:00 2001
> From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> Date: Fri, 9 Nov 2012 16:15:28 +0000
> Subject: [PATCH] mfd: Only unregister platform devices allocated by the mfd
>  core
> 
> mfd_remove_devices would iterate over all devices sharing a parent with
> an mfd device regardless of whether they were allocated by the mfd core
> or not. This especially caused problems when the device structure was
> not contained within a platform_device, because to_platform_device is
> used on each device pointer.
> 
> This patch defines a device_type for mfd devices and checks this is
> present from mfd_remove_devices_fn before processing the device.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

Tested-by: Peter Tyser <ptyser@xes-inc.com>

Looks good to me.

Best,
Peter

