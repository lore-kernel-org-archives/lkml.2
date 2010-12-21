Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab0LUWhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 17:37:05 -0500
Received: from claw.goop.org ([74.207.240.146]:49606 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab0LUWhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 17:37:03 -0500
Message-ID: <4D112C0D.6060400@goop.org>
Date: Tue, 21 Dec 2010 14:37:01 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, hpa@zytor.com,
        Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH 06/10] xen/setup: Only set identity mapping in E820 regions
 when privileged.
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com> <1292967460-15709-7-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1292967460-15709-7-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2010 01:37 PM, Konrad Rzeszutek Wilk wrote:
> We do not want to set the identity mapping on E820 reserved
> regions when running as PV. This is b/c the 0->ISA_END_ADDRESS region
> would be considered identity and we would try to read DMI information
> and fail (since the pfn_to_mfn(mfn)==pfn) under PV guests.
>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/setup.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index 752c865..34fb906 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -160,7 +160,7 @@ static unsigned long __init xen_set_identity(const struct e820map *e820)
>  		if (end < start)
>  			continue;
>  
> -		if (e820->map[i].type != E820_RAM) {
> +		if (xen_initial_domain() && e820->map[i].type != E820_RAM) {
>  			for (pfn = PFN_UP(start); pfn < PFN_DOWN(end); pfn++)
>  				set_phys_to_machine(pfn, pfn);
>  			identity += pfn - PFN_UP(start);

So you're relying on the fact that the ISA area is the only non-RAM e820
entry in domU?  I think it would be better to do a specific exclusion
for the ISA area rather than this.

    J
