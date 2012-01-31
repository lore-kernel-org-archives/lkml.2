Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab2AaNrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:47:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab2AaNrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:47:32 -0500
Message-ID: <4F27F0E6.1040309@redhat.com>
Date: Tue, 31 Jan 2012 15:47:18 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Paul E. McKenney" <paulmck@us.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: Re: [RFC][PATCH] srcu: Implement call_srcu()
References: <1328016724.2446.229.camel@twins>
In-Reply-To: <1328016724.2446.229.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2012 03:32 PM, Peter Zijlstra wrote:
> Subject: srcu: Implement call_srcu()
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon Jan 30 23:20:49 CET 2012
>
> Implement call_srcu() by using a state machine driven by
> call_rcu_sched() and timer callbacks.
>
> The state machine is a direct derivation of the existing
> synchronize_srcu() code and replaces synchronize_sched() calls with a
> call_rcu_sched() callback and the schedule_timeout() calls with simple
> timer callbacks.
>
> It then re-implements synchronize_srcu() using a completion where we
> send the complete through call_srcu().
>
> It completely wrecks synchronize_srcu_expedited() which is only used
> by KVM. 3 of the 5 

2 of the 5

> use cases look like they really want to use
> call_srcu() instead, the remaining 2 I don't know but hope they can,
> which would let us remove it.

They really need to return quickly to userspace, and they really need to
perform some operation between rcu_assign_pointer() and returning, so no.

>
> Compile tested only!! :-)
>

How much did synchronize_srcu_expedited() regress?  Presumably your
compiler didn't tell you that.

Can we get it back to speed by scheduling a work function on all cpus? 
wouldn't that force a quiescent state and allow call_srcu() to fire?

In kvm's use case synchronize_srcu_expedited() is usually called when no
thread is in a critical section, so we don't have to wait for anything
except the srcu machinery.

-- 
error compiling committee.c: too many arguments to function

