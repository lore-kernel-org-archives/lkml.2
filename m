Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082Ab0ENWmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 18:42:36 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:59251 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760058Ab0ENWmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 18:42:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAD9s7UtGGOJc/2dsb2JhbACeBXK9c4UQBINf
Date: Fri, 14 May 2010 18:42:27 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, andrej.gelenberg@udo.edu,
       davej@codemonkey.org.uk, venkatesh.pallipadi@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: +
	cpufreq-revert-remove-rwsem-lock-from-cpufreq_gov_stop-call-second-c
	all-site.patch added to -mm tree
Message-ID: <20100514224227.GD14234@Krystal>
References: <201005142215.o4EMFw4N025717@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <201005142215.o4EMFw4N025717@imap1.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 18:39:25 up 37 days,  8:33,  3 users,  load average: 0.50, 0.25,
	0.14
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* akpm@linux-foundation.org (akpm@linux-foundation.org) wrote:
> 
> The patch titled
>      cpufreq: revert "[CPUFREQ] remove rwsem lock from CPUFREQ_GOV_STOP call (second call site)"
> has been added to the -mm tree.  Its filename is
>      cpufreq-revert-remove-rwsem-lock-from-cpufreq_gov_stop-call-second-call-site.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: cpufreq: revert "[CPUFREQ] remove rwsem lock from CPUFREQ_GOV_STOP call (second call site)"
> From: Andrej Gelenberg <andrej.gelenberg@udo.edu>
> 
> 395913d0b1db37092ea3d9d69b832183b1dd84c5 ("[CPUFREQ] remove rwsem lock
> from CPUFREQ_GOV_STOP call (second call site)") is not needed, because
> there is no rwsem lock in cpufreq_ondemand and cpufreq_conservativ

nit: missing "e"

> anymore.  Lock should not be released until the work done.

Yep, locking has been restructured in the workqueue handler so the
deadlock scenario cannot occur anymore, so this fix seems appropriate.
It is needed to synchronize the governor start/stop. Without this fix, a
race between stop/start could corrupt the ondemand/conservative timer.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> 
> Addresses https://bugzilla.kernel.org/show_bug.cgi?id=1594
> 
> Signed-off-by: Andrej Gelenberg <andrej.gelenberg@udo.edu>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Cc: Dave Jones <davej@codemonkey.org.uk>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/cpufreq/cpufreq.c |   11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
> 
> diff -puN drivers/cpufreq/cpufreq.c~cpufreq-revert-remove-rwsem-lock-from-cpufreq_gov_stop-call-second-call-site drivers/cpufreq/cpufreq.c
> --- a/drivers/cpufreq/cpufreq.c~cpufreq-revert-remove-rwsem-lock-from-cpufreq_gov_stop-call-second-call-site
> +++ a/drivers/cpufreq/cpufreq.c
> @@ -1758,17 +1758,8 @@ static int __cpufreq_set_policy(struct c
>  			dprintk("governor switch\n");
>  
>  			/* end old governor */
> -			if (data->governor) {
> -				/*
> -				 * Need to release the rwsem around governor
> -				 * stop due to lock dependency between
> -				 * cancel_delayed_work_sync and the read lock
> -				 * taken in the delayed work handler.
> -				 */
> -				unlock_policy_rwsem_write(data->cpu);
> +			if (data->governor)
>  				__cpufreq_governor(data, CPUFREQ_GOV_STOP);
> -				lock_policy_rwsem_write(data->cpu);
> -			}
>  
>  			/* start new governor */
>  			data->governor = policy->governor;
> _
> 
> Patches currently in -mm which might be from andrej.gelenberg@udo.edu are
> 
> origin.patch
> cpufreq-revert-remove-rwsem-lock-from-cpufreq_gov_stop-call-second-call-site.patch
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
