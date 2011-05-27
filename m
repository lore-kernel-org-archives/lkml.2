Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465Ab1E0GiM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 02:38:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37283 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab1E0GiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 02:38:10 -0400
Date: Fri, 27 May 2011 08:38:05 +0200
From: Borislav Petkov <bp@alien8.de>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 10/12] x86, mce: cleanup mce_read
Message-ID: <20110527063804.GB16811@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Tony Luck <tony.luck@intel.com>
References: <4DDF21DE.9040705@jp.fujitsu.com>
 <4DDF2476.1010903@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4DDF2476.1010903@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 01:11:34PM +0900, Hidetoshi Seto wrote:
> Use temporary local entry to make code simple.
> No change in logic.
> 
> Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |   19 +++++++++----------
>  1 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 9fe9e6e..4ba4040 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1533,18 +1533,17 @@ static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
>  	do {
>  		for (i = prev; i < next; i++) {
>  			unsigned long start = jiffies;
> +			struct mce *entry = &mcelog.entry[i];

Just go ahead and call it m:

			struct mce *m = ...

we know it's an mce struct.

>  
> -			while (!mcelog.entry[i].finished) {
> +			while (!entry->finished) {
>  				if (time_after_eq(jiffies, start + 2)) {
> -					memset(mcelog.entry + i, 0,
> -					       sizeof(struct mce));
> +					memset(entry, 0, sizeof(struct mce));

..and thus you can do

					memset(m, 0, sizeof(*m));

and that's too short for some taste but since the definition is close
enough, we should still be readable.

>  					goto timeout;
>  				}
>  				cpu_relax();
>  			}
>  			smp_rmb();
> -			err |= copy_to_user(buf, mcelog.entry + i,
> -					    sizeof(struct mce));
> +			err |= copy_to_user(buf, entry, sizeof(struct mce));
>  			buf += sizeof(struct mce);
>  timeout:
>  			;
> @@ -1565,13 +1564,13 @@ timeout:
>  	on_each_cpu(collect_tscs, cpu_tsc, 1);
>  
>  	for (i = next; i < MCE_LOG_LEN; i++) {
> -		if (mcelog.entry[i].finished &&
> -		    mcelog.entry[i].tsc < cpu_tsc[mcelog.entry[i].cpu]) {
> -			err |= copy_to_user(buf, mcelog.entry+i,
> -					    sizeof(struct mce));
> +		struct mce *entry = &mcelog.entry[i];
> +
> +		if (entry->finished && entry->tsc < cpu_tsc[entry->cpu]) {
> +			err |= copy_to_user(buf, entry, sizeof(struct mce));
>  			smp_rmb();
>  			buf += sizeof(struct mce);
> -			memset(&mcelog.entry[i], 0, sizeof(struct mce));
> +			memset(entry, 0, sizeof(struct mce));
>  		}
>  	}
>  
> -- 
> 1.7.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards/Gruss,
    Boris.
