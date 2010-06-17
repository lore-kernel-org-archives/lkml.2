Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248Ab0FQUDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:03:08 -0400
Received: from lirone.symas.net ([64.71.152.235]:38302 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933204Ab0FQUDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:03:06 -0400
Message-ID: <4C1A7F72.6020907@symas.com>
Date: Thu, 17 Jun 2010 13:02:58 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; rv:1.9.3a5pre) Gecko/20100607 Firefox 3.6
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] tty: Add EXTPROC support for LINEMODE
References: <E1OObIu-0004K2-3K@lirone.symas.net> <20100615202924.24446d28@lxorguk.ukuu.org.uk> <4C17DA85.40803@symas.com>
In-Reply-To: <4C17DA85.40803@symas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping, any further advice on these issues?

Howard Chu wrote:
> Alan Cox wrote:
>>> diff --git a/arch/alpha/include/asm/termbits.h b/arch/alpha/include/asm/termbits.h
>>> index ad854a4..879dd35 100644
>>> --- a/arch/alpha/include/asm/termbits.h
>>> +++ b/arch/alpha/include/asm/termbits.h
>>> @@ -180,6 +180,7 @@ struct ktermios {
>>>    #define FLUSHO	0x00800000
>>>    #define PENDIN	0x20000000
>>>    #define IEXTEN	0x00000400
>>> +#define EXTPROC	0x10000000
>>
>> For Alpha this value should match OSF if possible.

OSF didn't define this flag, nor did it assign that particular bit to any 
purpose. Is that good enough?

>>> +			if (cs&   TIOCPKT_IOCTL) {
>>> +				c = sizeof(struct termios);
>>> +				if (c>   nr)
>>> +					c = nr;
>>> +				copy_to_user(b, tty->link->termios, c);
>>> +				nr -= c;
>>> +				b += c;
>>> +			}
>>
>> This is where the wheels come off the bus.
>>
>> The kernel use struct ktermios which is what tty->link->termios is
>>
>> The C library presents this via struct termios which is a glibc invention
>> dependant on the C library and which is converted by libc from struct
>> termios or struct termios2 depending on your C library
>>
>> How you fix that given a broken by design historic Unix interface which
>> pastes arbitary struct termios objects into the data stream is an
>> interesting question - doubly so when like most Unixen we have also have
>> extended terminal attributes as well (termiox)
>
> Are you suggesting that this is completely unfixable/unworkable? Would it be
> sufficient to use kernel_termios_to_user_termios() ?
>
Actually using kernel_termios_to_user_termios_1(). In all supported 
architectures this structure is basically aligned with but smaller than the 
userland struct termios. As such it will leave any unused fields unwritten in 
the user struct. This usually means it will leave c_ispeed and c_ospeed unset 
in the user struct, but that's a don't-care anyway since we're only talking 
about ptys here, and changing the speed (besides setting it to zero) is 
irrelevant for ptys.

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
