Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109Ab2IYPgE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:36:04 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:33286 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757036Ab2IYPgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:36:01 -0400
Message-ID: <5061CF5A.2030201@parrot.com>
Date: Tue, 25 Sep 2012 17:35:54 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        Matthieu CASTET <castet.matthieu@free.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2] hvc_dcc : add support to armv4 and armv5 core
References: <1346413645-4593-1-git-send-email-castet.matthieu@free.fr> <5040EAF7.9010003@codeaurora.org> <201209031257.28213.arnd@arndb.de>
In-Reply-To: <201209031257.28213.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann a écrit :
> On Friday 31 August 2012, Stephen Boyd wrote:
>>> +static int hvc_dcc_put_chars_v6(uint32_t vt, const char *buf, int count)
>>> +{
>>> +     int i;
>>> +
>>> +     for (i = 0; i < count; i++) {
>>> +             while (__dcc_getstatus_v6() & DCC_STATUS_TX_V6)
>>> +                     cpu_relax();
>>> +
>>> +             __dcc_putchar_v6(buf[i]);
>>> +     }
>>> +
>>> +     return count;
>>> +}
>> It's unfortunate that the main logic is duplicated. I wonder if we could
>> push the runtime decision slightly lower into the accessor functions
>> instead and make some new functions dcc_tx_busy() and dcc_rx_busy() or
>> something. Then these loops stay the same.
The code is so small (30 asm + 30 C code) that I wonder if worth adding
complexity in the code.
Also calling cpu_architecture isn't free and if the want to put the runtime
decision into the hot path, this means we need to cache the result.

> 
> Agreed. Ideally, you should be able to get the code to be compiled into
> the same binary as before for ARMv6+. If only the inline assembly differs,
> you can do something like
> 
> static inline char __dcc_getchar(void)
> {
>         char __c;
> 
>         if (__LINUX_ARM_ARCH >= 6)
> 		asm volatile("mrc p14, 0, %0, c0, c5, 0 @ read comms data reg"
> 	                : "=r" (__c));
> 	else
> 		asm volatile ("mrc p14, 0, %0, c1, c0  @ read comms data reg"
> 			: "=r" (ret));
>         isb();
> 
>         return __c;
> }
> 
> 	Arnd
> 
Yes doing that will be great!

But Alan wanted "all be runtime handled".

May be we can do something like:


static int cpu_arch;

static inline char __dcc_getchar(void)
{
         char __c;

         if (cpu_arch >= 6)
 		asm volatile("mrc p14, 0, %0, c0, c5, 0 @ read comms data reg"
 	                : "=r" (__c));
 	else
 		asm volatile ("mrc p14, 0, %0, c1, c0  @ read comms data reg"
 			: "=r" (ret));
         isb();

         return __c;
}

static int __init hvc_dcc_console_init(void)
{
	cpu_arch = cpu_architecture();
...

}
Matthieu
