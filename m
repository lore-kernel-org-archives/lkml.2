Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab0I2Hs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 03:48:29 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40669 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab0I2Hs2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 03:48:28 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTikvfr90AZRJXz6CQg2FJTG13ygzxp0J9OpkL03c@mail.gmail.com>
References: <1285739538-29058-1-git-send-email-monstr@monstr.eu>
 <1285739538-29058-2-git-send-email-monstr@monstr.eu> <1285739538-29058-3-git-send-email-monstr@monstr.eu>
 <1285739538-29058-4-git-send-email-monstr@monstr.eu> <1285739538-29058-5-git-send-email-monstr@monstr.eu>
 <1285739538-29058-6-git-send-email-monstr@monstr.eu> <1285739538-29058-7-git-send-email-monstr@monstr.eu>
 <1285739538-29058-8-git-send-email-monstr@monstr.eu> <20100929062710.GC2439@angua.secretlab.ca>
 <AANLkTikvfr90AZRJXz6CQg2FJTG13ygzxp0J9OpkL03c@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 29 Sep 2010 16:48:06 +0900
X-Google-Sender-Auth: 6YOCfj5zGIjgqnOxmaSnLzJw2W4
Message-ID: <AANLkTinA0X6Vb8=RL6x-H_A0HMF2xRfRvmSJHh1dJyE3@mail.gmail.com>
Subject: Re: [PATCH 7/7] microblaze: Add support for little-endian Microblaze
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, john.williams@petalogix.com,
        edgar.iglesias@gmail.com, duyl@xilinx.com, linnj@xilinx.com,
        microblaze-uclinux@itee.uq.edu.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 4:31 PM, Michal Simek <monstr@monstr.eu> wrote:
>
>
> 2010/9/29 Grant Likely <grant.likely@secretlab.ca>
>>
>> On Wed, Sep 29, 2010 at 03:52:18PM +1000, Michal Simek wrote:
>> > Microblaze little-endian toolchain exports __MICROBLAZEEL__
>> > which is used in the kernel to identify little/big endian.
>> >
>> > The most of the changes are in loading values from DTB which
>> > is always big endian.
>> >
>> > Little endian platforms are based on new AXI bus which has
>> > impact to early uartlite initialization.
>> >
>> > Signed-off-by: Michal Simek <monstr@monstr.eu>
>>
>> Hi Michal,
>>
>> Looks pretty good, but a few comments below.
>>
>> > @@ -87,7 +88,7 @@ static int __init early_init_dt_scan_serial(unsigned
>> > long node,
>> >  /* this function is looking for early uartlite console - Microblaze
>> > specific */
>> >  int __init early_uartlite_console(void)
>> >  {
>> > -     return of_scan_flat_dt(early_init_dt_scan_serial, NULL);
>> > +     return be32_to_cpu(of_scan_flat_dt(early_init_dt_scan_serial,
>> > NULL));
>>
>> of_scan_flat_dt returns a rc that should already by in cpu endianess.
>> of_scan_flat_dt needs to be fixed instead.
>
> It is easy to do it. I will generate patch for it. It is in drivers/of/fdt.c

Oops, I told you the wrong thing.  the fix needs to be made in
early_init_dt_scan_serial().  of_scan_flat_dt() is just fine.

>> diff --git a/arch/microblaze/kernel/vmlinux.lds.S
>> b/arch/microblaze/kernel/vmlinux.lds.S
>> index 20b0552..96a88c3 100644
>> --- a/arch/microblaze/kernel/vmlinux.lds.S
>> +++ b/arch/microblaze/kernel/vmlinux.lds.S
>> @@ -15,7 +15,11 @@ ENTRY(microblaze_start)
>>  #include <asm-generic/vmlinux.lds.h>
>>  #include <asm/thread_info.h>
>>
>> +#ifdef __MICROBLAZEEL__
>> +jiffies = jiffies_64;
>> +#else
>>  jiffies = jiffies_64 + 4;
>> +#endif
>
>> I comment would go nicely hear to explain to reviewers what this is
>> about.
>
> 1. It is the same what ARM and MIPS (maybe other) have.
>
> 2. Look at this example
> Store 64 bit value ("0x12345678 90abcdef") on little and big endian.
>
> a) big endian
> it is just copying values to the memory.
> 0x0 = 0x12345678
> 0x4 = 0x90abcdef
>
> Address 0 is start of jiffies_64
> and you just want to point on the last (smallest) 32 bit which is on offset
> 0x4 - which is jiffies.
>
> b) little endian
> The same case for little endian
> 0x0 = 0xefcdab90
> 0x4 = 0x78563412
>
> Address 0 is start of jiffies_64
> and you just want to point on the last (smallest) 32 bit which is on offset
> 0x0 - which is jiffies.

Ah, okay.  jiffies_64 is a pointer (I couldn't be bothered to look at
the definition of jiffies it in context).

g.
