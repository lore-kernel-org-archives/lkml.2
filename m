Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab0CYNfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 09:35:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36302 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab0CYNfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:35:36 -0400
X-Authority-Analysis: v=1.0 c=1 a=TA12unEhaaEA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=95YEHrbnwv_LDzxmKCAA:9 a=iv_ju_PtrkfUbh0qxrfNb-SiSMYA:4 a=PUjeQqilurYA:10 a=Kf_ysI2uTWo9o-o-:21 a=ZiO1URjKHhpOG1Kn:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: sched_wakeup_new and sched_kthread_stop events cause great
 overload
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4BAB2EAF.2030804@cn.fujitsu.com>
References: <4BAB2EAF.2030804@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 25 Mar 2010 09:35:33 -0400
Message-ID: <1269524133.2957.4067.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-25 at 17:36 +0800, Xiao Guangrong wrote:
> We have done sysbench test for ftrace's performance and it looks sched_wakeup_new
> and sched_kthread_stop events can cause great overload.
> 
> When we only enable sched_wakeup_new and sched_kthread_stop events, sysbench.threads
> shows the overload is 10%, sysbench.mutex shows the overload is 7.5%.
> 
> The more weird thing is that we found the sched_kthread_stop event is never called
> in this test, the test steps as follow:
> 
> echo > debugfs/tracing/set_event
> echo 1 > debugfs/tracing/events/sched/sched_wakeup_new/enable
> echo 1 > debugfs/tracing/events/sched/sched_kthread_stop/enable
> 
> com_opt="--num-threads=5000 --max-requests=50000"
> echo > debugfs/tracing/trace
> sysbench $com_opt --test=threads --thread-yields=1000 --thread-locks=10000 run >& log
> [or sysbench $com_opt --test=mutex --mutex-num=100 --mutex-locks=50000 --mutex-loops=10000 run for mutex]
> echo > debugfs/tracing/set_event
> 
> For sysbench.threads:
> cat debugfs/tracing/trace | grep "sched_wakeup_new" | wc -l
> 5001
> cat debugfs/tracing/trace | grep "sched_kthread_stop" | wc -l
> 0

Strange? So if you did:

cat debugfs/tracing/trace | wc -l

you should get 5005?

> 
> For sysbench.mutex:
> cat debugfs/tracing/trace | grep "sched_wakeup_new" | wc -l
> 5001
> cat debugfs/tracing/trace | grep "sched_kthread_stop" | wc -l
> 0
> 
> And, if only enable sched_kthread_stop event, the sysbench.threads's
> overload is 5.90%, the sysbench.mutex's overload is 3.36%.

Could be something that messes with the cache lines?

> 
> It hardly explain why sched_kthread_stop is never called but cause great overload.

Would be worth running perf against this test, to see where the issues
are occurring.

-- Steve


