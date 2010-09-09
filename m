Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab0IITHx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 15:07:53 -0400
Received: from smtp-out.google.com ([216.239.44.51]:38872 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab0IITHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 15:07:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=s3l/bHc/5FCxaIjZqtwSaiVHHYeLRMM1b5xAE1xJH96EDwTjUo1Vo53KTZ2CtEMhL
	decTP43EwQwqEPRpBb2xA==
Date: Thu, 9 Sep 2010 12:07:43 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>
cc: Nitin Gupta <ngupta@vflare.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Minchan Kim <minchan.kim@gmail.com>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [patch -rc] oom: always return a badness score of non-zero for
 eligible tasks
In-Reply-To: <1284053081.7586.7910.camel@nimitz>
Message-ID: <alpine.DEB.2.00.1009091152090.5556@chino.kir.corp.google.com>
References: <1281374816-904-1-git-send-email-ngupta@vflare.org> <1284053081.7586.7910.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Sep 2010, Dave Hansen wrote:

> Hi Nitin,
> 
> I've been playing with using zram (from -staging) to back some qemu
> guest memory directly.  Basically mmap()'ing the device in instead of
> using anonymous memory.  The old code with the backing swap devices
> seemed to work pretty well, but I'm running into a problem with the new
> code.
> 
> I have plenty of swap on the system, and I'd been running with compcache
> nicely for a while.  But, I went to go tar up (and gzip) a pretty large
> directory in my qemu guest.  It panic'd the qemu host system:
> 
> [703826.003126] Kernel panic - not syncing: Out of memory and no killable processes...
> [703826.003127] 
> [703826.012350] Pid: 25508, comm: cat Not tainted 2.6.36-rc3-00114-g9b9913d #29

I'm curious why there are no killable processes on the system; it seems 
like the triggering task here, cat, would at least be killable itself.  
Could you post the tasklist dump that preceeds this (or, if you've 
disabled it try echo 1 > /proc/sys/vm/oom_dump_tasks first)?

It's possible that if you have enough swap that none of the eligible tasks 
actually have non-zero badness scores either because they are being run as 
root or because the amount of RAM or swap is sufficiently high such that 
(task's rss + swap) / (total rss + swap) is never non-zero.  And, since 
root tasks have a 3% bonus, it's possible these are all root tasks and no 
single task uses more than 3% of rss and swap.

While this may not be the issue in your case, and can be confirmed with 
the tasklist dump if you can get it, we need to protect against these 
situations where eligible tasks may not be killed.

Andrew, I'd like to propose this patch for 2.6.36-rc-series since the 
worst case is that the machine will panic if there are an exceptionally 
large number of tasks, each with little memory usage at the time of oom.



oom: always return a badness score of non-zero for eligible tasks

A task's badness score is roughly a proportion of its rss and swap
compared to the system's capacity.  The scale ranges from 0 to 1000 with
the highest score chosen for kill.  Thus, this scale operates on a
resolution of 0.1% of RAM + swap.  Admin tasks are also given a 3% bonus,
so the badness score of an admin task using 3% of memory, for example,
would still be 0.

It's possible that an exceptionally large number of tasks will combine to 
exhaust all resources but never have a single task that uses more than
0.1% of RAM and swap (or 3.0% for admin tasks).

This patch ensures that the badness score of any eligible task is never 0
so the machine doesn't unnecessarily panic because it cannot find a task
to kill.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/oom_kill.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -208,8 +208,13 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
 	 */
 	points += p->signal->oom_score_adj;
 
-	if (points < 0)
-		return 0;
+	/*
+	 * Never return 0 for an eligible task that may be killed since it's
+	 * possible that no single user task uses more than 0.1% of memory and
+	 * no single admin tasks uses more than 3.0%.
+	 */
+	if (points <= 0)
+		return 1;
 	return (points < 1000) ? points : 1000;
 }
 
