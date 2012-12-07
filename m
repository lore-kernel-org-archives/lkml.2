Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423610Ab2LGR5c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 12:57:32 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59422 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423589Ab2LGR5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 12:57:30 -0500
Date: Fri, 7 Dec 2012 09:57:24 -0800
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, oleg@redhat.com,
        sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 1/9] CPU hotplug: Provide APIs to prevent CPU
 offline from atomic context
Message-ID: <20121207175724.GA2821@htj.dyndns.org>
References: <20121207173702.27305.1486.stgit@srivatsabhat.in.ibm.com>
 <20121207173759.27305.84316.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121207173759.27305.84316.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 07, 2012 at 11:08:13PM +0530, Srivatsa S. Bhat wrote:
> 4. No deadlock possibilities
> 
>    Per-cpu locking is not the way to go if we want to have relaxed rules
>    for lock-ordering. Because, we can end up in circular-locking dependencies
>    as explained in https://lkml.org/lkml/2012/12/6/290
> 
>    So, avoid per-cpu locking schemes (per-cpu locks/per-cpu atomic counters
>    with spin-on-contention etc) as much as possible.

I really can't say I like this approach.  percpu locking is very
tricky to get right and difficult to get right and we should try our
best to avoid implementing subsystem specific ones as much as
possible.  Also, I think the right approach would be auditing each
get_online_cpus_atomic() callsites and figure out proper locking order
rather than implementing a construct this unusual especially as
hunting down the incorrect cases shouldn't be difficult given proper
lockdep annotation.

lg_lock doesn't do local nesting and I'm not sure how big a deal that
is as I don't know how many should be converted.  But if nesting is an
absolute necessity, it would be much better to implement generic
rwlock variant (say, lg_rwlock) rather than implementing unusual
cpuhotplug-specific percpu synchronization construct.

Thanks.

-- 
tejun
