Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030237Ab2I2LE7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 07:04:59 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:35019 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759363Ab2I2LE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 07:04:58 -0400
Message-ID: <5066D5CB.5040405@synopsys.com>
Date: Sat, 29 Sep 2012 16:34:43 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Alexey Brodkin <Alexey.Brodkin@synopsys.com>, <gregkh@linuxfoundation.org>,
        <alan@linux.intel.com>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty/8250_early: Prevent rounding error in uartclk to
 baud ratio
References: <1348834748-31565-1-git-send-email-abrodkin@synopsys.com> <5065A003.4090604@suse.cz> <506697DC.50200@synopsys.com> <50669E35.20809@suse.cz>
In-Reply-To: <50669E35.20809@suse.cz>
Content-Type: text/plain; charset="ISO-8859-2"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 September 2012 12:37 PM, Jiri Slaby wrote:
> On 09/29/2012 08:40 AM, Vineet Gupta wrote:
>> On Friday 28 September 2012 06:32 PM, Jiri Slaby wrote:
>>> On 09/28/2012 02:19 PM, Alexey Brodkin wrote:
>>>> Modify divisor to select the nearest baud rate divider rather than the
>>>> lowest. It minimizes baud rate errors especially on low UART clock
>>>> frequencies.
>>>>
>>>> For example, if uartclk is 33000000 and baud is 115200 the ratio is
>>>> about 17.9 The current code selects 17 (5% error) but should select 18
>>>> (0.5% error).
>>>>
>>>> On the same lines as following:
>>>> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.9-rc3/2.6.9-rc3-mm2/broken-out/serial-pick-nearest-baud-rate-divider.patch
>>>>
>>>> Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
>>>> ---
>>>>  drivers/tty/serial/8250_early.c |    2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/tty/serial/8250_early.c b/drivers/tty/serial/8250_early.c
>>>> index eaafb98..cfc46b7 100644
>>>> --- a/drivers/tty/serial/8250_early.c
>>>> +++ b/drivers/tty/serial/8250_early.c
>>>> @@ -140,7 +140,7 @@ static void __init init_port(struct early_serial8250_device *device)
>>>>  	serial_out(port, UART_FCR, 0);		/* no fifo */
>>>>  	serial_out(port, UART_MCR, 0x3);	/* DTR + RTS */
>>>>  
>>>> -	divisor = port->uartclk / (16 * device->baud);
>>>> +	divisor = (port->uartclk + (8 * device->baud)) / (16 *	device->baud);
>>> So this should be in fact DIV_ROUND_CLOSEST(), right?
>>>
>>> But anyway I'm missing any explanation of *why* this is needed? This
>>> should be part of the commit log. Is there any bug you are fixing here?
>> Actually the issue showed up when using the stock 8250 driver for
>> Synopsys DW UART. This was on a FPGA with ~50MHz clk. When we enabled
>> early serial, we saw garbage which Alexey narrowed down to the rounding
>> error. So the bug had been latent and it only showed up with such low
>> clk rates.
> Yes, this is a perfect argument I was asking for and should have been a
> part of the commit...

First timer's anxiety I suppose ! Per your DIV_ROUND_CLOSEST()
suggestion, Alexey has already sent out a v2 patch. I presume he needs
to respin a v3 to beef up the commitlog along the lines of above !

Thx,
-Vineet

