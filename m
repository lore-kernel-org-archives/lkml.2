Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab0EKMfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 08:35:53 -0400
Received: from mail.openrapids.net ([64.15.138.104]:46015 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752165Ab0EKMfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 08:35:52 -0400
Date: Tue, 11 May 2010 08:35:50 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH -tip 1/5] [CLEANUP] kprobes: Remove redundant
	text_mutex lock in optimize
Message-ID: <20100511123550.GB25418@Krystal>
References: <20100510175313.27396.34605.stgit@localhost6.localdomain6> <20100510175320.27396.49896.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510175320.27396.49896.stgit@localhost6.localdomain6>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 08:27:50 up 108 days, 15:04, 10 users,  load average: 0.28, 0.27,
	0.26
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Remove text_mutex locking in optimize_all_kprobes, because
> that function doesn't modify text but just order optimization
> to worker.

Hi Masami,

A few comments:

1) optimize_all_kprobes/unoptimize_all_kprobes should have comments saying that
they are always called with kprobe_mutex held.

2) The sentence above in the changelog could be changed into:

 ..."because this function doesn't modify text. It simply queues optimizations
for the kprobe_optimizer worker thread."

3)

static DEFINE_MUTEX(kprobe_mutex);      /* Protects kprobe_table */

.. should also state that it protects optimizing_list.

Thanks,

Mathieu

> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Jim Keniston <jkenisto@us.ibm.com>
> Cc: Jason Baron <jbaron@redhat.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---
> 
>  kernel/kprobes.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> index 282035f..1d34eef 100644
> --- a/kernel/kprobes.c
> +++ b/kernel/kprobes.c
> @@ -606,14 +606,12 @@ static void __kprobes optimize_all_kprobes(void)
>  		return;
>  
>  	kprobes_allow_optimization = true;
> -	mutex_lock(&text_mutex);
>  	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
>  		head = &kprobe_table[i];
>  		hlist_for_each_entry_rcu(p, node, head, hlist)
>  			if (!kprobe_disabled(p))
>  				optimize_kprobe(p);
>  	}
> -	mutex_unlock(&text_mutex);
>  	printk(KERN_INFO "Kprobes globally optimized\n");
>  }
>  
> 
> 
> -- 
> Masami Hiramatsu
> e-mail: mhiramat@redhat.com

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
