Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab0F3Rze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 13:55:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51899 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab0F3Rzd (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 30 Jun 2010 13:55:33 -0400
Date: Wed, 30 Jun 2010 13:53:43 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano@stabellini.net, johnstul@us.ibm.com
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Stefano.Stabellini@eu.citrix.com, sheng@linux.intel.com,
       ddutile@redhat.com, jeremy@goop.org
Subject: Re: [PATCH 10/13] Do not try to disable hpet if it hasn't been
 initialized before
Message-ID: <20100630175343.GA16488@phenom.dumpdata.com>
References: <alpine.DEB.2.00.1006211456360.18470@kaball-desktop>
 <1277136847-13266-10-git-send-email-stefano@stabellini.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277136847-13266-10-git-send-email-stefano@stabellini.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C2B8503.0042:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 05:14:04PM +0100, stefano@stabellini.net wrote:
> From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> hpet_disable is called unconditionally on machine reboot if hpet support
> is compiled in the kernel.
> hpet_disable only checks if the machine is hpet capable but doesn't make
> sure that hpet has been initialized.

CC-ing John Stultz who has had his head wrapped around this time-thingy.

Hi John!

What are your thoughts about this patch?
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/x86/kernel/hpet.c |   18 ++++++++++--------
>  1 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
> index 23b4ecd..2b299da 100644
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -959,16 +959,18 @@ fs_initcall(hpet_late_init);
>  
>  void hpet_disable(void)
>  {
> -	if (is_hpet_capable()) {
> -		unsigned int cfg = hpet_readl(HPET_CFG);
> +	unsigned int cfg;
>  
> -		if (hpet_legacy_int_enabled) {
> -			cfg &= ~HPET_CFG_LEGACY;
> -			hpet_legacy_int_enabled = 0;
> -		}
> -		cfg &= ~HPET_CFG_ENABLE;
> -		hpet_writel(cfg, HPET_CFG);
> +	if (!is_hpet_capable() || !hpet_address || !hpet_virt_address)
> +		return;
> +
> +	cfg = hpet_readl(HPET_CFG);
> +	if (hpet_legacy_int_enabled) {
> +		cfg &= ~HPET_CFG_LEGACY;
> +		hpet_legacy_int_enabled = 0;
>  	}
> +	cfg &= ~HPET_CFG_ENABLE;
> +	hpet_writel(cfg, HPET_CFG);
>  }
>  
>  #ifdef CONFIG_HPET_EMULATE_RTC
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
