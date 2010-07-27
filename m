Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab0G0Hyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 03:54:40 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:53713 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753660Ab0G0Hyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 03:54:38 -0400
Message-ID: <4C4E9064.6070001@stericsson.com>
Date: Tue, 27 Jul 2010 09:53:08 +0200
From: Philippe Langlais <philippe.langlais@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Lightning/1.0b1 Thunderbird/3.0.5
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Vincent Guittot <vincent.guittot@stericsson.com>
Subject: Re: patch "U6715 8250 serial like driver" added to gregkh-2.6 tree
References: <1279531660-16317-1-git-send-email-philippe.langlais@stericsson.com>	<12798430773066@site> <20100723090119.5d63cfb7@lxorguk.ukuu.org.uk>
In-Reply-To: <20100723090119.5d63cfb7@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/23/10 10:01, Alan Cox wrote:
> On Thu, 22 Jul 2010 16:57:57 -0700
> <gregkh@suse.de>  wrote:
>
>    
>> This is a note to let you know that I've just added the patch titled
>>      
> NAK this
>
> I've nakked several similar patches already from people trying to
> convolute the 8250 driver even further, doubly so when the patch
> redefines properties of existing chips according to a compile time option
>
>
>    
>>   	[PORT_16550A] = {
>>   		.name		= "16550A",
>> +#if defined(CONFIG_SERIAL_8250_U6XXX)
>> +		.fifo_size	= 64,
>> +		.tx_loadsz	= 64,
>> +		.flags		= UART_CAP_FIFO | UART_CAP_AFE,
>> +#else
>>   		.fifo_size	= 16,
>>   		.tx_loadsz	= 16,
>> -		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
>>   		.flags		= UART_CAP_FIFO,
>> +#endif
>> +		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
>>   	},
>>      
> Define yourself a new port type
>    
I agree, but the problem is to recognize our 16550A IP vs others.
Until now I can't find a differentiator with other 16550A and this IP
is only use in our U6XXX SoCs family.
To avoid mis recognition can I patch autoconfig_16550a() in 8250.c like 
this:

static void autoconfig_16550a(struct uart_8250_port *up)
{
      unsigned char status1, status2;
      unsigned int iersave;

+#if !defined(CONFIG_PLAT_U6XXX)
      up->port.type = PORT_16550A;
+#else
+    up->port.type = PORT_U6_16550A;
+#endif

>
>    
>> @@ -2268,6 +2274,13 @@ serial8250_set_termios(struct uart_port
>>   	/*
>>   	 * Ask the core to calculate the divisor for us.
>>   	 */
>> +#ifdef CONFIG_SERIAL_8250_CUSTOM_CLOCK
>> +	baud = uart_get_baud_rate(port, termios, old, 0,
>> +			CONFIG_SERIAL_8250_CUSTOM_MAX_BAUDRATE);
>> +	/* Calculate the new uart clock frequency if it is tunable */
>> +	port->uartclk = serial8250_get_custom_clock(port, baud);
>> +#endif
>> +
>>   	baud = uart_get_baud_rate(port, termios, old,
>>   				  port->uartclk / 16 / 0xffff,
>>   				  port->uartclk / 16);
>>      
>
> I think what you need to keep this clean is to create a
> port->set_termios() for the 8250 port (akin to
> port->serial_in/serial_out) which does the specials you need each end and
> calls the standard serial8250_set_termios)
>    
I don't think so, call a function which compute clock each time
we access UART registers isn't optimal, another function to overload ?
>    
>> @@ -2298,6 +2311,13 @@ serial8250_set_termios(struct uart_port
>>   		up->mcr&= ~UART_MCR_AFE;
>>   		if (termios->c_cflag&  CRTSCTS)
>>   			up->mcr |= UART_MCR_AFE;
>> +#if defined(CONFIG_SERIAL_8250_U6XXX)
>> +		/**
>> +		 * When AFE is active, let the HW handle the stop/restart TX
>> +		 * upon CTS change. It reacts much quicker than the SW driver.
>> +		 */
>> +		port->flags&= ~ASYNC_CTS_FLOW;
>> +#endif
>>      
> Why do you need to clear this flag when doing so ?
>    
I don't know if it's useful, I'll withdraw this & make tests.
>
>
>
>    
>> +unsigned int serial8250_enable_clock(struct uart_port *port)
>> +{
>> +	struct u6_uart *uart_u6 = port->private_data;
>> +
>> +	if (!uart_u6)
>> +		return uart_enable_clock(port);
>> +
>> +	if (IS_ERR(uart_u6->uartClk)) {
>> +		printk(KERN_WARNING "%s - uart clock failed error:%ld\n",
>> +		       __func__, PTR_ERR(uart_u6->uartClk));
>>      
> pr_warn()
>
> Also as the functions are specific to the u6175 can you use u6715_ names
> so any printk, traceback and the like is obvious in where to look.
>    
OK
>
>    
>> +unsigned int serial8250_get_custom_clock(struct uart_port *port,
>> +					 unsigned int baud)
>> +{
>> +	switch (baud) {
>> +	case 3250000:
>> +		return 52000000;
>> +	case 2000000:
>> +		return 32000000;
>> +	case 1843200:
>> +		return 29491200;
>> +	case 921600:
>> +		return 14745600;
>> +	default:
>> +		return 7372800;
>> +	}
>> +}
>>      
> Baud rates are arbitary values, so surely this should doing range checks ?
>    
Yes
>
>    
>> +config SERIAL_8250_CUSTOM_CLOCK
>> +	bool "Support serial ports with tunable input clock frequency"
>> +	depends on SERIAL_8250_EXTENDED&&  SERIAL_8250_U6XXX
>> +	default y
>> +	help
>> +	  Say Y here if your platform has specific registers to change UART clock frequency.
>>      
> Except the patch you've posted is actually a patch for a U6715 not
> generic tunable input clock support, so this Kconfig option/help will
> confuse people. Better to describe it as U6715 support.
>    
Yes
>
>    
>> +#ifdef CONFIG_SERIAL_8250_CUSTOM_CLOCK
>> +unsigned int serial8250_enable_clock(struct uart_port *port);
>> +unsigned int serial8250_disable_clock(struct uart_port *port);
>> +unsigned int serial8250_get_custom_clock(struct uart_port *port,
>> +		unsigned int baud);
>> +void serial8250_set_custom_clock(struct uart_port *port);
>> +#endif
>>      
> This shouldn't need ifdefs in the header
>    
Yes

Regards
Philippe
