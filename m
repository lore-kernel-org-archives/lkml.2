Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab0FAQiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 12:38:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59629 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab0FAQiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 12:38:09 -0400
Date: Tue, 1 Jun 2010 18:38:07 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Gleb Natapov <gleb@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, avi@redhat.com, hpa@zytor.com, mingo@elte.hu,
       npiggin@suse.de, tglx@linutronix.de, mtosatti@redhat.com
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
Message-ID: <20100601163807.GA11880@basil.fritz.box>
References: <20100601093515.GH24302@redhat.com> <87sk56ycka.fsf@basil.nowhere.org> <20100601162414.GA6191@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601162414.GA6191@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 07:24:14PM +0300, Gleb Natapov wrote:
> On Tue, Jun 01, 2010 at 05:53:09PM +0200, Andi Kleen wrote:
> > Gleb Natapov <gleb@redhat.com> writes:
> > >
> > > The patch below allows to patch ticket spinlock code to behave similar to
> > > old unfair spinlock when hypervisor is detected. After patching unlocked
> > 
> > The question is what happens when you have a system with unfair
> > memory and you run the hypervisor on that. There it could be much worse.
> > 
> How much worse performance hit could be?

It depends on the workload. Overall it means that a contended
lock can have much higher latencies.

If you want to study some examples see the locking problems the
RT people have with their heavy weight mutex-spinlocks.

But the main problem is that in the worst case you 
can see extremly long stalls (upto a second has been observed),
which then turns in a correctness issue.
> 
> > Your new code would starve again, right?
> > 
> Yes, of course it may starve with unfair spinlock. Since vcpus are not
> always running there is much smaller chance then vcpu on remote memory
> node will starve forever. Old kernels with unfair spinlocks are running
> fine in VMs on NUMA machines with various loads.

Try it on a NUMA system with unfair memory.

> > There's a reason the ticket spinlocks were added in the first place.
> > 
> I understand that reason and do not propose to get back to old spinlock
> on physical HW! But with virtualization performance hit is unbearable.

Extreme unfairness can be unbearable too.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
