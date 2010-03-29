Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab0C2Wns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 18:43:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6445 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab0C2Wnr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 18:43:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=WmQFlFFNJNA/Xq7yCaoP3eGhJGNSps2P516XJ/mI43tm90JE2BjoULSu0ytHBbVNF
	3iIjJ6qRueKGnBhSddLWw==
MIME-Version: 1.0
In-Reply-To: <20100329211525.GA17703@linux.vnet.ibm.com>
References: <20100329211525.GA17703@linux.vnet.ibm.com>
Date: Mon, 29 Mar 2010 15:43:43 -0700
Message-ID: <6599ad831003291543r71300bcfv2957004bf2e927bb@mail.gmail.com>
Subject: Re: [PATCH tip/core/urgent] rcu: protect fork-time cgroup access
From: Paul Menage <menage@google.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com, abogani@texware.it
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 2:15 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> Add an rcu_read_lock() / rcu_read_unlock() pair to protect a fork-time
> cgroup access.  This seems likely to be a false positive.
>
> Located by: Alessio Igor Bogani <abogani@texware.it>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>
>  sched.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 9ab3cd7..d4bb5e0 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2621,7 +2621,9 @@ void sched_fork(struct task_struct *p, int clone_flags)
>        if (p->sched_class->task_fork)
>                p->sched_class->task_fork(p);
>
> +       rcu_read_lock();
>        set_task_cpu(p, cpu);
> +       rcu_read_unlock();

I think you're right that this is a false positive - it would only be
a problem if it were possible for the task to be moved to a different
cgroup, and I think that shouldn't be the case at this point in the
fork path since the new process isn't visible on the tasklist yet,
right?

Paul
