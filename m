Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab2FFGfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 02:35:53 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:55535 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab2FFGfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 02:35:52 -0400
Message-ID: <4FCEF956.9090603@snapgear.com>
Date: Wed, 6 Jun 2012 16:31:50 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Philippe De Muyter <phdm@macqel.be>, Greg Ungerer <gerg@uclinux.org>,
        <linux-m68k@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] m68k: Use generic strncpy_from_user(), strlen_user(),
 and strnlen_user()
References: <1338327216-15309-1-git-send-email-geert@linux-m68k.org> <20120530102226.GA28628@frolo.macqel> <CAMuHMdV5GVZR1BvGD3EncDFfPt=Bt9ndkKE8Mp7euE9KoSaGNQ@mail.gmail.com> <20120530140444.GA10543@frolo.macqel> <CAMuHMdW29QYN6XpBb9F3GGoJ-9frrD-00Wx=FchT9ALqW1LcPg@mail.gmail.com>
In-Reply-To: <CAMuHMdW29QYN6XpBb9F3GGoJ-9frrD-00Wx=FchT9ALqW1LcPg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On 06/06/12 06:57, Geert Uytterhoeven wrote:
> On Wed, May 30, 2012 at 4:04 PM, Philippe De Muyter<phdm@macqel.be>  wrote:
>> On Wed, May 30, 2012 at 01:20:02PM +0200, Geert Uytterhoeven wrote:
>>> On Wed, May 30, 2012 at 12:22 PM, Philippe De Muyter<phdm@macqel.be>  wrote:
>>>> On Tue, May 29, 2012 at 11:33:36PM +0200, Geert Uytterhoeven wrote:
>>>>> Signed-off-by: Geert Uytterhoeven<geert@linux-m68k.org>
>>>>> ---
>>>>> Do we also want
>>>>>
>>>>> 	select HAVE_EFFICIENT_UNALIGNED_ACCESS if (!COLDFIRE&&  !M68000)
>>>>
>>>> Sorry, I did not follow what happened to unaligned accesses, but
>>>> CPU32 family (at least 68340) crashes on unaligned accesses.
>>>
>>> We don't seem to have CONFIG_M68340 in arch/m68k/Kconfig.cpu?
>>
>> I have a local port here (but based on an ancient linux kernel, 2.6.2 IIRC)
>>
>>> But Freescale's website confirms both 68340 and 68360 are CPU32.
>>>
>>> arch/m68k/include/asm/unaligned.h assumes CPU32 (CONFIG_MCPU32)
>>> can do unaligned accesses:
>>
>> That's not true. Accessing a 16- or 32-bit word at an odd address
>> with a 68340 generates an Address Error Exception. I remember
>> discovering a bug in the ppp kernel code because of that.
>>
>>>
>>> #if defined(CONFIG_COLDFIRE) || defined(CONFIG_M68000)
>>> #include<linux/unaligned/be_struct.h>
>>> #include<linux/unaligned/le_byteshift.h>
>>> #include<linux/unaligned/generic.h>
>>>
>>> #define get_unaligned	__get_unaligned_be
>>> #define put_unaligned	__put_unaligned_be
>>>
>>> #else
>>> /*
>>>  * The m68k can do unaligned accesses itself.
>>>  */
>>> #include<linux/unaligned/access_ok.h>
>>> #include<linux/unaligned/generic.h>
>>>
>>> #define get_unaligned	__get_unaligned_be
>>> #define put_unaligned	__put_unaligned_be
>>>
>>> #endif
>>>
>>> Is this wrong?
>>
>> I can't tell from reading just the lines above, but I think one should add
>> "|| defined(CONFIG_MCPU32)" at the end of the if condition.
>
> Greg?
>
> If more CPUs cannot handle unaligned accesses, I propose to add
> CONFIG_CPU_HAS_NO_UNALIGNED.

Yes, looks like that should have a "|| defined(CONFIG_CPU32)".
(According to the CPU32 reference manual words and long words must
be aligned on word boundaries.)

I think something like CONFIG_CPU_HAS_NO_UNALIGNED makes sense.


>> I also think that the Coldfire 5272 can do unaligned accesses, but I
>> cannot test that at the moment.

According to the MCF5272 User Manual, "it supports misaligned data
accesses ...". So it looks like it does.

Having a CONFIG_CPU_HAS_NO_UNALIGNED looks like a really good solution
then. We need to be able select it as required on individual CPU types.

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
