Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab3AFMOS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 07:14:18 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:19445 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab3AFMOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 07:14:15 -0500
Message-ID: <50E96A59.1080602@huawei.com>
Date: Sun, 6 Jan 2013 20:13:13 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Jiang Liu <liuj97@gmail.com>, Daniel J Blueman <daniel@quora.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: 3.8-rc2: pciehp waitqueue hang...
References: <CAMVG2ssiRgcTD1bej2tkUUfsWmpL5eNtPcNif9va2-Gzb2u8nQ@mail.gmail.com> <50E5A6A1.5040508@gmail.com> <CAErSpo6KJvEkiqkU--sF_vySk2YUgL_9t1OEYAAGBp9Ebom26w@mail.gmail.com> <CAErSpo6vTS6MnWoHJgXgmVtq=jqrudOHW47+8hVpc8GfiY100A@mail.gmail.com>
In-Reply-To: <CAErSpo6vTS6MnWoHJgXgmVtq=jqrudOHW47+8hVpc8GfiY100A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/1/5 5:50, Bjorn Helgaas wrote:
> [+to Yijing, +cc Kenji]
> 
> On Fri, Jan 4, 2013 at 1:01 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Thu, Jan 3, 2013 at 8:41 AM, Jiang Liu <liuj97@gmail.com> wrote:
>>> Hi Daniel,
>>>         It seems like an issue caused by recursive PCIe HPC.
>>> Could you please help to try the patch from:
>>> http://www.spinics.net/lists/linux-pci/msg18625.html
>>
>> Hi Gerry,
>>
>> I'm working on merging this patch.  Seems like something that might be
>> appropriate for stable as well.
>>
>> Did you look for similar problems in other hotplug drivers?
> 
> Oops, sorry, I forgot that Yijing is the author of the patch in question.
> 
> Yijing, please check for the same problem in other hotplug drivers.
> Questions I have after a quick look:
> 

Hi Bjorn,
   Sorry for delay reply. There are some busy work these days.

>   - shpchp_wq looks like it might have the same deadlock issue.

shpchp driver uses two workqueues shpchp_wq and shpchp_ordered_wq, they are created by alloc_ordered_workqueue
which set the "max_active" parameter to 1. So only one pci hotplug slot can do hotplug at the same time.
shpchp introduced these workqueue to remove the use of flush_scheduled_work() which is deprecated and scheduled for removal.

hot remove path is:
 button press
       shpc_isr(interrupt handler)
	    shpchp_handle_attention_button
                queue_interrupt_event
                   queue_work "interrupt_event_handler" into "shpchp_wq"
                       interrupt_event_handler
			     handle_button_press_event
		      		   queue_delayed_work "shpchp_queue_pushbutton_work" into "shpchp_wq"
					 queue_work "shpchp_pushbutton_thread" into "shpchp_ordered_wq"
                                               shpchp_pushbutton_thread
                                                      shpchp_disable_slot
                                                            pci_stop_and_remove_bus_device
                                                                ......
                                                               shpc_remove()   if the hotplug slot connected a iobox which contains some hotplug pcieport, shpc_remove will be called when remove pcie port device.
                                                                   hpc_release_ctlr
                                                                       flush_workqueue(shpchp_wq);
                                                                       flush_workqueue(shpchp_ordered_wq);
                                                                       So hotplug task hang.
shpchp driver has the same deadlock issue like pciehp driver, I think we should fix the issue, I will send out the patch if you agree this, but I have no machine support shpchp hotplug,
so I can't test this patch in real machine.


>   - pciehp_wq (and your per-slot replacement) are allocated with
> alloc_workqueue().  shpchp_wq is allocated with
> alloc_ordered_workqueue().  Why the difference?

alloc_workqueue(name, 0, 0) set max_active to 0(0 is default value used and support 256 work items of the wq can be executing at the same time per CPU).
So pciehp driver can handle push button event asynchronously.

alloc_ordered_workqueue can only one handle push button event at the same time.

> 
>   - The alloc/alloc_ordered difference might be related to 486b10b9f4,
> where Kenji removed alloc_ordered from pciehp.  Should a similar
> change be made to shpchp?

Yes, I agree, we can use per-slot workqueue to fix this issue.

> 
>   - acpiphp uses the global kacpi_hotplug_wq.  We never flush or drain
> kacpi_hotplug_wq, so I doubt there's a deadlock issue, but I wonder if
> there are any ordering issues there because we *don't* ever wait for
> things in that queue to be completed.

