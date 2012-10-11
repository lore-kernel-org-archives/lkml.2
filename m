Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933613Ab2JKAai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:30:38 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58458 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933373Ab2JKAZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:25:21 -0400
Message-ID: <507611ED.3050202@zankel.net>
Date: Wed, 10 Oct 2012 17:25:17 -0700
From: Chris Zankel <chris@zankel.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [ 103/133] xtensa: Add missing RCU idle APIs on idle loop
References: <20121010224854.313159132@linuxfoundation.org> <20121010224913.049854645@linuxfoundation.org>
In-Reply-To: <20121010224913.049854645@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,
Thanks for adding it.

Signed-off-by: Chris Zankel <chris@zankel.net>



On 10/10/2012 03:52 PM, Greg Kroah-Hartman wrote:
> 3.5-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Frederic Weisbecker <fweisbec@gmail.com>
>
> commit 11ad47a0edbd62bfc0547cfcdf227a911433f207 upstream.
>
> In the old times, the whole idle task was considered
> as an RCU quiescent state. But as RCU became more and
> more successful overtime, some RCU read side critical
> section have been added even in the code of some
> architectures idle tasks, for tracing for example.
>
> So nowadays, rcu_idle_enter() and rcu_idle_exit() must
> be called by the architecture to tell RCU about the part
> in the idle loop that doesn't make use of rcu read side
> critical sections, typically the part that puts the CPU
> in low power mode.
>
> This is necessary for RCU to find the quiescent states in
> idle in order to complete grace periods.
>
> Add this missing pair of calls in the xtensa's idle loop.
>
> Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Chris Zankel <chris@zankel.net>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>   arch/xtensa/kernel/process.c |    3 +++
>   1 file changed, 3 insertions(+)
>
> --- a/arch/xtensa/kernel/process.c
> +++ b/arch/xtensa/kernel/process.c
> @@ -31,6 +31,7 @@
>   #include <linux/mqueue.h>
>   #include <linux/fs.h>
>   #include <linux/slab.h>
> +#include <linux/rcupdate.h>
>   
>   #include <asm/pgtable.h>
>   #include <asm/uaccess.h>
> @@ -110,8 +111,10 @@ void cpu_idle(void)
>   
>   	/* endless idle loop with no priority at all */
>   	while (1) {
> +		rcu_idle_enter();
>   		while (!need_resched())
>   			platform_idle();
> +		rcu_idle_exit();
>   		schedule_preempt_disabled();
>   	}
>   }
>
>

