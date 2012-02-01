Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab2BAOul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 09:50:41 -0500
Received: from mail.betterlinux.com ([199.58.199.50]:40796 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab2BAOuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 09:50:40 -0500
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Feb 2012 09:50:40 EST
X-DKIM: OpenDKIM Filter v2.4.1 mail.betterlinux.com 1DCC02341A3
Date: Wed, 1 Feb 2012 15:43:33 +0100
From: Andrea Righi <andrea@betterlinux.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Tuner <pjt@google.com>
Subject: Re: [PATCH] Add num_to_str() for speedup /proc/stat
Message-ID: <20120201144333.GA1542@thinkpad>
References: <20120124161221.032325d1.akpm@linux-foundation.org>
 <1327450945.14373.24.camel@edumazet-laptop>
 <20120124172732.19b3d9f4.akpm@linux-foundation.org>
 <1327469372.14373.31.camel@edumazet-laptop>
 <20120125170416.385ee9fa.akpm@linux-foundation.org>
 <20120126185520.25c8f9b6.kamezawa.hiroyu@jp.fujitsu.com>
 <20120126164342.a496ded0.akpm@linux-foundation.org>
 <20120127100933.5e782a33.kamezawa.hiroyu@jp.fujitsu.com>
 <20120126171800.01c2405c.akpm@linux-foundation.org>
 <20120130141619.a35863e2.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130141619.a35863e2.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 02:16:19PM +0900, KAMEZAWA Hiroyuki wrote:
...
> diff --git a/fs/proc/stat.c b/fs/proc/stat.c
> index 121f77c..0ff3b92 100644
> --- a/fs/proc/stat.c
> +++ b/fs/proc/stat.c
> @@ -89,18 +89,19 @@ static int show_stat(struct seq_file *p, void *v)
>  	}
>  	sum += arch_irq_stat();
>  
> -	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu %llu "
> -		"%llu\n",
> -		(unsigned long long)cputime64_to_clock_t(user),
> -		(unsigned long long)cputime64_to_clock_t(nice),
> -		(unsigned long long)cputime64_to_clock_t(system),
> -		(unsigned long long)cputime64_to_clock_t(idle),
> -		(unsigned long long)cputime64_to_clock_t(iowait),
> -		(unsigned long long)cputime64_to_clock_t(irq),
> -		(unsigned long long)cputime64_to_clock_t(softirq),
> -		(unsigned long long)cputime64_to_clock_t(steal),
> -		(unsigned long long)cputime64_to_clock_t(guest),
> -		(unsigned long long)cputime64_to_clock_t(guest_nice));
> +	seq_puts(p, "cpu ");
> +	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(user));
> +	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(nice));
> +	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(system));
> +	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(idle));
> +	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(iowait));
> +	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(irq));
> +	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(softirq));
> +	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(steal));
> +	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest));
> +	seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(guest_nice));
> +	seq_putc(p, '\n');
> +
>  	for_each_online_cpu(i) {
>  		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
>  		user = kcpustat_cpu(i).cpustat[CPUTIME_USER];
> @@ -113,26 +114,24 @@ static int show_stat(struct seq_file *p, void *v)
>  		steal = kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
>  		guest = kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
>  		guest_nice = kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
> -		seq_printf(p,
> -			"cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu "
> -			"%llu\n",
> -			i,
> -			(unsigned long long)cputime64_to_clock_t(user),
> -			(unsigned long long)cputime64_to_clock_t(nice),
> -			(unsigned long long)cputime64_to_clock_t(system),
> -			(unsigned long long)cputime64_to_clock_t(idle),
> -			(unsigned long long)cputime64_to_clock_t(iowait),
> -			(unsigned long long)cputime64_to_clock_t(irq),
> -			(unsigned long long)cputime64_to_clock_t(softirq),
> -			(unsigned long long)cputime64_to_clock_t(steal),
> -			(unsigned long long)cputime64_to_clock_t(guest),
> -			(unsigned long long)cputime64_to_clock_t(guest_nice));
> +		seq_printf(p, "cpu %d", i);
                               ^^^^^^
mmh... if I'm not wrong this looks like an ABI change.

Thanks,
-Andrea

---
From: Andrea Righi <andrea@betterlinux.com>
Subject: procfs: avoid breaking the ABI in /proc/stat

The speed up of /proc/stat changed the output of the cpu statistics
adding an extra space between the string "cpu" and the cpu id.

Restore the old ABI by removing this space.

Signed-off-by: Andrea Righi <andrea@betterlinux.com>
---
 fs/proc/stat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 0ff3b92..7ed7efa 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -114,7 +114,7 @@ static int show_stat(struct seq_file *p, void *v)
 		steal = kcpustat_cpu(i).cpustat[CPUTIME_STEAL];
 		guest = kcpustat_cpu(i).cpustat[CPUTIME_GUEST];
 		guest_nice = kcpustat_cpu(i).cpustat[CPUTIME_GUEST_NICE];
-		seq_printf(p, "cpu %d", i);
+		seq_printf(p, "cpu%d", i);
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(user));
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(nice));
 		seq_put_decimal_ull(p, ' ', cputime64_to_clock_t(system));