acpiphp driver is not attach to a pci device, so when hot remove pci device, driver will not to flush or drain kacpi_hotplug_wq.
But if we do acpiphp hot remove in sequence like this, there maybe cause some unexpected errors, I think.
slot(A)------pcie port----slot(B)
slot A and slot B both support acpiphp hotplug.
1、press attention button on slot A;
2、press attention button on slot B quickly after step 1;
Because kacpi_hotplug_wq is a ordered workqueue, slot B hot remove won't run unless slot A hot remove action completed.
After Slot B hot remove completed, some resources of slot A also has been destroyed. So slot B hot remove will cause some unexpected errors.
Because my hotplug machine's bios don't support iobox hotplug(slot-connected-slot), I can't verify this situation.


Thanks!
Yijing.


> 
>>> Thanks!
>>> Gerry
>>> On 01/03/2013 11:11 PM, Daniel J Blueman wrote:
>>>> When the Apple thunderbolt ethernet adapter comes loose on my Macbook
>>>> Pro Retina (Intel DSL3510), we see pci_slot_name return
>>>> non-deterministic data (ie varying each boot), and we see pciehp_wp
>>>> remain armed with events causing the kthread to get stuck:
>>>>
>>>> tg3 0000:0a:00.0 eth0: Link is up at 1000 Mbps, full duplex
>>>> tg3 0000:0a:00.0 eth0: Flow control is on for TX and on for RX
>>>> <thunderbold adapter comes loose>
>>>> pciehp 0000:06:03.0:pcie24: Card not present on Slot(3)
>>>> tg3 0000:0a:00.0: tg3_abort_hw timed out, TX_MODE_ENABLE will not
>>>> clear MAC_TX_MODE=ffffffff
>>>> tg3 0000:0a:00.0 eth0: No firmware running
>>>> tg3 0000:0a:00.0 eth0: Link is down
>>>> pcieport 0000:00:01.1: System wakeup enabled by ACPI
>>>> pciehp 0000:09:00.0:pcie24: unloading service driver pciehp
>>>> pciehp 0000:09:00.0:pcie24: Latch open on
>>>> Slot(\xfffffff89\xffffffbbe\x02\xffffff88\xffffffff\xffffffff\xffffffe09\xffffffbbe\x02\xffffff88\xffffffff\xfffffffffbcon)
>>>> pciehp 0000:09:00.0:pcie24: Button pressed on
>>>> Slot(\xfffffff89\xffffffbbe\x02\xffffff88\xffffffff\xffffffff\xffffffe09\xffffffbbe\x02\xffffff88\xffffffff\xfffffffffbcon)
>>>> pciehp 0000:09:00.0:pcie24: Card present on
>>>> Slot(\xfffffff89\xffffffbbe\x02\xffffff88\xffffffff\xffffffff\xffffffe09\xffffffbbe\x02\xffffff88\xffffffff\xfffffffffbcon)
>>>> pciehp 0000:09:00.0:pcie24: Power fault on slot
>>>> \xfffffff89\xffffffbbe\x02\xffffff88\xffffffff\xffffffff\xffffffe09\xffffffbbe\x02\xffffff88\xffffffff\xfffffffffbcon
>>>> pciehp 0000:09:00.0:pcie24: Power fault bit 0 set
>>>> pciehp 0000:09:00.0:pcie24: PCI slot
>>>> #\xfffffff89\xffffffbbe\x02\xffffff88\xffffffff\xffffffff\xffffffe09\xffffffbbe\x02\xffffff88\xffffffff\xfffffffffbcon
>>>> - powering on due to button press.
>>>> pciehp 0000:09:00.0:pcie24: Link Training Error occurs
>>>> pciehp 0000:09:00.0:pcie24: Failed to check link status
>>>> INFO: task kworker/0:1:52 blocked for more than 120 seconds.
>>>> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>> kworker/0:1   D ffff880265893090   0  52   2 0x00000000
>>>>  ffff8802655456f8 0000000000000046 ffffffff81a21a60 ffff880265545fd8
>>>>  0000000000004000 ffff880265545fd8 ffff880265892bb0 ffff880265adc8d0
>>>>  000000000000059e 0000000000000082 ffff880265545668 ffffffff810415aa
>>>> Call Trace:
>>>>  [<ffffffff810415aa>] ? console_unlock+0x1fa/0x4a0
>>>>  [<ffffffff8108d16d>] ? trace_hardirqs_off+0xd/0x10
>>>>  [<ffffffff81041b19>] ? vprintk_emit+0x1c9/0x510
>>>>  [<ffffffff81558db4>] schedule+0x24/0x70
>>>>  [<ffffffff8155653c>] schedule_timeout+0x19c/0x1e0
>>>>  [<ffffffff81558c43>] wait_for_common+0xe3/0x180
>>>>  [<ffffffff8105adc1>] ? flush_workqueue+0x111/0x4d0
>>>>  [<ffffffff81071140>] ? try_to_wake_up+0x2d0/0x2d0
>>>>  [<ffffffff81558d88>] wait_for_completion+0x18/0x20
>>>>  [<ffffffff8105ae86>] flush_workqueue+0x1d6/0x4d0
>>>>  [<ffffffff8105acb0>] ? flush_workqueue_prep_cwqs+0x200/0x200
>>>>  [<ffffffff8125e909>] pciehp_release_ctrl+0x39/0x90
>>>>  [<ffffffff8125b945>] pciehp_remove+0x25/0x30
>>>>  [<ffffffff81255bf2>] pcie_port_remove_service+0x52/0x70
>>>>  [<ffffffff81306a27>] __device_release_driver+0x77/0xe0
>>>>  [<ffffffff81306ab9>] device_release_driver+0x29/0x40
>>>>  [<ffffffff813064b1>] bus_remove_device+0xf1/0x140
>>>>  [<ffffffff81303fe7>] device_del+0x127/0x1c0
>>>>  [<ffffffff81255d70>] ? resume_iter+0x40/0x40
>>>>  [<ffffffff81304091>] device_unregister+0x11/0x20
>>>>  [<ffffffff81255da5>] remove_iter+0x35/0x40
>>>>  [<ffffffff81302eb6>] device_for_each_child+0x36/0x70
>>>>  [<ffffffff81256341>] pcie_port_device_remove+0x21/0x40
>>>>  [<ffffffff81256588>] pcie_portdrv_remove+0x28/0x50
>>>>  [<ffffffff8124a821>] pci_device_remove+0x41/0xc0
>>>>  [<ffffffff81306a27>] __device_release_driver+0x77/0xe0
>>>>  [<ffffffff81306ab9>] device_release_driver+0x29/0x40
>>>>  [<ffffffff813064b1>] bus_remove_device+0xf1/0x140
>>>>  [<ffffffff81303fe7>] device_del+0x127/0x1c0
>>>>  [<ffffffff81304091>] device_unregister+0x11/0x20
>>>>  [<ffffffff8124566c>] pci_stop_bus_device+0x8c/0xa0
>>>>  [<ffffffff81245615>] pci_stop_bus_device+0x35/0xa0
>>>>  [<ffffffff81245811>] pci_stop_and_remove_bus_device+0x11/0x20
>>>>  [<ffffffff8125cc91>] pciehp_unconfigure_device+0x91/0x190
>>>>  [<ffffffff8125c76d>] ? pciehp_power_thread+0x2d/0x110
>>>>  [<ffffffff8125c591>] pciehp_disable_slot+0x71/0x220
>>>>  [<ffffffff8125c826>] pciehp_power_thread+0xe6/0x110
>>>>  [<ffffffff8105d203>] process_one_work+0x193/0x550
>>>>  [<ffffffff8105d1a1>] ? process_one_work+0x131/0x550
>>>>  [<ffffffff8125c740>] ? pciehp_disable_slot+0x220/0x220
>>>>  [<ffffffff8105d96d>] worker_thread+0x15d/0x400
>>>>  [<ffffffff8109213d>] ? trace_hardirqs_on+0xd/0x10
>>>>  [<ffffffff8105d810>] ? rescuer_thread+0x210/0x210
>>>>  [<ffffffff81062bd6>] kthread+0xd6/0xe0
>>>>  [<ffffffff8155a18b>] ? _raw_spin_unlock_irq+0x2b/0x50
>>>>  [<ffffffff81062b00>] ? __init_kthread_worker+0x70/0x70
>>>>  [<ffffffff8155ae6c>] ret_from_fork+0x7c/0xb0
>>>>  [<ffffffff81062b00>] ? __init_kthread_worker+0x70/0x70
>>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> .
> 


-- 
Thanks!
Yijing

