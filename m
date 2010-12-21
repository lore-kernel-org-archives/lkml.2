Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab0LUWid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 17:38:33 -0500
Received: from claw.goop.org ([74.207.240.146]:33657 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862Ab0LUWic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 17:38:32 -0500
Message-ID: <4D112C66.9040600@goop.org>
Date: Tue, 21 Dec 2010 14:38:30 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, hpa@zytor.com,
        Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH 08/10] xen/mmu: Bugfix. Fill the top entry page with appropriate
 middle layer pointers.
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com> <1292967460-15709-9-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1292967460-15709-9-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2010 01:37 PM, Konrad Rzeszutek Wilk wrote:
> If we swapped over from using an p2m_mid_identical to p2m_mid_missing
> (earlier call to set_phys_to_machine) and then started going through the
> PFNs in descending order to program a new MFN (balloon worker), we would
> end up in this code path. At that point we would set up new page filled with
> pointers to p2m_identity instead of p2m_missing. This had the disastrous
> effect that get_phys_to_machine on that PFN would return an 1-1 mapping
> instead of INVALID_P2M_ENTRY resulting in hitting a BUG check in balloon driver.
>
Are you going to fold this into the appropriate patch later?

> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/mmu.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 92f4fec..a917439 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -480,7 +480,10 @@ static bool alloc_p2m(unsigned long pfn)
>  		if (!mid)
>  			return false;
>  
> -		p2m_mid_init(mid, p2m_identity);
> +		if (mid == p2m_mid_identity)
> +			p2m_mid_init(mid, p2m_identity);
> +		else
> +			p2m_mid_init(mid, p2m_missing);
>  
>  		if (cmpxchg(top_p, mid_orig, mid) != mid_orig)
>  			free_p2m_page(mid);

