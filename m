Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970Ab2IDMoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 08:44:24 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35539 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827Ab2IDMoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 08:44:22 -0400
Message-ID: <5045F7A0.1090400@gmail.com>
Date: Tue, 04 Sep 2012 07:44:16 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm-current
 tree
References: <20120904160626.f1dcb67ebbb145053c49da8c@canb.auug.org.au> <201209040808.25103.arnd@arndb.de> <20120904090132.GG24085@n2100.arm.linux.org.uk>
In-Reply-To: <20120904090132.GG24085@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2012 04:01 AM, Russell King - ARM Linux wrote:
> On Tue, Sep 04, 2012 at 08:08:24AM +0000, Arnd Bergmann wrote:
>> On Tuesday 04 September 2012, Stephen Rothwell wrote:
>>> Today's linux-next merge of the arm-soc tree got a conflict in
>>> arch/arm/mm/mmu.c between commit a849088aa155 ("ARM: Fix ioremap() of
>>> address zero") from the arm-current tree and commit c2794437091a ("ARM:
>>> Add fixed PCI i/o mapping") from the arm-soc tree.
>>>
>>> I am not sure how to fix this, so I have used the arm-current version of
>>> the change to pmd_empty_section_gap() since that changed the vm->flags.
>>> It may be that just changing the vm->flags value in vm_reserve_area_early()
>>> would be ok?
>>
>> If I read this correctly, we want pci_reserve_io to use VM_ARM_STATIC_MAPPING
>> while pmd_empty_section_gap should use VM_ARM_EMPTY_MAPPING, so we probably
>> want to add a flag argument to the vm_reserve_area_early() function.
> 
> Whereas Rob said to me that both can use VM_ARM_EMPTY_MAPPING when I
> queried this conflict last week.

Right. The PCI i/o reserved area has a dummy physical address of 0 and 
needs to be skipped by ioremap searches. So we don't set 
VM_ARM_STATIC_MAPPING to prevent matches by ioremap. The vm_struct settings
don't really matter when we do the real mapping of the i/o space.

Here's my merge:

diff --cc arch/arm/mm/mmu.c
index 4c2d045,c2fa21d,512b2c0..18144e6
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@@@ -785,6 -785,6 -786,19 +786,19 @@@@ void __init iotable_init(struct map_des
        }
   }
   
++ void __init vm_reserve_area_early(unsigned long addr, unsigned long size,
++                                void *caller)
++ {
++      struct vm_struct *vm;
++ 
++      vm = early_alloc_aligned(sizeof(*vm), __alignof__(*vm));
++      vm->addr = (void *)addr;
++      vm->size = size;
  -     vm->flags = VM_IOREMAP | VM_ARM_STATIC_MAPPING;
+++     vm->flags = VM_IOREMAP | VM_ARM_EMPTY_MAPPING;
++      vm->caller = caller;
++      vm_area_add_early(vm);
++ }
++ 
   #ifndef CONFIG_ARM_LPAE
   
   /*
