Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548Ab2IMQQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 12:16:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58060 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab2IMQQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 12:16:50 -0400
Message-ID: <505206E3.7050307@ti.com>
Date: Thu, 13 Sep 2012 18:16:35 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>, <balbi@ti.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <arnd@arndb.de>,
        <gregkh@linuxfoundation.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] arm: omap: hwmod: make *phy_48m* as the main_clk of
 ocp2scp
References: <1347008955-21310-1-git-send-email-kishon@ti.com> <alpine.DEB.2.00.1209112218440.9444@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.00.1209112218440.9444@utopia.booyaka.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 09/12/2012 12:28 AM, Paul Walmsley wrote:
> Hi Kishon, Benoît,
> 
> On Fri, 7 Sep 2012, Kishon Vijay Abraham I wrote:
> 
>> Made *ocp2scp_usb_phy_phy_48m* as the main_clk for ocp2scp. Since this 
>> ocp2scp module does not have any fck but does have a single opt_clock, 
>> it is added as the main_clk for ocp2scp. Also removed phy_48m as the 
>> optional clock since it is now made as the main clock. By this the 
>> driver need not enable/disable phy_48m clk separately and 
>> runtime_get/runtime_put will take care of that.
> 
> Looking at this patch, it doesn't seem to make sense from a hardware point 
> of view.  If you look at the OMAP4430 TRM Rev. AE, Table 23-1166 "Clocks 
> and Resets", the 48MHz clock input is listed as an "Optional functional 
> clock".  The main functional clock is listed as "INIT_960M_FCLK", which 
> according to the same TRM, Section 3.6.3.9.1 "Overview", is an alias for 
> the clock we call "dpll_usb_clkdcoldo_ck".
> 
> So if any clock should be the main functional clock in the hwmod data, 
> shouldn't it be dpll_usb_clkdcoldo_ck?  The goal with the hwmod data 
> is/was to have it match the hardware.

In this case, the ocp2scp IP is just the *bus controller* to access the
real USB_UTMI_PHY IP.

The TRM diagram does not show that level of detail unfortunately. You
can check the PRCM spec (Figure 78 : CD_L3_INIT_USB clock scheme) to see
the two modules.

So considering phy_48m as the main clock is still correct for the
ocp2scp IP.

The INIT_960M_FCLK will be a fck associated with the child of the
ocp2scp nodes which is the usb_phy.

Upgrading the opt_clk to fck does make sense as soon as we don't have
any other functional clock and as soon as this clock is *mandatory*. The
optional aspect in that case is just a wrong PRCM naming for a clock
that is mandatory. It is similar to the DSS case that does have only
optional clocks that are mandatory.

I do agree that we must stick to the HW definition as far as we can. But
the optional attribute is something that is wrong/inaccurate for a
couple of IPs. HW folks agreed on that point and will fix that in the
future.

Regards,
Benoit

