Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab2C0IA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 04:00:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16898 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751229Ab2C0IA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 04:00:57 -0400
X-IronPort-AV: E=Sophos;i="4.75,325,1330876800"; 
   d="scan'208";a="4628802"
Message-ID: <4F7174F0.1080504@cn.fujitsu.com>
Date: Tue, 27 Mar 2012 16:06:08 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org, torvalds@linux-foundation.org
Subject: Re: [PATCH RFC] rcu: Make __rcu_read_lock() inlinable
References: <20120325205249.GA29528@linux.vnet.ibm.com>
In-Reply-To: <20120325205249.GA29528@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-27 15:58:36,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-27 15:58:42,
	Serialize complete at 2012-03-27 15:58:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2012 04:52 AM, Paul E. McKenney wrote:

> +void rcu_switch_from(void)
>  {
> -	current->rcu_read_lock_nesting++;
> -	barrier();  /* needed if we ever invoke rcu_read_lock in rcutree.c */
> +	current->rcu_read_lock_nesting_save =
> +		__this_cpu_read(rcu_read_lock_nesting);
> +	barrier();
> +	__this_cpu_write(rcu_read_lock_nesting, 0);

-	__this_cpu_write(rcu_read_lock_nesting, 0);
+	__this_cpu_write(rcu_read_lock_nesting, 1);

if prev or next task has non-zero rcu_read_unlock_special,
"__this_cpu_write(rcu_read_lock_nesting, 1)" will prevent wrong qs reporting
when rcu_read_unlock() is called in any interrupt/tracing while doing switch_to().

> +}
> +
> +/*
> + * Restore the incoming task's value for rcu_read_lock_nesting at the
> + * end of a context switch.
> + */
> +void rcu_switch_to(void)
> +{
> +	__this_cpu_write(rcu_read_lock_nesting,
> +			 current->rcu_read_lock_nesting_save);
> +	barrier();
> +	current->rcu_read_lock_nesting_save = 0;
>  }

-	barrier();
-	current->rcu_read_lock_nesting_save = 0;

rcu_read_lock_nesting_save is set but not used before next set here, just remove it.


I don't like it hooks too much into scheduler.

Approaches:
0) stay using function call
1) hook into kbuild(https://lkml.org/lkml/2011/3/27/170,https://lkml.org/lkml/2011/3/27/171)
2) hook into scheduler(still need more works for rcu_read_unlock())
3) Add rcu_read_lock_nesting to thread_info like preempt_count
4) resolve header-file dependence

For me
3=4>1>2>0

Thanks,
Lai
