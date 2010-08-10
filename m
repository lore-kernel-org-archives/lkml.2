Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296Ab0HJLuy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 07:50:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44190 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab0HJLur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 07:50:47 -0400
Message-ID: <4C613D11.7080701@monstr.eu>
Date: Tue, 10 Aug 2010 13:50:41 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: jacmet@sunsite.dk, grant.likely@secretlab.ca, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        KGDB Mailing List <kgdb-bugreport@lists.sourceforge.net>
Subject: Re: [PATCH] serial: Add CONSOLE_POLL support for uartlite
References: <1281348452-26924-1-git-send-email-monstr@monstr.eu> <4C613C8A.1050600@windriver.com>
In-Reply-To: <4C613C8A.1050600@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wessel wrote:
> On 08/09/2010 05:07 AM, Michal Simek wrote:
>> CONSOLE_POLL support for uartlite enables
>> KGDB debugging over serial line.
>>
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>> ---
>>  drivers/serial/uartlite.c |   26 +++++++++++++++++++++++++-
>>  1 files changed, 25 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/serial/uartlite.c b/drivers/serial/uartlite.c
>> index caf085d..ce1f3e0 100644
>> --- a/drivers/serial/uartlite.c
>> +++ b/drivers/serial/uartlite.c
>> @@ -322,6 +322,26 @@ static int ulite_verify_port(struct uart_port *port, struct serial_struct *ser)
>>  	return -EINVAL;
>>  }
>>  
>> +#ifdef CONFIG_CONSOLE_POLL
>> +static int ulite_get_poll_char(struct uart_port *port)
>> +{
>> +	while (!(ioread32be(port->membase + ULITE_STATUS)
>> +						& ULITE_STATUS_RXVALID))
>> +		cpu_relax();
>> +
>> +	return ioread32be(port->membase + ULITE_RX);
>> +}
> 
> 
> 
> After kdb was merged, the CONSOLE_POLL API had a subtle change where
> all I/O drivers should return immediately with a return of
> NO_POLL_CHAR in order to allow more than one I/O driver to operate in
> the same poll loop.
> 
> 
> The patch should look like the following for the get_poll_char.
> 
> +static int ulite_get_poll_char(struct uart_port *port)
> +{
> +	if (!(ioread32be(port->membase + ULITE_STATUS)
> +	    & ULITE_STATUS_RXVALID))
> +		return NO_POLL_CHAR;
> +
> +	return ioread32be(port->membase + ULITE_RX);
> +}
> 
> 
> If you agree to the change you can add my SOB.
> 
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

I have no problem with it.

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
