Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab2JBEdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 00:33:50 -0400
Received: from us02smtp1.synopsys.com ([198.182.60.75]:47447 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab2JBEds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 00:33:48 -0400
Message-ID: <506A6E8E.2000005@synopsys.com>
Date: Tue, 2 Oct 2012 10:03:18 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: <gregkh@linuxfoundation.org>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial/arc-uart: Add new driver
References: <1348835752-28426-1-git-send-email-vgupta@synopsys.com> <20120928140248.54a10d06@bob.linux.org.uk>
In-Reply-To: <20120928140248.54a10d06@bob.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 September 2012 06:32 PM, Alan Cox wrote:

>> +static void
>> +arc_serial_set_termios(struct uart_port *port, struct ktermios
>> *termios,
>> +		       struct ktermios *old)
>> +{
>> +	struct arc_uart_port *uart = (struct arc_uart_port *)port;
>> +	unsigned int baud, uartl, uarth, hw_val;
>> +	unsigned long flags;
>> +
> Two things here. Firstly you want to write the actual baud back to the
> termios (tty_termios_encode_baud_rate) unless B0 is set.
>
> Secondly if you don't support hardware flow control, character size
> setting etc then you need to set those bits back so the caller knows.
> Two ways to do that. Either initialise the default termios for the tty
> type to the correct values and use tty_termios_copy_hw() or set them in
> the termios handler.

Just to give you an idea, is something on the lines of following OK for
both the above points above !

-       uart_update_timeout(port, termios->c_cflag, baud);
+       new->c_cflag &= ~(CMSPAR|CRTSCTS);  /* Don't care for
parity/flow ctrl */
+
+       if (old)
+               tty_termios_copy_hw(new, old);
+
+       /* Don't rewrite B0 */
+       if (tty_termios_baud_rate(new))
+               tty_termios_encode_baud_rate(new, baud, baud);
+
+       uart_update_timeout(port, new->c_cflag, baud);
 

Respun patch to follow shortly.

Thx,
Vineet
