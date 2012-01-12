Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab2ALRFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 12:05:55 -0500
Received: from static.121.164.40.188.clients.your-server.de ([188.40.164.121]:55441
	"EHLO smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab2ALRFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 12:05:52 -0500
Date: Thu, 12 Jan 2012 18:05:46 +0100
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <256392989.20120112180546@eikelenboom.it>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        xen-devel <xen-devel@lists.xensource.com>
Subject: Re: linux 3.3-pre-rc1: Starting domU fails with Error: Failed to query current memory allocation of dom0.
In-Reply-To: <20120112164025.GA22773@phenom.dumpdata.com>
References: <498097597.20120112133832@eikelenboom.it> <20120112154613.GA10148@phenom.dumpdata.com> <CAPXgP1373C5SfzU-rfo5GG53dUE6dVzECSuKzX1c_FirpXQt2g@mail.gmail.com> <20120112161204.GC10269@phenom.dumpdata.com> <20120112164025.GA22773@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Konrad,

Thursday, January 12, 2012, 5:40:25 PM, you wrote:

> On Thu, Jan 12, 2012 at 11:12:04AM -0500, Konrad Rzeszutek Wilk wrote:
>> On Thu, Jan 12, 2012 at 05:05:34PM +0100, Kay Sievers wrote:
>> > On Thu, Jan 12, 2012 at 16:46, Konrad Rzeszutek Wilk
>> > <konrad.wilk@oracle.com> wrote:
>> > > On Thu, Jan 12, 2012 at 01:38:32PM +0100, Sander Eikelenboom wrote:
>> > 
>> > >> Today i tried linuses tree of today (last commit is 4c4d285ad5665bfbd983b95fde8d7a477d24a361).
>> > >>
>> > >> It boots dom0 fine, but it fails to start any domU with: "Error: Failed to query current memory allocation of dom0."
>> > >> With my previous 3.1.5 kernel everything is fine, nothing else changed in config in between.
>> > > Your patch that converts the xen-balloon to use the regular device bus driver
>> > > (070680218379e15c1901f4bf21b98e3cbf12b527) has some not-so-happy consequences.
>> > >
>> > > The toolstack (xen-tools) use:
>> > >
>> > > /sys/devices/system/xen_memory/xen_memory0
>> > >
>> > > But with the change, it is now:
>> > >
>> > > /sys/devices/xen_memory0/target_kb
>> > 
>> > Urks, seems like a mistake on my side.
>> > 
>> > Please try if changing:
>> >   bus_unregister(&balloon_subsys);
>> > to:
>> >   subsys_system_register(&balloon_subsys, NULL);
>> > in:
>> >   drivers/xen/xen-balloon.c
>> > fixes the issue.
>> 
>> Heh. I was *just* looking at d369a5d8fc70710236ae2d06a0e42dce483712df
>> ("clocksource: convert sysdev_class to a regular subsystem") and typed up this patch
>> to try it out:

> Kay, are you Acking this patch? (I can send it to Linus for rc0 or rc1)

> commit 4e6f161986678a25c9e76af98df928408c734a27
> Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date:   Thu Jan 12 11:35:50 2012 -0500

>     xen/balloon: Move the registration from device to subsystem.
>     
>     With git commit 070680218379e15c1901f4bf21b98e3cbf12b527
>     "xen-balloon: convert sysdev_class to a regular subsystem" we would
>     end up with the attributes being put in:
>     
>      /sys/devices/xen_memory0/target_kb
>     instead of
>     /sys/devices/system/xen_memory/xen_memory0/target_kb
>     
>     Making the tools unable to deflate the kernel to make more space
>     for launching another guest and printing:

>     Error: Failed to query current memory allocation of dom0
>     
>     Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
>     Suggested-by:  Kay Sievers <kay.sievers@vrfy.org>
>     Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

> diff --git a/drivers/xen/xen-balloon.c b/drivers/xen/xen-balloon.c
> index 3832e30..596e6a7 100644
> --- a/drivers/xen/xen-balloon.c
> +++ b/drivers/xen/xen-balloon.c
> @@ -221,7 +221,7 @@ static int register_balloon(struct device *dev)
>  {
>         int i, error;
>  
> -       error = bus_register(&balloon_subsys);
> +       error = subsys_system_register(&balloon_subsys, NULL);
>         if (error)
>                 return error;
>  


Shouldn't the

if (error) {
        bus_unregister(&balloon_subsys);
        return error;
}

right below it also be changed ?

