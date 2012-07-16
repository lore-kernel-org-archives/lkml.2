Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab2GPPxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 11:53:09 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49927 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab2GPPxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 11:53:05 -0400
MIME-Version: 1.0
In-Reply-To: <5000A6E1.5070306@xenotime.net>
References: <20120713202900.15160.23438.stgit@amt.stowe> <5000A6E1.5070306@xenotime.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 16 Jul 2012 09:52:43 -0600
Message-ID: <CAErSpo43dYfNjWfvb_B3oUJwT2PS+6P8=FDt==96JzH-MaCaZA@mail.gmail.com>
Subject: Re: [PATCH] PCI: Fix undefined reference to 'pci_fixup_final_inited'
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Myron Stowe <myron.stowe@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 4:53 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On 07/13/2012 01:29 PM, Myron Stowe wrote:
>
>> My "PCI: Integrate 'pci_fixup_final' quirks into hot-plug paths" patch
>> introduced an undefined reference to 'pci_fixup_final_inited' when
>> CONFIG_PCI_QUIRKS is not enabled (on x86_64):
>>   drivers/built-in.o: In function `pci_bus_add_device':
>>   (.text+0x4f62): undefined reference to `pci_fixup_final_inited'
>>
>> This patch removes the external reference ending up with a result closer
>> to what we ultimately want when the boot path issues described in the
>> original patch are resolved.
>>
>> References:
>>   https://lkml.org/lkml/2012/7/9/542    Original, offending, patch
>>   https://lkml.org/lkml/2012/7/12/338 Randy's catch
>>
>> Reported-by: rdunlap@xenotime.net
>> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
>
>
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
>
> Thanks.

I added this to my "next" branch, thanks!

>>
>>  drivers/pci/bus.c    |    4 +---
>>  drivers/pci/quirks.c |   20 ++++----------------
>>  2 files changed, 5 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
>> index b511bd4..4b0970b 100644
>> --- a/drivers/pci/bus.c
>> +++ b/drivers/pci/bus.c
>> @@ -164,10 +164,8 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
>>  int pci_bus_add_device(struct pci_dev *dev)
>>  {
>>       int retval;
>> -     extern bool pci_fixup_final_inited;
>>
>> -     if (pci_fixup_final_inited)
>> -             pci_fixup_device(pci_fixup_final, dev);
>> +     pci_fixup_device(pci_fixup_final, dev);
>>       retval = device_add(&dev->dev);
>>       if (retval)
>>               return retval;
>> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
>> index 52f44b5..003f356 100644
>> --- a/drivers/pci/quirks.c
>> +++ b/drivers/pci/quirks.c
>> @@ -2956,6 +2956,7 @@ extern struct pci_fixup __end_pci_fixups_resume_early[];
>>  extern struct pci_fixup __start_pci_fixups_suspend[];
>>  extern struct pci_fixup __end_pci_fixups_suspend[];
>>
>> +static bool pci_apply_fixup_final_quirks;
>>
>>  void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev)
>>  {
>> @@ -2973,6 +2974,8 @@ void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev)
>>               break;
>>
>>       case pci_fixup_final:
>> +             if (!pci_apply_fixup_final_quirks)
>> +                     return;
>>               start = __start_pci_fixups_final;
>>               end = __end_pci_fixups_final;
>>               break;
>> @@ -3006,21 +3009,6 @@ void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev)
>>  EXPORT_SYMBOL(pci_fixup_device);
>>
>>
>> -/*
>> - * The global variable 'pci_fixup_final_inited' is being used as a interim
>> - * solution for calling the final quirks only during hot-plug events (not
>> - * during boot processing).
>> - *
>> - * When the boot path's PCI device setup sequencing is addressed, we can
>> - * remove the instance, and usages of, 'pci_fixup_final_inited' along with
>> - * removing 'fs_initcall_sync(pci_apply_final_quirks);' and end up with a
>> - * single, uniform, solution that satisfies both the boot path and the
>> - * various hot-plug event paths.
>> - *
>> - * ToDo: Remove 'pci_fixup_final_inited'
>> - */
>> -bool pci_fixup_final_inited;
>> -
>>  static int __init pci_apply_final_quirks(void)
>>  {
>>       struct pci_dev *dev = NULL;
>> @@ -3031,6 +3019,7 @@ static int __init pci_apply_final_quirks(void)
>>               printk(KERN_DEBUG "PCI: CLS %u bytes\n",
>>                      pci_cache_line_size << 2);
>>
>> +     pci_apply_fixup_final_quirks = true;
>>       for_each_pci_dev(dev) {
>>               pci_fixup_device(pci_fixup_final, dev);
>>               /*
>> @@ -3051,7 +3040,6 @@ static int __init pci_apply_final_quirks(void)
>>                       pci_cache_line_size = pci_dfl_cache_line_size;
>>               }
>>       }
>> -     pci_fixup_final_inited = 1;
>>
>>       if (!pci_cache_line_size) {
>>               printk(KERN_DEBUG "PCI: CLS %u bytes, default %u\n",
>>
>
>
>
> --
> ~Randy
