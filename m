Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161064Ab2JaJEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:04:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37944 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161031Ab2JaJEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:04:38 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <5090E865.1060503@jp.fujitsu.com>
Date: Wed, 31 Oct 2012 17:59:17 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        martin.wilck@ts.fujitsu.com, andi@firstfloor.org,
        kexec@lists.infradead.org, hbabu@us.ibm.com, mingo@redhat.com,
        ddutile@redhat.com, vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com,
        hpa@zytor.com, bhelgaas@google.com, tglx@linutronix.de,
        khalid@gonehiking.org
Subject: Re: [PATCH v5 0/2] Reset PCIe devices to address DMA problem on kdump
 with iommu
References: <20121017061757.2944.36671.sendpatchset@indoh>
In-Reply-To: <20121017061757.2944.36671.sendpatchset@indoh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/10/17 15:23), Takao Indoh wrote:
> These patches reset PCIe devices at boot time to address DMA problem on
> kdump with iommu. When "reset_devices" is specified, a hot reset is
> triggered on each PCIe root port and downstream port to reset its
> downstream endpoint.
>
> Background:
> A kdump problem about DMA has been discussed for a long time. That is,
> when a kernel is switched to the kdump kernel DMA derived from first
> kernel affects second kernel. Recently this problem surfaces when iommu
> is used for PCI passthrough on KVM guest. In the case of the machine I
> use, when intel_iommu=on is specified, DMAR error is detected in kdump
> kernel and PCI SERR is also detected. Finally kdump fails because some
> devices does not work correctly.
>
> The root cause is that ongoing DMA from first kernel causes DMAR fault
> because page table of DMAR is initialized while kdump kernel is booting
> up. Therefore to address this problem DMA needs to be stopped before
> DMAR is initialized at kdump kernel boot time. By these patches, PCIe
> devices are reset by hot reset and its DMA is stopped when reset_devices
> is specified. One problem of this solution is that the monitor blacks
> out when VGA controller is reset. So this patch does not reset the port
> whose child endpoint is VGA device.
>
> What I tried:
> - Clearing bus master bit and INTx disable bit at boot time
>      This did not solve this problem. I still got DMAR error on devices.
> - Resetting devices in fixup_final(v1 patch)
>      DMAR error disappeared, but sometimes PCI SERR was detected. This
>      is well explained here.
>      https://lkml.org/lkml/2012/9/9/245
>      This PCI SERR seems to be related to interrupt remapping.
> - Clearing bus master in setup_arch() and resetting devices in
>    fixup_final
>      Neither DMAR error nor PCI SERR occurred. But on certain machine
>      kdump kernel hung up when resetting devices. It seems to be a
>      problem specific to the platform.
> - Resetting devices in setup_arch() (v2 and later patch)
>      This solution solves all problems I found so far.
>
> v5:
> Do bus reset after all devices are scanned and its config registers are
> saved. This fixes a bug that config register is accessed without delay
> after reset.
>
> v4:
> Reduce waiting time after resetting devices. A previous patch does reset
> like this:
>    for (each device) {
>      save config registers
>      reset
>      wait for 500 ms
>      restore config registers
>    }
>
> If there are N devices to be reset, it takes N*500 ms. On the other
> hand, the v4 patch does:
>    for (each device) {
>      save config registers
>      reset
>    }
>    wait 500 ms
>    for (each device) {
>      restore config registers
>    }
> Though it needs more memory space to save config registers, the waiting
> time is always 500ms.
> https://lkml.org/lkml/2012/10/15/49
>
> v3:
> Move alloc_bootmem and free_bootmem to early_reset_pcie_devices so that
> they are called only once.
> https://lkml.org/lkml/2012/10/10/57
>
> v2:
> Reset devices in setup_arch() because reset need to be done before
> interrupt remapping is initialized.
> https://lkml.org/lkml/2012/10/2/54
>
> v1:
> Add fixup_final quirk to reset PCIe devices
> https://lkml.org/lkml/2012/8/3/160

Any other comments or ack/nack? If this is accepted I'll try multiple
domain support as next step.

Thanks,
Takao Indoh

