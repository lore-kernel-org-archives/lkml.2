Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab2LWXn2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 18:43:28 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63967 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab2LWXn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 18:43:26 -0500
MIME-Version: 1.0
In-Reply-To: <1356057332.5896.81.camel@gandalf.local.home>
References: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
	<1356057332.5896.81.camel@gandalf.local.home>
Date: Mon, 24 Dec 2012 00:43:25 +0100
Message-ID: <CAFTL4hy_k8rWg5EAFnh-owey7NJCQbK+ULrkNrSjgdynzEseTw@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.7-nohz1
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/21 Steven Rostedt <rostedt@goodmis.org>:
> On Thu, 2012-12-20 at 19:32 +0100, Frederic Weisbecker wrote:
>> Let's imagine you have 4 CPUs. We keep the CPU 0 to offline RCU callbacks there and to
>> handle the timekeeping. We set the rest as full dynticks. So you need the following kernel
>> parameters:
>>
>>       rcu_nocbs=1-3 full_nohz=1-3
>>
>> (Note rcu_nocbs value must always be the same as full_nohz).
>
> Why? You can't have: rcu_nocbs=1-4 full_nohz=1-3

That should be allowed.

>   or: rcu_nocbs=1-3 full_nohz=1-4 ?

But that not.

You need to have: rcu_nocbs & full_nohz == full_nohz. This is because
the tick is not there to maintain the local RCU callbacks anymore. So
this must be offloaded to the rcu_nocb threads.

I just have a doubt with rcu_nocb. Do we still need the tick to
complete the grace period for local rcu callbacks? I need to discuss
that with Paul.

>
> That needs to be fixed. Either with a warning, and/or to force the two
> to be the same. That is, if they specify:
>
>   rcu_nocbs=1-3 full_nohz=1-4
>
> Then set rcu_nocbs=1-4 with a warning about it. Or simply set
>  full_nohz=1-3.

Yep, will do.

Thanks!

>
> -- Steve
>
>>
>> Now if you want proper isolation you need to:
>>
>> * Migrate your processes adequately
>> * Migrate your irqs to CPU 0
>> * Migrate the RCU nocb threads to CPU 0. Example with the above configuration:
>>
>>       for p in $(ps -o pid= -C rcuo1,rcuo2,rcuo3)
>>       do
>>               taskset -cp 0 $p
>>       done
>>
>> Then run what you want on the full dynticks CPUs. For best results, run 1 task
>> per CPU, mostly in userspace and mostly CPU bound (otherwise more IO = more kernel
>> mode execution = more chances to get IPIs, tick restarted, workqueues, kthreads, etc...)
>>
>> This page contains a good reminder for those interested in CPU isolation: https://github.com/gby/linux/wiki
>>
>> But keep in mind that my tree is not yet ready for serious production.
>>
>
>
