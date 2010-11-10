Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab0KJVAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 16:00:42 -0500
Received: from smtp-out.google.com ([216.239.44.51]:50771 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349Ab0KJVAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 16:00:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=GcuKf/KGws7ny+L+oSduyWY/qjqyd3gEUdIHsNy8iwC4ILbf2q+V3EIagCqJgmBpMl
         mmGq8DccIbJCbsASEj2A==
Date: Wed, 10 Nov 2010 13:00:34 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Figo.zhang" <figo1802@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Figo.zhang" <zhangtianfei@leadcoretech.com>
Subject: Re: [PATCH v3]mm/oom-kill: direct hardware access processes should
 get bonus
In-Reply-To: <1289402666.10699.28.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1011101252260.830@chino.kir.corp.google.com>
References: <1288662213.10103.2.camel@localhost.localdomain> <1289305468.10699.2.camel@localhost.localdomain> <1289402093.10699.25.camel@localhost.localdomain> <1289402666.10699.28.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010, Figo.zhang wrote:

> the victim should not directly access hardware devices like Xorg server,
> because the hardware could be left in an unpredictable state, although 
> user-application can set /proc/pid/oom_score_adj to protect it. so i think
> those processes should get bonus for protection.
> 

Again, this argument doesn't work: if killing the task leaves hardware in 
an unpredictable state (and that's presumably harmful), then they 
shouldn't be killed at all.

Please show why CAP_SYS_RESOURCE equates to 3% additional memory for such 
tasks.

CAP_SYS_RESOURCE allows those threads to override resource limits, so 
these have potentially unbounded amounts of memory usage.  Thus, they may 
have the highest memory usage on the machine and now your patch has caused 
other innocent tasks to be killed before this is actually targeted.  
That's a bad result.  Why do we need this type of hack in the oom killer 
when these threads have the privilege to modify oom killing priorities for 
all tasks on the system?  Laziness, at the cost of a less predictable 
heuristic?

Why aren't you doing the same change for __vm_enough_memory() for LSMs?

> in v2, fix the incorrect comment.
> in v3, change the divided the badness score by 4, like old heuristic for protection. we just
> want the oom_killer don't select Root/RESOURCE/RAWIO process as possible.
> 
> suppose that if a user process A such as email cleint "evolution" and a process B with
> ditecly hareware access such as "Xorg", they have eat the equal memory (the badness score is 
> the same),so which process are you want to kill? so in new heuristic, it will kill the process B.
> but in reality, we want to kill process A.
> 

Then you need to protect process B accordingly and since it has 
CAP_SYS_RESOURCE it can easily do that on its own or the admin can protect 
Xorg.

> Signed-off-by: Figo.zhang <figo1802@gmail.com>
> Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Unless you did this in private, I didn't see KOSAKI-san's reviewed-by line 
for this change and it is drastically different from what you've proposed 
before.

> ---
> mm/oom_kill.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 4029583..f43d759 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -202,6 +202,15 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
>  		points -= 30;
>  
>  	/*
> +	 * Root and direct hareware access processes are usually more 
> +	 * important, so they should get bonus for protection. 
> +	 */
> +	if (has_capability_noaudit(p, CAP_SYS_ADMIN) ||
> +	    has_capability_noaudit(p, CAP_SYS_RESOURCE) ||
> +	    has_capability_noaudit(p, CAP_SYS_RAWIO))
> +		points /= 4;
> +

What on earth?  So now CAP_SYS_ADMIN gets a 3% bonus in the if-clause 
above this, then we divide a percentage of memory use by 4?  What does 
that mean AT ALL?

And now you've thrown CAP_SYS_RAWIO in there without any mention in the 
changelog?

Are you just trying to introduce all the old arbitrary heuristics from 
before the rewrite back into the oom killer like this?

Do you actually have a log from an event where the oom killer targeted the 
incorrect task?
