Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247Ab2BJVXZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 16:23:25 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59376 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759174Ab2BJVXX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 16:23:23 -0500
MIME-Version: 1.0
In-Reply-To: <20120210130029.44d2a823@jbarnes-desktop>
References: <1328424908-6385-1-git-send-email-yinghai@kernel.org>
	<1328424908-6385-10-git-send-email-yinghai@kernel.org>
	<20120210130029.44d2a823@jbarnes-desktop>
Date: Fri, 10 Feb 2012 13:23:23 -0800
X-Google-Sender-Auth: 1R-FLUsOe5LaJ3smfVSt7cOMxWU
Message-ID: <CAE9FiQX5Ln9YM6gh-cm8_OiJpMHgD8dpYo1_4rVm35K4F_gP6Q@mail.gmail.com>
Subject: Re: [PATCH 9/9] PCI: only enable pci realloc when SRIOV bar is not assigned
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 1:00 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Sat,  4 Feb 2012 22:55:08 -0800
> Yinghai Lu <yinghai@kernel.org> wrote:
>
>> If bios does not assign those BAR or wrong address, then kernel will
>> try to do pci realloc.
>>
>> in that case, user still can use pci=realloc=off to override it.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> ---
>>  drivers/pci/setup-bus.c |   28 ++++++++++++++++++++++++++++
>>  1 files changed, 28 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
>> index 9526038..520f256 100644
>> --- a/drivers/pci/setup-bus.c
>> +++ b/drivers/pci/setup-bus.c
>> @@ -1293,6 +1293,31 @@ static bool __init pci_realloc_enabled(void)
>>       return pci_realloc_enable >= enable_yes_user;
>>  }
>>
>> +static void __init pci_realloc_detect(void)
>> +{
>> +     struct pci_dev *dev = NULL;
>> +
>> +     if (pci_realloc_enable != enable_not_set)
>> +             return;
>> +
>> +#ifdef CONFIG_PCI_IOV
>> +     for_each_pci_dev(dev) {
>> +             int i;
>> +
>> +             for (i = PCI_IOV_RESOURCES; i <= PCI_IOV_RESOURCE_END; i++) {
>> +                     struct resource *r = &dev->resource[i];
>> +
>> +                     /* Not assigned, or rejected by kernel */
>> +                     if (r->flags && !r->start) {
>> +                             pci_realloc_enable = enable_yes_detected;
>> +
>> +                             return;
>> +                     }
>> +             }
>> +     }
>> +#endif
>> +}
>> +
>>  /*
>>   * first try will not touch pci bridge res
>>   * second  and later try will clear small leaf bridge res
>> @@ -1314,6 +1339,7 @@ pci_assign_unassigned_resources(void)
>>       int pci_try_num = 1;
>>
>>       /* don't realloc if asked to do so */
>> +     pci_realloc_detect();
>>       if (pci_realloc_enabled()) {
>>               int max_depth = pci_get_max_depth();
>>
>> @@ -1348,6 +1374,8 @@ again:
>>       if (tried_times >= pci_try_num) {
>>               if (pci_realloc_enable == enable_not_set)
>>                       printk(KERN_INFO "Some pci devices resources are not assigned, please try to boot with pci=realloc\n");
>> +             else if (pci_realloc_enable == enable_yes_detected)
>> +                     printk(KERN_INFO "Automatically enabled pci realloc, if you have problem, please try to boot with pci=realloc=off\n");
>>
>>               free_list(&fail_head);
>>               goto enable_and_dump;
>
> Not sure I like this one either.  Distros will want to enable IOV by
> default, but in most configs users still won't use it, and many BIOSes
> won't bother to allocate IOV space.  So defaulting to trying to do so
> will likely cause a lot of unnecessary re-allocation.
>
> So distro guidance would be appreciated here for the default behavior.

Or do you prefer to:

if all SRIOV bar are not assigned, We will not enable SRIOV feature even?

Yinghai
