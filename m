Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab2HEJhn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 05:37:43 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:47508 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab2HEJhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 05:37:41 -0400
Message-ID: <501E3EAD.9090905@huawei.com>
Date: Sun, 5 Aug 2012 17:36:45 +0800
From: Jiang Liu <jiang.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jiang Liu <liuj97@gmail.com>, Len Brown <lenb@kernel.org>,
        Tony Luck <tony.luch@intel.com>, Bob Moore <robert.moore@intel.com>,
        Huang Ying <ying.huang@intel.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Hanjun Guo <guohanjun@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, Gaohuai Han <hangaohuai@huawei.com>
Subject: Re: [RFC PATCH 2/3] ACPIHP: ACPI system device hotplug slot enumerator
References: <1343475772-21345-1-git-send-email-jiang.liu@huawei.com> <1343475772-21345-3-git-send-email-jiang.liu@huawei.com> <CAE9FiQU=HmRCy0nxLgi7oqnjbaW4DJ2ct1EE2pVP+=rac2D+wQ@mail.gmail.com>
In-Reply-To: <CAE9FiQU=HmRCy0nxLgi7oqnjbaW4DJ2ct1EE2pVP+=rac2D+wQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.108.108.229]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-8-5 4:14, Yinghai Lu wrote:
> On Sat, Jul 28, 2012 at 4:42 AM, Jiang Liu <liuj97@gmail.com> wrote:
>> The first is an ACPI hotplug slot enumerator, which enumerates ACPI hotplug
>> slots on load and provides callbacks to manage those hotplug slots.
>> An ACPI hotplug slot is an abstraction of receptacles, where a group of
>> system devices could be connected to. This patch implements the skeleton for
>> ACPI system device hotplug slot enumerator. On loading, the driver scans the
>> whole ACPI namespace for hotplug slots and creates a device node for each
>> hotplug slots. Every slot is associated with a device class named
>> acpihp_slot_class and will be managed by ACPI hotplug drivers.
> 
> I was thinking:
>    We can have module in ACPI DSDT, and every module is coresponding
> to SystemModule.
>    so it will be
> 	\_SB.NOD1
> 		CPU0
> 		CPU1
> 		CPU2
> 		CPU3
> 		MEM0
> 		MEM1
> 		MEM2
> 		MEM3
> 		PCI0
> 		PCI1
> 		PCI2
> 		PCI3
> 		NTFY
> 		STAT
> 		STOP
>     NTFY will be something like:
> 	Notify(\_SB.NOD1.CPU0,....)
> 	Notify(\_SB.NOD1.CPU1,....)
> 	Notify(\_SB.NOD1.CPU2,....)
> 	Notify(\_SB.NOD1.CPU3,....)
> 
> 	Notify(\_SB.NOD1.MEM0,....)
> 	Notify(\_SB.NOD1.MEM1,....)
> 	Notify(\_SB.NOD1.MEM2,....)
> 	Notify(\_SB.NOD1.MEM3,....)
> 
> 	Notify(\_SB.NOD1.PCI0,....)
> 	Notify(\_SB.NOD1.PCI1,....)
> 	Notify(\_SB.NOD1.PCI2,....)
> 	Notify(\_SB.NOD1.PCI3,....)
> 
>    and will link GPE button for SystemModule to call NTFY.
> 
>    STAT could be 32bit integer for final turn off the power.
> 	every CPU, MEM, PCI will own one bit, it will clear that bit in this own
> 	_EJ0.
> 	Every _EJ0 will double check if all are cleared, then it call extra STOP
> 	to power off the whole SystemModule.
> 
> if OS already have seperated handler for those type objects (CPU, MEM,
> PCI),  we may not need to change to much to os.

Hi Yinghai,
	Thanks for your comments.
	It's one of the major concerns that we may need to make too many changes
to existing code, and even break backward compatibilities:(

	There are two possible ways to support hotplug in ACPI BIOS:
	1) send hotplug notifications to each sub-component of an FRU/module.
	2) send hotplug notifications to the FRU itself. 

	We have had discussions with BIOS team and chose to adopt the second 
solution because:
	1) It's more convenient for user to operate on FRUs instead of sub-components.
	2) BIOS will be simpler because it only need to track status of FRU itself
	instead	of sub-components.
	3) It will be much more complex to do error recover if OS/BIOS cooperate on
	sub-component granularity.
	Any suggestions here?
	Regards!
	Gerry

