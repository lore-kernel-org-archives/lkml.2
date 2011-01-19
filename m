Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab1ASWYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:24:32 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49715 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994Ab1ASWY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:24:29 -0500
Date: Wed, 19 Jan 2011 22:24:07 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-arm-msm@vger.kernel.org,
        davidb@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, rlove@google.com
Subject: Re: [PATCH 2/2] serial: msm: Add support for UARTDM cores
Message-ID: <20110119222407.GD6335@n2100.arm.linux.org.uk>
References: <1295407585-18386-1-git-send-email-stepanm@codeaurora.org> <20110119082534.GA9569@gallagher> <4D3760DD.1010609@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3760DD.1010609@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 02:08:29PM -0800, Stepan Moskovchenko wrote:
>>> +		/* Mask conditions we're ignorning. */
>>> +		sr&= port->read_status_mask;
>>> +		if (sr&  UART_SR_RX_BREAK)
>>> +			flag = TTY_BREAK;
>>> +		else if (sr&  UART_SR_PAR_FRAME_ERR)
>>> +			flag = TTY_FRAME;
>> It doesn't look like the flag is used anywhere after it has been
>> assigned.
> An artifact of an old driver. Removed.

But still required to support proper error signalling.

>>>   static void msm_init_clock(struct uart_port *port)
>>>   {
>>>   	struct msm_port *msm_port = UART_TO_MSM(port);
>>>
>>>   	clk_enable(msm_port->clk);
>>> +	if (msm_port->pclk)
>>> +		clk_enable(msm_port->pclk);
>> NULL is a valid clk, so this should really be something like
>>
>> 	if (!IS_ERR(mem_port->pclk)
>> 		clk_enable(...);
> I don't think that will have the correct behavior. The clock is already  
> checked with IS_ERR in the probe function, so we could not get here if  
> the clk_get returned an error. Depending on the unit, there may or may  
> not be a pclk associated with it. Thus, I use NULL to indicate that a  
> pclk does not exist and should not be turned on. Regardless, at least in  
> the MSM clock driver (and in drivers/clkdev) NULL is not a valid clock,  
> I think this should be fine as is.

Don't invent new ways to do things.  As far as drivers are concerned,
struct clk pointers are cookies.  The only thing they can interpret from
them is whether they're IS_ERR() and then what the error is.  They must
assume every other value is valid.

So, if you want "clock not present" assign ERR_PTR(-ENOENT) to it or
just assign the return value from the failed clk_get().
