Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab0ISRPe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 13:15:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127Ab0ISRPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 13:15:33 -0400
Message-ID: <4C96452F.8090802@redhat.com>
Date: Sun, 19 Sep 2010 19:15:27 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Cam Macdonell <cam@cs.ualberta.ca>
CC: "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Chris Wright <chrisw@redhat.com>
Subject: Re: [Qemu-devel] ACPI error when mapping a 2GB BAR w/ 4GB of RAM
References: <AANLkTinORYZOYk9xsST+J=zxgeZPr2BNw3S=dvPPTcdn@mail.gmail.com>
In-Reply-To: <AANLkTinORYZOYk9xsST+J=zxgeZPr2BNw3S=dvPPTcdn@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/17/2010 10:00 PM, Cam Macdonell wrote:
> After fixing the resource_size_t return value with
> pci_resource_alignment, I see one other strange behaviour only when
> using 4GB of RAM and a 2GB BAR.  I haven't found any other combination
> of RAM/BAR size that triggers this bug.  I am using 2.6.36-rc3.
>
> ACPI Error: The DSDT has been corrupted or replaced - old, new headers
> below (20100702/tbutils-372)
> ACPI: DSDT (null) 01F15 (v01   BXPC   BXDSDT 00000001 INTL 20090123)
> ACPI:      (null) 00000 (v00                 00000000      00000000)
> ACPI Error: Please send DMI info to linux-acpi@vger.kernel.org
> If system does not work as expected, please boot with acpi=copy_dsdt
> (20100702/tbutils-378)
> ACPI: PCI Interrupt Link [LNKC] disabled and referenced, BIOS bug
> ACPI Exception: AE_AML_INVALID_RESOURCE_TYPE, Evaluating _CRS
> (20100702/pci_link-283)
> ACPI: Unable to set IRQ for PCI Interrupt Link [LNKC]. Try pci=noacpi
> or acpi=off
> virtio-pci 0000:00:03.0: PCI INT A: no GSI - using ISA IRQ 11
> Non-volatile memory driver v1.3
> Linux agpgart interface v0.103
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
>
> with acpi=off, the ACPI error output goes away, but the boot does not
> get any further.
>
> here are the PCI writes from Qemu related to this BAR's assignment in
> case they are helpful,
>
> pci_write_config: (val) 0x80000004 ->  0x18 (addr)
> IVSHMEM: guest pci addr = 80000000, guest h/w addr = 4312137728, size = 80000000
> pci_read_config: (val) 0x80000004<- 0x18 (addr)
> pci_write_config: (val) 0x1 ->  0x1c (addr)
> IVSHMEM: guest pci addr = 180000000, guest h/w addr = 4312137728, size
> = 80000000
> pci_read_config: (val) 0x1<- 0x1c (addr)
>
> Any pointers are appreciated,
>

Looks like the BAR was temporarily mapped @ 2GB which screwed up memory.

Try changing the write order to first write the top half of the BAR, 
then the lower half.

Strange that there is no enable bit in the BAR, so you can't move it 
atomically?  Maybe we need to clear PCI_CMD_MEMORY, play with the BAR, 
and reenable PCI_CMD_MEMORY.

-- 
error compiling committee.c: too many arguments to function

