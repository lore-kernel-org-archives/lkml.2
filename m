Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab0HEFOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 01:14:36 -0400
Received: from claw.goop.org ([74.207.240.146]:55460 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516Ab0HEFOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 01:14:34 -0400
Message-ID: <4C5A48B8.2060101@goop.org>
Date: Wed, 04 Aug 2010 22:14:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Mike Frysinger <vapier.adi@gmail.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: missing .data.shared_align placement in vmlinux
References: <AANLkTilVZ3GCU_hsfVNeR4oG6ETREb9UeJ0Cv_5hSwVZ@mail.gmail.com> <20100804115658.GA21357@merkur.ravnborg.org> <AANLkTikz7pvirg7VUxrm-6v=yrLwHy4UeaJTS0wz3BLc@mail.gmail.com> <20100804202806.GA22134@merkur.ravnborg.org> <20100804204002.GA22147@merkur.ravnborg.org>
In-Reply-To: <20100804204002.GA22147@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/04/2010 01:40 PM, Sam Ravnborg wrote:
> [Resend - this time with Jeremy included in To: ]
>
> Jeremy - you introduced this in ("x86/i386: Put aligned
> stack-canary in percpu shared_aligned section")
> 53f824520b6d84ca5b4a8fd71addc91dbf64357e
>
> Does the following simple fix look correct to you?
> [See below]
>
> 	Sam
>
> On Wed, Aug 04, 2010 at 10:28:06PM +0200, Sam Ravnborg wrote:
>> On Wed, Aug 04, 2010 at 02:12:03PM -0400, Mike Frysinger wrote:
>>> On Wed, Aug 4, 2010 at 07:56, Sam Ravnborg wrote:
>>>> On Fri, May 21, 2010 at 04:58:53PM -0400, Mike Frysinger wrote:
>>>>> am i missing something or does the .data.shared_align section lack
>>>>> definition in vmlinux.lds.h and all arch vmlinux.lds.S files ?
>>>>>
>>>>> with the recent change "net: remove time limit in process_backlog()",
>>>>> the softnet_data variable changed from "DEFINE_PER_CPU()" to
>>>>> "DEFINE_PER_CPU_ALIGNED()" which moved it from the .data section to
>>>>> the .data.shared_align section.  i'm not saying this patch is wrong,
>>>>> just that is what caused me to notice this larger problem.  no one
>>>>> else in the kernel is using this aligned macro variant, so i imagine
>>>>> that's why no one has noticed yet.

That's a bit odd and embarrassing...  I guess the stack_canary stuff is 
only visible when using CONFIG_CC_STACKPROTECTOR.

>>>>> since .data.shared_align isnt declared in any vmlinux files that i can
>>>>> see, the linker just places it last.  this "just works" for most
>>>>> people, but when building a ROM kernel on Blackfin systems, it causes
>>>>> section overlap errors:
>>>>> bfin-uclinux-ld.real: section .init.data [00000000202e06b8 ->
>>>>> 00000000202e48b7] overlaps section .data.shared_aligned
>>>>> [00000000202e06b8 ->  00000000202e0723]
>>>>> i imagine other arches which support the ROM config option and thus do
>>>>> funky placement would see similar issues ...
>>>>>
>>>>> on x86, it is stuck in a dedicated section:
>>>>>    [ 8] .data             PROGBITS        ffffffff810ec000 2ec000
>>>>> 0303a8 00  WA  0   0 4096
>>>>>    [ 9] .data.shared_alig PROGBITS        ffffffff8111c3c0 31c3c0
>>>>> 0000c8 00  WA  0   0 64
>>>>>
>>>>> the ifdef forest in asm-generic/percpu.h is beyond a quick glance&
>>>>> fix, so i leave it up to someone else ;)
>>>> as there any resolution on this?
>>>> I briefly looked at it some time ago.
>>>> And it looks like a plain oversight.
>>> no, it's still broken in 2.6.35 :(
>>> $ make ARCH=blackfin BF537-STAMP_defconfig
>>> $ make ARCH=blackfin -s -j4
>>> $ readelf -WS vmlinux | grep '\<data\>'
>>>    [10] .data             PROGBITS        0018369c 17269c 012964 00  WA  0   0  4
>>>    [11] .data..shared_aligned PROGBITS        00196000 185000 00006c 00
>>>   WA  0   0  4
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 030a954..e87260f 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -150,6 +150,7 @@
>   #define DATA_DATA							\
>   	*(.data)							\
>   	*(.ref.data)							\
> +	*(.data..shared_aligned) /* percpu related */			\

Typo?  Shouldn't that be ".data.shared_aligned"?  Or where does the '..' 
come from?

     J
