Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab2HNUBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 16:01:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59544 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287Ab2HNUBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 16:01:19 -0400
Date: Tue, 14 Aug 2012 17:01:11 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Colin Cross <ccross@android.com>,
        Barry Song <bs14@csr.com>, Catalin Marinas <catalin.marinas@arm.com>,
        Ido Yariv <ido@wizery.com>, Daniel Drake <dsd@laptop.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [ 07/44] ARM: 7477/1: vfp: Always save VFP state in
 vfp_pm_suspend on UP
Message-ID: <20120814200110.GE5277@herton-Z68MA-D2H-B3>
References: <20120813220142.113186818@linuxfoundation.org>
 <20120813220142.801309366@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120813220142.801309366@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 03:02:14PM -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
> 
[...]
> --- a/arch/arm/vfp/vfpmodule.c
> +++ b/arch/arm/vfp/vfpmodule.c
> @@ -412,6 +412,12 @@ static int vfp_pm_suspend(void)
>  
>  		/* disable, just in case */
>  		fmxr(FPEXC, fmrx(FPEXC) & ~FPEXC_EN);
> +	} else if (vfp_current_hw_state[ti->cpu]) {
> +#ifndef CONFIG_SMP
> +		fmxr(FPEXC, fpexc | FPEXC_EN);
> +		vfp_save_state(vfp_current_hw_state[ti->cpu], fpexc);
> +		fmxr(FPEXC, fpexc);
> +#endif

This fails to build on 3.0:

linux-stable/arch/arm/vfp/vfpmodule.c: In function 'vfp_pm_suspend':
linux-stable/arch/arm/vfp/vfpmodule.c:415:13: error: 'vfp_current_hw_state' undeclared (first use in this function)
linux-stable/arch/arm/vfp/vfpmodule.c:415:13: note: each undeclared identifier is reported only once for each function it appears in
make[3]: *** [arch/arm/vfp/vfpmodule.o] Error 1

In 3.0, vfp_current_hw_state was still named last_VFP_context, so I
think just renaming should be enough to fix this.

>  	}
>  
>  	/* clear any information we had about last context state */
> 

-- 
[]'s
Herton
