Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab1BRHeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 02:34:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54314 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027Ab1BRHeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 02:34:12 -0500
Date: Fri, 18 Feb 2011 08:34:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Len Brown <len.brown@intel.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
        linux-acpi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] printk: Minimize time zero output
Message-ID: <20110218073402.GF11404@elte.hu>
References: <20110217185131.960038922@gulag1.americas.sgi.com>
 <20110217185132.576051720@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110217185132.576051720@gulag1.americas.sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Reduce the length for time zero messages by only printing "[0] ".
> 
> v2: updated to apply to x86-tip
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> Reviewed-by: Jack Steiner <steiner@sgi.com>
> Reviewed-by: Robin Holt <holt@sgi.com>
> ---
>  kernel/printk.c |    8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> --- linux.orig/kernel/printk.c
> +++ linux/kernel/printk.c
> @@ -818,11 +818,13 @@ asmlinkage int vprintk(const char *fmt,
>  				unsigned long nanosec_rem;
>  
>  				t = cpu_clock(printk_cpu);
> -				nanosec_rem = do_div(t, 1000000000);
> -				tlen = sprintf(tbuf, "[%5lu.%06lu] ",
> +				if (likely(t)) {
> +					nanosec_rem = do_div(t, 1000000000);
> +					tlen = sprintf(tbuf, "[%5lu.%06lu] ",
>  						(unsigned long) t,
>  						nanosec_rem / 1000);

The excessive number of very ugly linebreaks in this statement should have told you 
that the whole printk_time function wants to be broken out of vsprintk(), into a 
helper function.

Please make it two patches: one cleanup-only patch that factors out the code, the 
second one that modifies it materially.

Thanks,

	Ingo
