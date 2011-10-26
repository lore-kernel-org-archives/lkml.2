Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab1JZO6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 10:58:46 -0400
Received: from mail.windriver.com ([147.11.1.11]:55580 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994Ab1JZO6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 10:58:45 -0400
Message-ID: <4EA82015.4020600@windriver.com>
Date: Wed, 26 Oct 2011 10:58:29 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Marc Zyngier <marc.zyngier@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: linux-next failure on tegra due to conflicts between PPI and
 irq domain patches and irq.h->module.h include removal
References: <CAOesGMhqRg29tq5Cw03UQMzGs_6nc3YA9UE6Cvps_0q7h5OeZw@mail.gmail.com>	<4EA73171.5020207@gmail.com>	<CAOesGMiCvFypQ6MbkTARxH3i3YTgYqSVcUwXe=2tdqSqufXtzg@mail.gmail.com>	<4EA818ED.9000006@windriver.com> <CAOesGMgB0nVqaxAvuEa2auJ0rBBYQ4fDbG82MwXApYHtt8=Y+g@mail.gmail.com>
In-Reply-To: <CAOesGMgB0nVqaxAvuEa2auJ0rBBYQ4fDbG82MwXApYHtt8=Y+g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-10-26 10:35 AM, Olof Johansson wrote:
> On Wed, Oct 26, 2011 at 7:27 AM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
>> On 11-10-25 06:01 PM, Olof Johansson wrote:
>>> On Tue, Oct 25, 2011 at 3:00 PM, Rob Herring <robherring2@gmail.com> wrote:
>>>> Olof,
>>>>
>>>> On 10/25/2011 04:48 PM, Olof Johansson wrote:
>>>>> Hi,
>>>>>
>>>>> Looks like Marc added new references to irq_start in his PPI patch,
>>>>> and Rob removed it in parallel. Also, irq_offset is no longer
>>>>> available. Looks like you need to respin your patch, Marc.
>>>>>
>>>>> arch/arm/common/gic.c: In function 'gic_dist_init':
>>>>> arch/arm/common/gic.c:290: error: 'irq_start' undeclared (first use in
>>>>> this function)
>>>>> arch/arm/common/gic.c:290: error: (Each undeclared identifier is
>>>>> reported only once
>>>>> arch/arm/common/gic.c:290: error: for each function it appears in.)
>>>>> arch/arm/common/gic.c:296: error: 'struct gic_chip_data' has no member
>>>>> named 'irq_offset'
>>>>
>>>> I fixed this and sent a pull request yesterday to Arnd.
>>>
>>> Ah, oops, forgot to check for already-posted-patches. :) Excellent.
>>>
>>>
>>>>> The second error is because of the change from Paul that removes
>>>>> module.h from irq.h:
>>>>>
>>>>> arch/arm/common/gic.c: In function 'gic_init':
>>>>> arch/arm/common/gic.c:620: error: 'THIS_MODULE' undeclared (first use
>>>>> in this function)
>>>>>
>>>>> Looks odd that I should need to include module.h on my own just to use
>>>>> irq defines. Paul?
>>>>>
>>>>
>>>> THIS_MODULE is needed by irq.h itself in irq_alloc_descs, so it probably
>>>> needs to be added back.
>>>
>>> Well, the new export.h that defines THIS_MODULE probably needs to be
>>> added to irq.h, yes.
>>
>> No.  The whole point of the commit was to avoid nested includes
>> as per the commit log:
>>
>>    Also convert the irq_alloc_descs variants to macros, since all
>>    they really do is is call the __irq_alloc_descs primitive.
>>    This avoids including export.h and no debug info is lost.
>>
>> If your file is relating to modular usage such that it is a modular
>> provider of interrupt sources and hence uses "THIS_MODULE", then it
>> will need export.h in the future. And that macro has nothing whatsoever
>> to do with any irq defines; it is used all over the kernel to tie
>> structures back to a (possibly modular) code block, just as per the
>> use case here in irq.h is.
> 
> I strongly disagree.
> 
> Why should I have to include export.h to a file that is not ever going
> to be built as a module just because I need to include irq.h? That's

You won't.  Unless you use irq_alloc_descs.  Also export.h isn't just
for modules.  It is for code that in some way is exporting infrastructure
to allow modular infrastructure to exist.  So there is lots of files that
will include export.h that in turn are not modules themselves.  That was
largely the point.

Thanks,
Paul.

> nonsense. If irq.h needs it, it should include it on its own.
> 
> 
> -Olof
