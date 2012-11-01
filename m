Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762155Ab2KASc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 14:32:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab2KAScy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 14:32:54 -0400
Date: Thu, 1 Nov 2012 19:33:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] percpu_rw_semaphore: reimplement to not block the
	readers unnecessarily
Message-ID: <20121101183324.GA30442@redhat.com>
References: <20121017224430.GC2518@linux.vnet.ibm.com> <20121018162409.GA28504@redhat.com> <20121018163833.GK2518@linux.vnet.ibm.com> <20121018175747.GA30691@redhat.com> <20121019192838.GM2518@linux.vnet.ibm.com> <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com> <20121030184800.GA16129@redhat.com> <20121031194135.GA504@redhat.com> <20121031194158.GB504@redhat.com> <20121101154340.GH3027@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121101154340.GH3027@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul, thanks.

Sorry, I can't reply today, just one note...

On 11/01, Paul E. McKenney wrote:
>
> OK, so it looks to me that this code relies on synchronize_sched()
> forcing a memory barrier on each CPU executing in the kernel.

No, the patch tries to avoid this assumption, but probably I missed
something.

> 1.	A task running on CPU 0 currently write-holds the lock.
>
> 2.	CPU 1 is running in the kernel, executing a longer-than-average
> 	loop of normal instructions (no atomic instructions or memory
> 	barriers).
>
> 3.	CPU 0 invokes percpu_up_write(), calling up_write(),
> 	synchronize_sched(), and finally mutex_unlock().

And my expectation was, this should be enough because ...

> 4.	CPU 1 executes percpu_down_read(), which calls update_fast_ctr(),

since update_fast_ctr does preempt_disable/enable it should see all
modifications done by CPU 0.

IOW. Suppose that the writer (CPU 0) does

	percpu_done_write();
	STORE;
	percpu_up_write();

This means

	STORE;
	synchronize_sched();
	mutex_unlock();

Now. Do you mean that the next preempt_disable/enable can see the
result of mutex_unlock() but not STORE?

Oleg.

