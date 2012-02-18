Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab2BRHwp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 02:52:45 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33608 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab2BRHwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 02:52:44 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of hughd@google.com designates 10.68.73.97 as permitted sender) smtp.mail=hughd@google.com; dkim=pass header.i=hughd@google.com
Date: Fri, 17 Feb 2012 23:52:15 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Holger Macht <holger@homac.de>
cc: Matthew Garrett <mjg@redhat.com>, Jeff Garzik <jgarzik@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: dock_link_device is oopsy
In-Reply-To: <20120217230107.GA12929@homac.suse.de>
Message-ID: <alpine.LSU.2.00.1202172341540.14838@eggly.anvils>
References: <alpine.LSU.2.00.1202171320590.5994@eggly.anvils> <20120217222922.GA2741@homac.suse.de> <alpine.LSU.2.00.1202171436490.10222@eggly.anvils> <20120217230107.GA12929@homac.suse.de>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Feb 2012, Holger Macht wrote:
> On Fr 17. Feb - 14:42:31, Hugh Dickins wrote:
> > On Fri, 17 Feb 2012, Holger Macht wrote:
> > > On Fr 17. Feb - 13:46:04, Hugh Dickins wrote:
> > > > Matthew,
> > > > 
> > > > A linux-next oops at bootup in dock_link_device() tells me that you
> > > > were not feeling well when you wrote that and dock_unlink_device():
> > > > I hope you're feeling better now and can rewrite them soon.
> > > 
> > > Andrew Morton experienced a similar problem. What system are you using?
> > > I didn't encounter this problem with the systems I tested with.
> > 
> > The two systems I got that on were both 4-year-old Core2 Duo systems,
> > one an HP quad desktop, one a Fujitsu-Siemens laptop.
> 
> Thanks for the information I think this is really independent from the
> fact if a laptop, or more precicely if a system with dock station/bay is
> used.
> 
> > 
> > > 
> > > Do you actually have a /sys/devices/platform/dock.?/ directory with a
> > > file 'type' that contains 'dock_station'?
> > 
> > I'll have to report back on that this evening, I'm away from them now.
> 
> I actually guess that those systems don't have a
> /sys/devices/platform/dock.? directory at all, which is fine.

You are correct, no /sys/devices/platform/dock.? directory on those.

> 
> I also think this will fix it, would be great if you could confirm this:
> 
> acpi: Bail out when linking devices and there are no dock stations
> 
> If dock_station_count is zero, we allocate zero memory and don't check
> this at future references. So bail out if there are actually no dock
> stations.
> 
> Signed-off-by: Holger Macht <holger@homac.de>
> ---
>  drivers/acpi/dock.c |   13 ++++++++++---
>  1 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
> index b5e4142..8641912 100644
> --- a/drivers/acpi/dock.c
> +++ b/drivers/acpi/dock.c
> @@ -286,6 +286,9 @@ struct device **dock_link_device(acpi_handle handle)
>  	int ret, dock = 0;
>  	struct device **devices;
>  
> +	if (!dock_station_count)
> +		return -ENODEV;

If I change your -ENODEV to NULL (here and in unlink, though I didn't
check if that gets called), yes, that "fixes" the crash at boot.

But note that in each case you already did an acpi_get_physical_device:
if the existing code was correct in this regard, then you ought to be
doing a put_device(dev) before returning.

Or better reorder it all.

Hugh

> +
>  	devices = kmalloc(dock_station_count * sizeof(struct device *),
>  			  GFP_KERNEL);
>  
> @@ -323,9 +326,13 @@ struct device **dock_unlink_device(acpi_handle handle)
>  	struct device *dev = acpi_get_physical_device(handle);
>  	struct dock_station *dock_station;
>  	int dock = 0;
> -	struct device **devices =
> -		kmalloc(dock_station_count * sizeof(struct device *),
> -			GFP_KERNEL);
> +	struct device **devices;
> +
> +	if (!dock_station_count)
> +		return -ENODEV;
> +
> +	devices = kmalloc(dock_station_count * sizeof(struct device *),
> +			  GFP_KERNEL);
>  
>  	if (!dev)
>  		return NULL;
> -- 
> 1.7.7
