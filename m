Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab0HPTbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 15:31:12 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35993 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab0HPTbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 15:31:11 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
From: Takao Indoh <indou.takao@jp.fujitsu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, vgoyal@redhat.com,
        nhorman@tuxdriver.com
Subject: Re: [PATCH][EFI] Run EFI in physical mode
Date: Mon, 16 Aug 2010 15:30:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Mailer: HidemaruMail 5.38 (WinNT,501)
In-Reply-To: <m1iq3ep33n.fsf@fess.ebiederm.org>
References: <F0CB3B1C601247indou.takao@jp.fujitsu.com> <m1iq3ep33n.fsf@fess.ebiederm.org>
Message-Id: <F4CB3D796CF475indou.takao@jp.fujitsu.com>
X-Antivirus: avast! (VPS 100816-1, 2010/08/16), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Aug 2010 15:19:56 -0700, "Eric W. Biederman" wrote:

>Takao Indoh <indou.takao@jp.fujitsu.com> writes:
>
>> Hi all,
>>
>> The attached patch enables EFI to run in physical mode.
>>
>> Basically EFI is in physical mode at first and it's switched to virtual
>> mode after calling SetVirtualAddressMap. By applying this patch, you can
>> run EFI always in physical mode. And you can also specify "virtefi" as
>> kernel boot parameter to run EFI in virtual mode as before. Note that
>> this patch supports only x86_64.
>>
>> This is needed to run kexec/kdump in EFI-booted system. The following is
>> an original discussion. In this thread, I explained that kdump does not
>> work because EFI system table is modified by SetVirtualAddressMap. And
>> the idea to run EFI in physical mode was proposed. This patch implements
>> it.
>>
>> http://marc.info/?l=linux-kernel&m=128018221820234&w=2
>>> When the 1st kernel boots, EFI system table(efi_system_table_t) is
>>> modified by SetVirtualAddressMap, which is one of EFI runtime service.
>>> This runtime changes physical address in EFI system table to virtual
>>> address.
>>> 
>>> When the 2nd kernel boots, it also receives the same EFI system table,
>>> and the address included in it is already virtual address(1st kernel
>>> rewrote it).  But 2nd kernel does not know that, 2nd kernel thinks it is
>>> a physical address. This causes problems.
>>
>> Basic idea of this patch is to create EFI own pagetable. This pagetable
>> maps physical address of EFI runtime to the virtual address which is the
>> same value so that we can call it directly. For example, physical 
>> address 0x800000 is mapped to virtual address 0x800000. Before calling
>> EFI runtime, cr3 register is switched to this pagetable, and restored
>> when we come back from EFI.
>>
>> Any comments would be appreciated.
>>
>> Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
>
>Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
>There is what appears to be unneeded redundancy (we need two
>implementations of physciall calls into efi?), but that is confined to
>the weird efi state.
>
>It is a shame you haven't done the little bit extra to get
>efi_pagetable_init working on x86_32.

Unfortunately I don't have a machine to test. The machine I'm using does 
not support EFI on x86_32:-( I'd appreciate it if anyone try it...

Thanks,
Takao Indoh

>
>Overall this seems sane and confined to the x86 efi, and it looks
>like further improvements could easily be layered on top of this one.
>
>Eric
