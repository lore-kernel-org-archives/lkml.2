Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424Ab2CIRWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:22:35 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:45312 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757929Ab2CIRWd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:22:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWjsfduRrFqgxq-_ceg8kC-Bi-g4nGUYp0t1sZk3gM95g@mail.gmail.com>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
 <1331018040-30725-7-git-send-email-yinghai@kernel.org> <CAErSpo4ynKbMWUUo2QdVr6fbRYoexSXpQrgYbE+AXhXgg5yzvA@mail.gmail.com>
 <CAE9FiQWjsfduRrFqgxq-_ceg8kC-Bi-g4nGUYp0t1sZk3gM95g@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 9 Mar 2012 10:22:11 -0700
Message-ID: <CAErSpo59nU_GVA4i_x4m_jaxD1Aq6k62NXZVE3Xev0QP9ytnUg@mail.gmail.com>
Subject: Re: [PATCH 06/23] PCI: rescan with bus or bridge using callback
 method too
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 11:53 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Thu, Mar 8, 2012 at 4:56 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Tue, Mar 6, 2012 at 12:13 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> Just like removal.
>>>
>>> Because We could add new bus under the bridges...
>>>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>> ---
>>>  drivers/pci/pci-sysfs.c |   43 +++++++++++++++++++++++++++++++------------
>>>  1 files changed, 31 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
>>> index 2049b2f..1794508 100644
>>> --- a/drivers/pci/pci-sysfs.c
>>> +++ b/drivers/pci/pci-sysfs.c
>>> @@ -325,21 +325,31 @@ dev_rescan_store(struct device *dev, struct device_attribute *attr,
>>>        return count;
>>>  }
>>>
>>> +static void bridge_rescan_callback(struct device *dev)
>>> +{
>>> +       struct pci_dev *pdev = to_pci_dev(dev);
>>> +
>>> +       mutex_lock(&pci_remove_rescan_mutex);
>>> +       pci_rescan_bus_bridge_resize(pdev);
>>> +       mutex_unlock(&pci_remove_rescan_mutex);
>>> +}
>>> +
>>>  static ssize_t
>>>  dev_bridge_rescan_store(struct device *dev, struct device_attribute *attr,
>>>                 const char *buf, size_t count)
>>>  {
>>> +       int ret = 0;
>>>        unsigned long val;
>>> -       struct pci_dev *pdev = to_pci_dev(dev);
>>>
>>>        if (kstrtoul(buf, 0, &val) < 0)
>>>                return -EINVAL;
>>>
>>> -       if (val) {
>>> -               mutex_lock(&pci_remove_rescan_mutex);
>>> -               pci_rescan_bus_bridge_resize(pdev);
>>> -               mutex_unlock(&pci_remove_rescan_mutex);
>>> -       }
>>> +       if (val)
>>> +               ret = device_schedule_callback(dev, bridge_rescan_callback);
>>> +
>>> +       if (ret)
>>> +               count = ret;
>>> +
>>>        return count;
>>
>> I see that you copied this style from remove_store(), but it's ugly
>> and hard to follow.  I think this would be more readable:
>>
>>    if (!val)
>>        return count;
>>
>>    err = device_schedule_callback(dev, bridge_rescan_callback);
>>    if (err)
>>        return err;
>>
>>    return count;
>>
>
> like
>
>        if (!val)
>                return count;
>
>        ret = device_schedule_callback(dev, bus_rescan_callback);
>
>        if (ret)
>                return ret;
>
>        return count;
>
> that will have three return instead of one.
>
> both should be ok.

Why did you just repeat my proposal, changing "err" to "ret"?  I
missed the point you're trying to make.  The name "err" gives an
important clue that device_schedule_callback() returns 0 or errno.
That's essential to understanding the code.

Your original patch has one "return."  Mine proposal has three.  All
that means is that the reader of your patch has to manage more stuff
in her head to understand the code.  That's not a benefit!

Bjorn
