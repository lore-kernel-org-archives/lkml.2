Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab2FUAqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 20:46:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:50516 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab2FUAqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 20:46:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="160302694"
Message-ID: <4FE26EF9.5060004@linux.intel.com>
Date: Wed, 20 Jun 2012 17:46:49 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] phys_efi_set_virtual_address_map needs va, no pa.
References: <20120620082457.GE3464@sgi.com> <20120620120702.GA3983@srcf.ucam.org> <4FE23592.60201@linux.intel.com> <20120621002742.GL3464@sgi.com>
In-Reply-To: <20120621002742.GL3464@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2012 05:27 PM, Robin Holt wrote:
> 
> What do you need from me?  If you want me to help with this, I have a
> _WHOLE_ lot of learning to do.  Can you give me any pointers?
> 
> We are trying to get this finally fixed.  We have had work-around code
> in SLES11 SP1, SLES11 SP2, and RHEL 6.x.  I would love to get this fixed
> for future distro snaps.
> 

If you want to tackle it, the task is basically that when we modify the
pgds in 32-bit legacy (non-PAE) mode, we should make the corresponding
modifications to initial_page_table, and in 64-bit mode to
real_mode_header->trampoline_pgd.  It might be worthwhile to introduce a
common pointer for both, obviously.

This is currently handled via something called the pgd_list (when we
update the top level kernel address space we walk pgd_list and update
them all), but there are two issues:

1. Obviously, in the case of the 1:1 map, we don't just need to maintain
the kernel area, but the "user space" part of the address space should
contain a copy, as well.

2. To complicate things, there is code in there to grab an mm lock for
the benefit of Xen.  The 1:1 map doesn't have an mm associated with it,
so I'm not quite sure how that is to be handled.  Perhaps Xen just plain
won't need it and we can just bypass it, but I have no bloody idea.

It is also a bit "cute" how we seem to make a function call to indirect
through a pointer (why on Earth is pgd_page_get_mm() not an inline?!),
and then grab a lock unconditionally, regardless of if we are affected
by Xen or not.

	-hpa
