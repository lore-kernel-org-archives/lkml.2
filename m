Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab1BTBvj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 20:51:39 -0500
Received: from smtp-out.google.com ([216.239.44.51]:46550 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab1BTBvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 20:51:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=VjVstVE+IKxQpQlnEseEddg/anikSqflBAfPsU6erEQmna1m/NOlZPMiqHeB+sSk10
         NFoEWY4MPvX0rInByhNA==
Date: Sat, 19 Feb 2011 17:51:15 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Travis <travis@sgi.com>
cc: Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
        Robin Holt <holt@sgi.com>, Len Brown <len.brown@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] printk: Minimize time zero output
In-Reply-To: <20110219024706.121740209@gulag1.americas.sgi.com>
Message-ID: <alpine.DEB.2.00.1102191733220.27722@chino.kir.corp.google.com>
References: <20110219024705.308511527@gulag1.americas.sgi.com> <20110219024706.121740209@gulag1.americas.sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Feb 2011, Mike Travis wrote:

> Reduce the length for time zero messages by only printing "[0] ".
> 
> v2: updated to apply to x86-tip
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> Reviewed-by: Jack Steiner <steiner@sgi.com>
> Reviewed-by: Robin Holt <holt@sgi.com>
> ---
>  kernel/printk.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> --- linux.orig/kernel/printk.c
> +++ linux/kernel/printk.c
> @@ -735,9 +735,14 @@ static inline int printk_emit_time(void)
>  	unsigned long microsec_rem;
>  
>  	t = cpu_clock(printk_cpu);
> -	microsec_rem = do_div(t, 1000000000) / 1000;
> -	tlen = sprintf(tbuf, "[%5lu.%06lu] ", (unsigned long)t, microsec_rem);
> -
> +	if (likely(t)) {
> +		microsec_rem = do_div(t, 1000000000) / 1000;
> +		tlen = sprintf(tbuf, "[%5lu.%06lu] ",
> +					(unsigned long)t, microsec_rem);

The definition of microsec_rem can become local to this clause.

> +	} else {
> +		/* reduce byte count in log when time is zero */
> +		tlen = sprintf(tbuf, "[0] ");

If we know the padding when cpu_clock() is non-zero, then why not make 
sure the kernel log is aligned properly by using the same padding here?

> +	}
>  	for (tp = tbuf; tp < tbuf + tlen; tp++)
>  		emit_log_char(*tp);
>  
