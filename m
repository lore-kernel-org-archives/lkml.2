Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1ATALb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 19:11:31 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46967 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab1ATALa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 19:11:30 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6231"; a="70936326"
Message-ID: <4D377DB2.5090101@codeaurora.org>
Date: Wed, 19 Jan 2011 16:11:30 -0800
From: Stepan Moskovchenko <stepanm@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Jamie Iles <jamie@jamieiles.com>, linux-arm-msm@vger.kernel.org,
        davidb@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, rlove@google.com
Subject: Re: [PATCH 2/2] serial: msm: Add support for UARTDM cores
References: <1295407585-18386-1-git-send-email-stepanm@codeaurora.org> <20110119082534.GA9569@gallagher> <4D3760DD.1010609@codeaurora.org> <20110119222407.GD6335@n2100.arm.linux.org.uk>
In-Reply-To: <20110119222407.GD6335@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/19/2011 2:24 PM, Russell King - ARM Linux wrote:
> On Wed, Jan 19, 2011 at 02:08:29PM -0800, Stepan Moskovchenko wrote:
>>>> +		/* Mask conditions we're ignorning. */
>>>> +		sr&= port->read_status_mask;
>>>> +		if (sr&   UART_SR_RX_BREAK)
>>>> +			flag = TTY_BREAK;
>>>> +		else if (sr&   UART_SR_PAR_FRAME_ERR)
>>>> +			flag = TTY_FRAME;
>>> It doesn't look like the flag is used anywhere after it has been
>>> assigned.
>> An artifact of an old driver. Removed.
> But still required to support proper error signalling.
I am not very familiar with the TTY subsystem, so I am not really sure 
what to do with the flag when using tty_insert_flip_string.
Should I be using tty_insert_flip_string_fixed_flag here?

>>>>    static void msm_init_clock(struct uart_port *port)
>>>>    {
>>>>    	struct msm_port *msm_port = UART_TO_MSM(port);
>>>>
>>>>    	clk_enable(msm_port->clk);
>>>> +	if (msm_port->pclk)
>>>> +		clk_enable(msm_port->pclk);
>>> NULL is a valid clk, so this should really be something like
>>>
>>> 	if (!IS_ERR(mem_port->pclk)
>>> 		clk_enable(...);
>> I don't think that will have the correct behavior. The clock is already
>> checked with IS_ERR in the probe function, so we could not get here if
>> the clk_get returned an error. Depending on the unit, there may or may
>> not be a pclk associated with it. Thus, I use NULL to indicate that a
>> pclk does not exist and should not be turned on. Regardless, at least in
>> the MSM clock driver (and in drivers/clkdev) NULL is not a valid clock,
>> I think this should be fine as is.
> Don't invent new ways to do things.  As far as drivers are concerned,
> struct clk pointers are cookies.  The only thing they can interpret from
> them is whether they're IS_ERR() and then what the error is.  They must
> assume every other value is valid.
>
> So, if you want "clock not present" assign ERR_PTR(-ENOENT) to it or
> just assign the return value from the failed clk_get().
Very well. If I know that clock will not be needed, I will assign 
ERR_PTR(-ENOENT) instead of null to it and then check for IS_ERR.

Thanks
Steve

