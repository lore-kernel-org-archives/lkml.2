Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934Ab2EUXwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 19:52:44 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51733 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932732Ab2EUXwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 19:52:41 -0400
Message-ID: <4FBAD545.7060803@gmail.com>
Date: Mon, 21 May 2012 18:52:37 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: Shawn Guo <shawn.guo@freescale.com>,
        Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] DT clk binding support
References: <4FB80F32.5090309@gmail.com> <20120520030653.GB5810@S2100-06.ap.freescale.net> <4FB9A5E7.2070000@gmail.com> <20120521064901.GE8140@S2101-09.ap.freescale.net> <4FBA89E3.7010106@gmail.com> <20120521232616.GF8140@S2101-09.ap.freescale.net>
In-Reply-To: <20120521232616.GF8140@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2012 06:26 PM, Shawn Guo wrote:
> On Mon, May 21, 2012 at 01:30:59PM -0500, Rob Herring wrote:
>>> With the bindings here, I need something like below in device tree to
>>> replace the clk lookup registration that is currently done in imx6q
>>> sabrelite specific setup code.  However the problem here is I have cko
>>> defined in clock driver, and thus I can not give phandle to cko in
>>> device tree.  What I suggest is for such cases, we could require
>>> clock-names = "cko" than clocks = <&cko>, and of_clk_get() should also
>>> be able to find the clock with looking for the clk name.
>>>
>>> imx6q-sabrelite.dts:
>>>
>>> 	codec: sgtl5000@0a {
>>> 		compatible = "fsl,sgtl5000";
>>> 		reg = <0x0a>;
>>> 		clocks = <&cko>;
>>> 	};
>>>
>>> mach-imx6q.c, imx6q_sabrelite_cko1_setup(): 
>>>
>>>         cko1 = clk_get_sys(NULL, "cko1");
>>>         clk_register_clkdev(cko1, NULL, "0-000a");
>>>
>>
>> What!? This is a terrible abuse/hack of the clock binding and is in no
>> way what was intended. You cannot use half of the clock binding. You
>> have to have a provider. The primary binding is a phandle reference.
>> clock-names is just auxiliary data.
>>
> Well, on conversation [1], it seems people agreed that for those huge
> clock tree, only leaf clocks should be exposed in device tree.  Then
> please help me understand how we could do that with the current binding
> design, considering those leaf clocks are consumers of their parent
> clocks while being provider to the leaf clock the parent clock is not
> exposed in device tree.

You are mis-interpreting things.

As Grant states: "This proposed binding is only about one thing:
attaching clock providers to clock consumers." This means you have to
have at least a single provider and a single consumer defined in the DT.

By only exposing leaf nodes of the clocks, that means only exposing a
single DT node for the SOC clocks with a whole bunch of outputs (i.e.
the leaf clocks). In the imx case, this would be a single node for the
CCM with the dozens clocks the CCM outputs. In this case you would not
expose all the individual muxes, gates, and dividers of the CCM in the
DT. You still have to describe the connection between the CCM and a h/w
block. I'm not sure what you want here. Based on our prior
conversations, I thought you wanted to break out every single clock as a
separate DT node and have generic divider, mux, and gate bindings. Now
you are arguing for the opposite.

Rob

> Regards,
> Shawn
> 
> [1] http://thread.gmane.org/gmane.linux.ports.arm.kernel/139414/focus=1216423

