Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199Ab0EKGsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 02:48:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41637 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab0EKGsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 02:48:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=k+TOJKJ/Mep4iJ/tJCq8c4yH3xJ2OUCDs14N4RIRwBNBLIg0RQvcDWvagNMbrFtjNV
         Wu+leFE2AjwgjXWqCktTGSv13JQ3BFwl1oODeok7NIX2JirY03Plfxa10outmadE1FJA
         qIZD575vJJzEdt16z7wSJytbmmK0rovdT64TM=
Date: Tue, 11 May 2010 08:48:12 +0200
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
Message-ID: <20100511064809.GA5468@nowhere>
References: <4BE51A90.2060305@dcl.info.waseda.ac.jp> <1273306229-5216-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20100508161404.GB5444@nowhere> <4BE6CC5F.2020503@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE6CC5F.2020503@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 09, 2010 at 11:53:19PM +0900, Hitoshi Mitake wrote:
> On 05/09/10 01:14, Frederic Weisbecker wrote:
> > On Sat, May 08, 2010 at 05:10:29PM +0900, Hitoshi Mitake wrote:
> >> This patch drops "-a" from record_args, which is passed to cmd_record().
> >>
> >> Even if user wants to record all lock events during process runs,
> >>          perf lock record -a<program>  <argument>  ...
> >> is enough for this purpose.
> >>
> >> This can reduce size of perf.data.
> >>
> >> % sudo ./perf lock record whoami
> >> root
> >> [ perf record: Woken up 1 times to write data ]
> >> [ perf record: Captured and wrote 0.439 MB perf.data (~19170 samples) ]
> >> % sudo ./perf lock record -a whoami   # with -a option
> >> root
> >> [ perf record: Woken up 0 times to write data ]
> >> [ perf record: Captured and wrote 48.962 MB perf.data (~2139197  
> samples) ]
> >>
> >> This patch was made on perf/test of random-tracing.git,
> >> could you queue this, Frederic?
> >>
> >> Cc: Ingo Molnar<mingo@elte.hu>
> >> Cc: Peter Zijlstra<a.p.zijlstra@chello.nl>
> >> Cc: Paul Mackerras<paulus@samba.org>
> >> Cc: Arnaldo Carvalho de Melo<acme@redhat.com>
> >> Cc: Jens Axboe<jens.axboe@oracle.com>
> >> Cc: Jason Baron<jbaron@redhat.com>
> >> Cc: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> >> Signed-off-by: Hitoshi Mitake<mitake@dcl.info.waseda.ac.jp>
> >
> >
> > Thanks, will test it and if it's fine I'll queue.
> >
> > I did a lot of tests these last days to understand what was going on
> > with perf lock, I mean the fact we have various bad locking scenario.
> >
> > So far, the state machine looks rather good. In fact, the real problem
> > is that we don't have every events. We lose a _lot_ of them and that's
> > because the frequency of lock events is too high and perf record
> > can't keep up.
>
> Really, I didn't think about lack of events :(



You can observe this by looking at perf trace output and search
for long series of the same type of events without the others.

For example it's common to find long series of lock_contended
events without corresponding lock_acquire/release/acquired.

This is because lock_contended is the lowest frequent lock event,
when the others have their buffers full, this one still has rooms
for samples.



> >
> > I think I'm going to unearth the injection code to reduce the size
> > of these events.
> >
> >
>
> Yeah, injection will be really helpful thing.
>
> And I have a rough idea for reducing event frequency.
>
> Many lock event sequences are like this form:
>  * acquire -> acquired -> release
>  * acquire -> contended -> acquired -> release
> I think that making 3 or 4 events per each lock sequences
> is waste of CPU time and memory space.
>
> If threads store time of each events
> and make only 1 event at time of release,
> we will be able to reduce lots of time and space.
>
> For example, ID of each lock instance is 8 byte in x86_64.
> In this scheme 8 * 4 byte for ID will be only 8 byte.
> I think this optimization has worth to consider because of
> high frequency of lock events.
>
> How do you think?


You're right, we could optimize the lock events sequence layout.
What I'm afraid of is to break userspace, but ripping the name from
the lock events while introducing injection will break userspace anyway :-(

May be we can think about providing new lock events and announce the
deprecation of the old ones and remove them later. I'm not sure yet.

But summing up in only one event is not possible. Having only one
lock_release event (and a lock init for name mapping) is suitable
for latency measurements only (timestamp + lock addr + wait time +
acquired time).
And once you dig into finer grained analysis like latency induced
by dependencies (take lock A and then take lock B under A, latency
of B depends of A), then you're screwed, because you only know
you've released locks at given times but you don't know when you
acquired them, hence you can't build a tree of dependencies with
sequences inside.

Ideally, I think that we need to remove lock contended and only
trigger lock_acquired when we contended. We obviously don't need
lock_contended/lock_acquired if the lock wasn't contended.

We could even remove lock_acquire and only play with lock_acquired,
changing a bit the rules, but that will make us lose all the dependencies
"intra-lock". I mean there are locks which slowpath are implemented on top
of other locks: mutexes use mutex->wait_lock spinlock for example.

