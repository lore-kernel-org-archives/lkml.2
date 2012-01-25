Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab2AYOTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 09:19:21 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40130 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2AYOTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 09:19:20 -0500
Message-ID: <4F200F64.9060203@monstr.eu>
Date: Wed, 25 Jan 2012 15:19:16 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        John Williams <john.williams@petalogix.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "Grosen, Mark" <mgrosen@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: remoteproc: Load coprocessor code to the specific main memory
 location
References: <4F1EE861.4030405@monstr.eu> <CAK=Wgba5kT8AwLtuHyosucYnWf-EA+xpE1kzmssfhSC7ZXQA=g@mail.gmail.com> <4F1FF870.3000105@monstr.eu> <CAK=WgbZwaxMPsMiNcq5yFvBLrcODqGgDT6b=mmQ91JBVtTEyXA@mail.gmail.com>
In-Reply-To: <CAK=WgbZwaxMPsMiNcq5yFvBLrcODqGgDT6b=mmQ91JBVtTEyXA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ohad Ben-Cohen wrote:
> On Wed, Jan 25, 2012 at 2:41 PM, Michal Simek <monstr@monstr.eu> wrote:
>> First of all will be the best to describe what we want to achieve.
>> We have Zynq platform ARM Cortex-A9(which should be ARMv7 - 2cpus).
>> cpu0 runs Linux and cpu1 will be used for real-time os. We would like to use
>> remoteproc for loading any code(firmware if you like) for the cpu1 and start
>> it.
> 
> Sounds cool.
> 
> So you're not < ARMv6, and I now understand why you bumped into that
> code path: you're using a vanilla kernel, without CMA.

I started with pur vanilla kernel and patches from your tree
git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git
for-next branch
but then I had to moved to for-next-acked-merged because in the origin
one were some problems.

> 
> I suggest you merge Marek's CMA branch into your tree. Though 1MB
> isn't that much really, and you can easily get away even without CMA.
> You just won't have any non-CMA public example to use as a reference
> ;).

I use 1MB for now. It is hard to say how big that real-time OS with app will be.
I will merge it. Hopefully there won't be conflicts.

Do you have any kernel tree with CMA just for sure?

> 
> For details about the CMA tree and branches, see Marek's email:
> 
> https://lkml.org/lkml/2012/1/10/48

No problem to do so. I have read CMA some time ago.

> 
>> Then in zynq_rproc_kick I copy content of this 1MB carveout to 0x0 physical
> 
> I recommend to keep the ->kick() handler as light as possible, as it
> may be frequently triggered (think of a network driver doing I/O).

It will be no problem to keep it pretty light when I am able to map firmware to
location I like.

> 
> Ideally you should do the minimum required to only wake up the other
> core when you are kicked. Copying a 1MB region every kick sounds
> excessive.

Sure I know. It is just hack to proof me that I am able to do what I want to do.
Currently it is right time to do it in way which could be possible to add to mainline
in future.

> 
>> The main my problem is that firmware base addr must be at the beginning of
>> address space
>> or selected address but it is fixed and known.
> ..
>> ok. How do you handle limitations if coprocessor expect code on any address?
> 
> Just make sure you reserve the CMA region at that fixed address.
> 
> For a reference how this can be done, look for OMAP_RPROC_CMA_BASE in
> my rpmsg_3.2_rc4 branch.

I have looked at it. Please correct me if I am wrong.

You use 0xa9800000 address which is pretty good.
What I can do is to say - all sw for cpu1 has to start at 0x0f000000 which
give me enough space for Linux kernel. And CMA can allocate this place
in bootup time. Probably it is not the best to use physical address 0x0
because it is mapped to virtual 0xC0000000 and have to solve all problems
with linux text base.


>>> Looping in Mark, who did the davinci remoteproc support, and might
>>> have the code available to share. Hopefully we'd have the patches
>>> posted soon, and then no-iommu platforms could just use them for
>>> reference.
>>
>> ok. great. Will look forward for that code and recommendation because I am
>> ARM newbie.
> 
> So I no longer think you need the davinci code, you can just follow
> the OMAP example.

Good examples are always welcomed - it can show others how to do it in the right way. :-)

>> I am also interested in suggestions about DTS binding. Have someone tried to
>> describe it or use it?
> 
> No, AFAICT. And I'm not sure there are DTS binding for CMA regions
> yet. Feel free to take a stab at it though ;)

ok. Will wait for Grants suggestions. I have added devicetree mailing list to CC list too.

What do you use for firmware replacing?
Just remove kernel module and load different one?

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
