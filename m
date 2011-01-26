Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab1AZPgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 10:36:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab1AZPgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 10:36:14 -0500
Subject: Re: [PATCH 01/16] KVM-HDR: register KVM basic header infrastructure
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com
In-Reply-To: <4D4039CB.6060008@redhat.com>
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>
	 <1295892397-11354-2-git-send-email-glommer@redhat.com>
	 <4D400045.2000405@redhat.com>
	 <1296044013.15920.47.camel@mothafucka.localdomain>
	 <4D4039CB.6060008@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Wed, 26 Jan 2011 13:36:10 -0200
Message-ID: <1296056170.3591.14.camel@mothafucka.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 17:12 +0200, Avi Kivity wrote:
> On 01/26/2011 02:13 PM, Glauber Costa wrote:
> > >
> > >  - it doesn't lend itself will to live migration.  Extra state must be
> > >  maintained in the hypervisor.
> > Yes, but can be queried at any time as well. I don't do it in this
> > patch, but this is explicitly mentioned in my TODO.
> 
> Using the existing method (MSRs) takes care of this, which reduces churn.

No, it doesn't.

First, we have to explicitly list some msrs for save/restore in
userspace anyway. But also, the MSRs only holds values. For the case I'm
trying to hit here, being: msrs being used to register something, like
kvmclock, there is usually accompanying code as well.


> > >  - it isn't how normal hardware operates
> > Since we're trying to go for guest cooperation here, I don't really see
> > a need to stay close to hardware here.
> 
> For Linux there is not much difference, since we can easily adapt it.
> But we don't know the impact on other guests, and we can't refactor 
> them.  Staying close to precedent means it will be easier for other 
> guests to work with a kvm host, if they choose.

I honestly don't see the difference. I am not proposing anything
terribly different, in the end, for the sake of this specific point of
guest supportability it's all 1 msr+cpuid vs n msr+cpuid.

> 
> > >
> > >  what's wrong with extending the normal approach of one msr per feature?
> >
> > * It's harder to do discovery with MSRs. You can't just rely on getting
> > an error before the idts are properly setups. The way I am proposing
> > allow us to just try to register a memory area, and get a failure if we
> > can't handle it, at any time
> 
> Use cpuid to ensure that you won't get a #GP.
Again, that increases confusion, IMHO. Your hypervisor may have a
feature, userspace lack it, and then you end up figuring why something
does not work.

> 
> > * To overcome the above, we had usually relied on cpuids. This requires
> > qemu/userspace cooperation for feature enablement
> 
> We need that anyway.  The kernel cannot enable features on its own since 
> that breaks live migration.

That is true. But easy to overcome as well.

> > * This mechanism just bumps us out to userspace if we can't handle a
> > request. As such, it allows for pure guest kernel ->  userspace
> > communication, that can be used, for instance, to emulate new features
> > in older hypervisors one does not want to change. BTW, maybe there is
> > value in exiting to userspace even if we stick to the
> > one-msr-per-feature approach?
> 
> Yes.
> 
> I'm not 100% happy with emulating MSRs in userspace, but we can think 
> about a mechanism that allows userspace to designate certain MSRs as 
> handled by userspace.
> 
> Before we do that I'd like to see what fraction of MSRs can be usefully 
> emulated in userspace (beyond those that just store a value and ignore it).

None of the existing. But for instance, I was discussing this issue with
anthony a while ago, and he thinks that in order to completely avoid
bogus softlockups, qemu/userspace, which is the entity here that knows
when it has stopped (think ctrl+Z or stop + cont, save/restore, etc),
could notify this to the guest kernel directly through a shared variable
like this.

See, this is not about "new features", but rather, about between pieces
of memory. So what I'm doing in the end is just generalizing "an MSR for
shared memory", instead of one new MSR for each piece of data.

Maybe I was unfortunate to mention async_pf in the description to begin
with.

