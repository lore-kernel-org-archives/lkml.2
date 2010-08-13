Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab0HMW3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 18:29:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48990 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055Ab0HMW3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 18:29:33 -0400
Message-ID: <4C65C715.5030201@zytor.com>
Date: Fri, 13 Aug 2010 15:28:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Takao Indoh <indou.takao@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, tglx@linutronix.de, mingo@redhat.com,
        vgoyal@redhat.com, nhorman@tuxdriver.com
Subject: Re: [PATCH][EFI] Run EFI in physical mode
References: <F0CB3B1C601247indou.takao@jp.fujitsu.com>
In-Reply-To: <F0CB3B1C601247indou.takao@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2010 12:18 PM, Takao Indoh wrote:
> Hi all,
> 
> The attached patch enables EFI to run in physical mode.
> 
> Basically EFI is in physical mode at first and it's switched to virtual
> mode after calling SetVirtualAddressMap. By applying this patch, you can
> run EFI always in physical mode. And you can also specify "virtefi" as
> kernel boot parameter to run EFI in virtual mode as before. Note that
> this patch supports only x86_64.
> 
> This is needed to run kexec/kdump in EFI-booted system. The following is
> an original discussion. In this thread, I explained that kdump does not
> work because EFI system table is modified by SetVirtualAddressMap. And
> the idea to run EFI in physical mode was proposed. This patch implements
> it.
> 
> http://marc.info/?l=linux-kernel&m=128018221820234&w=2
>> When the 1st kernel boots, EFI system table(efi_system_table_t) is
>> modified by SetVirtualAddressMap, which is one of EFI runtime service.
>> This runtime changes physical address in EFI system table to virtual
>> address.
>>
>> When the 2nd kernel boots, it also receives the same EFI system table,
>> and the address included in it is already virtual address(1st kernel
>> rewrote it).  But 2nd kernel does not know that, 2nd kernel thinks it is
>> a physical address. This causes problems.
> 
> Basic idea of this patch is to create EFI own pagetable. This pagetable
> maps physical address of EFI runtime to the virtual address which is the
> same value so that we can call it directly. For example, physical 
> address 0x800000 is mapped to virtual address 0x800000. Before calling
> EFI runtime, cr3 register is switched to this pagetable, and restored
> when we come back from EFI.
> 
> Any comments would be appreciated.
> 

Another aspect of this... this plays well into the already-outstanding
proposal to keep an identity-mapped set of page tables around at all
times.  Right now we do it ad hoc for 64 bits and not really for 32
bits, but that is being changed, see the thread starting at:

http://marc.info/?i=1280940316-7966-1-git-send-email-bp@amd64.org

This would definitely be better than keeping yet another private page table.

	-hpa
