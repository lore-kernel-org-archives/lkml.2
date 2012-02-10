Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760436Ab2BJWMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:12:41 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:58049 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760420Ab2BJWMT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:12:19 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXeNGP3zj2PhWK_Gcnwr9Qsn6LZ74TL2OA2RrztLaewvg@mail.gmail.com>
References: <1328424908-6385-1-git-send-email-yinghai@kernel.org>
 <1328424908-6385-4-git-send-email-yinghai@kernel.org> <20120210124614.5006563e@jbarnes-desktop>
 <CAE9FiQXeNGP3zj2PhWK_Gcnwr9Qsn6LZ74TL2OA2RrztLaewvg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 10 Feb 2012 14:11:58 -0800
Message-ID: <CAErSpo7oxTDdB3CJZuG+=xsZanOc76xdnMYDPsfaP-CSsmGxiQ@mail.gmail.com>
Subject: Re: [PATCH 3/9] PCI: Disable cardbus bridge MEM1 pref CTL
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ram Pai <linuxram@us.ibm.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 12:54 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Feb 10, 2012 at 12:46 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>> On Sat,  4 Feb 2012 22:55:02 -0800
>> Yinghai Lu <yinghai@kernel.org> wrote:
>>
>>> Some BIOS enable both pref for MEM0 and MEM1.
>>>
>>> but we assume MEM1 is non-pref...
>>>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>> ---
>>>  drivers/pci/setup-bus.c |    8 ++++++++
>>>  1 files changed, 8 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
>>> index 090217a..d5897c3 100644
>>> --- a/drivers/pci/setup-bus.c
>>> +++ b/drivers/pci/setup-bus.c
>>> @@ -914,6 +914,14 @@ static void pci_bus_size_cardbus(struct pci_bus *bus,
>>>       if (realloc_head)
>>>               add_to_list(realloc_head, bridge, b_res+1, pci_cardbus_io_size, 0 /* dont care */);
>>>
>>> +     /* MEM1 must not be pref mmio */
>>> +     pci_read_config_word(bridge, PCI_CB_BRIDGE_CONTROL, &ctrl);
>>> +     if (ctrl & PCI_CB_BRIDGE_CTL_PREFETCH_MEM1) {
>>> +             ctrl &= ~PCI_CB_BRIDGE_CTL_PREFETCH_MEM1;
>>> +             pci_write_config_word(bridge, PCI_CB_BRIDGE_CONTROL, ctrl);
>>> +             pci_read_config_word(bridge, PCI_CB_BRIDGE_CONTROL, &ctrl);
>>> +     }
>>> +
>>>       /*
>>>        * Check whether prefetchable memory is supported
>>>        * by this bridge.
>>
>> Does this actually fix any bugs?
>
> at least, one of laptop have this problem.

Rogério Brito's Clevo M5X0JE laptop seems to boot with both CardBus
mem apertures set to prefetchable.  I think there's evidence of this
in one of the video boot logs Rogério mentioned in this thread:
https://lkml.org/lkml/2012/1/6/343 because I noticed the same thing
and fixed a nearby bug in lspci.

I looked for it, but didn't find it.  I think it would be useful if
Yinghai could locate it, transcribe it into a bugzilla report, and
mention the bugzilla URL in this commit log.

I think Rogério did try the patch, but I don't know whether he
observed different behavior.  I think it *does* fix a bug; it's just
that his box has more serious problems that we haven't figured out
yet.

Bjorn
