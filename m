Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760Ab2EWSks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 14:40:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57038 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046Ab2EWSkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 14:40:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXx_x9M5ncLk4DyL8heYQTcsHZt2JofFMjPfUd4mympeA@mail.gmail.com>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
	<1337754877-19759-3-git-send-email-yinghai@kernel.org>
	<CA+55aFzd1BWqidt95qZLc1x_YU=WeGS=mKUOMvO_3omOhc_5VA@mail.gmail.com>
	<CAE9FiQXx_x9M5ncLk4DyL8heYQTcsHZt2JofFMjPfUd4mympeA@mail.gmail.com>
Date: Wed, 23 May 2012 11:40:46 -0700
X-Google-Sender-Auth: YNaPIbN-6NWegaEFDD4CEzFZK1o
Message-ID: <CAE9FiQX=ECg5BmKm7B2ua_rZ6bOsceeHNsfFQRWBbNZx+8sBfw@mail.gmail.com>
Subject: Re: [PATCH 02/11] PCI: Try to allocate mem64 above 4G at first
From: Yinghai Lu <yinghai@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Newbury <steve@snewbury.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 10:30 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Wed, May 23, 2012 at 8:57 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Tue, May 22, 2012 at 11:34 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> and will fall back to below 4g if it can not find any above 4g.
>>
>> Has this been tested on 32-bit machines without PAE? There might be
>> things that just happen to work because their allocations were always
>> done bottom-up.
>
> Good point. that problem should be addressed at first before this patch.

Just checked code for 32bit machines without PAE.

when X86_PAE is not set, phys_addr_t aka resource_size_t will be 32bit.
so in drivers/pci/bus.c::pci_bus_alloc_resource_fit()
will have bottom to 0.
    resource_size_t bottom = PCIBIOS_MAX_MEM_32 + 1ULL;
also in arch/x86/kernel/setup.c::setup_arch()
   iomem_resource.end = (1ULL << boot_cpu_data.x86_phys_bits) - 1;
will have iomem_resource.end to 0xffffffff

when X86_PAE is set, but CPU does not support PAE.
phys_addr_t aka resource_size_t will be 32bit.
so in drivers/pci/bus.c::pci_bus_alloc_resource_fit()
will have bottom to 4g.
    resource_size_t bottom = PCIBIOS_MAX_MEM_32 + 1ULL;
but
in arch/x86/kernel/setup.c::setup_arch()
   iomem_resource.end = (1ULL << boot_cpu_data.x86_phys_bits) - 1;
will have iomem_resource.end to 0xffffffff, because x86_phys_bits is 32 when PAE
is not detected in arch/x86/kernel/cpu/common.c::get_cpu_cap.
that mean first try will fail, so it will go to second try with bottom to 0.

so both case are safe with this patch.

Thanks

Yinghai
