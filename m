Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab1I3J0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 05:26:43 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:33179 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753567Ab1I3J0l convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 05:26:41 -0400
MIME-Version: 1.0
In-Reply-To: <20110930091957.GC3458@legolas.emea.dhcp.ti.com>
References: <1317361318-28295-1-git-send-email-keshava_mgowda@ti.com>
	<alpine.DEB.2.00.1109300113200.32653@utopia.booyaka.com>
	<20110930073449.GA13825@legolas.emea.dhcp.ti.com>
	<CAP05o4L1iR++BhYmYYEc-uV6pGfjBeSPPcFqhRizdBeV7Ko26g@mail.gmail.com>
	<20110930091957.GC3458@legolas.emea.dhcp.ti.com>
Date: Fri, 30 Sep 2011 14:56:40 +0530
Message-ID: <CAP05o4+Ww=R-hOVMbW5St2ZvwrK5cmPtM5_5Gj2pV8W1tdiQ-Q@mail.gmail.com>
Subject: Re: [PATCH 3/5 v12] arm: omap: usb: register hwmods of usbhs
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: balbi@ti.com
Cc: Paul Walmsley <paul@pwsan.com>, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        khilman@ti.com, b-cousson@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, tony@atomide.com,
        johnstul@us.ibm.com, vishwanath.bs@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 2:49 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Fri, Sep 30, 2011 at 02:45:32PM +0530, Munegowda, Keshava wrote:
>> On Fri, Sep 30, 2011 at 1:04 PM, Felipe Balbi <balbi@ti.com> wrote:
>> > Hi,
>> >
>> > On Fri, Sep 30, 2011 at 01:15:55AM -0600, Paul Walmsley wrote:
>> >> > The hwmod structure of usb_host_hs  and usb_tll are
>> >> > retrieved and registered with omap device
>> >> >
>> >> > Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
>> >> > Reviewed-by: Partha Basak <parthab@india.ti.com>
>> >> > ---
>> >> >  arch/arm/mach-omap2/usb-host.c |  100 ++++++++++++++--------------------------
>> >> >  1 files changed, 34 insertions(+), 66 deletions(-)
>> >> >
>> >> > diff --git a/arch/arm/mach-omap2/usb-host.c b/arch/arm/mach-omap2/usb-host.c
>> >> > index 89ae298..771dc78 100644
>> >> > --- a/arch/arm/mach-omap2/usb-host.c
>> >> > +++ b/arch/arm/mach-omap2/usb-host.c
>> >> > @@ -28,51 +28,28 @@
>> >>
>> >> > +   oh[0] = omap_hwmod_lookup(USBHS_UHH_HWMODNAME);
>> >> > +   if (!oh[0]) {
>> >> > +           pr_err("Could not look up %s\n", USBHS_UHH_HWMODNAME);
>> >> > +           return;
>> >> >     }
>> >> >
>> >> > -   if (platform_device_register(&usbhs_device) < 0)
>> >> > -           printk(KERN_ERR "USBHS platform_device_register failed\n");
>> >> > +   oh[1] = omap_hwmod_lookup(USBHS_TLL_HWMODNAME);
>> >> > +   if (!oh[1]) {
>> >> > +           pr_err("Could not look up %s\n", USBHS_TLL_HWMODNAME);
>> >> > +           return;
>> >> > +   }
>> >> >
>> >> > -init_end:
>> >> > -   return;
>> >> > +   od = omap_device_build_ss(OMAP_USBHS_DEVICE, bus_id, oh, 2,
>> >> > +                           (void *)&usbhs_data, sizeof(usbhs_data),
>> >> > +                           omap_uhhtll_latency,
>> >> > +                           ARRAY_SIZE(omap_uhhtll_latency), false);
>> >>
>> >> Usually there's something wrong with omap_devices that contain
>> >> multiple hwmods.  Is there some reason why there isn't a separate driver
>> >> for the TLL?  Judging by a brief look at drivers/mfd/omap_usb_host.c, the
>> >> TLL handling looks logically distinct?
>> >
>> > Yes, I have the same feeling. To my understanding, USB Host Subsystem on
>> > OMAP is composed of the Transceiver-less link (TLL) and USB Host (UHH).
>> > Aparently, they could be handled by separate drivers.
>> >
>> > --
>> > balbi
>>
>> yes, it can be as two separate drivers for uhh and tll;  But i don't
>> think driver can be used effectively.
>> Now ehci and ohci gets the clocks , config reg and port settings
>> through usb host which is sufficient.
>> If you make them as two different drivers; then ehci and ohci has to
>> interact with both the drivers separately.
>> which will be an unnecessary complications. I feel not divided this
>> driver into two
>
> Come again, EHCI/OHCI need clocks from UHH and TLL ?? If that's the
> case, then there's really no easy way to handle this as a device can
> have only one parent.

yes,  if you are using ehci phy mode ( port modes of UHH_HOSTCONFIG register)
then uhh functional ( omap3: interface clocks too) is sufficient;
if you are using ehci in tll mode , then you need tll functional clock too.

regards
keshava
