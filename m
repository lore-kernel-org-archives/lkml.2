Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab1BYKDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 05:03:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53404 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794Ab1BYKDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 05:03:50 -0500
Date: Fri, 25 Feb 2011 11:03:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86,mm,64bit: Round up memory boundary for
 init_memory_mapping_high()
Message-ID: <20110225100336.GA26608@elte.hu>
References: <20110223171945.GI26065@htj.dyndns.org>
 <4D656D1A.7030006@kernel.org>
 <20110223204656.GA27738@atj.dyndns.org>
 <4D657359.5060901@kernel.org>
 <20110223210326.GB27738@atj.dyndns.org>
 <AANLkTintYZ00-MZD5hv7p0zNeDJTyyzdR-C=7qWo78Ly@mail.gmail.com>
 <20110224091557.GD7840@htj.dyndns.org>
 <4D674A33.8000809@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D674A33.8000809@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

>  init_memory_mapping_active_regions(unsigned long start, unsigned long end)
>  {
>  	struct mapping_work_data data;
> +	int use_gbpages;
> +
> +	/* see init_memory_mapping() for the setting */
> +#if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
> +	use_gbpages = 0;
> +#else
> +	use_gbpages = direct_gbpages;
> +#endif

Sigh. You should *never* ever even think about writing such code. It only results in 
crap, and in crap duplicated elsewhere as well:

if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
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

Thanks,

	Ingo
