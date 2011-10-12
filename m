Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab1JLGzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 02:55:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751422Ab1JLGzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 02:55:07 -0400
Date: Wed, 12 Oct 2011 08:55:04 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Rientjes <rientjes@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <htejun@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] lguest: move process freezing before pending signals
 check
Message-ID: <20111012065504.GC31570@tiehlicka.suse.cz>
References: <cover.1317110948.git.mhocko@suse.cz>
 <e213ea00900cba783f228eb4234ad929a05d4359.1317110948.git.mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e213ea00900cba783f228eb4234ad929a05d4359.1317110948.git.mhocko@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,
what is the current state of this patch? Are you planning to push it for
3.2?

Thanks

On Tue 27-09-11 08:56:03, Michal Hocko wrote:
> run_guest tries to freeze the current process after it has handled
> pending interrupts and before it calls lguest_arch_run_guest.
> This doesn't work nicely if the task has been killed while being frozen
> and when we want to handle that signal as soon as possible.
> Let's move try_to_freeze before we check for pending signal so that we
> can get out of the loop as soon as possible.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  drivers/lguest/core.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/lguest/core.c b/drivers/lguest/core.c
> index 2535933..e7dda91 100644
> --- a/drivers/lguest/core.c
> +++ b/drivers/lguest/core.c
> @@ -232,6 +232,13 @@ int run_guest(struct lg_cpu *cpu, unsigned long __user *user)
>  			}
>  		}
>  
> +		/*
> +		 * All long-lived kernel loops need to check with this horrible
> +		 * thing called the freezer.  If the Host is trying to suspend,
> +		 * it stops us.
> +		 */
> +		try_to_freeze();
> +
>  		/* Check for signals */
>  		if (signal_pending(current))
>  			return -ERESTARTSYS;
> @@ -246,13 +253,6 @@ int run_guest(struct lg_cpu *cpu, unsigned long __user *user)
>  			try_deliver_interrupt(cpu, irq, more);
>  
>  		/*
> -		 * All long-lived kernel loops need to check with this horrible
> -		 * thing called the freezer.  If the Host is trying to suspend,
> -		 * it stops us.
> -		 */
> -		try_to_freeze();
> -
> -		/*
>  		 * Just make absolutely sure the Guest is still alive.  One of
>  		 * those hypercalls could have been fatal, for example.
>  		 */
> -- 
> 1.7.5.4
> 

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
