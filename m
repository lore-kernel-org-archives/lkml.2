Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab1AZPMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 10:12:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267Ab1AZPMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 10:12:19 -0500
Message-ID: <4D4039CB.6060008@redhat.com>
Date: Wed, 26 Jan 2011 17:12:11 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com
Subject: Re: [PATCH 01/16] KVM-HDR: register KVM basic header infrastructure
References: <1295892397-11354-1-git-send-email-glommer@redhat.com>	 <1295892397-11354-2-git-send-email-glommer@redhat.com>	 <4D400045.2000405@redhat.com> <1296044013.15920.47.camel@mothafucka.localdomain>
In-Reply-To: <1296044013.15920.47.camel@mothafucka.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2011 02:13 PM, Glauber Costa wrote:
> >
> >  - it doesn't lend itself will to live migration.  Extra state must be
> >  maintained in the hypervisor.
> Yes, but can be queried at any time as well. I don't do it in this
> patch, but this is explicitly mentioned in my TODO.

Using the existing method (MSRs) takes care of this, which reduces churn.

> >  - it isn't how normal hardware operates
> Since we're trying to go for guest cooperation here, I don't really see
> a need to stay close to hardware here.

For Linux there is not much difference, since we can easily adapt it.  
But we don't know the impact on other guests, and we can't refactor 
them.  Staying close to precedent means it will be easier for other 
guests to work with a kvm host, if they choose.

> >
> >  what's wrong with extending the normal approach of one msr per feature?
>
> * It's harder to do discovery with MSRs. You can't just rely on getting
> an error before the idts are properly setups. The way I am proposing
> allow us to just try to register a memory area, and get a failure if we
> can't handle it, at any time

Use cpuid to ensure that you won't get a #GP.

> * To overcome the above, we had usually relied on cpuids. This requires
> qemu/userspace cooperation for feature enablement

We need that anyway.  The kernel cannot enable features on its own since 
that breaks live migration.

> * This mechanism just bumps us out to userspace if we can't handle a
> request. As such, it allows for pure guest kernel ->  userspace
> communication, that can be used, for instance, to emulate new features
> in older hypervisors one does not want to change. BTW, maybe there is
> value in exiting to userspace even if we stick to the
> one-msr-per-feature approach?

Yes.

I'm not 100% happy with emulating MSRs in userspace, but we can think 
about a mechanism that allows userspace to designate certain MSRs as 
handled by userspace.

Before we do that I'd like to see what fraction of MSRs can be usefully 
emulated in userspace (beyond those that just store a value and ignore it).

-- 
error compiling committee.c: too many arguments to function

