Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758567Ab2IFPsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:48:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:50536 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758524Ab2IFPsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:48:24 -0400
Subject: Re: [PATCH] x86, efi: 1:1 pagetable mapping for virtual EFI calls
From: Matt Fleming <matt.fleming@intel.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Vasco Dias <rafa.vasco@gmail.com>, Matthew Garrett <mjg@redhat.com>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        cJ-ko@zougloub.eu, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <5048D09A020000780009965B@nat28.tlf.novell.com>
References: <1346937309-1581-1-git-send-email-matt@console-pimps.org>
	 <5048D09A020000780009965B@nat28.tlf.novell.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Thu, 06 Sep 2012 16:47:45 +0100
Message-ID: <1346946465.4244.107.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-06 at 15:34 +0100, Jan Beulich wrote:
> >>> On 06.09.12 at 15:15, Matt Fleming <matt@console-pimps.org> wrote:
> > From: Matt Fleming <matt.fleming@intel.com>
> > 
> > Some firmware still needs a 1:1 (virt->phys) mapping even after we've
> > called SetVirtualAddressMap(). So install the mapping alongside our
> > existing kernel mapping whenever we make EFI calls in virtual mode.
> > 
> > This bug was discovered on ASUS machines where the firmware
> > implementation of GetTime() accesses the RTC device via physical
> > addresses, even though that's bogus per the UEFI spec since we've
> > informed the firmware via SetVirtualAddressMap() that the boottime
> > memory map is no longer valid.
> 
> > @@ -741,6 +742,114 @@ static void __init runtime_code_page_mkexec(void)
> >  	}
> >  }
> >  
> > +#ifdef CONFIG_X86_64
> > +pgd_t *efi_one_to_one_pgd;
> > +int efi_one_to_one_index = 0;
> 
> I wasn't able to spot where this variable ever gets set to a
> non-zero value.

Oops. Yeah, you're right. It seems I lost that code at some point in
development. I'll re-add in a v2 of this patch.

> > @@ -58,6 +62,47 @@ static void __init early_code_mapping_set_exec(int 
> > executable)
> >  	}
> >  }
> >  
> > +pgd_t *efi_call_virt_prelog(void)
> > +{
> > +	pgd_t *save;
> > +	int i;
> > +
> > +	save = kmalloc(sizeof(pgd_t) * (efi_one_to_one_index + 1), GFP_KERNEL);
> 
> GFP_ATOMIC perhaps, given that many runtime calls happen
> inside spin locks?

Yeah, good idea.

> > +	if (!save) {
> > +		pr_alert("Unable to save pgd entries\n");
> > +		return NULL;
> > +	}
> > +
> > +	for (i = 0; i <= efi_one_to_one_index; i++) {
> > +		pgd_t *pgd = __va(read_cr3() & PHYSICAL_PAGE_MASK);
> 
> I'd suggest moving this out of the loop (also below), slightly
> adjusting the rest of the loop body.

Sure.

> > +
> > +		pgd += i;
> > +		save[i] = *pgd;
> > +		set_pgd(pgd, efi_one_to_one_pgd[i]);
> > +	}
> 
> Did you, as an alternative, consider switching to a different
> CR3 instead of copying back and forth?

I did consider it, but I couldn't convince myself whether or not the EFI
pagetable would need to be manually kept in sync with any other
pagetables. But now I look at the code a bit harder, it seems that
should be taken care of automatically. In fact, the tboot code seems to
do something similar. I'll try that approach.

> > +
> > +	__flush_tlb_all();
> 
> Is it certain you will _never_ hit a global mapping (in which case I
> believe the above would be insufficient)?

Are you saying that this should be a flush_tlb_all() if we have global
mappings? Or that if we are guaranteed to never have global mappings we
can opitmise this by simply doing a __flush_tlb()?

Thanks Jan!

