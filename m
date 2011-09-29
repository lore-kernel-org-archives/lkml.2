Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab1I2RXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 13:23:23 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29162 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab1I2RXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 13:23:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6484"; a="123507445"
Message-ID: <4E84A962.9030806@codeaurora.org>
Date: Thu, 29 Sep 2011 10:22:42 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCHv2 2/2] ARM: debug: Move DEBUG_ICEDCC into the DEBUG_LL
 choice
References: <1316568208-4518-1-git-send-email-sboyd@codeaurora.org> <1316568208-4518-2-git-send-email-sboyd@codeaurora.org> <4E83D25C.6020306@codeaurora.org> <20110929092102.GB25061@e102144-lin.cambridge.arm.com> <20110929094243.GC25061@e102144-lin.cambridge.arm.com> <20110929094602.GH23944@n2100.arm.linux.org.uk> <20110929103939.GD25061@e102144-lin.cambridge.arm.com>
In-Reply-To: <20110929103939.GD25061@e102144-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/11 03:39, Will Deacon wrote:
> Hi Russell,
>
> On Thu, Sep 29, 2011 at 10:46:02AM +0100, Russell King - ARM Linux wrote:
>> On Thu, Sep 29, 2011 at 10:42:43AM +0100, Will Deacon wrote:
>>> Bah, just took this for a spin on my Realview-PBX (Cortex-A9) platform and
>>> the board won't boot unless I have a hardware debugger enabled that can
>>> service the comms channel. This contradicts the Kconfig text which says:
>>>
>>> 	  It does include a timeout to ensure that the system does not
>>> 	  totally freeze when there is nothing connected to read.
>>>
>>> so we certainly need to fix something!
>> One of the problems you'll encounter is that there's places where we
>> don't have any timer infrastructure (eg, decompressor) and software
>> timing loops won't work (they'll be too slow for the lower-end CPUs
>> and too fast for the upper-end CPUs.)
> Agreed, software timing loops are the only option and it's impossible to get
> them right everywhere. I think the Kconfig help text should be updated so
> that the timeout paragraph is removed.

Yes if you wait a long time the timeout for each character will expire
and the execution will continue.

>
>> The best fix is probably to leave that as-is, but introduce a 'default'
>> output entry instead - so platforms which don't have any listed will
>> get that instead of the ICEDDC stuff.
[...]
> ----8<----
>
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 32b1be4..bfdf86b 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -81,6 +81,14 @@ choice
>         prompt "Kernel low-level debugging port"
>         depends on DEBUG_LL
>  
> +       config DEBUG_LL_UART_NONE
> +               bool "No low-level debugging UART"

Should this grow a long list of platforms that are in this choice menu?
For example:

    depends on !FOOTBRIDGE && !ARCH_CLPS711X && ...

> +               help
> +                 Say Y here if your platform doesn't provide a UART option
> +                 below. This relies on your platform choosing the right UART
> +                 definition internally in order for low-level debugging to
> +                 work.
> +
>         config DEBUG_ICEDCC
>                 bool "Kernel low-level debugging via EmbeddedICE DCC channel"
>                 help
> @@ -89,8 +97,8 @@ choice
>                   co-processor 14. This is known to work on the ARM9 style ICE
>                   channel and on the XScale with the PEEDI.
>  
> -                 It does include a timeout to ensure that the system does not
> -                 totally freeze when there is nothing connected to read.
> +                 Note that this may cause the system to hang during boot if
> +                 there is nothing to read from the DCC.
>  
>         config DEBUG_FOOTBRIDGE_COM1
>                 bool "Kernel low-level debugging messages via footbridge 8250 at PCI COM1"
>

Otherwise

Acked-by: Stephen Boyd <sboyd@codeaurora.org>

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

