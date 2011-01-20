Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab1ATFz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 00:55:26 -0500
Received: from mail.openrapids.net ([64.15.138.104]:36466 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755239Ab1ATFzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 00:55:25 -0500
Date: Thu, 20 Jan 2011 00:55:23 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Chris Mason <chris.mason@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH -v10 0/4] Lock-less list
Message-ID: <20110120055523.GA27974@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295245019-7816-1-git-send-email-ying.huang@intel.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 00:28:46 up 57 days, 10:31,  1 user,  load average: 0.05, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,

I just found out about your lockless linked-list implementation, it looks
interesting. Paul McKenney and myself have created a similar implementation for
userspace within the Userspace RCU project, you might want to have a look (it's
LGPLv2.1).

One point about semantic: a singly-linked list for which you can either delete
the first element or all the elements should probably be called a stack ? I'm
therefore going to refer to "push/pop" in this email rather than "add/delete".

We've got two linked-list stack implementations in the userspace RCU tree:

One has wait-free push, and blocking pop. Useful if you can afford to block when
you pop from the list. There is no restriction on the number of concurrent
push/pop to/from the list. The code is at:

http://git.lttng.org/?p=userspace-rcu.git;a=blob;f=urcu/wfstack-static.h

The other has lock-free push and pop, no restriction on the number of concurrent
push/pop, but uses a clever trick that ensures that the cmpxchg loop will never
see a re-used pointer by using a RCU read-side to protect from memory reclaim.
It therefore requires that the memory used for the list must only be freed after
a RCU grace period. The code is at:

http://git.lttng.org/?p=userspace-rcu.git;a=blob;f=urcu/rculfstack-static.h

We could probably extend this to allow popping all stack entries in one go, but
I haven't given it much thought. 

We also have queue implementations (enqueue at head, dequeue at tail). The first
has wait-free enqueue/blocking dequeue and the second has lock-free
enqueue/dequeue. We use the wait-free enqueue/blocking dequeue queue to push
RCU callbacks when call_rcu() is executed from real-time threads, and we then
dequeue the callbacks to execute with a blocking thread. The lock-free
enqueue/dequeue queue also needs a reference count on the "dummy" node it keeps
in addition to use RCU to delay memory reclamation (see comments in the code).

wait-free enqueue/blocking dequeue:

http://git.lttng.org/?p=userspace-rcu.git;a=blob;f=urcu/wfqueue-static.h

lock-free enqueue/dequeue (beware, the refcounting makes the API less elegant
than the other implementations):

http://git.lttng.org/?p=userspace-rcu.git;a=blob;f=urcu/rculfqueue-static.h

Hoping this might be helpful to you,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
