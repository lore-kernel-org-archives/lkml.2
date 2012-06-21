Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759892Ab2FUQwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 12:52:23 -0400
Received: from relay3.sgi.com ([192.48.152.1]:51302 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759870Ab2FUQwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 12:52:21 -0400
Date: Thu, 21 Jun 2012 11:52:20 -0500
From: Robin Holt <holt@sgi.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Robin Holt <holt@sgi.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        linux-kernel@vger.kernel.org,
        "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] phys_efi_set_virtual_address_map needs va, no pa.
Message-ID: <20120621165220.GQ3464@sgi.com>
References: <20120620082457.GE3464@sgi.com>
 <20120620120702.GA3983@srcf.ucam.org>
 <4FE23592.60201@linux.intel.com>
 <20120621002742.GL3464@sgi.com>
 <4FE26EF9.5060004@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE26EF9.5060004@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
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

I am completely lost as to what should be done.  How do we know
which identity maps need to be created?  Do we just add them as we are
scanning the e820/EFI memory maps and include the reserved, etc ranges?
Do we look at the table handed to us by EFI at the beginning of boot and
use that as the basis?  Or do we simply wait until the kernel's memory
initialization is complete and cover all of physical memory from zero
up to the highest physical address?

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
> 
> It is also a bit "cute" how we seem to make a function call to indirect
> through a pointer (why on Earth is pgd_page_get_mm() not an inline?!),
> and then grab a lock unconditionally, regardless of if we are affected
> by Xen or not.
> 
> 	-hpa
