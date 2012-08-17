Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab2HQKJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 06:09:06 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:46335 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab2HQKJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 06:09:04 -0400
X-IronPort-AV: E=Sophos;i="4.77,784,1336348800"; 
   d="scan'208";a="14056778"
Message-ID: <1345198122.30865.155.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH 4/6] xen/mmu: Fix compile warnings.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Date: Fri, 17 Aug 2012 11:08:42 +0100
In-Reply-To: <1345133558-23341-5-git-send-email-konrad.wilk@oracle.com>
References: <1345133558-23341-1-git-send-email-konrad.wilk@oracle.com>
	 <1345133558-23341-5-git-send-email-konrad.wilk@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-16 at 17:12 +0100, Konrad Rzeszutek Wilk wrote:
> linux/arch/x86/xen/mmu.c:1788:14: warning: comparison between pointer and integer [enabled by default]
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/mmu.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 90d31a2..4911354 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1786,11 +1786,11 @@ void __init xen_setup_machphys_mapping(void)
>  {
>  	struct xen_machphys_mapping mapping;
>  
> -	if (HYPERVISOR_memory_op(XENMEM_machphys_mapping, &mapping) == 0) {
> +	if (HYPERVISOR_memory_op(XENMEM_machphys_mapping, (void *)&mapping) == 0) {

This changes seems to be unnecessary and not related to the commit
message.

>  		machine_to_phys_mapping = (unsigned long *)mapping.v_start;
>  		machine_to_phys_nr = mapping.max_mfn + 1;
>  	} else {
> -		machine_to_phys_nr = MACH2PHYS_NR_ENTRIES;
> +		machine_to_phys_nr = (unsigned long)MACH2PHYS_NR_ENTRIES;

I must be missing something. Given:
        #define MACH2PHYS_VIRT_START  mk_unsigned_long(__MACH2PHYS_VIRT_START)
        #define MACH2PHYS_VIRT_END    mk_unsigned_long(__MACH2PHYS_VIRT_END)
        #define MACH2PHYS_NR_ENTRIES  ((MACH2PHYS_VIRT_END-MACH2PHYS_VIRT_START)>>__MACH2PHYS_SHIFT)
How is MACH2PHYS_NR_ENTRIES not already unsigned long? Or at the very
least how is it not an integer type of some sort, it certainly doesn't
look like it can be a pointer (as suggested by the commit message) to
me.


>  	}
>  #ifdef CONFIG_X86_32
>  	WARN_ON((machine_to_phys_mapping + (machine_to_phys_nr - 1))


