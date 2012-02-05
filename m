Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab2BEMgA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 07:36:00 -0500
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:57793 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750840Ab2BEMf6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 07:35:58 -0500
MIME-Version: 1.0
In-Reply-To: <20120205113521.GA13533@legolas.emea.dhcp.ti.com>
References: <4F2AF68D.1000505@ti.com> <20120202214907.GA22888@legolas.emea.dhcp.ti.com>
 <20120202215350.GB22888@legolas.emea.dhcp.ti.com> <4F2B078B.1040709@ti.com>
 <20120202220744.GA23092@legolas.emea.dhcp.ti.com> <87liojajs4.fsf@ti.com>
 <20120204160802.GA10818@legolas.emea.dhcp.ti.com> <CA+HSevqvHAgA+PPLm8BH5vfWkc8yY8W+fRpqjT2urq2EWtSYiA@mail.gmail.com>
 <20120205090805.GA13300@legolas.emea.dhcp.ti.com> <CAMQu2gyNhEJ3vr7_o_xYAQOYKaRofJViobKtfH2HoxwgU7nUpw@mail.gmail.com>
 <20120205113521.GA13533@legolas.emea.dhcp.ti.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Sun, 5 Feb 2012 18:05:37 +0530
Message-ID: <CAMQu2gzaQ+uHGpu-mpEPaxFim4_yRayKw_XBPBUgu7ML7daR2w@mail.gmail.com>
Subject: Re: [PATCH v9 01/25] gpio/omap: remove dependency on gpio_bank_count
To: balbi@ti.com
Cc: "Varadarajan, Charulatha" <charu@ti.com>, Kevin Hilman <khilman@ti.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>, linux-omap@vger.kernel.org,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 5, 2012 at 5:05 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Sun, Feb 05, 2012 at 02:46:19PM +0530, Shilimkar, Santosh wrote:
>> >> bank->mod_usage check is used to take care of doing pm_runtime_get*/put* only
>> >> if all the GPIOs in a particular bank are enabled or disabled respectively.
>> >
>> > and why should you care about that ? The first get will enable the
>> > resources you need, the second get will just increase a counter and so
>> > on. So if you have 32 gets, you will disable the module when you have 32
>> > puts.
>> >
>> Am not sure if it is clear to you that the GPIO resources like clock,
>> debounce clk are per bank wise and not per GPIO line. So doing 32
>
> this is just one more reason to have usage counters.
>
>> get/put per bank is stupid. runtime pm is for managing pm
>
> what's stupid is trying to use the pm usage counters as a binary flag,
> see below.
>
>> resources and if the pm resource is per bank, it has to be
>> handled per bank.
>
> hehe, what are you talking about Santosh ? That's the whole point of
> reference counting. If there are 32 users for 1 resource, you want to
> make sure that you only free the resources (clocks, or whatever resource
> you want) after all 32 users are done with it.
>
> Trying to use the pm usage counter as a binary flag, that's the stupid
> part of the OMAP GPIO driver.
>
> Instead of adding checks such as:
>
> if (module_isnt_used())
>        enable_clocks();
>
> on get and:
>
> if (module_isnt_needed_anymore())
>        disable_clcoks()
>
> on put is the most useless piece of code on that driver. Because such
> checks are already available on PM core through usage counters. The way
> that part of the code works is as follow:
>
> get() {
>        if (pm_counter_is_zero(dev)) {
>                atomic_inc();
>
>                rpm_resume();
>        }
> }
>
> put() {
>        atomic_dec();
>
>        if (pm_counter_is_zero(dev)) {
>                rpm_suspend();
>        }
> }
>
> Do you not see that you're duplicating functionality by trying to use
> the pm counter a binary flag ?
>
Ahh.. Now I see your point. I miss-understood the point first time
and thought that we have disconnect on the pm resources from
number of GPIO perspective.

What you are saying is to use pm runtime reference counters rather
than creating local ones for GPIO which seems to be right thing to
do. Sorry for the noise.

The agressive clock cutting was tried initially without much success
and may be we can revisit this one more time.

As per as this series is concerned, we would like to fix
the build error pointed by Kevin and queue it for 3.4.

There are few more fixes getting cooked up for GPIO and
as part of that series we will have a look at your suggestion.

Thanks for review.

Regards
santosh




Regards
Santosh
