Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab2BRNhV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 08:37:21 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58572 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab2BRNhT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 08:37:19 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dhillf@gmail.com designates 10.220.148.146 as permitted sender) smtp.mail=dhillf@gmail.com; dkim=pass header.i=dhillf@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120218132610.GA15265@homac.suse.de>
References: <alpine.LSU.2.00.1202171320590.5994@eggly.anvils>
	<20120217222922.GA2741@homac.suse.de>
	<alpine.LSU.2.00.1202171436490.10222@eggly.anvils>
	<20120217230107.GA12929@homac.suse.de>
	<alpine.LSU.2.00.1202171541040.3155@eggly.anvils>
	<20120218111419.GA2488@homac.suse.de>
	<CAJd=RBDRZSizawvRYqr7=U75Su5TLvMfgdagRA49wzJr40DqSg@mail.gmail.com>
	<20120218132610.GA15265@homac.suse.de>
Date: Sat, 18 Feb 2012 21:37:18 +0800
Message-ID: <CAJd=RBAhnsuP4+pRS=MLyOaqx8O1gOR30bcoZC0Owabh1-1nzA@mail.gmail.com>
Subject: Re: linux-next: dock_link_device is oopsy
From: Hillf Danton <dhillf@gmail.com>
To: Holger Macht <holger@homac.de>
Cc: Hugh Dickins <hughd@google.com>, Matthew Garrett <mjg@redhat.com>,
        Jeff Garzik <jgarzik@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 18, 2012 at 9:26 PM, Holger Macht <holger@homac.de> wrote:
> On Sa 18. Feb - 21:05:18, Hillf Danton wrote:
>> On Sat, Feb 18, 2012 at 7:14 PM, Holger Macht <holger@homac.de> wrote:
>> > So how about that?
>> >
>> > acpi: Bail out when linking devices and there are no dock stations
>> >
>> > If dock_station_count is zero, we allocate zero memory and don't check
>> > this at future references. So bail out if there are actually no dock
>> > stations.
>> >
>> > Signed-off-by: Holger Macht <holger@homac.de>
>> > ---
>> >  drivers/acpi/dock.c |   19 ++++++++++++++-----
>> >  1 files changed, 14 insertions(+), 5 deletions(-)
>> >
>> > diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
>> > index b5e4142..0b3072c 100644
>> > --- a/drivers/acpi/dock.c
>> > +++ b/drivers/acpi/dock.c
>> > @@ -281,11 +281,15 @@ EXPORT_SYMBOL_GPL(is_dock_device);
>> >  */
>> >  struct device **dock_link_device(acpi_handle handle)
>> >  {
>> > -       struct device *dev = acpi_get_physical_device(handle);
>> > +       struct device *dev;
>> >        struct dock_station *dock_station;
>> >        int ret, dock = 0;
>> >        struct device **devices;
>> >
>> > +       if (!dock_station_count)
>> > +               return NULL;
>> > +
>> > +       dev = acpi_get_physical_device(handle);
>> >        devices = kmalloc(dock_station_count * sizeof(struct device *),
>> >                          GFP_KERNEL);
>> >
>> > @@ -320,12 +324,17 @@ EXPORT_SYMBOL_GPL(dock_link_device);
>> >  */
>> >  struct device **dock_unlink_device(acpi_handle handle)
>> >  {
>> > -       struct device *dev = acpi_get_physical_device(handle);
>> > +       struct device *dev;
>> >        struct dock_station *dock_station;
>> >        int dock = 0;
>> > -       struct device **devices =
>> > -               kmalloc(dock_station_count * sizeof(struct device *),
>> > -                       GFP_KERNEL);
>> > +       struct device **devices;
>> > +
>> > +       if (!dock_station_count)
>> > +               return NULL;
>> > +
>> > +       dev = acpi_get_physical_device(handle);
>> > +       devices = kmalloc(dock_station_count * sizeof(struct device *),
>> > +                         GFP_KERNEL);
>> >
>>
>> If bail out in this way, another patch looks needed to fix up
>> mem leakage :-(
>
> Sorry if I'm a little slow...but where is the leakage? The function
> doesn't allocate anything before bailing out in the dock_station_count
> check. And the rerun value should be freed by the caller. Please point
> me in the right direction.
>

Hi  Holger

Lets check the following snippet from what you posted,

> @@ -320,12 +324,17 @@ EXPORT_SYMBOL_GPL(dock_link_device);
>  */
>  struct device **dock_unlink_device(acpi_handle handle)
>  {
> -       struct device *dev = acpi_get_physical_device(handle);
> +       struct device *dev;
>        struct dock_station *dock_station;
>        int dock = 0;
> -       struct device **devices =
> -               kmalloc(dock_station_count * sizeof(struct device *),
> -                       GFP_KERNEL);
> +       struct device **devices;
> +
> +       if (!dock_station_count)
> +               return NULL;
> +
> +       dev = acpi_get_physical_device(handle);
> +       devices = kmalloc(dock_station_count * sizeof(struct device *),
> +                         GFP_KERNEL);
>
>        if (!dev)
>                return NULL;  <=== here return without freeing the newly
                                               allocated devices after checking
                                               dock_station_count is not zero
> --
> 1.7.7
>
