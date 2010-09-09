Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab0IIHzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 03:55:15 -0400
Received: from rcsinet14.oracle.com ([148.87.113.126]:21118 "EHLO
	rcsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab0IIHzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 03:55:08 -0400
X-Greylist: delayed 1644 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Sep 2010 03:55:07 EDT
Message-ID: <4C888B8B.5020304@kernel.org>
Date: Thu, 09 Sep 2010 00:23:55 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Torsten Kaiser <just.for.lkml@googlemail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86, setup: fix earlyprintk=serial,0x3f8,115200
References: <AANLkTinRRiW1VUzS+3T82=q8PsoRn78Cgn_X8gSduM0U@mail.gmail.com> <AANLkTi=652CHVZz8TAqCOiOLO2XyUHd6_i3vWNgbVzKA@mail.gmail.com> <4C7B0578.8090807@kernel.org> <4C7B05A6.4010801@kernel.org> <4C880001.8000908@zytor.com>
In-Reply-To: <4C880001.8000908@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2010 02:28 PM, H. Peter Anvin wrote:
> On 08/29/2010 06:13 PM, Yinghai Lu wrote:
>>
>> earlyprintk could take io port.
>>
>> So we need to handle this case in setup code too, otherwise 0x3f8
>> will be treated as baud rate.
>>
> 
> What about a non-hexadecimal port?  It seems more logical to me to move
> the strncmp() up and test that before using simple_strtoull().

non-hex is not supported...

in arch/x86/kernel/early_printk.c
static __init void early_serial_init(char *s)
{
        unsigned char c;
        unsigned divisor;
        unsigned baud = DEFAULT_BAUD;
        char *e;

        if (*s == ',')
                ++s;

        if (*s) {
                unsigned port;
                if (!strncmp(s, "0x", 2)) {
                        early_serial_base = simple_strtoul(s, &e, 16);
                } else {
                        static const int __initconst bases[] = { 0x3f8, 0x2f8 };

                        if (!strncmp(s, "ttyS", 4))
                                s += 4;
                        port = simple_strtoul(s, &e, 10);
                        if (port > 1 || s == e)
                                port = 0;
                        early_serial_base = bases[port];
                }
                s += strcspn(s, ",");
                if (*s == ',')
                        s++;
        }

so it check 0x too.


Yinghai
