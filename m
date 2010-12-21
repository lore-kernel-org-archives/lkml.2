Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab0LUWl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 17:41:26 -0500
Received: from claw.goop.org ([74.207.240.146]:33674 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab0LUWlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 17:41:25 -0500
Message-ID: <4D112D13.8010208@goop.org>
Date: Tue, 21 Dec 2010 14:41:23 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, hpa@zytor.com,
        Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH 02/10] xen/p2m: change p2m_missing_* to p2m_identity_*
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com> <1292967460-15709-3-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1292967460-15709-3-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2010 01:37 PM, Konrad Rzeszutek Wilk wrote:
> From: Konrad Rzeszutek Wilk <konrad@kernel.org>
>
> We are going to alter how we think about P2M. Most of the
> P2M contains MFN, and areas that are not populated are
> considered to be "missing". Missing means that the PFN
> is either not set for this guest (not have that much memory
> allocated) or is under the balloon driver ownership.
>
> We are instead now going to think of those not populated
> areas as "identity." Meaning that that the PFN for which
> we would get the p2m_identity we will provide the the PFN
> value back instead of P2M_MISSING. Essentially treating
> those regions as PFN==MFN.
>

This renames missing -> identity, but does it actually change the
functionality?  Doesn't it just leave it being misnamed?  It would
probably be better to fold in the actual identity implementation as well.
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/mmu.c |   59 ++++++++++++++++++++++++++-------------------------
>  1 files changed, 30 insertions(+), 29 deletions(-)
>
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 44924e5..d6d0276 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -209,9 +209,9 @@ unsigned long xen_max_p2m_pfn __read_mostly;
>  #define MAX_P2M_PFN		(P2M_TOP_PER_PAGE * P2M_MID_PER_PAGE * P2M_PER_PAGE)
>  
>  /* Placeholders for holes in the address space */
> -static RESERVE_BRK_ARRAY(unsigned long, p2m_missing, P2M_PER_PAGE);
> -static RESERVE_BRK_ARRAY(unsigned long *, p2m_mid_missing, P2M_MID_PER_PAGE);
> -static RESERVE_BRK_ARRAY(unsigned long, p2m_mid_missing_mfn, P2M_MID_PER_PAGE);
> +static RESERVE_BRK_ARRAY(unsigned long, p2m_identity, P2M_PER_PAGE);
> +static RESERVE_BRK_ARRAY(unsigned long *, p2m_mid_identity, P2M_MID_PER_PAGE);
> +static RESERVE_BRK_ARRAY(unsigned long, p2m_mid_identity_mfn, P2M_MID_PER_PAGE);
>  
>  static RESERVE_BRK_ARRAY(unsigned long **, p2m_top, P2M_TOP_PER_PAGE);
>  static RESERVE_BRK_ARRAY(unsigned long, p2m_top_mfn, P2M_TOP_PER_PAGE);
> @@ -241,7 +241,7 @@ static void p2m_top_init(unsigned long ***top)
>  	unsigned i;
>  
>  	for (i = 0; i < P2M_TOP_PER_PAGE; i++)
> -		top[i] = p2m_mid_missing;
> +		top[i] = p2m_mid_identity;
>  }
>  
>  static void p2m_top_mfn_init(unsigned long *top)
> @@ -249,7 +249,7 @@ static void p2m_top_mfn_init(unsigned long *top)
>  	unsigned i;
>  
>  	for (i = 0; i < P2M_TOP_PER_PAGE; i++)
> -		top[i] = virt_to_mfn(p2m_mid_missing_mfn);
> +		top[i] = virt_to_mfn(p2m_mid_identity_mfn);
>  }
>  
>  static void p2m_top_mfn_p_init(unsigned long **top)
> @@ -257,7 +257,7 @@ static void p2m_top_mfn_p_init(unsigned long **top)
>  	unsigned i;
>  
>  	for (i = 0; i < P2M_TOP_PER_PAGE; i++)
> -		top[i] = p2m_mid_missing_mfn;
> +		top[i] = p2m_mid_identity_mfn;
>  }
>  
>  static void p2m_mid_init(unsigned long **mid)
> @@ -265,7 +265,7 @@ static void p2m_mid_init(unsigned long **mid)
>  	unsigned i;
>  
>  	for (i = 0; i < P2M_MID_PER_PAGE; i++)
> -		mid[i] = p2m_missing;
> +		mid[i] = p2m_identity;
>  }
>  
>  static void p2m_mid_mfn_init(unsigned long *mid)
> @@ -273,7 +273,7 @@ static void p2m_mid_mfn_init(unsigned long *mid)
>  	unsigned i;
>  
>  	for (i = 0; i < P2M_MID_PER_PAGE; i++)
> -		mid[i] = virt_to_mfn(p2m_missing);
> +		mid[i] = virt_to_mfn(p2m_identity);
>  }
>  
>  static void p2m_init(unsigned long *p2m)
> @@ -300,8 +300,8 @@ void xen_build_mfn_list_list(void)
>  
>  	/* Pre-initialize p2m_top_mfn to be completely missing */
>  	if (p2m_top_mfn == NULL) {
> -		p2m_mid_missing_mfn = extend_brk(PAGE_SIZE, PAGE_SIZE);
> -		p2m_mid_mfn_init(p2m_mid_missing_mfn);
> +		p2m_mid_identity_mfn = extend_brk(PAGE_SIZE, PAGE_SIZE);
> +		p2m_mid_mfn_init(p2m_mid_identity_mfn);
>  
>  		p2m_top_mfn_p = extend_brk(PAGE_SIZE, PAGE_SIZE);
>  		p2m_top_mfn_p_init(p2m_top_mfn_p);
> @@ -310,7 +310,7 @@ void xen_build_mfn_list_list(void)
>  		p2m_top_mfn_init(p2m_top_mfn);
>  	} else {
>  		/* Reinitialise, mfn's all change after migration */
> -		p2m_mid_mfn_init(p2m_mid_missing_mfn);
> +		p2m_mid_mfn_init(p2m_mid_identity_mfn);
>  	}
>  
>  	for (pfn = 0; pfn < xen_max_p2m_pfn; pfn += P2M_PER_PAGE) {
> @@ -326,15 +326,15 @@ void xen_build_mfn_list_list(void)
>  		 * they're just missing, just update the stored mfn,
>  		 * since all could have changed over a migrate.
>  		 */
> -		if (mid == p2m_mid_missing) {
> +		if (mid == p2m_mid_identity) {
>  			BUG_ON(mididx);
> -			BUG_ON(mid_mfn_p != p2m_mid_missing_mfn);
> -			p2m_top_mfn[topidx] = virt_to_mfn(p2m_mid_missing_mfn);
> +			BUG_ON(mid_mfn_p != p2m_mid_identity_mfn);
> +			p2m_top_mfn[topidx] = virt_to_mfn(p2m_mid_identity_mfn);
>  			pfn += (P2M_MID_PER_PAGE - 1) * P2M_PER_PAGE;
>  			continue;
>  		}
>  
> -		if (mid_mfn_p == p2m_mid_missing_mfn) {
> +		if (mid_mfn_p == p2m_mid_identity_mfn) {
>  			/*
>  			 * XXX boot-time only!  We should never find
>  			 * missing parts of the mfn tree after
> @@ -370,11 +370,11 @@ void __init xen_build_dynamic_phys_to_machine(void)
>  
>  	xen_max_p2m_pfn = max_pfn;
>  
> -	p2m_missing = extend_brk(PAGE_SIZE, PAGE_SIZE);
> -	p2m_init(p2m_missing);
> +	p2m_identity = extend_brk(PAGE_SIZE, PAGE_SIZE);
> +	p2m_init(p2m_identity);
>  
> -	p2m_mid_missing = extend_brk(PAGE_SIZE, PAGE_SIZE);
> -	p2m_mid_init(p2m_mid_missing);
> +	p2m_mid_identity = extend_brk(PAGE_SIZE, PAGE_SIZE);
> +	p2m_mid_init(p2m_mid_identity);
>  
>  	p2m_top = extend_brk(PAGE_SIZE, PAGE_SIZE);
>  	p2m_top_init(p2m_top);
> @@ -388,7 +388,7 @@ void __init xen_build_dynamic_phys_to_machine(void)
>  		unsigned topidx = p2m_top_index(pfn);
>  		unsigned mididx = p2m_mid_index(pfn);
>  
> -		if (p2m_top[topidx] == p2m_mid_missing) {
> +		if (p2m_top[topidx] == p2m_mid_identity) {
>  			unsigned long **mid = extend_brk(PAGE_SIZE, PAGE_SIZE);
>  			p2m_mid_init(mid);
>  
> @@ -443,7 +443,7 @@ static bool alloc_p2m(unsigned long pfn)
>  	top_p = &p2m_top[topidx];
>  	mid = *top_p;
>  
> -	if (mid == p2m_mid_missing) {
> +	if (mid == p2m_mid_identity) {
>  		/* Mid level is missing, allocate a new one */
>  		mid = alloc_p2m_page();
>  		if (!mid)
> @@ -451,7 +451,7 @@ static bool alloc_p2m(unsigned long pfn)
>  
>  		p2m_mid_init(mid);
>  
> -		if (cmpxchg(top_p, p2m_mid_missing, mid) != p2m_mid_missing)
> +		if (cmpxchg(top_p, p2m_mid_identity, mid) != p2m_mid_identity)
>  			free_p2m_page(mid);
>  	}
>  
> @@ -460,9 +460,9 @@ static bool alloc_p2m(unsigned long pfn)
>  
>  	BUG_ON(virt_to_mfn(mid_mfn) != *top_mfn_p);
>  
> -	if (mid_mfn == p2m_mid_missing_mfn) {
> +	if (mid_mfn == p2m_mid_identity_mfn) {
>  		/* Separately check the mid mfn level */
> -		unsigned long missing_mfn;
> +		unsigned long identity_mfn;
>  		unsigned long mid_mfn_mfn;
>  
>  		mid_mfn = alloc_p2m_page();
> @@ -471,15 +471,16 @@ static bool alloc_p2m(unsigned long pfn)
>  
>  		p2m_mid_mfn_init(mid_mfn);
>  
> -		missing_mfn = virt_to_mfn(p2m_mid_missing_mfn);
> +		identity_mfn = virt_to_mfn(p2m_mid_identity_mfn);
>  		mid_mfn_mfn = virt_to_mfn(mid_mfn);
> -		if (cmpxchg(top_mfn_p, missing_mfn, mid_mfn_mfn) != missing_mfn)
> +		if (cmpxchg(top_mfn_p, identity_mfn, mid_mfn_mfn) !=
> +		    identity_mfn)

Don't wrap this.

>  			free_p2m_page(mid_mfn);
>  		else
>  			p2m_top_mfn_p[topidx] = mid_mfn;
>  	}
>  
> -	if (p2m_top[topidx][mididx] == p2m_missing) {
> +	if (p2m_top[topidx][mididx] == p2m_identity) {
>  		/* p2m leaf page is missing */
>  		unsigned long *p2m;
>  
> @@ -489,7 +490,7 @@ static bool alloc_p2m(unsigned long pfn)
>  
>  		p2m_init(p2m);
>  
> -		if (cmpxchg(&mid[mididx], p2m_missing, p2m) != p2m_missing)
> +		if (cmpxchg(&mid[mididx], p2m_identity, p2m) != p2m_identity)
>  			free_p2m_page(p2m);
>  		else
>  			mid_mfn[mididx] = virt_to_mfn(p2m);
> @@ -512,7 +513,7 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
>  	mididx = p2m_mid_index(pfn);
>  	idx = p2m_index(pfn);
>  
> -	if (p2m_top[topidx][mididx] == p2m_missing)
> +	if (p2m_top[topidx][mididx] == p2m_identity)
>  		return mfn == INVALID_P2M_ENTRY;
>  
>  	p2m_top[topidx][mididx][idx] = mfn;

Thanks,
    J
