Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab1HQVuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 17:50:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324Ab1HQVuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 17:50:23 -0400
Date: Thu, 18 Aug 2011 00:50:15 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org
Subject: Re: RCU treating guest mode just like it does user-mode execution
Message-ID: <20110817215015.GA6423@redhat.com>
References: <20110817204327.GA10633@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110817204327.GA10633@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 01:43:27PM -0700, Paul E. McKenney wrote:
> Hello, Gleb,
> 
> I was looking at KVM's call to rcu_virt_note_context_switch()
> in kvm_guest_enter(), and noting the comment talking about treating
> guest mode like user-mode execution is.  One difference between RCU's
> treatment of KVM guest execution and user-mode execution is that RCU
> notes a context switch only at the beginning of KVM guest execution,
> but notes user-mode execution at every scheduling-clock interrupt.
> 
> Does it make sense to also note KVM guest execution on each
> scheduling-clock interrupt?  One reason it might not make sense is
> if interrupts from KVM guest execution appear to rcu_check_callbacks()
> as interrupts from user-mode execution.  (Do they?  Given that people
> are reporting RCU CPU stall warnings in virtualized environments, I
> am beginning to suspect that the answer is "no".)
> 
The answer is "no" because any interrupt kicks cpu out of a guest mode, so
it appears to be in the kernel for RCU. Do people still reporting RCU
stalls even with the my patch?

> If KVM guest execution does not appear as user-mode execution to
> rcu_check_callback(), I would consider doing the following:
> 
> 1.	Rename rcu_virt_note_context_switch() to something like
> 	rcu_guest_execution_start().
> 
> 2.	Place a call to a new rcu_guest_execution_end() in
> 	kvm_guest_exit().
> 
> 3.	Make rcu_guest_execution_start() and rcu_guest_execution_end()
> 	set and clear a new per-CPU variable.
There is such variable already: current->flags & PF_VCPU.

> 
> 4.	Make rcu_check_callbacks() check this per-CPU variable in
> 	much the same way that it currently checks its "user"
> 	argument, aside from needing to check that the CPU is
> 	not in an interrupt handler or some such.
> 
> Of course, some thought is required to make sure that the checks for
> executing in an interrupt handler actually cover all of the needed
> situations, but so it goes!
> 
> Thoughts?
I wonder why it will be better than current situation. After cpu leaves
a guest mode there are only three options. It will either go to
userspace, execute schedule or go back to guest mode. At all those cases
RCU should note quiescent state.

--
			Gleb.
