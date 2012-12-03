Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab2LCUBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 15:01:54 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41330 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab2LCUBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:01:53 -0500
MIME-Version: 1.0
In-Reply-To: <1354564084.1809.390.camel@bling.home>
References: <1354552622-687-1-git-send-email-betty.dall@hp.com>
	<CAKocOOOudEzMx0Zs9CB2zmtCkPHVkx1TCbWeK2+uoV5cb=eiGg@mail.gmail.com>
	<1354564084.1809.390.camel@bling.home>
Date: Mon, 3 Dec 2012 13:01:52 -0700
Message-ID: <CAKocOOPcCOPnEBfh=aePjw=2HY-0j5reFZMe=xKT=85YFjwVEQ@mail.gmail.com>
Subject: Re: [PATCH] PCI AER: pci_get_domain_bus_and_slot() call missing
 required pci_dev_put()
From: Shuah Khan <shuahkhan@gmail.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Betty Dall <betty.dall@hp.com>, bhelgaas@google.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        wangyijing@huawei.com, jiang.liu@huawei.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 3, 2012 at 12:48 PM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Mon, 2012-12-03 at 10:40 -0700, Shuah Khan wrote:
>> On Mon, Dec 3, 2012 at 9:37 AM, Betty Dall <betty.dall@hp.com> wrote:
>> > The function aer_recover_queue() makes a call to pci_get_domain_bus_and_slot().
>> > That function is documented to require that the caller decrement the
>> > reference count by calling pci_dev_put(). This patch adds the missing
>> > call to pci_dev_put().
>> >
>> > Signed-off-by: Betty Dall <betty.dall@hp.com>
>> > ---
>> >  drivers/pci/pcie/aer/aerdrv_core.c |    1 +
>> >  1 files changed, 1 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
>> > index af4e31c..43caf53 100644
>> > --- a/drivers/pci/pcie/aer/aerdrv_core.c
>> > +++ b/drivers/pci/pcie/aer/aerdrv_core.c
>> > @@ -616,6 +616,7 @@ static void aer_recover_work_func(struct work_struct *work)
>> >                         continue;
>> >                 }
>> >                 do_recovery(pdev, entry.severity);
>> > +               pci_dev_put(pdev);
>>
>> Are you sure pci_get_domain_bus_and_slot() does indeed increment the
>> reference count? I see that in the comments right above the
>> definition.
>>
>> pci_dev_get() does that for sure. I see a call trace of
>>
>> pci_dev_get() -> get_device() -> kobj_to_dev(kobject_get(&dev->kobj)  etc.
>>
>> and kref_get() finally incrementing the
>>
>> static inline void kref_get(struct kref *kref)
>> {
>>         WARN_ON(!atomic_read(&kref->refcount));
>>         atomic_inc(&kref->refcount);
>> }
>>
>> However, I could not find any evidence that
>> pci_get_domain_bus_and_slot() does that. I see
>> pci_get_domain_bus_and_slot() calling pci_domain_nr() and there are
>> several architecture specific defines for pci_domain_nr(). It is not
>> clear to me where does refcount get incremented from
>> pci_get_domain_bus_and_slot() is called.
>>
>> What am I missing?
>
> Trace back the for_each_pci_dev()
>
> for_each_pci_dev
>  -> pci_get_device
>   -> pci_get_subsys
>    -> pci_get_dev_by_id
>     -> bus_find_device
>      -> get_device()

Thanks. Didn't trace for_each_pci_dev()
>
> The real question is how many places do we call for_each_pci_dev()
> without a put.  It seems like pci_get_domain_bus_and_slot() doesn't even
> get it right since it should include a put of the non-matched devices.
> Thanks,
>

Probably several. I have seen only one or two cases pci_dev_put() is
called after pci_get_domain_bus_and_slot(). Did a quick search for
for_each_pci_dev() and found several instances that don't do
pci_dev_put()

-- Shuah
