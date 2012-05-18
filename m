Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab2ERPgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:36:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:59275 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab2ERPf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:35:57 -0400
Message-ID: <1337355341.573.68.camel@twins>
Subject: Re: [tip:sched/numa] sched/numa: Introduce sys_numa_{t,m}bind()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, pjt@google.com, cl@linux.com,
        bharata.rao@gmail.com, akpm@linux-foundation.org,
        Lee.Schermerhorn@hp.com, aarcange@redhat.com, danms@us.ibm.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Date: Fri, 18 May 2012 17:35:41 +0200
In-Reply-To: <4FB66756.2060302@redhat.com>
References: <tip-nf7brf1b88w0ojwuf689xeet@git.kernel.org>
	 <4FB66756.2060302@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 11:14 -0400, Rik van Riel wrote:
> 
> I am not convinced this is the right way forward.

Well, you don't have to use it.. but you can.

> While this may work well for programs written in languages
> with pointers, and for virtual machines, I do not see how
> eg. a JVM could provide useful hints to the kernel, because
> the Java program running on top has no idea about the
> memory addresses of its objects, and the Java language has
> no way to hint which thread will be the predominant user
> of an object.

This is one of the many reasons why you'll never see me use Java or any
other 'managed' language. 

> I like your code for handling smaller processes in NUMA
> systems, but we do need to have a serious discussion on
> how to handle processes that do not fit in one node.
> 
> The more I think about it, the more Andrea's code looks
> like it might be the more flexible way forward.

I still have serious concerns about his approach; it very much assumes
there's a temporal page<->thread relation to exploit. This might not at
all be true for some programs (including JVM) that have hardly any data
separation and just point chase their way around the entire object set.

Consider a database where each thread is basically scanning the global
data-set at random.

Furthermore, virtual machines actively counter this assumption, a guest
scheduler will move tasks between vcpus at will -- for the host this
effective scrambles any page<->thread (vcpu) relation that might have
existed.

I've also yet to see a coherent patch-set from Andrea with coherent
changelogs and comments (this very much precludes PDFs of any kind).

And you know I detest the way he cobbled his way around the scheduler
instead of integrating it properly. And I'll very much not accept
anything like the spaghetti code anywhere near the scheduler I have to
maintain. (I recently looked at the THP code and if that's the standard
I'm not having it).

That said, I'll leave the door open and will consider something like his
scanning stuff as an optional add on on-top of this.

I very much believe in doing the simple thing first, and this is that,
this is much like what the userspace daemons try to do and many of the
traditional Unixes have also done (albeit many of those didn't go the
way of home-node migration).

> Another topic to discuss is whether we want lazy
> migrate-on-fault, or if we want to keep the program
> spend its time running, using another (idle) core to
> do the migration in the background.

I've also said many times over that I absolutely detest all the async
stuff because it messes up accounting. And until someone comes up with a
sane means of sorting that I'll stick to migrate-on-fault.

You also assume there's idle time elsewhere. This isn't true in general.


