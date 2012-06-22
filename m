Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096Ab2FVAgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 20:36:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54419 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760764Ab2FVAgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 20:36:05 -0400
Message-ID: <4FE3BDD9.60105@zytor.com>
Date: Thu, 21 Jun 2012 17:35:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] phys_efi_set_virtual_address_map needs va, no pa.
References: <20120620082457.GE3464@sgi.com> <20120620120702.GA3983@srcf.ucam.org> <4FE23592.60201@linux.intel.com> <20120621002742.GL3464@sgi.com> <4FE26EF9.5060004@linux.intel.com> <20120621165220.GQ3464@sgi.com>
In-Reply-To: <20120621165220.GQ3464@sgi.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 09:52 AM, Robin Holt wrote:
> 
> I am completely lost as to what should be done.  How do we know
> which identity maps need to be created?  Do we just add them as we are
> scanning the e820/EFI memory maps and include the reserved, etc ranges?
> Do we look at the table handed to us by EFI at the beginning of boot and
> use that as the basis?  Or do we simply wait until the kernel's memory
> initialization is complete and cover all of physical memory from zero
> up to the highest physical address?
> 

Robin, we already create the 1:1 maps.  Right now there is some
weirdness with some of the issues that you mention, but that is
orthogonal to this.

The 1:1 map created for the kernel is created at a specific offset,
__PAGE_OFFSET, and is propagated into every vm context created by the
kernel.  There are two problems:

1. The "initial" (32 bit) or "trampoline" (64 bit) maps aren't on the
list of vm contexts created by the kernel (pgd_list), so they never get
updated after a particular point in the boot.

2. The initial/trampoline maps need these mappings not just at address
__PAGE_OFFSET, but also at address zero (identity mapping), which means
that just adding it to the pgd_list is insufficient.

Note that i386-PAE is unaffected, simply because the contents of the top
(3rd) level is always fixed.

	-hpa

