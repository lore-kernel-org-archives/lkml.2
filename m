Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab1EaQwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 12:52:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63075 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974Ab1EaQwE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 12:52:04 -0400
MIME-Version: 1.0
X-Originating-IP: [230.229.188.175]
In-Reply-To: <20110531160822.GA32411@S2100-06.ap.freescale.net>
References: <1306767139-24763-1-git-send-email-shawn.guo@linaro.org>
	<201105311328.18012.arnd@arndb.de>
	<20110531151019.GA32275@S2100-06.ap.freescale.net>
	<201105311727.55985.arnd@arndb.de>
	<20110531160822.GA32411@S2100-06.ap.freescale.net>
Date: Tue, 31 May 2011 09:52:02 -0700
Message-ID: <BANLkTi=sejqS_trYtVXF79ejekHfKX7nOA@mail.gmail.com>
Subject: Re: [PATCH 2/4] ARM: mxc: migrate mach-mx5 gpio driver to gpio-mxc
From: Olof Johansson <olof@lixom.net>
To: Shawn Guo <shawn.guo@freescale.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[was offline last night, apologies for the latency]

On Tue, May 31, 2011 at 9:08 AM, Shawn Guo <shawn.guo@freescale.com> wrote:
> On Tue, May 31, 2011 at 05:27:55PM +0200, Arnd Bergmann wrote:
>> On Tuesday 31 May 2011, Shawn Guo wrote:
>> >
>> > On Tue, May 31, 2011 at 01:28:17PM +0200, Arnd Bergmann wrote:
>> > > On Tuesday 31 May 2011, Shawn Guo wrote:
>> > > > > Just open-code the mxc_add_mxc_gpio() by moving the individual calls to
>> > > > > mxc_add_gpio() into the respective callers. Having a global
>> > > > > mxc_add_mxc_gpio() function that does something different for each
>> > > > > caller seems entirely pointless to me.
>> > > > >
>> > > > Right now, mxc_add_mxc_gpio() is a postcore_initcall.  Moving
>> > > > individual mxc_add_gpio() call into irq_init function does not work.
>> > > > And I need to find a proper caller for each SoC to call mxc_add_gpio
>> > > > to register gpio devices.
>> > >
>> > > Why not init_machine? That is an arch_initcall(), so it's probably close
>> > > enough.
>> > >
>> > The init_machine is mostly a board specific function than SoC specific
>> > one.  That is to say we will call mxc_add_gpio() in every single board
>> > init function even for the same SoC.
>>
>> But the machine is the only place that knows what SOC is being used.
>> Your patch right now detects it by looking at the CPU type that is
>> also being set by the board file using the init_early call, which
>> is a bit silly.
>>
> I would say that the CPU type is being set by SoC file (e.g.
> mach-mx5/mm.c) than board file.  All the things in mach-mx5/mm.c are
> common to any mx51 based boards.

The thing is that all initialization today starts at the board file.
Instead of setting a variable that determines code paths in
asyncronous initcalls later, you might as well call the appropriate
initcall functions from common functions called by board files.

So, you'd just add a call to a common per-soc init in each of the
per-board machine_init functions. Over time it'll be a good place to
add code that would otherwise be duplicated per board of the same soc
family.

>> I would leave e.g. the imx51_register_gpios() in place, but only
>> change the definition and the caller to
>>
>> void __init imx51_register_gpios(void)
>> {
>>         mxc_add_gpio(0, MX51_GPIO1_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO1_LOW, MX51_MXC_INT_GPIO1_HIGH);
>>         mxc_add_gpio(1, MX51_GPIO2_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO2_LOW, MX51_MXC_INT_GPIO2_HIGH);
>>         mxc_add_gpio(2, MX51_GPIO3_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO3_LOW, MX51_MXC_INT_GPIO3_HIGH);
>>         mxc_add_gpio(3, MX51_GPIO4_BASE_ADDR, SZ_16K, MX51_MXC_INT_GPIO4_LOW, MX51_MXC_INT_GPIO4_HIGH);
>> }
>>
>> Then you can call that function from each i.mx51 based board, or
>> from a new imx51_soc_init() function that groups multiple such
>> functions.
>>
> It will anyway touch every single board file (a lot) to have this SoC
> specific device registration plugged in.  If you still think it's
> worthy to do so, I can turn around.

I personally prefer the imx51_soc_init() Arnd proposed above, since
there's a chance you will want to add more things to it over time. It
is worth adding it now, it's just a one-line change per board and it
gives you a good place to hook in other per-family setup that might be
needed later.


-Olof
