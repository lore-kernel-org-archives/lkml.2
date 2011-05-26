Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503Ab1EZUgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 16:36:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755767Ab1EZUgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 16:36:12 -0400
Date: Thu, 26 May 2011 13:35:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com
Subject: Re: [PATCH v2 1/3] vmscan,memcg: memcg aware swap token
Message-Id: <20110526133551.8c158f1c.akpm@linux-foundation.org>
In-Reply-To: <4DD480DD.2040307@jp.fujitsu.com>
References: <4DD480DD.2040307@jp.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011 11:30:53 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Currently, memcg reclaim can disable swap token even if the swap token
> mm doesn't belong in its memory cgroup. It's slightly risky. If an
> admin creates very small mem-cgroup and silly guy runs contentious heavy
> memory pressure workload, every tasks are going to lose swap token and
> then system may become unresponsive. That's bad.
> 
> This patch adds 'memcg' parameter into disable_swap_token(). and if
> the parameter doesn't match swap token, VM doesn't disable it.
> 
>
> ...
>
> --- a/mm/thrash.c
> +++ b/mm/thrash.c
> @@ -21,14 +21,17 @@
>  #include <linux/mm.h>
>  #include <linux/sched.h>
>  #include <linux/swap.h>
> +#include <linux/memcontrol.h>
> 
>  static DEFINE_SPINLOCK(swap_token_lock);
>  struct mm_struct *swap_token_mm;
> +struct mem_cgroup *swap_token_memcg;
>  static unsigned int global_faults;
> 
>  void grab_swap_token(struct mm_struct *mm)
>  {
>  	int current_interval;
> +	struct mem_cgroup *memcg;
> 
>  	global_faults++;
> 
> @@ -38,40 +41,72 @@ void grab_swap_token(struct mm_struct *mm)
>  		return;
> 
>  	/* First come first served */
> -	if (swap_token_mm == NULL) {
> -		mm->token_priority = mm->token_priority + 2;
> -		swap_token_mm = mm;
> +	if (!swap_token_mm)
> +		goto replace_token;
> +
> +	if (mm == swap_token_mm) {
> +		mm->token_priority += 2;
>  		goto out;
>  	}
> 
> -	if (mm != swap_token_mm) {
> -		if (current_interval < mm->last_interval)
> -			mm->token_priority++;
> -		else {
> -			if (likely(mm->token_priority > 0))
> -				mm->token_priority--;
> -		}
> -		/* Check if we deserve the token */
> -		if (mm->token_priority > swap_token_mm->token_priority) {
> -			mm->token_priority += 2;
> -			swap_token_mm = mm;
> -		}
> -	} else {
> -		/* Token holder came in again! */
> -		mm->token_priority += 2;
> +	if (current_interval < mm->last_interval)
> +		mm->token_priority++;
> +	else {
> +		if (likely(mm->token_priority > 0))
> +			mm->token_priority--;
>  	}
> 
> +	/* Check if we deserve the token */
> +	if (mm->token_priority > swap_token_mm->token_priority)
> +		goto replace_token;
> +
>  out:
>  	mm->faultstamp = global_faults;
>  	mm->last_interval = current_interval;
>  	spin_unlock(&swap_token_lock);
> +	return;
> +
> +replace_token:
> +	mm->token_priority += 2;
> +	memcg = try_get_mem_cgroup_from_mm(mm);
> +	if (memcg)
> +		css_put(mem_cgroup_css(memcg));
> +	swap_token_mm = mm;
> +	swap_token_memcg = memcg;
> +	goto out;
>  }

CONFIG_CGROUPS=n:

mm/thrash.c: In function 'grab_swap_token':
mm/thrash.c:73: error: implicit declaration of function 'css_put'

I don't think that adding a null stub for css_put() is the right fix
here...
