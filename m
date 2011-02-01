Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1BAVep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 16:34:45 -0500
Received: from claw.goop.org ([74.207.240.146]:49760 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab1BAVeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 16:34:44 -0500
Message-ID: <4D487C6B.9000003@goop.org>
Date: Tue, 01 Feb 2011 13:34:35 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, Xen-devel@lists.xensource.com,
        konrad@kernel.org, hpa@zytor.com, stefano.stabellini@eu.citrix.com,
        Ian.Campbell@eu.citrix.com
Subject: Re: [PATCH 04/11] xen/mmu: BUG_ON when racing to swap middle leaf.
References: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com> <1296513876-31415-5-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1296513876-31415-5-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 02:44 PM, Konrad Rzeszutek Wilk wrote:
> The initial bootup code uses set_phys_to_machine quite a lot, and after
> bootup it would be used by the balloon driver. The balloon driver does have
> mutex lock so this should not be necessary - but just in case, add
> a BUG_ON if we do hit this scenario.
>
> [v2: Change from WARN to BUG_ON]
> [v3: Rebased on top of xen->p2m code split]
> Reviewed-by: Ian Campbell <Ian.Campbell@eu.citrix.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/p2m.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> index 19b0a65..fbbd2ab 100644
> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -478,7 +478,8 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
>  
>  		/* Swap over from MISSING to IDENTITY if needed. */
>  		if (p2m_top[topidx][mididx] == p2m_missing) {
> -			p2m_top[topidx][mididx] = p2m_identity;
> +			BUG_ON(cmpxchg(&p2m_top[topidx][mididx], p2m_missing,
> +				p2m_identity) != p2m_missing);

Don't put side-effects in BUG_ONs.  Why is it a bug anyway?

    J
