Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1BAPxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 10:53:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab1BAPxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 10:53:45 -0500
Subject: Re: [PATCH v2 4/6] KVM-GST: KVM Steal time registration
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <4D45649A.4090709@redhat.com>
References: <1296244340-15173-1-git-send-email-glommer@redhat.com>
	 <1296244340-15173-5-git-send-email-glommer@redhat.com>
	 <4D45649A.4090709@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Tue, 01 Feb 2011 13:53:38 -0200
Message-ID: <1296575618.5081.13.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-30 at 15:16 +0200, Avi Kivity wrote:
> On 01/28/2011 09:52 PM, Glauber Costa wrote:
> > Register steal time within KVM. Everytime we sample the steal time
> > information, we update a local variable that tells what was the
> > last time read. We then account the difference.
> >
> >
> >
> >   static void kvm_guest_cpu_offline(void *dummy)
> >   {
> >   	kvm_pv_disable_apf(NULL);
> > +	native_write_msr(MSR_KVM_STEAL_TIME, 0, 0);
> >   	apf_task_wake_all();
> >   }
> 
> Don't use the native_ versions, they override the pvops implementation.  
> It doesn't matter for kvm, but we're not supposed to know this.

fair.

> > +	/*
> > +	 * using nanoseconds introduces noise, which accumulates easily
> > +	 * leading to big steal time values. We want, however, to keep the
> > +	 * interface nanosecond-based for future-proofness. The hypervisor may
> > +	 * adopt a similar strategy, but we can't rely on that.
> > +	 */
> > +	delta /= NSEC_PER_MSEC;
> > +	delta *= NSEC_PER_MSEC;
> 
> You're working around this problem both in the guest and host.  So even 
> if we fix it in one, it will still be broken in the other.

And if you notice, in two different ways:
I am (was) forcing to usecs in the host, and msecs in the guest.
One of the problems here, is that if we account steal time, we refrain
from accounting user / system time. Reason being, that if we account it,
we'll end up with more than HZ ticks per HZ, since we'll account ticks
as both steal and real.

And since the granularity of the cpu accounting is too coarse, we end up
with much more steal time than we should, because things that are less
than 1 unity of cputime, are often rounded up to 1 unity of cputime.

Now, I've already said that I will investigate further, and I'm ready to
back of from all of this. But assuming my analysis is right so far, what
if we keep things in nsecs or msecs, and only convert to cputime in the
time of read? This would allow us to just subtract steal time from
user/system time, in a more fine grained way.


