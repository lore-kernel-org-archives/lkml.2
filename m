Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab0HJOHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 10:07:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:55866 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757706Ab0HJOHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 10:07:00 -0400
Message-ID: <4C615C84.6060300@suse.cz>
Date: Tue, 10 Aug 2010 16:04:52 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Arve Hj?nnev?g <arve@android.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, JBeulich@novell.com,
        aris@redhat.com, catalin.marinas@arm.com, jacmet@sunsite.dk,
        justinmattock@gmail.com, lizf@cn.fujitsu.com, ulfalizer.lkml@gmail.com,
        zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] kbuild: kconfig changes
References: <20100804125156.GA23464@sepie.suse.cz> <AANLkTinN4npO7qfSa-42B-Cq5mKZX+--H0=1SuSrWTEP@mail.gmail.com> <20100807040101.GA30520@merkur.ravnborg.org> <AANLkTinOWBfsncSZw3bvHa6Mp+eb5dzibKSV15OKgW2M@mail.gmail.com> <20100808155712.GA4804@merkur.ravnborg.org>
In-Reply-To: <20100808155712.GA4804@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8.8.2010 17:57, Sam Ravnborg wrote:
> On Fri, Aug 06, 2010 at 09:43:24PM -0700, Arve Hj?nnev?g wrote:
>> On Fri, Aug 6, 2010 at 9:01 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>>>>
>>>> This change prevents some the minimal defconfig options from working.
>>>> Specifically our usb gadget drivers do not get set.
>>>
>>> Can you help me reproduce this?
>>>
>>> I have found an issue with choice values in combination with
>>> tristate logic that fails. I hope this is something similar.
>>>
>>
>> It is probably the same problem. The gadget driver that was not set is
>> not buildable as a module (it is not in the mainline kernel). If I
>> select another gadget driver instead it just gets changed to build as
>> a module instead.
>>
>> If you create a file, arch/arm/configs/test_defconfig with the following:
>> CONFIG_MODULES=y
>> CONFIG_USB_GADGET=y
>> CONFIG_USB_MASS_STORAGE=y
>>
>> then "make test_defconfig" results in .config having:
>> CONFIG_USB_MASS_STORAGE=m
>>
>>  (at least if you are set up to compile for arm)
> 
> Thanks Arve.
> 
> I have it reproduced now with a simple Kconfig:
> 
> $ cat Kconfig
> config M
> 	def_bool y
> 	option modules
> 
> choice
> 	prompt "choice list"
> 
> config A
> 	tristate "a"
> 
> config B
> 	tristate "b"
> 
> endchoice
> 
> $cat defconfig
> CONFIG_M=y
> CONFIG_A=y
> # CONFIG_B is not set
> 
> 
> If I do:
> 
>     $scripts/kconfig/conf --defconfig=defconfig Kconfig
> 
> with the above input the resulting .config is OK.
> 
> But If I drop the line:
> 
>     # CONFIG_B is not set
> 
> in the defconfig file then I end with CONFIG_A set to m.
> And this is not as expected - I cannot see why it should matter
> if we specify the value of B or not.
> 
> What we see here is that savedefconfig trigger a bug in the
> other part of kconfig - a bug which was not exposed before.
> 
> The reason why your patch cured it was that we then no
> longer triggered the bug (at least I guess so I did not look to close).
> 
> I will look into this as time permits. I assume the fix is simple
> when I find the reason.

I'm looking into it now, but understanding the kconfig internals is not
easy...

Michal
