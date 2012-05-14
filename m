Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828Ab2EOB1r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 21:27:47 -0400
Received: from ozlabs.org ([203.10.76.45]:49626 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932652Ab2EOB1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 21:27:46 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, anton@samba.org,
        Arnd Bergmann <arnd@arndb.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PULL] cpumask: finally make them variable size w/ CPUMASK_OFFSTACK.
In-Reply-To: <4FAB6363.4080808@gmail.com>
References: <87ipg5c2bk.fsf@rustcorp.com.au> <4FAB1AC9.1050306@gmail.com> <871umsdbm0.fsf@rustcorp.com.au> <4FAB2B5B.4020902@gmail.com> <87vck4bppw.fsf@rustcorp.com.au> <4FAB6363.4080808@gmail.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 14 May 2012 12:28:49 +0930
Message-ID: <87zk9btqmu.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2012 02:42:43 -0400, KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:
> (5/10/12 12:54 AM), Rusty Russell wrote:
> > On Wed, 09 May 2012 22:43:39 -0400, KOSAKI Motohiro<kosaki.motohiro@gmail.com>  wrote:
> >>> Or is there a reason we shouldn't even try to allocate here?
> >>
> >> 1) your code always use GFP_KERNEL. it is trouble maker when alloc_pages w/ GFP_ATOMIC.
> >
> > Oh :(
> >
> > How about the below instead?
> 
> This code still slow than original. when calling reclaim path, new allocation is almost always
> fail. then, your code almost always invoke all cpu batch invalidation. i.e. many ipi.

I don't know this code.  Does that happen often?  Do we really need to
optimize the out-of-memory path?

But I should have used on_each_cpu_cond() helper which does this for us
(except it falls back to individial IPIs) which would make this code
neater.

> >> 2) When CONFIG_CPUMASK_OFFSTACK=n and NR_CPUS is relatively large, cpumask on stack may
> >> cause stack overflow. because of, alloc_pages() can be called from
> >> very deep call stack.
> >
> > You can't have large NR_CPUS without CONFIG_CPUMASK_OFFSTACK=y,
> > otherwise you'll get many other stack overflows, too.
> 
> Original code put cpumask bss instead stack then. :-)

Yes, and this is what it looks like if we convert it directly, but I
still don't want to encourage people to do this :(

Cheers,
Rusty.

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1179,7 +1179,7 @@ void drain_all_pages(void)
 	 * Allocate in the BSS so we wont require allocation in
 	 * direct reclaim path for CONFIG_CPUMASK_OFFSTACK=y
 	 */
-	static cpumask_t cpus_with_pcps;
+	static DECLARE_BITMAP(cpus_with_pcps, NR_CPUS);
 
 	/*
 	 * We don't care about racing with CPU hotplug event
@@ -1197,11 +1197,12 @@ void drain_all_pages(void)
 			}
 		}
 		if (has_pcps)
-			cpumask_set_cpu(cpu, &cpus_with_pcps);
+			cpumask_set_cpu(cpu, to_cpumask(cpus_with_pcps));
 		else
-			cpumask_clear_cpu(cpu, &cpus_with_pcps);
+			cpumask_clear_cpu(cpu, to_cpumask(cpus_with_pcps));
 	}
-	on_each_cpu_mask(&cpus_with_pcps, drain_local_pages, NULL, 1);
+	on_each_cpu_mask(to_cpumask(cpus_with_pcps),
+			 drain_local_pages, NULL, 1);
 }
 
 #ifdef CONFIG_HIBERNATION
