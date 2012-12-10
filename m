Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab2LJLXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:23:43 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:35528 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2LJLXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:23:41 -0500
Message-ID: <50C5C62D.8080904@synopsys.com>
Date: Mon, 10 Dec 2012 16:53:25 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kbuild.devel
To: Arnd Bergmann <arnd@arndb.de>
CC: Michal Marek <mmarek@suse.cz>, Noam Camus <noamc@ezchip.com>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Makefile race between jobs
References: <264C179F799EF24AB26D5319053335E80CC3049A10@ezexch.ezchip.com> <50C5B9D9.1080208@suse.cz> <50C5BB4A.9000403@synopsys.com> <201212101059.28161.arnd@arndb.de>
In-Reply-To: <201212101059.28161.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 December 2012 04:29 PM, Arnd Bergmann wrote:
> On Monday 10 December 2012, Vineet Gupta wrote:
>>
>> On Monday 10 December 2012 04:00 PM, Michal Marek wrote:
>>> On 10.12.2012 11:11, Vineet Gupta wrote:
>>>> ARC Port caches current task pointer in a register - thus we have a
>>>> global asm register definition in current.h
>>>> In the past, a customer ran into issue when porting some "really
>>>> portable" code to kernel - such that asm/current.h didn't make it into
>>>> the build of their module - via normal header includes - strange but
>>>> true. Thus forcing current.h via way of -include seemed like a
>>>> safe/sensible way.
>>>
>>> To me that sounds like either an arc header is using the define but
>>> lacking an include of asm/current.h, or the code is lacking asm/current.h.
>>>
>>
>> It was latter - customer code was lacking include of asm/current.h
>> At any rate, independent of above, since we are dealing with a global
>> reg definition, IMHO, forcing the -include for each file built ensures
>> the generated code correctness (gcc reg allocator not fiddling with that
>> reg) - w/o "assuming" it would.
> 
> I'm not convinced that adding the -include to the kernel Makefile
> actually helps here: If a third party module is built outside of
> the kernel sources, it probably also does not use the kernel Makefile,
> and it may not have access to the kernel header files at all.

There might be NDA issues otherwise I would have uploaded the customer
code. It was third party code alright - but built in tree - and
interestingly not using any kernel headers - even linux/types.h. I was
dazzled myself when I found the root cause (due to r25 getting clobbered
mysteriously after some code from that driver had run).
So seriously it was really portable code.


> That aside, can't you just have an arch specific header file that
> reservers the register but does not rely on asm-generic/types.h?
> That would eliminate the need to serialize the build process.

The code in asm/current.h is as follows:

#ifdef CONFIG_ARC_CURR_IN_REG
register struct task_struct *curr_arc asm("r25");
#define current (curr_arc)
#else
#include <asm-generic/current.h>
#endif

The Makefile snippet in 3.2 (which Noam is using) is
LINUXINCLUDE	+=  -include ${src}/arch/arc/include/asm/current.h

I'm ready to change it to anything which helps alleviate the need for
build system change - w/o terribly uglifying this code.

However, in the 3.7 port which I posted to lists, the Makefile fragment
has already been changed due to other reasons.

ifdef CONFIG_ARC_CURR_IN_REG
# Can't do unconditionally because of recursive include
# issues due to <linux/thread_info.h>
LINUXINCLUDE	+=  -include ${src}/arch/arc/include/asm/current.h
endif

Does that make the problem report moot already - since the issue only
seems to happen for !CONFIG_ARC_CURR_IN_REG in which case the header
won't be -include ed

-Vineet

> 
> 	Arnd
> 

