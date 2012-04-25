Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127Ab2DYRXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 13:23:45 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59591 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498Ab2DYRXn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 13:23:43 -0400
MIME-Version: 1.0
In-Reply-To: <4F840ED6.3050408@jp.fujitsu.com>
References: <1333822735-10902-1-git-send-email-jiang.liu@huawei.com> <4F840ED6.3050408@jp.fujitsu.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 25 Apr 2012 11:23:20 -0600
Message-ID: <CAErSpo7qqDJ+pM-OZN6wDRGCU3duLd1-hjA5_LA+em=PBVuY0Q@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] PCI: correctly flush workqueue when destroy pcie
 hotplug controller
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jiang Liu <liuj97@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>, matsumoto.hiroo@jp.fujitsu.com,
        Keping Chen <chenkeping@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 4:43 AM, Kenji Kaneshige
<kaneshige.kenji@jp.fujitsu.com> wrote:
> I think you're rignt.
>
> Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
>
> (2012/04/08 3:18), Jiang Liu wrote:
>> When destroying a PCIe hotplug controller, all work items associated with
>> that controller should be flushed.  Function pcie_cleanup_slot() calls
>> cancel_delayed_work() and flush_workqueue() to achieve that.
>> Function flush_workqueue() will flush all work items already submitted,
>> but new work items submitted by those already submitted work items may
>> still be in live state when returning from flush_workqueue().
>>
>> For the extreme case, pciehp driver may expierence following calling path:
>> 1) pcie_isr() ->  pciehp_handle_xxx() ->  queue_interrupt_event()->queue_work()
>> 2) interrupt_event_handler() ->  handle_button_press_event() ->
>>     queue_delayed_work()
>> 3) pciehp_queue_pushbutton_work() ->  queue_work()
>>
>> So enhance pcie_cleanup_slot() to correctly flush workqueue when destroying
>> PCIe hotplug controller.
>>
>> Signed-off-by: Jiang Liu<jiang.liu@huawei.com>
>> ---
>>   drivers/pci/hotplug/pciehp_hpc.c |   13 ++++++++++++-
>>   1 files changed, 12 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
>> index d4fa705..9a48a51 100644
>> --- a/drivers/pci/hotplug/pciehp_hpc.c
>> +++ b/drivers/pci/hotplug/pciehp_hpc.c
>> @@ -890,8 +890,19 @@ static int pcie_init_slot(struct controller *ctrl)
>>   static void pcie_cleanup_slot(struct controller *ctrl)
>>   {
>>       struct slot *slot = ctrl->slot;
>> -     cancel_delayed_work(&slot->work);
>> +
>> +     /*
>> +      * Following workqueue flushing logic is to deal with the special call path:
>> +      * 1) pcie_isr() ->  pciehp_handle_xxx() ->
>> +      *    queue_interrupt_event(pciehp_wq_event)->queue_work(pciehp_wq)
>> +      * 2) interrupt_event_handler() ->  handle_button_press_event() ->
>> +      *    queue_delayed_work(pciehp_wq)
>> +      * 3) pciehp_queue_pushbutton_work() ->  queue_work(pciehp_wq)
>> +      */
>>       flush_workqueue(pciehp_wq);
>> +     cancel_delayed_work_sync(&slot->work);
>> +     flush_workqueue(pciehp_wq);
>> +
>>       kfree(slot);
>>   }

Jiang, I'm ignoring this (and the next [2/2] patch) because I assume
they're superceded by the "[PATCH RFC 00/17] Introduce a global lock
to serialize all PCI hotplug" series of April 16.  Let me know if
otherwise.

Bjorn
