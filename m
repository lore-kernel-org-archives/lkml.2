Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab1KPQ0c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:26:32 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44789 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791Ab1KPQ0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:26:30 -0500
Date: Wed, 16 Nov 2011 08:26:24 -0800
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, pavel@ucw.cz, lenb@kernel.org, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2] PM/Memory-hotplug: Avoid task freezing failures
Message-ID: <20111116162601.GB18919@google.com>
References: <20111116115515.25945.35368.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111116115515.25945.35368.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 16, 2011 at 05:25:23PM +0530, Srivatsa S. Bhat wrote:
> v2: Tejun pointed problems with using mutex_lock_interruptible() in a
>     while loop, when signals not related to freezing are involved.
>     So, replaced it with mutex_trylock().
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> 
>  include/linux/suspend.h |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/suspend.h b/include/linux/suspend.h
> index 57a6924..c2b5aab 100644
> --- a/include/linux/suspend.h
> +++ b/include/linux/suspend.h
> @@ -5,6 +5,7 @@
>  #include <linux/notifier.h>
>  #include <linux/init.h>
>  #include <linux/pm.h>
> +#include <linux/freezer.h>
>  #include <linux/mm.h>
>  #include <asm/errno.h>
>  
> @@ -380,7 +381,18 @@ static inline void unlock_system_sleep(void) {}
>  
>  static inline void lock_system_sleep(void)
>  {
> -	mutex_lock(&pm_mutex);
> +	/*
> +	 * We should not use mutex_lock() here because, in case we fail to
> +	 * acquire the lock, it would put us to sleep in TASK_UNINTERRUPTIBLE
> +	 * state, which would lead to task freezing failures. As a
> +	 * consequence, hibernation would fail (even though it had acquired
> +	 * the 'pm_mutex' lock).
> +	 *
> +	 * We should use try_to_freeze() in the while loop so that we don't
> +	 * cause freezing failures due to busy looping.
> +	 */
> +	while (!mutex_trylock(&pm_mutex))
> +		try_to_freeze();

I'm kinda lost.  We now always busy-loop if the lock is held by
someone else.  I can't see how that is an improvement.  If this isn't
an immediate issue, wouldn't it be better to wait for proper solution?

Thank you.

-- 
tejun
