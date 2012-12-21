Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab2LUKht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 05:37:49 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40840 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab2LUKho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 05:37:44 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <50D43BCF.3080201@jp.fujitsu.com>
Date: Fri, 21 Dec 2012 19:37:03 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: yangoliver@gmail.com
CC: linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, tokunaga.keiich@jp.fujitsu.com,
        kexec@lists.infradead.org, hbabu@us.ibm.com, mingo@redhat.com,
        ddutile@redhat.com, vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com,
        hpa@zytor.com, bhelgaas@google.com, tglx@linutronix.de,
        yinghai@kernel.org, khalid@gonehiking.org
Subject: Re: [PATCH v7 0/5] Reset PCIe devices to address DMA problem on kdump
 with iommu
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local> <CAK4g67ZEUfCqqpa1-4wkN4+OXZYQqLTiJC+6OpwVWVLfO2_7xQ@mail.gmail.com>
In-Reply-To: <CAK4g67ZEUfCqqpa1-4wkN4+OXZYQqLTiJC+6OpwVWVLfO2_7xQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(2012/12/21 18:59), oliver yang wrote:
>
> Hi Takao,
>
> Because I want to config the kdump in our lab, I have some questions
> about the backgroud of your patch.
>
> 1. Will you patch only work while IOMMU is enabled?

No. It always works when "reset_devices" is specified as boot parameter.


>
> 2. Looks like kdump doesn't disable DMA and interrupts in the systems,
> how can Linux make sure second kernel's memory is not corrupted by
> devices initialized by first kernel?

See purgatory/purgatory.c in kexec_tools. Before jumping into second
kernel, a part of memory is checked using sha256 digest.

Thanks,
Takao Indoh


>
>
> 2012/11/27 Takao Indoh <indou.takao@jp.fujitsu.com <mailto:indou.takao@jp.fujitsu.com>>
>
>     These patches reset PCIe devices at boot time to address DMA problem on
>     kdump with iommu. When "reset_devices" is specified, a hot reset is
>     triggered on each PCIe root port and downstream port to reset its
>     downstream endpoint.
>
>     Background:
>     A kdump problem about DMA has been discussed for a long time. That is,
>     when a kernel is switched to the kdump kernel, DMA derived from first
>     kernel affects second kernel. Especially this problem surfaces when
>     iommu is used for PCI passthrough on KVM guest. In the case of the
>     machine I use, when intel_iommu=on is specified, DMAR error is detected
>     in kdump kernel and PCI SERR is also detected. Finally kdump fails
>     because some devices does not work correctly.
>
>     The root cause is that ongoing DMA from first kernel causes DMAR fault
>     because page table of DMAR is initialized while kdump kernel is booting
>     up. Therefore to solve this problem DMA needs to be stopped before DMAR
>     is initialized at kdump kernel boot time. By these patches, PCIe devices
>     are reset by hot reset and its DMA is stopped when reset_devices is
>     specified. One problem of this solution is that the monitor blacks out
>     when VGA controller is reset. So this patch does not reset the port
>     whose child endpoint is VGA device.
>
>     What I tried:
>     - Clearing bus master bit and INTx disable bit at boot time
>          This did not solve this problem. I still got DMAR error on devices.
>     - Resetting devices in fixup_final(v1 patch)
>          DMAR error disappeared, but sometimes PCI SERR was detected. This
>          is well explained here.
>     https://lkml.org/lkml/2012/9/9/245
>          This PCI SERR seems to be related to interrupt remapping.
>     - Clearing bus master in setup_arch() and resetting devices in
>        fixup_final
>          Neither DMAR error nor PCI SERR occurred. But on certain machine
>          kdump kernel hung up when resetting devices. It seems to be a
>          problem specific to the platform.
>     - Resetting devices in setup_arch() (v2 and later patch)
>          This solution solves all problems I found so far.
>
>     Changelog:
>     v7:
>     Update Yinghai's dummy-pci patch with macros in linux/pci.h, and fix
>     some bugs
>
>     v6:
>     Rewrite using Yinghai's dummy-pci patch
>     https://lkml.org/lkml/2012/11/13/118
>
>     v5:
>     Do bus reset after all devices are scanned and its config registers are
>     saved. This fixes a bug that config register is accessed without delay
>     after reset.
>     https://lkml.org/lkml/2012/10/17/47
>
>     v4:
>     Reduce waiting time after resetting devices. A previous patch does reset
>     like this:
>        for (each device) {
>          save config registers
>          reset
>          wait for 500 ms
>          restore config registers
>        }
>
>     If there are N devices to be reset, it takes N*500 ms. On the other
>     hand, the v4 patch does:
>        for (each device) {
>          save config registers
>          reset
>        }
>        wait 500 ms
>        for (each device) {
>          restore config registers
>        }
>     Though it needs more memory space to save config registers, the waiting
>     time is always 500ms.
>     https://lkml.org/lkml/2012/10/15/49
>
>     v3:
>     Move alloc_bootmem and free_bootmem to early_reset_pcie_devices so that
>     they are called only once.
>     https://lkml.org/lkml/2012/10/10/57
>
>     v2:
>     Reset devices in setup_arch() because reset need to be done before
>     interrupt remapping is initialized.
>     https://lkml.org/lkml/2012/10/2/54
>
>     v1:
>     Add fixup_final quirk to reset PCIe devices
>     https://lkml.org/lkml/2012/8/3/160
>
>     Takao Indoh (5):
>        x86, pci: add dummy pci device for early stage
>        PCI: Define the maximum number of PCI function
>        Make reset_devices available at early stage
>        x86, pci: Reset PCIe devices at boot time
>        x86, pci: Enable PCI INTx when MSI is disabled
>
>       arch/x86/include/asm/pci-direct.h |    3 +
>       arch/x86/kernel/setup.c           |    3 +
>       arch/x86/pci/common.c             |    4 +-
>       arch/x86/pci/early.c              |  315 +++++++++++++++++++++++++++++++++++++
>       include/linux/pci.h               |    2 +
>       init/main.c                       |    4 +-
>       6 files changed, 328 insertions(+), 3 deletions(-)
>
>
>     --
>     To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>     the body of a message to majordomo@vger.kernel.org <mailto:majordomo@vger.kernel.org>
>     More majordomo info at http://vger.kernel.org/majordomo-info.html
>     Please read the FAQ at http://www.tux.org/lkml/
>
>
>
>
> --
> ------------------
> Oliver Yang

