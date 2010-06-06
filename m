Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab0FFJjc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 05:39:32 -0400
Received: from wsp.xs4all.nl ([80.101.25.214]:58365 "EHLO wsprwl.xs4all.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751140Ab0FFJjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 05:39:31 -0400
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Jun 2010 05:39:30 EDT
Message-ID: <4C0B6B52.5050702@xs4all.nl>
Date: Sun, 06 Jun 2010 11:33:06 +0200
From: Ruud Linders <kernelml@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100401 Thunderbird/3.0.4
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
CC: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Johan Hovold <jhovold@gmail.com>, Alan Cox <alan@linux.intel.com>,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb-serial/ftdi_sio: fix DTR/RTS line modes
References: <1275566102-5613-1-git-send-email-daniel@caiaq.de> <20100603115727.GY2695@buzzloop.caiaq.de>
In-Reply-To: <20100603115727.GY2695@buzzloop.caiaq.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 06/03/2010 01:57 PM, Daniel Mack wrote:
> On Thu, Jun 03, 2010 at 01:55:02PM +0200, Daniel Mack wrote:
>> Call set_mctrl() and clear_mctrl() according to the flow control mode
>> selected. This makes serial communication for FT232 connected devices
>> work when CRTSCTS is not set.
>>
>> This fixes a regression introduced by 4175f3e31 ("tty_port: If we are
>> opened non blocking we still need to raise the carrier"). This patch
>> calls the low-level driver's dtr_rts() function which consequently sets
>> TIOCM_DTR | TIOCM_RTS. A later call to set_termios() without CRTSCTS in
>> cflags, however, does not reset these bits, and so data is not actually
>> sent out on the serial wire.
>>
>> Signed-off-by: Daniel Mack <daniel@caiaq.de>
>> Cc: Greg Kroah-Hartman <gregkh@suse.de>
>> Cc: Johan Hovold <jhovold@gmail.com>
>> Cc: Alan Cox <alan@linux.intel.com>
>> Cc: linux-usb@vger.kernel.org
> 
> Oops. I forgot to Cc: stable@kernel.org.
> This is in fact broken since 2.6.31-something.
> 
> 
> 
> 
>> ---
>>  drivers/usb/serial/ftdi_sio.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
>> index 050211a..79dd1ae 100644
>> --- a/drivers/usb/serial/ftdi_sio.c
>> +++ b/drivers/usb/serial/ftdi_sio.c
>> @@ -2005,6 +2005,8 @@ static void ftdi_set_termios(struct tty_struct *tty,
>>  				"urb failed to set to rts/cts flow control\n");
>>  		}
>>  
>> +		/* raise DTR/RTS */
>> +		set_mctrl(port, TIOCM_DTR | TIOCM_RTS);
>>  	} else {
>>  		/*
>>  		 * Xon/Xoff code
>> @@ -2052,6 +2054,8 @@ static void ftdi_set_termios(struct tty_struct *tty,
>>  			}
>>  		}
>>  
>> +		/* lower DTR/RTS */
>> +		clear_mctrl(port, TIOCM_DTR | TIOCM_RTS);
>>  	}
>>  	return;
>>  }
>> -- 
>> 1.7.1
>>
> --

Hmm, I tried this patch on plain 2.6.34 but still have a problem.
As you indicated since 2.6.31-something something is broken.

I'm using a receive only device (http://rfxcom.com/receivers.htm)
which works fine until the system becomes more busy, usually it runs
almost idle and all is fine.

However, when this happens, it appears the received characters get
buffered somewhere as nothing seems to get through or is delayed for
many minutes.
When I then =write= a character to the serial device
	echo > /dev/ttyUSB0
the data is received in sudden burst, seems no data is actually lost
just seriously delayed.

Any ideas ?
