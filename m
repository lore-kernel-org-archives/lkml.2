Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab2DGOwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 10:52:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48329 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab2DGOwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 10:52:08 -0400
Message-ID: <4F80548C.3060202@gmail.com>
Date: Sat, 07 Apr 2012 22:51:56 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        Keping Chen <chenkeping@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Fix a device reference count leakage issue in pci_dev_present()
References: <1333726296-3817-1-git-send-email-jiang.liu@huawei.com> <CAErSpo7KdaYt0tVpBW5vXmc7RXRgnbaOe7JTNmb5xp4vZMsK3w@mail.gmail.com>
In-Reply-To: <CAErSpo7KdaYt0tVpBW5vXmc7RXRgnbaOe7JTNmb5xp4vZMsK3w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2012 07:23 AM, Bjorn Helgaas wrote:
> On Fri, Apr 6, 2012 at 9:31 AM, Jiang Liu <liuj97@gmail.com> wrote:
>> Function pci_get_dev_by_id() will hold a reference count on the pci device
>> returned, so pci_dev_present() should release the corresponding reference
>> count to avoid memory leakage.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> ---
>>  drivers/pci/search.c |   10 +++++-----
>>  1 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/pci/search.c b/drivers/pci/search.c
>> index 9d75dc8..b572730 100644
>> --- a/drivers/pci/search.c
>> +++ b/drivers/pci/search.c
>> @@ -338,13 +338,13 @@ int pci_dev_present(const struct pci_device_id *ids)
>>        WARN_ON(in_interrupt());
>>        while (ids->vendor || ids->subvendor || ids->class_mask) {
>>                found = pci_get_dev_by_id(ids, NULL);
>> -               if (found)
>> -                       goto exit;
>> +               if (found) {
>> +                       pci_dev_put(found);
>> +                       return 1;
>> +               }
>>                ids++;
>>        }
>> -exit:
>> -       if (found)
>> -               return 1;
>> +
>>        return 0;
>>  }
>>  EXPORT_SYMBOL(pci_dev_present);
> 
> This might be the right thing to do, but I'd like to understand what's
> going on, so let's talk about it a bit first.
> 
> I agree, there appears to be a leak here.  Or at least, the fact that
> we keep a reference when a device is found doesn't match the comment.
> What problem are you seeing from this leak?
> 
> There are not many callers, and most appear to be one-time things done
> at boot, looking for built-in devices known to be defective.  These
> devices won't be removable, so the leak shouldn't be causing
> hot-remove issues.
I noticed this issue when reading code, no real issue disclosed yet.
As you have pointed out, this interface is used for built-in devices only,
there should be no real issue currently and the patch is just for purity. 

> 
> IMO, this is a bogus interface that leads to poor code, and I don't
> want to encourage its use.  For device defect workarounds, I think
> it'd be better to use PCI quirks to catch the defective device.  Some
> chipset defects affect all downstream devices, and a quirk could make
> the defect visible to all the drivers, not just the ones that use
> pci_dev_present().  For example, look at tg3_write_reorder_chipsets
> and tg3_dma_wait_state_chipsets.  Those aren't for tg3 bugs, they're
> for chipset bugs that might affect other devices, too.  But right now,
> that knowledge is buried in the tg3 driver.
Thanks for pointing out the real issue behind this bogus interface.
It would be better to solve this type of chip bugs in PCI core instead
of in individual drivers.

> 
> Bjorn

