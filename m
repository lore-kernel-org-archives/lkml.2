Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab0FCQWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 12:22:07 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43066 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab0FCQWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 12:22:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=JqJkq+tQkGpTea2KDSB21JZfwZhiBV8BA8a0+seW8DcFiZ8V7/jbRLGymzm1plMTWd
         dSM13Wkcwa58boMWE41I90Yjv+r71XN/oepVXh/jW20sPCVy2UO9ORp6zZfqAvw+lfvG
         5B7cKJ/P5hQkJTOQ3YJ93oaLOkDzQDfv/MWJI=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Daniel Mack <daniel@caiaq.de>
Subject: Re: [PATCH] usb-serial/ftdi_sio: fix DTR/RTS line modes
Date: Thu, 3 Jun 2010 12:21:56 -0400
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
       Johan Hovold <jhovold@gmail.com>, Alan Cox <alan@linux.intel.com>,
       linux-usb@vger.kernel.org
References: <1275566102-5613-1-git-send-email-daniel@caiaq.de> <20100603115727.GY2695@buzzloop.caiaq.de>
In-Reply-To: <20100603115727.GY2695@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006031221.56150.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 June 2010, Daniel Mack wrote:
>On Thu, Jun 03, 2010 at 01:55:02PM +0200, Daniel Mack wrote:
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
>Oops. I forgot to Cc: stable@kernel.org.
>This is in fact broken since 2.6.31-something.
>
>> ---
>>  drivers/usb/serial/ftdi_sio.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/usb/serial/ftdi_sio.c
>> b/drivers/usb/serial/ftdi_sio.c index 050211a..79dd1ae 100644
>> --- a/drivers/usb/serial/ftdi_sio.c
>> +++ b/drivers/usb/serial/ftdi_sio.c
>> @@ -2005,6 +2005,8 @@ static void ftdi_set_termios(struct tty_struct
>> *tty, "urb failed to set to rts/cts flow control\n");
>>  		}
>>
>> +		/* raise DTR/RTS */
>> +		set_mctrl(port, TIOCM_DTR | TIOCM_RTS);
>>  	} else {
>>  		/*
>>  		 * Xon/Xoff code
>> @@ -2052,6 +2054,8 @@ static void ftdi_set_termios(struct tty_struct
>> *tty, }
>>  		}
>>
>> +		/* lower DTR/RTS */
>> +		clear_mctrl(port, TIOCM_DTR | TIOCM_RTS);
>>  	}
>>  	return;
>>  }
>

How soon can this get in?  I ask because I have been crippled in all 
attempts to use an ftdi adaptor to talk to an old legacy machine I have for 
about that long now. xon/xoff seems completely broken, and 7wire seems to 
scramble things to the point where no null modem cable I have made (and I 
have a book on them) will allow the 7wire flow controls to function.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
"Being against torture ought to be sort of a multipartisan thing."
-- Karl Lehenbauer, as amended by Jeff Daiell, a Libertarian
