Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab1D0H45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 03:56:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab1D0H44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 03:56:56 -0400
Date: Wed, 27 Apr 2011 10:56:47 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: paulmck@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: RCU+KVM: making CPU guest mode a quiescent state.
Message-ID: <20110427075647.GJ2265@redhat.com>
References: <20110426123824.GD22443@redhat.com>
 <20110426155528.GD2135@linux.vnet.ibm.com>
 <4DB7C9F8.5070906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB7C9F8.5070906@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 10:47:04AM +0300, Avi Kivity wrote:
> On 04/26/2011 06:55 PM, Paul E. McKenney wrote:
> >On Tue, Apr 26, 2011 at 03:38:24PM +0300, Gleb Natapov wrote:
> >>  Hello Paul,
> >>
> >>  I have a question about RCU + KVM. KVM does not hold any references to RCU
> >>  protected data when it switches CPU into a guest mode. In fact switching
> >>  to a guest mode is very similar to exiting to userspase from RCU point
> >>  of view. In addition CPU may stay in a guest mode for quite a long time
> >>  (up to one time slice). It looks like it will be beneficial to treat guest
> >>  mode as quiescent state, just like user-mode execution. How can this be
> >>  done? I was trying to find how RCU knows about cpu entering user-mode,
> >>  but it seems that it does this by checking CPU mode in a timer interrupt
> >>  (update_process_times()->rcu_check_callbacks()). This will not work for
> >>  guest mode detection since timer interrupt will kick CPU out of a guest
> >>  mode and timer interrupt will always see CPU in kernel mode. Do we have
> >>  a simple function to call to notify RCU that CPU passed quiescent state
> >>  which we can call just before entering guest?
> >
> >Hello, Gleb,
> >
> >You could call rcu_note_context_switch(), passing it the current
> >CPU.  Please note that preemption -must- be disabled when calling
> >this.  You could call this just after exiting the guest as well
> >as just before entering guest.
> >
> 
> It's expected that after exiting, we'd spend a very short time in
> the kernel, and then either re-enter the guest, exit to userspace,
> or switch to another task.  So I think calling it just before entry
> should be sufficient.
Definitely. This will allow other CPUs to complete rcu barrier much
earlier.

> 
> Looking at the code, I see rcu_note_context_switch() calls
> rcu_sched_qs(), which does
> 
>     rdp->passed_quiesc_completed = rdp->gpnum - 1;
>     barrier();
>     rdp->passed_quiesc = 1;
> 
> and also calls rcu_preempt_note_context_switch(), which calls
> rcu_preempt_qs(), which does
> 
>     rdp->passed_quiesc_completed = rdp->gpnum - 1;
>     barrier();
>     rdp->passed_quiesc = 1;
>     current->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
> 
> the similarity is remarkable.  Is this intended?  Or did I get lost
> in a maze of #ifdefs?
> 
One of them works on rcu_sched_data another on rcu_preempt_data as far
as I see.

--
			Gleb.
