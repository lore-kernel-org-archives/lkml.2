Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab2JHPsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 11:48:39 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49065 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab2JHPsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 11:48:35 -0400
Message-ID: <5072F52D.6090807@gmail.com>
Date: Mon, 08 Oct 2012 23:45:49 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Hanjun Guo <guohanjun@huawei.com>, Yijing Wang <wangyijing@huawei.com>,
        Gong Chen <gong.chen@linux.intel.com>,
        Jiang Liu <jiang.liu@huawei.com>, Tony Luck <tony.luck@intel.com>,
        Huang Ying <ying.huang@intel.com>, Bob Moore <robert.moore@intel.com>,
        Len Brown <lenb@kernel.org>,
        "Srivatsa S . Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [RFC PATCH v3 00/28] ACPI based system device hotplug framework
References: <1349537256-21670-1-git-send-email-jiang.liu@huawei.com> <4290643.jEcV9mqAac@vostro.rjw.lan>
In-Reply-To: <4290643.jEcV9mqAac@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2012 05:47 AM, Rafael J. Wysocki wrote:
> Hi,
> 
> On Saturday 06 of October 2012 23:27:08 Jiang Liu wrote:
>> The patchset is based on "5f3d2f2e1a63679cf1c4a4210f2f1cc2f335bef6"
>> from git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>> And you pull the changeset from git://github.com/jiangliu/linux.git acpihp
>>
>> Modern high-end server may support advanced hotplug features for system
>> devices, including physical processor, memory board, IO extension board
>> and/or computer node. The ACPI specifications have provided standard
>> interfaces between firmware and OS to support device hotplug at runtime.
>> This patch series provide an ACPI based hotplug framework to support system
>> device hotplug at runtime, which will replace current existing ACPI device
>> driver based CPU/memory/CONTAINER hotplug mechanism.
>>
>> The new ACPI system device hotplug framework has following design goals:
>> 1) Provide a mechanism to detect hotplug slots by checking ACPI _EJ0 method,
>> ACPI PRCT (platform RAS capabilities table) and other platform specific
>> mechanisms.
> 
> Which of the patches does that?
Hi Rafael,
	Thanks for your review:)
Currently we have only implemented slot detection based on _EJ0 method. PRCT is
still in plan because that spec is not in public domain yet, ACPI5.0 only reserves
that key word without any detail information about it:(
	The patch 1-4 implement the slot enumeration driver.

> 
>> 2) Unify the way to enumerate ACPI based hotplug slots. All hotplug slots
>> will be enumerated by the enumeration driver
> 
> What is the enumeration driver?
The enumerator is a driver to create ACPI system device hotplug slots, which
takes following responsibilities:
1) walk the ACPI namespace to scan for hotpug slot with platform specific knowledge.
2) create hotplug slot device for each hotplug slot found, later a hotplug driver
will bind to those hotplug slots.
3) Provide platform specific callback methods to control those hotplug slots,
such as get slot capabilities, power on slot, power off slot etc.

> 
>> , instead of by ACPI device drivers.
>> 3) Unify the way to handle ACPI hotplug events. All ACPI hotplug events
>> for system devices will be handled by a generic ACPI hotplug driver,
>> instead of handled by ACPI device drivers.
> 
> What are "system devices"
System devices includes CPU, memory, PCI host bridge and node (ACPI module device
contains CPU, memory and/or PCI host bridge).

> 
>> 4) Solve dependencies among hotplug slots. You need first to remove the
>> memory device before removing a physical processor if a hotpluggable memory
>> device is connected to a hotpluggable physical processor.
>> 5) Provide better error handling and recover.
>> 6) Provide interface to cancel ongoing hotplug operations. It may take a
>> very long time to remove a memory device, so provide interface to cancel
>> the operation. This is important especially for memory hot-removal.
>> 7) Support new RAS features, such as socket/memory migration.
>> 8) Provide better user interfaces to the hotplug functionalities.
>> 9) Trigger hotplug events/operations by software. This feature is useful
>>    for hardware fault management and power saving.
> 
> Well, this may or may not be OK.  I'm going to review the patches, but I can't
> really say when it's going to happen (not really soon for sure).
> 

>>  create mode 100644 drivers/acpi/hotplug/slot_fake.c
>>  create mode 100644 drivers/acpi/hotplug/state_machine.c
>>  create mode 100644 drivers/acpi/hotplug/sysfs.c
>>  create mode 100644 include/acpi/acpi_hotplug.h
>>  delete mode 100644 include/acpi/container.h
> 
> And I seriously think this is too much material for a single patchset.
> 
> Please consider splitting it into smaller and well-documented series of
> patches, so that the reviewers can understand things more easily.
Thanks for your advice, I will split them into small groups next time.
The patch set could be divided into four parts:
patch 1-4: implement a ACPI system device hotplug slot enumerator
patch 6-17: implement a hotplug driver to manage all ACPI system device hotplug slots
patch 18-19: refine ACPI container driver to support new hotplug framework
patch 20-28: refine ACPI processor driver to support new hotplug framewor, also with some code cleanup

Thanks
Gerry

