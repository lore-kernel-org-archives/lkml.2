Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294Ab1FWMjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 08:39:49 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:12820
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756339Ab1FWMjs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 08:39:48 -0400
X-SpamScore: -6
X-BigFish: VPS-6(zz1432Nzz1202hzz8275bhz2fh2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:80.242.17.33;KIP:(null);UIP:(null);IPVD:NLI;H:JKLMAIL02.ixonos.local;RD:po02.ixonos.com;EFVD:NLI
From: =?iso-8859-1?Q?Penttil=E4_Mika?= <mika.penttila@ixonos.com>
To: "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: do not assume head_64.S used 4KB pages when
 !use_pse
Thread-Topic: Re: [PATCH] x86_64: do not assume head_64.S used 4KB pages
 when !use_pse
Thread-Index: AcwxooNbw6hL5g5qQn2fMGfFtIoRyQ==
Date: Thu, 23 Jun 2011 12:38:54 +0000
Message-ID: <1A61D8EA6755AF458F06EA669A4EC8182F05B07E@JKLMAIL02.ixonos.local>
Accept-Language: en-US, fi-FI
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.200.5.70]
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: ixonos.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

> head_64.S, which sets up the initial page table on x86_64, is not aware
> of PSE being enabled or disabled and it always allocates the initial
> mapping using 2MB pages.

> Therefore on x86_64 find_early_table_space shouldn't update the amount
> of pages needed for pte pages depending on the size of the initial
> mapping, because we know for sure that no pte pages have been allocated
> yet.

> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Reported-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/mm/init.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)

> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index 36bacfe..1e3098b 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -42,12 +42,19 @@ static void __init find_early_table_space(unsigned long start,
>  			(PMD_SIZE * PTRS_PER_PMD));
>  	pmd_mapped *= (PMD_SIZE * PTRS_PER_PMD);
>  
> +	/* 
> +	 * On x86_64 do not limit the size we need to cover with 4KB pages
> +	 * depending on the initial allocation because head_64.S always uses
> +	 * 2MB pages.
> +	 */
> +#ifdef CONFIG_X86_32
>  	if (start < PFN_PHYS(max_pfn_mapped)) {
> 		if (PFN_PHYS(max_pfn_mapped) < end)
>  			size -= PFN_PHYS(max_pfn_mapped) - start;
>  		else
>  			size = 0;
>  	}
> +#endif

And arch/x86/mm/init.c also has: 
 
#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
        /*
         * For CONFIG_DEBUG_PAGEALLOC, identity mapping will use small pages.
         * This will simplify cpa(), which otherwise needs to support splitting
         * large pages into small in interrupt context, etc.
         */
        use_pse = use_gbpages = 0;
#else
        use_pse = cpu_has_pse;
        use_gbpages = direct_gbpages;
#endif


So big pages are also not used for DEBUG_PAGEALLOC and KMEMCHECK configs even if head_32.S did.

--Mika





