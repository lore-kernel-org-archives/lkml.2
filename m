Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab0IQUx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 16:53:27 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45861 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab0IQUx0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 16:53:26 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTiny67-sKAwn3ipHBDEMx9NJujznNOjAeyZZXj_j@mail.gmail.com>
References: <AANLkTinORYZOYk9xsST+J=zxgeZPr2BNw3S=dvPPTcdn@mail.gmail.com>
	<20100917200428.GD19949@x200.localdomain>
	<AANLkTiny67-sKAwn3ipHBDEMx9NJujznNOjAeyZZXj_j@mail.gmail.com>
Date: Fri, 17 Sep 2010 14:53:25 -0600
X-Google-Sender-Auth: qWKWVAOWyFtlqk0HfXqFLlPGP5s
Message-ID: <AANLkTim0dCDGeC+sLFLSH1Ezb=2UHP6dn=EPBhxBQ4-P@mail.gmail.com>
Subject: Re: [Qemu-devel] Re: ACPI error when mapping a 2GB BAR w/ 4GB of RAM
From: Cam Macdonell <cam@cs.ualberta.ca>
To: Chris Wright <chrisw@redhat.com>
Cc: "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 2:52 PM, Cam Macdonell <cam@cs.ualberta.ca> wrote:
> On Fri, Sep 17, 2010 at 2:04 PM, Chris Wright <chrisw@redhat.com> wrote:
>> * Cam Macdonell (cam@cs.ualberta.ca) wrote:
>>> After fixing the resource_size_t return value with
>>> pci_resource_alignment, I see one other strange behaviour only when
>>> using 4GB of RAM and a 2GB BAR.  I haven't found any other combination
>>> of RAM/BAR size that triggers this bug.  I am using 2.6.36-rc3.
>>>
>>> ACPI Error: The DSDT has been corrupted or replaced - old, new headers
>>> below (20100702/tbutils-372)
>>> ACPI: DSDT (null) 01F15 (v01   BXPC   BXDSDT 00000001 INTL 20090123)
>>> ACPI:      (null) 00000 (v00                 00000000      00000000)
>>> ACPI Error: Please send DMI info to linux-acpi@vger.kernel.org
>>> If system does not work as expected, please boot with acpi=copy_dsdt
>>> (20100702/tbutils-378)
>>> ACPI: PCI Interrupt Link [LNKC] disabled and referenced, BIOS bug
>>> ACPI Exception: AE_AML_INVALID_RESOURCE_TYPE, Evaluating _CRS
>>> (20100702/pci_link-283)
>>> ACPI: Unable to set IRQ for PCI Interrupt Link [LNKC]. Try pci=noacpi
>>> or acpi=off
>>> virtio-pci 0000:00:03.0: PCI INT A: no GSI - using ISA IRQ 11
>>> Non-volatile memory driver v1.3
>>> Linux agpgart interface v0.103
>>> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
>>
>> IIRC,  the pci hole is only 1.5G in the BIOS, can you verify that
>> seabios is doing the right thing?
>
> I'm not sure what the right thing for seabios to do is.  Here is the
> seabios output related to the device.
>
> PCI: bus=0 devfn=0x20: vendor_id=0x1af4 device_id=0x1110
> region 0: 0xf2040000
> init smm
> init boot device ordering
>
> <snip>
>
> Attempting to init PCI bdf 00:04.0 (vd 1af4:1110)
> Attempting to map option rom on dev 00:04.0
> Option rom sizing returned 0 0
> Checking rom 0x000c9800 (sig aa55 size 17)
> Checking rom 0x000cc000 (sig aa55 size 2)
> Checking rom 0x000c9000 (sig aa55 size 4)
> Checking rom 0x000c9800 (sig aa55 size 17)
> Checking rom 0x000cc000 (sig aa55 size 2)
> Mapping hd drive 0x000fdb50 to 0
> Running option rom at c980:0003
> Running option rom at cc00:0003
> pmm_malloc zone=0x000f515c handle=ffffffff size=36 align=10
> ret=0x000fdaf0 (detail=0x7ffefca0)
> ebda moved from 9fc00 to 9f400
> pmm_malloc zone=0x000f5154 handle=ffffffff size=2048 align=10
> ret=0x0009f800 (detail=0x7ffefb40)
> finalize PMM
> malloc finalize
>
> when using a BAR of 2GB or less, there is an additional write to the
> PCI space of the device, which may be from the bios
>
> pci_write_config: (val) 0xffffffff -> 0x18 (addr)
> pci_read_config: (val) 0x80000004 <- 0x18 (addr)
> pci_write_config: (val) 0x4 -> 0x18 (addr)
> pci_write_config: (val) 0x3 -> 0x4 (addr)
> pci_read_config: (val) 0x0 <- 0x1c (addr)
> pci_write_config: (val) 0xffffffff -> 0x1c (addr)
> IVSHMEM: guest pci addr = ffffffff00000000, guest h/w addr =
> 4312137728, size = 80000000
>
> so is it succeeding with smaller sizes (> 2GB) because it fits in the
> bios' pci hole?

sorry that should be "< 2GB".

>
> Cam
>
>>
>> thanks,
>> -chris
>>
>>
>
