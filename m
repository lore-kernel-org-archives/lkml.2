Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659Ab0ELPvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 11:51:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37694 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab0ELPvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 11:51:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=L5/TDJHRzpOl1HAlnbdjE9l2Vb/qYNw7T+6bIAQUXdAybKXV1v7XN+zX9mstQdkIBz
         HQx9sD/gV2YG3oEiBwp0QxY/x3KJ8r5MVzMFu1+Npk8pw6dPJVX7iOvet4JPkoRxOSle
         3VExP28t7bXXlT/jHSdSgLw4usqsCL0D9HoIM=
Date: Wed, 12 May 2010 17:51:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH] perf lock: Drop "-a" option from set of default
	arguments to cmd_record()
Message-ID: <20100512155136.GG5405@nowhere>
References: <4BE51A90.2060305@dcl.info.waseda.ac.jp> <1273306229-5216-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20100508161404.GB5444@nowhere> <4BE6CC5F.2020503@dcl.info.waseda.ac.jp> <20100511064809.GA5468@nowhere> <4BEA819B.5020602@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BEA819B.5020602@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 07:23:23PM +0900, Hitoshi Mitake wrote:
> On 05/11/10 15:48, Frederic Weisbecker wrote:
>
> >>>
> >>> I think I'm going to unearth the injection code to reduce the size
> >>> of these events.
> >>>
> >>>
> >>
> >> Yeah, injection will be really helpful thing.
> >>
> >> And I have a rough idea for reducing event frequency.
> >>
> >> Many lock event sequences are like this form:
> >>   * acquire ->  acquired ->  release
> >>   * acquire ->  contended ->  acquired ->  release
> >> I think that making 3 or 4 events per each lock sequences
> >> is waste of CPU time and memory space.
> >>
> >> If threads store time of each events
> >> and make only 1 event at time of release,
> >> we will be able to reduce lots of time and space.
> >>
> >> For example, ID of each lock instance is 8 byte in x86_64.
> >> In this scheme 8 * 4 byte for ID will be only 8 byte.
> >> I think this optimization has worth to consider because of
> >> high frequency of lock events.
> >>
> >> How do you think?
> >
> >
> > You're right, we could optimize the lock events sequence layout.
> > What I'm afraid of is to break userspace, but ripping the name from
> > the lock events while introducing injection will break userspace  
> anyway :-(
>
> Really? For me, at least ripping the name with injection
> doesn't make bad things for userspace.
> What does the word "break" mean in this context?


The fact that tools which relied on the name field in the lock events
won't work anymore as it will be present on lock_init_class only.



> >
> > May be we can think about providing new lock events and announce the
> > deprecation of the old ones and remove them later. I'm not sure yet.
> >
> > But summing up in only one event is not possible. Having only one
> > lock_release event (and a lock init for name mapping) is suitable
> > for latency measurements only (timestamp + lock addr + wait time +
> > acquired time).
> > And once you dig into finer grained analysis like latency induced
> > by dependencies (take lock A and then take lock B under A, latency
> > of B depends of A), then you're screwed, because you only know
> > you've released locks at given times but you don't know when you
> > acquired them, hence you can't build a tree of dependencies with
> > sequences inside.
>
> In my imagination, composing 3 or 4 events into one is meaning
> timestamp of itself(it is also one of release) + lock addr
> + timestamp of acquire + timestamp of acquired
> (+ timestamp of contended) + misc information
> like flags.



Ah I see.



> I'd like to call this new event as "batch event" in below.
>
> If perf lock reads one batch event, original events of 3 or 4
> can be reconstructed in userspace.
> So I think dependency relation between locks can be obtained
> with sorting reconstructed events with timestamp.
>
> For this way, each threads have to hold memory for
> size of batch event * MAX_LOCK_DEPTH.
>
> I'm not sure about possibility and effect of this way :(
> and if I misunderstood something about your opinion, please correct me



Ok it would be indeed more efficient for what we want with perf lock.
But I see drawbacks with this: other people might be interested
in only few of these events. Someone may want to count lock_contended
events only to produce simple contention stats for example, and this
user will have in turn larger traces than he was supposed to with
this batch event.

I think it's usually better to divide the problems into smaller
problems. And here it's about dividing a high level meaning
(a lock sequence) into smaller and lower level meanings (a lock
event). Following this rule makes tracing much more powerful IMO.

A lock acquire event has also an isolated meaning outside the
whole lock sequence, like in my above lock_contended example,
it can be useful alone for someone.



> > We could even remove lock_acquire and only play with lock_acquired,
> > changing a bit the rules, but that will make us lose all the dependencies
> > "intra-lock". I mean there are locks which slowpath are implemented on 
> top
> > of other locks: mutexes use mutex->wait_lock spinlock for example.
> >
> >
>
> Do you mean that the relation like acquire(mutex) -> acquire(spinlock)
> -> acquired(spinlock) -> acquired(mutex) -> release(spinlock)
> will be lost?


Yep.


> It seems taht locks on other locks are only mutex and rwsem.
> I think that we have a way to rewrite their lock events
> of mutex and rwsem for intra-lock dependencies.
>
> But I cannot measure the actual cost of it :(
> So I cannot say easily this is possible...


But still I think it's useful to keep lock_contended and
lock_acquired. They have an important meaning alone.

