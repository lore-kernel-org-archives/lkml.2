Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab1LNPrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:47:53 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58069 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193Ab1LNPru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:47:50 -0500
Date: Wed, 14 Dec 2011 16:47:38 +0100
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        "Huang, Ying" <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH 6/6] x86, mce: Recognise machine check bank signature for
 data path error
Message-ID: <20111214154738.GF23589@aftab>
References: <cover.1323803130.git.tony.luck@intel.com>
 <9fc2d80b67a31c7b3c25bdabb20c361443113c04.1323803130.git.tony.luck@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9fc2d80b67a31c7b3c25bdabb20c361443113c04.1323803130.git.tony.luck@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 02:49:09PM -0800, Tony Luck wrote:
> Action required data path signature is defined in table 15-19 of SDM:
> 
> +-----------------------------------------------------------------------------+
> | SRAR Error | Valid | OVER | UC | EN | MISCV | ADDRV | PCC | S | AR | MCACOD |
> | Data Load  |     1 |    0 |  1 |  1 |     1 |     1 |   0 | 1 |  1 |  0x134 |
> +-----------------------------------------------------------------------------+
> 
> Recognise this, and pass MCE_AR_SEVERITY code back to do_machine_check()
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce-severity.c |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce-severity.c b/arch/x86/kernel/cpu/mcheck/mce-severity.c
> index 7395d5f..c4d8b24 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce-severity.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce-severity.c
> @@ -54,6 +54,7 @@ static struct severity {
>  #define  MASK(x, y)	.mask = x, .result = y
>  #define MCI_UC_S (MCI_STATUS_UC|MCI_STATUS_S)
>  #define MCI_UC_SAR (MCI_STATUS_UC|MCI_STATUS_S|MCI_STATUS_AR)
> +#define	MCI_ADDR (MCI_STATUS_ADDRV|MCI_STATUS_MISCV)
>  #define MCACOD 0xffff
>  
>  	MCESEV(
> @@ -102,11 +103,22 @@ static struct severity {
>  		SER, BITCLR(MCI_STATUS_S)
>  		),
>  
> -	/* AR add known MCACODs here */
>  	MCESEV(
>  		PANIC, "Action required with lost events",
>  		SER, BITSET(MCI_STATUS_OVER|MCI_UC_SAR)
>  		),
> +
> +	/* known AR MCACODs: */
> +	MCESEV(
> +		KEEP, "HT thread notices Action required: data load error",
> +		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|0x0134),
> +		MCGMASK(MCG_STATUS_EIPV, 0)

Oh this is the core "observed" the error case, ok.

This is marked as MCE_KEEP_SEVERITY, which means that we're panicking
in case we lose the AR error on the affected CPU. Which should be
conservative enough...

ACK.

> +		),
> +	MCESEV(
> +		AR, "Action required: data load error",
> +		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR|MCI_ADDR|MCACOD, MCI_UC_SAR|MCI_ADDR|0x0134),
> +		USER
> +		),
>  	MCESEV(
>  		PANIC, "Action required: unknown MCACOD",
>  		SER, MASK(MCI_STATUS_OVER|MCI_UC_SAR, MCI_UC_SAR)
> -- 
> 1.7.3.1
> 
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
