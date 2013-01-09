Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab3AIHk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 02:40:56 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:3416 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab3AIHky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 02:40:54 -0500
Message-ID: <50ED1EEB.8000405@huawei.com>
Date: Wed, 9 Jan 2013 15:40:27 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jiang Liu <liuj97@gmail.com>, Daniel J Blueman <daniel@quora.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: 3.8-rc2: pciehp waitqueue hang...
References: <CAMVG2ssiRgcTD1bej2tkUUfsWmpL5eNtPcNif9va2-Gzb2u8nQ@mail.gmail.com> <50E5A6A1.5040508@gmail.com> <CAErSpo6KJvEkiqkU--sF_vySk2YUgL_9t1OEYAAGBp9Ebom26w@mail.gmail.com> <CAErSpo6vTS6MnWoHJgXgmVtq=jqrudOHW47+8hVpc8GfiY100A@mail.gmail.com> <50E96A59.1080602@huawei.com> <CAErSpo7Qo_=d1dLqEFwFcpYjkncST-c1Lx8=3fThtLOaG_P8tQ@mail.gmail.com>
In-Reply-To: <CAErSpo7Qo_=d1dLqEFwFcpYjkncST-c1Lx8=3fThtLOaG_P8tQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,
   I will send the shpchp patch soon.

Thanks!
Yijing

>>> Yijing, please check for the same problem in other hotplug drivers.
>>> Questions I have after a quick look:
>>>
>>
>> Hi Bjorn,
>>    Sorry for delay reply. There are some busy work these days.
>>
>>>   - shpchp_wq looks like it might have the same deadlock issue.
>>
>> shpchp driver uses two workqueues shpchp_wq and shpchp_ordered_wq, they are created by alloc_ordered_workqueue
>> which set the "max_active" parameter to 1. So only one pci hotplug slot can do hotplug at the same time.
>> shpchp introduced these workqueue to remove the use of flush_scheduled_work() which is deprecated and scheduled for removal.
>>
>> hot remove path is:
>>  button press
>>        shpc_isr(interrupt handler)
>>             shpchp_handle_attention_button
>>                 queue_interrupt_event
>>                    queue_work "interrupt_event_handler" into "shpchp_wq"
>>                        interrupt_event_handler
>>                              handle_button_press_event
>>                                    queue_delayed_work "shpchp_queue_pushbutton_work" into "shpchp_wq"
>>                                          queue_work "shpchp_pushbutton_thread" into "shpchp_ordered_wq"
>>                                                shpchp_pushbutton_thread
>>                                                       shpchp_disable_slot
>>                                                             pci_stop_and_remove_bus_device
>>                                                                 ......
>>                                                                shpc_remove()   if the hotplug slot connected a iobox which contains some hotplug pcieport, shpc_remove will be called when remove pcie port device.
>>                                                                    hpc_release_ctlr
>>                                                                        flush_workqueue(shpchp_wq);
>>                                                                        flush_workqueue(shpchp_ordered_wq);
>>                                                                        So hotplug task hang.
>> shpchp driver has the same deadlock issue like pciehp driver, I think we should fix the issue, I will send out the patch if you agree this, but I have no machine support shpchp hotplug,
>> so I can't test this patch in real machine.
> 
> That's OK.  You've tested pciehp, and I don't want to leave shpchp
> broken the same way just because we can't test a similar fix there, so
> please do send the shpchp patch, too.
> 
>>>   - pciehp_wq (and your per-slot replacement) are allocated with
>>> alloc_workqueue().  shpchp_wq is allocated with
>>> alloc_ordered_workqueue().  Why the difference?
>>
>> alloc_workqueue(name, 0, 0) set max_active to 0(0 is default value used and support 256 work items of the wq can be executing at the same time per CPU).
>> So pciehp driver can handle push button event asynchronously.
>>
>> alloc_ordered_workqueue can only one handle push button event at the same time.
> 
> pciehp and shpchp should work the same in this respect unless there's
> a reason they can't, so it sounds like we should make shpchp work like
> pciehp.
> 
>>>   - The alloc/alloc_ordered difference might be related to 486b10b9f4,
>>> where Kenji removed alloc_ordered from pciehp.  Should a similar
>>> change be made to shpchp?
>>
>> Yes, I agree, we can use per-slot workqueue to fix this issue.
>>
>>>
>>>   - acpiphp uses the global kacpi_hotplug_wq.  We never flush or drain
>>> kacpi_hotplug_wq, so I doubt there's a deadlock issue, but I wonder if
>>> there are any ordering issues there because we *don't* ever wait for
>>> things in that queue to be completed.
>>
>> acpiphp driver is not attach to a pci device, so when hot remove pci device, driver will not to flush or drain kacpi_hotplug_wq.
>> But if we do acpiphp hot remove in sequence like this, there maybe cause some unexpected errors, I think.
>> slot(A)------pcie port----slot(B)
>> slot A and slot B both support acpiphp hotplug.
>> 1、press attention button on slot A;
>> 2、press attention button on slot B quickly after step 1;
>> Because kacpi_hotplug_wq is a ordered workqueue, slot B hot remove won't run unless slot A hot remove action completed.
>> After Slot B hot remove completed, some resources of slot A also has been destroyed. So slot B hot remove will cause some unexpected errors.
>> Because my hotplug machine's bios don't support iobox hotplug(slot-connected-slot), I can't verify this situation.
> 
> Hmm.  That definitely sounds like a potential problem.  But I think
> it's beyond the scope of the issue you're trying to fix, and any fix
> would look much different from your current pciehp patch, so I think
> we can treat it separately.
> 
> Bjorn
> 
> .
> 


-- 
Thanks!
Yijing

