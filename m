Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab0LRPwp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 10:52:45 -0500
Received: from mail-bw0-f66.google.com ([209.85.214.66]:64650 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263Ab0LRPwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 10:52:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rNoWYnXpLCBN/Fuh6kVIlblhV6okrOecip5Pq4lkIomnPvzOf5IoNrW7uKWncQaccY
         lHXsqIRsOtm70prh2QXDU7Wxk7e8Z3vIKL6PWa3S02PqA5CdFoIFjbRji7tFFZG7cO6D
         mxeTRD9VGMLPiqyttGNZKXB8o+IXn5GtYfzRA=
Message-ID: <4D0CD8C7.8070604@kernel.org>
Date: Sat, 18 Dec 2010 16:52:39 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com
Subject: Re: [PATCH RFC tip/core/rcu 11/20] rcu: fix race condition in synchronize_sched_expedited()
References: <20101217205433.GA10199@linux.vnet.ibm.com> <1292619291-2468-11-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1292619291-2468-11-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/17/2010 09:54 PM, Paul E. McKenney wrote:
> The new (early 2010) implementation of synchronize_sched_expedited() uses
> try_stop_cpu() to force a context switch on every CPU.  It also permits
> concurrent calls to synchronize_sched_expedited() to share a single call
> to try_stop_cpu() through use of an atomically incremented
> synchronize_sched_expedited_count variable.  Unfortunately, this is
> subject to failure as follows:
> 
> o	Task A invokes synchronize_sched_expedited(), try_stop_cpus()
> 	succeeds, but Task A is preempted before getting to the atomic
> 	increment of synchronize_sched_expedited_count.
> 
> o	Task B also invokes synchronize_sched_expedited(), with exactly
> 	the same outcome as Task A.
> 
> o	Task C also invokes synchronize_sched_expedited(), again with
> 	exactly the same outcome as Tasks A and B.
> 
> o	Task D also invokes synchronize_sched_expedited(), but only
> 	gets as far as acquiring the mutex within try_stop_cpus()
> 	before being preempted, interrupted, or otherwise delayed.
> 
> o	Task E also invokes synchronize_sched_expedited(), but only
> 	gets to the snapshotting of synchronize_sched_expedited_count.
> 
> o	Tasks A, B, and C all increment synchronize_sched_expedited_count.
> 
> o	Task E fails to get the mutex, so checks the new value
> 	of synchronize_sched_expedited_count.  It finds that the
> 	value has increased, so (wrongly) assumes that its work
> 	has been done, returning despite there having been no
> 	expedited grace period since it began.
> 
> The solution is to have the lowest-numbered CPU atomically increment
> the synchronize_sched_expedited_count variable within the
> synchronize_sched_expedited_cpu_stop() function, which is under
> the protection of the mutex acquired by try_stop_cpus().  However, this
> also requires that piggybacking tasks wait for three rather than two
> instances of try_stop_cpu(), because we cannot control the order in
> which the per-CPU callback function occur.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: Tejun Heo <tj@kernel.org>

I suppose this should go -stable?

-- 
tejun
