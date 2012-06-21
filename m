Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760111Ab2FUTXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 15:23:52 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20177 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759961Ab2FUTXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 15:23:51 -0400
Date: Thu, 21 Jun 2012 15:16:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Robin Holt <holt@sgi.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-kernel@vger.kernel.org,
        "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>
Subject: Re: [PATCH] phys_efi_set_virtual_address_map needs va, no pa.
Message-ID: <20120621191606.GA6885@phenom.dumpdata.com>
References: <20120620082457.GE3464@sgi.com>
 <20120620120702.GA3983@srcf.ucam.org>
 <4FE23592.60201@linux.intel.com>
 <20120621002742.GL3464@sgi.com>
 <4FE26EF9.5060004@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE26EF9.5060004@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 05:46:49PM -0700, H. Peter Anvin wrote:
> On 06/20/2012 05:27 PM, Robin Holt wrote:
> > 
> > What do you need from me?  If you want me to help with this, I have a
> > _WHOLE_ lot of learning to do.  Can you give me any pointers?
> > 
> > We are trying to get this finally fixed.  We have had work-around code
> > in SLES11 SP1, SLES11 SP2, and RHEL 6.x.  I would love to get this fixed
> > for future distro snaps.
> > 
> 
> If you want to tackle it, the task is basically that when we modify the
> pgds in 32-bit legacy (non-PAE) mode, we should make the corresponding
> modifications to initial_page_table, and in 64-bit mode to
> real_mode_header->trampoline_pgd.  It might be worthwhile to introduce a
> common pointer for both, obviously.
> 
> This is currently handled via something called the pgd_list (when we
> update the top level kernel address space we walk pgd_list and update
> them all), but there are two issues:
> 
> 1. Obviously, in the case of the 1:1 map, we don't just need to maintain
> the kernel area, but the "user space" part of the address space should
> contain a copy, as well.
> 
> 2. To complicate things, there is code in there to grab an mm lock for
> the benefit of Xen.  The 1:1 map doesn't have an mm associated with it,
> so I'm not quite sure how that is to be handled.  Perhaps Xen just plain
> won't need it and we can just bypass it, but I have no bloody idea.

You mean this?

79e53d8        (Andrea Arcangeli       2011-02-16 15:45:22 -0800       127)    spin_lock(&pgd_lock);
4f76cd38        (Jeremy Fitzhardinge    2008-03-17 16:36:55 -0700       128)    pgd_list_del(pgd);
a79e53d8        (Andrea Arcangeli       2011-02-16 15:45:22 -0800       129)    spin_unlock(&pgd_lock);

which says:
    x86/mm: Fix pgd_lock deadlock
    
    It's forbidden to take the page_table_lock with the irq disabled
    or if there's contention the IPIs (for tlb flushes) sent with
    the page_table_lock held will never run leading to a deadlock.
    
    Nobody takes the pgd_lock from irq context so the _irqsave can be
    removed.
    
Looking before that git commit I see Jeremy's 4f76cd38 unification of
the 32-bit and 64-bit pgtable, and before that:

1da177e4c3f41524e886b7f1b8a0c1fc7321cac2
Linux-2.6.12-rc2

I am not really convienced that lock was put there for Xen as the
git history seems to point to well, way ancient stuff.

Or are you referring to something else?

> 
> It is also a bit "cute" how we seem to make a function call to indirect
> through a pointer (why on Earth is pgd_page_get_mm() not an inline?!),
> and then grab a lock unconditionally, regardless of if we are affected
> by Xen or not.
> 
> 	-hpa
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
