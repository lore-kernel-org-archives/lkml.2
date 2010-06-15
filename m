Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab0FOTyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 15:54:54 -0400
Received: from lirone.symas.net ([64.71.152.235]:58816 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757835Ab0FOTyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 15:54:53 -0400
Message-ID: <4C17DA85.40803@symas.com>
Date: Tue, 15 Jun 2010 12:54:45 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; rv:1.9.3a5pre) Gecko/20100607 Firefox 3.6
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] tty: Add EXTPROC support for LINEMODE
References: <E1OObIu-0004K2-3K@lirone.symas.net> <20100615202924.24446d28@lxorguk.ukuu.org.uk>
In-Reply-To: <20100615202924.24446d28@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>       bit set, and the data will be the contents of a struct termios.
>>       This allows the process on the server side of the pty to know
>>       when the state of the terminal has changed, and what the new
>>       state is.
>
> First problem - the kernel and user idea of struct termios don't match.

OK, since you mention it again down below I'll respond to this last.

>> diff --git a/arch/alpha/include/asm/termbits.h b/arch/alpha/include/asm/termbits.h
>> index ad854a4..879dd35 100644
>> --- a/arch/alpha/include/asm/termbits.h
>> +++ b/arch/alpha/include/asm/termbits.h
>> @@ -180,6 +180,7 @@ struct ktermios {
>>   #define FLUSHO	0x00800000
>>   #define PENDIN	0x20000000
>>   #define IEXTEN	0x00000400
>> +#define EXTPROC	0x10000000
>
> For Alpha this value should match OSF if possible.

I'm grubbing around looking for a live Alpha system now, doesn't seem likely 
that I'll find one. Not sure what needs to match here, it's also unlikely that 
OSF/1 (or any other SVR4 platform) ever provided a definition for this bit. 
Looking at the telnet README:
 >>>>
This is a distribution of both client and server telnet.  These programs
have been compiled on:
			telnet	telnetd
	BSD 4.4		  x	  x
	BSD 4.3 Reno	  X	  X
	UNICOS 8.0	  X	  X
	UNICOS 7.C	  X	  X
	UNICOS 7.0	  X	  X
	UNICOS 6.1	  X	  X
	BSDI 1.0	  X	  X
	Solaris 2.2       x       x (no linemode in server)
	Solaris 2.3       x       x (no linemode in server)
	SunOs 4.1.3	  X	  X (no linemode in server)
	Ultrix 4.3	  X	  X (no linemode in server)
	DYNIX V3.0.17.9	  X	  X (no linemode in server)
	HP-UX 8.0	  x       x (no linemode in server)
<<<<

I doubt that anyone ever ported this feature over to those OSes.
>
>
>> +			if (cs&  TIOCPKT_IOCTL) {
>> +				c = sizeof(struct termios);
>> +				if (c>  nr)
>> +					c = nr;
>> +				copy_to_user(b, tty->link->termios, c);
>> +				nr -= c;
>> +				b += c;
>> +			}
>
> This is where the wheels come off the bus.
>
> The kernel use struct ktermios which is what tty->link->termios is
>
> The C library presents this via struct termios which is a glibc invention
> dependant on the C library and which is converted by libc from struct
> termios or struct termios2 depending on your C library
>
> How you fix that given a broken by design historic Unix interface which
> pastes arbitary struct termios objects into the data stream is an
> interesting question - doubly so when like most Unixen we have also have
> extended terminal attributes as well (termiox)

Are you suggesting that this is completely unfixable/unworkable? Would it be 
sufficient to use kernel_termios_to_user_termios() ?

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
