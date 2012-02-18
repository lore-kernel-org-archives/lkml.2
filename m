Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab2BRNFV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 08:05:21 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43565 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab2BRNFT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 08:05:19 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dhillf@gmail.com designates 10.52.26.65 as permitted sender) smtp.mail=dhillf@gmail.com; dkim=pass header.i=dhillf@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120218111419.GA2488@homac.suse.de>
References: <alpine.LSU.2.00.1202171320590.5994@eggly.anvils>
	<20120217222922.GA2741@homac.suse.de>
	<alpine.LSU.2.00.1202171436490.10222@eggly.anvils>
	<20120217230107.GA12929@homac.suse.de>
	<alpine.LSU.2.00.1202171541040.3155@eggly.anvils>
	<20120218111419.GA2488@homac.suse.de>
Date: Sat, 18 Feb 2012 21:05:18 +0800
Message-ID: <CAJd=RBDRZSizawvRYqr7=U75Su5TLvMfgdagRA49wzJr40DqSg@mail.gmail.com>
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

On Sat, Feb 18, 2012 at 7:14 PM, Holger Macht <holger@homac.de> wrote:
> On Fr 17. Feb - 15:49:02, Hugh Dickins wrote:
>> On Sat, 18 Feb 2012, Holger Macht wrote:
>> > On Fr 17. Feb - 14:42:31, Hugh Dickins wrote:
>> > > On Fri, 17 Feb 2012, Holger Macht wrote:
>> > > > On Fr 17. Feb - 13:46:04, Hugh Dickins wrote:
>> > > > > Matthew,
>> > > > >
>> > > > > A linux-next oops at bootup in dock_link_device() tells me that you
>> > > > > were not feeling well when you wrote that and dock_unlink_device():
>> > > > > I hope you're feeling better now and can rewrite them soon.
>> > > >
>> > > > Andrew Morton experienced a similar problem. What system are you using?
>> > > > I didn't encounter this problem with the systems I tested with.
>> > >
>> > > The two systems I got that on were both 4-year-old Core2 Duo systems,
>> > > one an HP quad desktop, one a Fujitsu-Siemens laptop.
>> >
>> > Thanks for the information I think this is really independent from the
>> > fact if a laptop, or more precicely if a system with dock station/bay is
>> > used.
>> >
>> > >
>> > > >
>> > > > Do you actually have a /sys/devices/platform/dock.?/ directory with a
>> > > > file 'type' that contains 'dock_station'?
>> > >
>> > > I'll have to report back on that this evening, I'm away from them now.
>> >
>> > I actually guess that those systems don't have a
>> > /sys/devices/platform/dock.? directory at all, which is fine.
>> >
>> > I also think this will fix it, would be great if you could confirm this:
>> >
>> > acpi: Bail out when linking devices and there are no dock stations
>> >
>> > If dock_station_count is zero, we allocate zero memory and don't check
>> > this at future references. So bail out if there are actually no dock
>> > stations.
>> >
>> > Signed-off-by: Holger Macht <holger@homac.de>
>>
>> Certainly won't fix it as is (well, it shifts the crash over into kfree).
>> This function is expected to return a pointer, not an error or success
>> code.
>
> Oh well, too late for me yesterday...
>
>>
>> I've little doubt that returning NULL rather than -ENODEV there would fix
>> the boot crash; and if you're in a hurry to fix up booting (understandable)
>> then I suppose that would do for the moment.
>
> I really think this will basically do the trick. dock_(un)link_device()
> is called by ata_acpi_(un)bind_dock(), which in turn is called by
> ata_scsi_scan_host() unconditionally, thus not depending on the presence
> of a dock device. And dock_(un)link_device() simply misses the check if
> there is a dock/bay device.
>
> So how about that?
>
> acpi: Bail out when linking devices and there are no dock stations
>
> If dock_station_count is zero, we allocate zero memory and don't check
> this at future references. So bail out if there are actually no dock
> stations.
>
> Signed-off-by: Holger Macht <holger@homac.de>
> ---
>  drivers/acpi/dock.c |   19 ++++++++++++++-----
>  1 files changed, 14 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
> index b5e4142..0b3072c 100644
> --- a/drivers/acpi/dock.c
> +++ b/drivers/acpi/dock.c
> @@ -281,11 +281,15 @@ EXPORT_SYMBOL_GPL(is_dock_device);
>  */
>  struct device **dock_link_device(acpi_handle handle)
>  {
> -       struct device *dev = acpi_get_physical_device(handle);
> +       struct device *dev;
>        struct dock_station *dock_station;
>        int ret, dock = 0;
>        struct device **devices;
>
> +       if (!dock_station_count)
> +               return NULL;
> +
> +       dev = acpi_get_physical_device(handle);
>        devices = kmalloc(dock_station_count * sizeof(struct device *),
>                          GFP_KERNEL);
>
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

If bail out in this way, another patch looks needed to fix up
mem leakage :-(

>        if (!dev)
>                return NULL;
> --
> 1.7.7
