Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab2JIQGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 12:06:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727Ab2JIQGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 12:06:41 -0400
Message-ID: <50744B40.5030504@redhat.com>
Date: Tue, 09 Oct 2012 12:05:20 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120601 Thunderbird/10.0.5
MIME-Version: 1.0
To: Takao Indoh <indou.takao@jp.fujitsu.com>
CC: linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        martin.wilck@ts.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, vgoyal@redhat.com,
        ishii.hironobu@jp.fujitsu.com, hpa@zytor.com, bhelgaas@google.com,
        tglx@linutronix.de
Subject: Re: [PATCH v2 0/2] Reset PCIe devices to address DMA problem on kdump
 with iommu
References: <20121002074434.204.47750.sendpatchset@indoh> <506C3C4C.1060808@redhat.com> <5073E84A.8080301@jp.fujitsu.com>
In-Reply-To: <5073E84A.8080301@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2012 05:03 AM, Takao Indoh wrote:
> (2012/10/03 22:23), Don Dutile wrote:
>> On 10/02/2012 03:49 AM, Takao Indoh wrote:
>>> These patches reset PCIe devices at boot time to address DMA problem on
>>> kdump with iommu. When "reset_devices" is specified, a hot reset is
>>> triggered on each PCIe root port and downstream port to reset its
>>> downstream endpoint.
>>>
>>> Background:
>>> A kdump problem about DMA has been discussed for a long time. That is,
>>> when a kernel is switched to the kdump kernel DMA derived from first
>>> kernel affects second kernel. Recently this problem surfaces when iommu
>>> is used for PCI passthrough on KVM guest. In the case of the machine I
>>> use, when intel_iommu=on is specified, DMAR error is detected in kdump
>>> kernel and PCI SERR is also detected. Finally kdump fails because some
>>> devices does not work correctly.
>>>
>>> The root cause is that ongoing DMA from first kernel causes DMAR fault
>>> because page table of DMAR is initialized while kdump kernel is booting
>>> up. Therefore to address this problem DMA needs to be stopped before
>>> DMAR is initialized at kdump kernel boot time. By these patches, PCIe
>>> devices are reset by hot reset and its DMA is stopped when reset_devices
>>> is specified. One problem of this solution is that the monitor blacks
>>> out when VGA controller is reset. So this patch does not reset the port
>>> whose child endpoint is VGA device.
>>>
>>> v2:
>>> Reset devices in setup_arch() because reset need to be done before
>>> interrupt remapping is initialized.
>>>
>>> v1:
>>> https://lkml.org/lkml/2012/8/3/160
>>>
>>> Thanks,
>>> Takao Indoh
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>>
>> Maybe you've tried the following, and I missed a thread on it,
>> but instead of a somewhat-large, reset hammer, did any one try
>> just reading all the endpoint-only device CMD register, flip the MasterEnable
>> bit off, and write it back? .... that would stop all DMA (should stop
>> all MSI writes as well since they are just another DMA), and then
>> restart the system?
>> May also have to do PCI INT Disable as well... and note, that's a PCI 2.3
>> optional feature.... so devices using INT signalling vs MSI
>> is just borked on IOMMU/intr-remapping systems... which I would expect
>> are few. Then again, if this is foolishly done, then reset legacy PCI
>> busses as the fallback.
>
> Just clearing bus master bit and INTx disable bit in setup_arch() did
> not solve this problem. I still got DMAR error on devices(for exmaple,
> igb and megaraid_sas).
>
> Clearing bus master in setup_arch() and resetting devices in fixup_final
> like v1 patch is better, DMAR error was not detected. But on certain
> machine kdump kernel hung up when resetting devices. It seems to be a
> problem specific to the platform.
>
> And, resetting devices in setup_arch() like v2 patch solves all problems
> I found so far.
>
> Thanks,
> Takao Indoh
>
this summary should be in the patch set, so others know/learn
what was attempted, what failed, and how you reached this working conclusion.

