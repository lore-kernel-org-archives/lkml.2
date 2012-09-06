Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab2IFOdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:33:45 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:53857 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423Ab2IFOdn convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:2>);
	Thu, 6 Sep 2012 10:33:43 -0400
Message-Id: <5048D09A020000780009965B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 06 Sep 2012 15:34:34 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matt Fleming" <matt@console-pimps.org>
Cc: "Vasco Dias" <rafa.vasco@gmail.com>,
        "Matt Fleming" <matt.fleming@intel.com>,
        "Matthew Garrett" <mjg@redhat.com>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <cJ-ko@zougloub.eu>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86, efi: 1:1 pagetable mapping for virtual EFI
 calls
References: <1346937309-1581-1-git-send-email-matt@console-pimps.org>
In-Reply-To: <1346937309-1581-1-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.09.12 at 15:15, Matt Fleming <matt@console-pimps.org> wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> Some firmware still needs a 1:1 (virt->phys) mapping even after we've
> called SetVirtualAddressMap(). So install the mapping alongside our
> existing kernel mapping whenever we make EFI calls in virtual mode.
> 
> This bug was discovered on ASUS machines where the firmware
> implementation of GetTime() accesses the RTC device via physical
> addresses, even though that's bogus per the UEFI spec since we've
> informed the firmware via SetVirtualAddressMap() that the boottime
> memory map is no longer valid.

> @@ -741,6 +742,114 @@ static void __init runtime_code_page_mkexec(void)
>  	}
>  }
>  
> +#ifdef CONFIG_X86_64
> +pgd_t *efi_one_to_one_pgd;
> +int efi_one_to_one_index = 0;

I wasn't able to spot where this variable ever gets set to a
non-zero value.

> @@ -58,6 +62,47 @@ static void __init early_code_mapping_set_exec(int 
> executable)
>  	}
>  }
>  
> +pgd_t *efi_call_virt_prelog(void)
> +{
> +	pgd_t *save;
> +	int i;
> +
> +	save = kmalloc(sizeof(pgd_t) * (efi_one_to_one_index + 1), GFP_KERNEL);

GFP_ATOMIC perhaps, given that many runtime calls happen
inside spin locks?

> +	if (!save) {
> +		pr_alert("Unable to save pgd entries\n");
> +		return NULL;
> +	}
> +
> +	for (i = 0; i <= efi_one_to_one_index; i++) {
> +		pgd_t *pgd = __va(read_cr3() & PHYSICAL_PAGE_MASK);

I'd suggest moving this out of the loop (also below), slightly
adjusting the rest of the loop body.

> +
> +		pgd += i;
> +		save[i] = *pgd;
> +		set_pgd(pgd, efi_one_to_one_pgd[i]);
> +	}

Did you, as an alternative, consider switching to a different
CR3 instead of copying back and forth?

> +
> +	__flush_tlb_all();

Is it certain you will _never_ hit a global mapping (in which case I
believe the above would be insufficient)?

Jan

> +	return save;
> +}
> +
> +void efi_call_virt_epilog(pgd_t *save)
> +{
> +	int i;
> +
> +	if (!save)
> +		return;
> +
> +	for (i = 0; i <= efi_one_to_one_index; i++) {
> +		pgd_t *pgd = __va(read_cr3() & PHYSICAL_PAGE_MASK);
> +
> +		pgd += i;
> +		set_pgd(pgd, save[i]);
> +	}
> +
> +	kfree(save);
> +	__flush_tlb_all();
> +}
> +
>  void __init efi_call_phys_prelog(void)
>  {
>  	unsigned long vaddress;
> -- 
> 1.7.4.4



