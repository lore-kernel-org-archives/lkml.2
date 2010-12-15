Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab0LOXnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 18:43:01 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:42207 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781Ab0LOXm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 18:42:59 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, horms@verge.net.au,
        nhorman@tuxdriver.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, vgoyal@redhat.com
References: <F7CB3D97D99F33indou.takao@jp.fujitsu.com>
	<4D06E7FE.5000600@jp.fujitsu.com>
	<ACB9BDFABD971indou.takao@jp.fujitsu.com>
Date: Wed, 15 Dec 2010 15:42:44 -0800
In-Reply-To: <ACB9BDFABD971indou.takao@jp.fujitsu.com> (Takao Indoh's message
	of "Tue, 14 Dec 2010 17:38:47 -0500")
Message-ID: <m1d3p2vc0b.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18AtvWiueZeGJmAsYfcNg7fOU6AXwy7LpQ=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Takao Indoh <indou.takao@jp.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2][EFI] Run EFI in physical mode
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takao Indoh <indou.takao@jp.fujitsu.com> writes:

> On Tue, 14 Dec 2010 12:43:58 +0900, Kenji Kaneshige wrote:
>
>>Hi,
>>
>>I tested this patch on the system that has large amount of memory (1TB),
>>and I encountered the immediate system reset problem that happens every
>>time I modify the EFI boot entry using efibootmgr command. It seems that
>>triple fault happens due to the incorrect page table setup.
>>
>>> +void __init efi_pagetable_init(void)
>>> +{
>>(snip.)
>>> +	pgd = efi_pgd + pgd_index(PAGE_OFFSET);
>>> +	set_pgd(pgd, *pgd_offset_k(PAGE_OFFSET));
>>> +	pgd = efi_pgd + pgd_index(__START_KERNEL_map);
>>> +	set_pgd(pgd, *pgd_offset_k(__START_KERNEL_map));
>>> +}
>>
>>Maybe we need to map whole kernel address space. The problem doesn't
>>happen by modifying as follows.
>>
>>	clone_pgd_range(efi_pgd + KERNEL_PGD_BOUNDARY,
>>			swapper_pg_dir + KERNEL_PGD_BOUNDARY, 
>>KERNEL_PGD_PTRS);
>
>
> Besides this bug, I'm thinking that we need global TLB flush after
> restoring cr3 because EFI code page is mapped with PAGE_KERNEL_EXEC.
>
>  void efi_call_phys_epilog_in_physmode(void)
>  {
>  	write_cr3(get_cpu_var(save_cr3));
> +	if (cpu_has_pge)
> +		__flush_tlb_global();
>  	local_irq_restore(get_cpu_var(efi_flags));
>  }
>
> Somethinkg like this. Anybody comments?

If only one cpu runs efi we shouldn't need a global flush.
I presume you aren't modifying the kernel's global page table?

If we are giving the entire machine to efi then yes we would need
to set cr3 on all machines.

Eric
