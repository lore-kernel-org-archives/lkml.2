Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab2DCIss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 04:48:48 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:57141 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab2DCIsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 04:48:45 -0400
X-IronPort-AV: E=Sophos;i="4.75,362,1330923600"; 
   d="scan'208";a="188773170"
Message-ID: <4F7AB96B.5030900@citrix.com>
Date: Tue, 3 Apr 2012 09:48:43 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 5/7] xen/setup: Transfer MFNs from non-RAM
 E820	entries and gaps to E820 RAM
References: <1333139850-28456-1-git-send-email-konrad.wilk@oracle.com> <1333139850-28456-6-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1333139850-28456-6-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/03/12 21:37, Konrad Rzeszutek Wilk wrote:
> We will now get:
> 
> -Released 283999 pages of unused memory
> +Exchanged 283999 pages
> .. snip..
> -Memory: 6487732k/9208688k available (5817k kernel code, 1136060k absent, 1584896k reserved, 2900k data, 692k init)
> +Memory: 6503888k/8072692k available (5817k kernel code, 1136060k absent, 432744k reserved, 2900k data, 692k init)

This isn't correct.  You've have lost ~1 GB of memory which are the
pages that were supposed to be moved.  The additional 1GB of reserved
memory in the old case is the balloon.

In xen_memory_setup() where it loops through the e820 to clip the RAM
regions you need to factor in the additional memory you've moved.  In
this loop you may need to count the pages in the RAM region instead of
the simple (addr < mem_end) test.  Take care with RAM regions with
partial pages and the like.

> which is more in line with classic XenOLinux.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/setup.c |   85 ++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 files changed, 82 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index 1ba8dff..2a12143 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -120,12 +120,89 @@ static unsigned long __init xen_release_chunk(unsigned long start,
>  	return len;
>  }
>  
> +static unsigned long __init xen_exchange_chunk(unsigned long start_pfn,
> +	unsigned long end_pfn, unsigned long nr_pages, unsigned long exchanged,
> +	unsigned long *pages_left, const struct e820entry *list,
> +	size_t map_size)
> +{
[...]
> +
> +		for (pfn = start_pfn; pfn < start_pfn + nr; pfn++) {
> +			unsigned long mfn = pfn_to_mfn(pfn);
> +
> +			if (mfn == INVALID_P2M_ENTRY || mfn_to_pfn(mfn) != pfn)
> +				break;
> +
> +			if (!early_set_phys_to_machine(dest_pfn, mfn))
> +				break;
> +
> +			/* You would think we should do HYPERVISOR_update_va_mapping
> +			 * but we don't need to as the hypervisor only sets up the
> +			 * initial pagetables up to nr_pages, and we stick the MFNs
> +			 * past that.
> +			 */

Hmmm. Are you sure this is safe?  What happens if Linux tries to use
these pages before creating new page tables?  e.g., via some early boot
allocator before the final page tables are setup? (This might not be a
problem, I haven't checked).

You've may have gotten away with it for now because the moved MFNs are
marked as unusable.

David
