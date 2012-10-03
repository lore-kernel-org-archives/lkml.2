Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab2JCNXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 09:23:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107Ab2JCNXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 09:23:53 -0400
Message-ID: <506C3C4C.1060808@redhat.com>
Date: Wed, 03 Oct 2012 09:23:24 -0400
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
References: <20121002074434.204.47750.sendpatchset@indoh>
In-Reply-To: <20121002074434.204.47750.sendpatchset@indoh>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2012 03:49 AM, Takao Indoh wrote:
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
> v2:
> Reset devices in setup_arch() because reset need to be done before
> interrupt remapping is initialized.
>
> v1:
> https://lkml.org/lkml/2012/8/3/160
>
> Thanks,
> Takao Indoh
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Maybe you've tried the following, and I missed a thread on it,
but instead of a somewhat-large, reset hammer, did any one try
just reading all the endpoint-only device CMD register, flip the MasterEnable
bit off, and write it back? .... that would stop all DMA (should stop
all MSI writes as well since they are just another DMA), and then
restart the system?
May also have to do PCI INT Disable as well... and note, that's a PCI 2.3
optional feature.... so devices using INT signalling vs MSI
is just borked on IOMMU/intr-remapping systems... which I would expect
are few. Then again, if this is foolishly done, then reset legacy PCI
busses as the fallback.
