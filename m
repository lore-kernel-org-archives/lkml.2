Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493Ab1FQRKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 13:10:52 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57761 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759133Ab1FQRKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 13:10:46 -0400
Date: Fri, 17 Jun 2011 19:10:24 +0200
From: Borislav Petkov <bp@amd64.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH 8/8] x86, mce, edac: call edac_mce_parse() once per a
 record
Message-ID: <20110617171024.GH20010@aftab>
References: <4DFB1242.90404@jp.fujitsu.com>
 <4DFB1568.2090808@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFB1568.2090808@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 04:50:48AM -0400, Hidetoshi Seto wrote:
> There is no reason to keep it in the cmpxchg loop.
> (The loop continues until mcelog acquires buffer to save the record)
> 
> And use do-while for the loop here.
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

Good catch.

Reviewed-by: Borislav Petkov <borislav.petkov@amd.com>

> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |   26 +++++++++++++-------------
>  1 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index bc8a02c..f1d8ce1 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -148,21 +148,21 @@ void mce_log(struct mce *mce)
>  	/* Emit the trace record: */
>  	trace_mce_record(mce);
>  
> +	/*
> +	 * If edac_mce is enabled, it will check the error type and will
> +	 * process it, if it is a known error.
> +	 * Otherwise, the error will be sent through mcelog interface.
> +	 */
> +	if (edac_mce_parse(mce))
> +		return;
> +
>  	mce->finished = 0;
>  	wmb();
> -	for (;;) {
> +
> +	do {
>  		entry = rcu_dereference_check_mce(mcelog.next);
>  		for (;;) {
>  			/*
> -			 * If edac_mce is enabled, it will check the error type
> -			 * and will process it, if it is a known error.
> -			 * Otherwise, the error will be sent through mcelog
> -			 * interface
> -			 */
> -			if (edac_mce_parse(mce))
> -				return;
> -
> -			/*
>  			 * When the buffer fills up discard new entries.
>  			 * Assume that the earlier errors are the more
>  			 * interesting ones:
> @@ -181,10 +181,10 @@ void mce_log(struct mce *mce)
>  		}
>  		smp_rmb();
>  		next = entry + 1;
> -		if (cmpxchg(&mcelog.next, entry, next) == entry)
> -			break;
> -	}
> +	} while (cmpxchg(&mcelog.next, entry, next) != entry);
> +
>  	memcpy(mcelog.entry + entry, mce, sizeof(struct mce));
> +
>  	wmb();
>  	mcelog.entry[entry].finished = 1;
>  	wmb();
> -- 
> 1.7.1

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
