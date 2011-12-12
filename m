Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab1LLMng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 07:43:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47353 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762Ab1LLMnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 07:43:35 -0500
Date: Mon, 12 Dec 2011 13:43:33 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        "Artem S. Tashkinov" <t.artem@mailcity.com>,
        Dave Jones <davej@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] procfs: do not confuse jiffies with cputime64_t
Message-ID: <20111212124333.GC14720@tiehlicka.suse.cz>
References: <m28vmi7ip3.fsf@igel.home>
 <201112120922.13633.arnd@arndb.de>
 <m21usavwi0.fsf_-_@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m21usavwi0.fsf_-_@igel.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 12-12-11 12:51:19, Andreas Schwab wrote:
> get_{idle,iowait}_time are supposed to return cputime64_t values, not
> jiffies.  Add usecs_to_cputime64 for this.

OK, this looks much better than doing an artificial 
us -> ns -> jiffies -> cputime64

Could you also add usecs_to_cputime64 for s390 so that all this is
consistent?

This should cover all architectures AFAICS.

Thanks

> 
> Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  arch/ia64/include/asm/cputime.h    |    1 +
>  arch/powerpc/include/asm/cputime.h |    2 ++
>  fs/proc/stat.c                     |    4 ++--
>  include/asm-generic/cputime.h      |    1 +
>  4 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/ia64/include/asm/cputime.h b/arch/ia64/include/asm/cputime.h
> index 6073b18..5a274af 100644
> --- a/arch/ia64/include/asm/cputime.h
> +++ b/arch/ia64/include/asm/cputime.h
> @@ -60,6 +60,7 @@ typedef u64 cputime64_t;
>   */
>  #define cputime_to_usecs(__ct)		((__ct) / NSEC_PER_USEC)
>  #define usecs_to_cputime(__usecs)	((__usecs) * NSEC_PER_USEC)
> +#define usecs_to_cputime64(__usecs)	usecs_to_cputime(__usecs)
>  
>  /*
>   * Convert cputime <-> seconds
> diff --git a/arch/powerpc/include/asm/cputime.h b/arch/powerpc/include/asm/cputime.h
> index 33a3580..fa3f921 100644
> --- a/arch/powerpc/include/asm/cputime.h
> +++ b/arch/powerpc/include/asm/cputime.h
> @@ -150,6 +150,8 @@ static inline cputime_t usecs_to_cputime(const unsigned long us)
>  	return ct;
>  }
>  
> +#define usecs_to_cputime64(us)		usecs_to_cputime(us)
> +
>  /*
>   * Convert cputime <-> seconds
>   */
> diff --git a/fs/proc/stat.c b/fs/proc/stat.c
> index 2a30d67..0855e6f 100644
> --- a/fs/proc/stat.c
> +++ b/fs/proc/stat.c
> @@ -32,7 +32,7 @@ static cputime64_t get_idle_time(int cpu)
>  		idle = kstat_cpu(cpu).cpustat.idle;
>  		idle = cputime64_add(idle, arch_idle_time(cpu));
>  	} else
> -		idle = nsecs_to_jiffies64(1000 * idle_time);
> +		idle = usecs_to_cputime64(idle_time);
>  
>  	return idle;
>  }
> @@ -46,7 +46,7 @@ static cputime64_t get_iowait_time(int cpu)
>  		/* !NO_HZ so we can rely on cpustat.iowait */
>  		iowait = kstat_cpu(cpu).cpustat.iowait;
>  	else
> -		iowait = nsecs_to_jiffies64(1000 * iowait_time);
> +		iowait = usecs_to_cputime64(iowait_time);
>  
>  	return iowait;
>  }
> diff --git a/include/asm-generic/cputime.h b/include/asm-generic/cputime.h
> index 62ce682..12a1764 100644
> --- a/include/asm-generic/cputime.h
> +++ b/include/asm-generic/cputime.h
> @@ -40,6 +40,7 @@ typedef u64 cputime64_t;
>   */
>  #define cputime_to_usecs(__ct)		jiffies_to_usecs(__ct)
>  #define usecs_to_cputime(__msecs)	usecs_to_jiffies(__msecs)
> +#define usecs_to_cputime64(__msecs)	nsecs_to_jiffies64((__msecs) * 1000)
>  
>  /*
>   * Convert cputime to seconds and back.
> -- 
> 1.7.8
> 
> 
> -- 
> Andreas Schwab, schwab@linux-m68k.org
> GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
> "And now for something completely different."
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
