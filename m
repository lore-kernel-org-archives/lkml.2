Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab2DKOrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 10:47:35 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44771 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab2DKOrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 10:47:33 -0400
Message-ID: <4F859981.1020502@gmail.com>
Date: Wed, 11 Apr 2012 09:47:29 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120402 Thunderbird/11.0.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PULL] generic irq chip and pl061 irqdomain support
References: <4F3ADFE7.4090409@gmail.com> <4F5437FE.2000306@gmail.com> <4F5FD037.5000703@gmail.com> <20120313231834.8B6AE3E050F@localhost> <4F79A3B3.9040209@gmail.com> <20120407041155.196043E25B3@localhost>
In-Reply-To: <20120407041155.196043E25B3@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2012 11:11 PM, Grant Likely wrote:
> On Mon, 02 Apr 2012 08:03:47 -0500, Rob Herring <robherring2@gmail.com> wrote:
>> Grant,
>>
>> On 03/13/2012 06:18 PM, Grant Likely wrote:
>>> On Tue, 13 Mar 2012 17:54:47 -0500, Rob Herring <robherring2@gmail.com> wrote:
>>>> On 03/04/2012 09:50 PM, Rob Herring wrote:
>>>>> Grant,
>>>>>
>>>>> On 02/14/2012 04:27 PM, Rob Herring wrote:
>>>>>> Grant,
>>>>>>
>>>>>> Please pull. This is based on your current branch which you have said
>>>>>> you plan to rebase, so feel free to rebase these as you need to. This
>>>>>> has been tested on highbank and i.MX5.
>>>>>>
>>>>>
>>>>> Ping.
>>>>>
>>>>> I've rebased onto your current tree. Updated pull request:
>>>>>
>>>>> The following changes since commit 280ad7fda5f95211857fda38960f2b6fdf6edd3e:
>>>>>
>>>>>   mfd: twl-core: Add IRQ_DOMAIN dependency (2012-02-26 16:48:06 -0700)
>>>>>
>>>>> are available in the git repository at:
>>>>>   git://sources.calxeda.com/kernel/linux.git irqdomain-for-grant
>>>>>
>>>>> Rob Herring (3):
>>>>>       ARM: kconfig: always select IRQ_DOMAIN
>>>>>       irq: add irq_domain support to generic-chip
>>>>>       gpio: pl061: enable interrupts with DT style binding
>>>>>
>>>>>  .../devicetree/bindings/gpio/pl061-gpio.txt        |   15 ++
>>>>>  arch/arm/Kconfig                                   |    2 +-
>>>>>  arch/arm/common/Kconfig                            |    2 -
>>>>>  drivers/gpio/gpio-pl061.c                          |   48 ++++---
>>>>>  include/linux/irq.h                                |   15 ++
>>>>>  kernel/irq/generic-chip.c                          |  152
>>>>> +++++++++++++++++---
>>>>>  6 files changed, 186 insertions(+), 48 deletions(-)
>>>>>
>>>>
>>>> Ping again...
>>>
>>> Okay, I've pulled this in.  I need to do some compile testing before I push
>>> it out.
>>
>> What happened to this? It's not in rc1.
> 
> I kept looking at it and planning to send Linus a pull request, but I
> just couldn't make myself comfortable with the state of the patch.  It
> seems to me that there is too much bleeding of irq_domain state into
> irq_generic_chip and it doesn't return any meaningful context to the
> caller that can be used to tear it back down.
> 
> I think for the domain+generic_chip use case the API needs refining so
> that it returns a container structure with both the irq_domain and the
> array of generic chips.  Plus there needs to be a remove function
> (there also needs to be an irq_domain remove function; I also realized
> that was a missing piece when I looked at it).
> 
> I had really hoped to get fixup patches sorted out in time to still
> get Linus to merge it even though it hadn't been through Linux next,
> but given that I couldn't even find time to email you properly about
> it, it seems I was doomed.  :-(  There weren't any other users of it
> in linux-next though, so in the end I just didn't sent the pull req.

There weren't any users in next because this was not in next for very
long. iMX had support ready to go. This (or at least some parts) is
needed to convert any existing users of generic_chip over to domains and
DT whether we add domain support directly or not.

> I've got a couple of fixup patches on top of your branch that I'll
> send to you so you can see some of the stuff that I've done.  I'm also
> not comfortable with adding flags, irq_clr & irq_set into
> irq_generic_chip, but I can't quite put my finger on why.  :-/  Also,

I'm not adding those. The timing of the irq handler setup is different
with a domain, so I have to store those for later. I think this also
makes generic_chip incompatible with domains as it now exists.

> the api for irq_setup_generic_chip_domain() is enormous.  If a context
> structure is used, then it would probably be better to populate it
> with the configuration so that the API isn't nearly so large.

This is largely an artifact of the existing generic_chip api which has
a large number of parameters, but they are spread across 2 functions.

There's a couple of simple things I could do:
- drop name and use node->name instead. If node is null then the
irq_chip will have no name, but this appears to be optional.
- make the callback fill in irq_base, reg_base, flags, irq_clr, irq_set
and private
- make the common case an inline wrapper. All but 1 user sets num_ct to
1 for example.

Rob

