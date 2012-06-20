Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab2FTUmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 16:42:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:33205 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab2FTUmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 16:42:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="156184518"
Message-ID: <4FE23592.60201@linux.intel.com>
Date: Wed, 20 Jun 2012 13:41:54 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org,
        "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>
Subject: Re: [PATCH] phys_efi_set_virtual_address_map needs va, no pa.
References: <20120620082457.GE3464@sgi.com> <20120620120702.GA3983@srcf.ucam.org>
In-Reply-To: <20120620120702.GA3983@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 05:07 AM, Matthew Garrett wrote:
> 
> No, that's completely wrong. UEFI can't be called in virtual mode until 
> *after* SetVirtualAddressMap(). The UEFI spec indicates that all 
> physical memory must have an identity mapping at this stage (section 
> 2.3.4), so if we don't then that's a bug that needs to be fixed.
> 

I think it is a bug, and with the trampoline work in 3.4 we should
finally have a proper platform to fix it.

In particular, we should keep a full 1:1 page map around, and it should
be the one that is in the trampoline (real_mode_header->trampoline_pgd)
as we need the page directory to be 32-bit addressable.

The right thing to do is to sync the pgds in the 1:1 area, both for 64
bit and for legacy 32 bit (PAE 32 bit don't need it, since all the
kernel maps are shared.)  This is currently done ad hoc (and
differently!) on both 32 and 64 bits and that really should be fixed.

Once that is properly fixed, we have a usable identity mapping.

On that subject, I have been thinking about the kexec use case.  I'm
thinking that if we indeed cannot use either physical mode nor a
zero-offset virtual mode, that the most likely sane thing to do is to
use a fixed offset of 2^46 and still use a (pseudo-)1:1 map.

Do we have any data at all on machines that supposedly can't use
identity-mapped EFI?

	-hpa
