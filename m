Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab1I0SfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:35:14 -0400
Received: from smtp-out.google.com ([74.125.121.67]:25328 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab1I0SfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:35:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=KHOl1h9NWSlAhaFcoHg2i/QOh3yyquQMAZ0MbPbfUKIs53MkTW9mvFVldReexC2IW
	KSVOiqh/UUscG1xgGHJLQ==
Date: Tue, 27 Sep 2011 11:35:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <htejun@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [patch] oom: thaw threads if oom killed thread is frozen before
 deferring
In-Reply-To: <65d9dff7ff78fad1f146e71d32f9f92741281b46.1317110948.git.mhocko@suse.cz>
Message-ID: <alpine.DEB.2.00.1109271133590.17876@chino.kir.corp.google.com>
References: <cover.1317110948.git.mhocko@suse.cz> <65d9dff7ff78fad1f146e71d32f9f92741281b46.1317110948.git.mhocko@suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Sep 2011, Michal Hocko wrote:

> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 626303b..c419a7e 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -32,6 +32,7 @@
>  #include <linux/mempolicy.h>
>  #include <linux/security.h>
>  #include <linux/ptrace.h>
> +#include <linux/freezer.h>
>  
>  int sysctl_panic_on_oom;
>  int sysctl_oom_kill_allocating_task;
> @@ -451,10 +452,15 @@ static int oom_kill_task(struct task_struct *p, struct mem_cgroup *mem)
>  				task_pid_nr(q), q->comm);
>  			task_unlock(q);
>  			force_sig(SIGKILL, q);
> +
> +			if (frozen(q))
> +				thaw_process(q);
>  		}
>  
>  	set_tsk_thread_flag(p, TIF_MEMDIE);
>  	force_sig(SIGKILL, p);
> +	if (frozen(p))
> +		thaw_process(p);
>  
>  	return 0;
>  }

Also needs this...


oom: thaw threads if oom killed thread is frozen before deferring

If a thread has been oom killed and is frozen, thaw it before returning
to the page allocator.  Otherwise, it can stay frozen indefinitely and
no memory will be freed.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/oom_kill.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -318,8 +318,11 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
 		 * blocked waiting for another task which itself is waiting
 		 * for memory. Is there a better alternative?
 		 */
-		if (test_tsk_thread_flag(p, TIF_MEMDIE))
+		if (test_tsk_thread_flag(p, TIF_MEMDIE)) {
+			if (unlikely(frozen(p)))
+				thaw_process(p);
 			return ERR_PTR(-1UL);
+		}
 		if (!p->mm)
 			continue;
 
