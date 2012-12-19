Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab2LSTMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 14:12:25 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10787 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab2LSTMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 14:12:18 -0500
X-IronPort-AV: E=Sophos;i="4.84,318,1355126400"; 
   d="scan'208";a="15229519"
Message-ID: <50D21191.3000501@codeaurora.org>
Date: Wed, 19 Dec 2012 11:12:17 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Josh Cartwright <josh.cartwright@ni.com>
CC: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH 4/4] clk: zynq: Use of_init_clk_data()
References: <1355778135-32458-1-git-send-email-sboyd@codeaurora.org> <1355778135-32458-5-git-send-email-sboyd@codeaurora.org> <20121219172619.GB1005@beefymiracle.amer.corp.natinst.com> <50D2056E.9000507@codeaurora.org> <20121219183617.GC1005@beefymiracle.amer.corp.natinst.com>
In-Reply-To: <20121219183617.GC1005@beefymiracle.amer.corp.natinst.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/12 10:36, Josh Cartwright wrote:
> On Wed, Dec 19, 2012 at 10:20:30AM -0800, Stephen Boyd wrote:
>> On 12/19/12 09:26, Josh Cartwright wrote:
>>> On Mon, Dec 17, 2012 at 01:02:15PM -0800, Stephen Boyd wrote:
> [..]
>> Can you show the code at those line numbers? There are quite a few
>> WARN_ONs in that code and it's possible the WARN_ON is the one
>> introduced in this patch.
> It looks like we're not hitting the WARN_ON() you added, but several of
> the other ones.

Ah it seems that zynq is doing different things with the clock names.
The periph clock is this

                                uart_clk: uart_clk {
                                        #clock-cells = <1>;
                                        compatible =
"xlnx,zynq-periph-clock";
                                        clocks = <&iopll &armpll &ddrpll>;
                                        reg = <0x154>;
                                        clock-output-names =
"uart0_ref_clk",
                                                            
"uart1_ref_clk";

and so zynq_periph_clk_setup() wants to register clocks named uart_clk,
uart0_ref_clk, and uart1_ref_clk. But my change causes uart0_ref_clk to
be registered twice because of the way of_init_clk_data() detects the
init.name property from the binding (we use clock-output-names[0] and
only use np->name if there is no clock-output-names).

Perhaps we need to make of_init_clk_data() take an integer argument
indicating which name to use? So of_init_clk_data(np, &init, 0) would
mean use the np->name as the init.name, and of_init_clk_data(np, &init,
1) would mean use the clock-output-names[0] property,
of_init_clk_data(np, &init, 2) would mean use the clock-output-names[1]
property.

Or perhaps we should think of some way to generate unique names from the
bindings that the clock APIs can use internally.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

