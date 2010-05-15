Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275Ab0EOIyn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 04:54:43 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:53742 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab0EOIyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 04:54:41 -0400
Message-ID: <4BEE614F.6060208@dcl.info.waseda.ac.jp>
Date: Sat, 15 May 2010 17:54:39 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH] perf lock: Drop "-a" option from set of default	arguments
 to cmd_record()
References: <4BE51A90.2060305@dcl.info.waseda.ac.jp> <1273306229-5216-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20100508161404.GB5444@nowhere> <4BE6CC5F.2020503@dcl.info.waseda.ac.jp> <20100511064809.GA5468@nowhere> <4BEA819B.5020602@dcl.info.waseda.ac.jp> <20100512155136.GG5405@nowhere>
In-Reply-To: <20100512155136.GG5405@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/10 00:51, Frederic Weisbecker wrote:
 > On Wed, May 12, 2010 at 07:23:23PM +0900, Hitoshi Mitake wrote:
 >> On 05/11/10 15:48, Frederic Weisbecker wrote:
 >>
 >>>>>
 >>>>> I think I'm going to unearth the injection code to reduce the size
 >>>>> of these events.
 >>>>>
 >>>>>
 >>>>
 >>>> Yeah, injection will be really helpful thing.
 >>>>
 >>>> And I have a rough idea for reducing event frequency.
 >>>>
 >>>> Many lock event sequences are like this form:
 >>>>    * acquire ->   acquired ->   release
 >>>>    * acquire ->   contended ->   acquired ->   release
 >>>> I think that making 3 or 4 events per each lock sequences
 >>>> is waste of CPU time and memory space.
 >>>>
 >>>> If threads store time of each events
 >>>> and make only 1 event at time of release,
 >>>> we will be able to reduce lots of time and space.
 >>>>
 >>>> For example, ID of each lock instance is 8 byte in x86_64.
 >>>> In this scheme 8 * 4 byte for ID will be only 8 byte.
 >>>> I think this optimization has worth to consider because of
 >>>> high frequency of lock events.
 >>>>
 >>>> How do you think?
 >>>
 >>>
 >>> You're right, we could optimize the lock events sequence layout.
 >>> What I'm afraid of is to break userspace, but ripping the name from
 >>> the lock events while introducing injection will break userspace
 >> anyway :-(
 >>
 >> Really? For me, at least ripping the name with injection
 >> doesn't make bad things for userspace.
 >> What does the word "break" mean in this context?
 >
 >
 > The fact that tools which relied on the name field in the lock events
 > won't work anymore as it will be present on lock_init_class only.

Ah, but rewriting perf lock will be required anyway
because this is still very alpha program :)

 >
 >
 >
 >>>
 >>> May be we can think about providing new lock events and announce the
 >>> deprecation of the old ones and remove them later. I'm not sure yet.
 >>>
 >>> But summing up in only one event is not possible. Having only one
 >>> lock_release event (and a lock init for name mapping) is suitable
 >>> for latency measurements only (timestamp + lock addr + wait time +
 >>> acquired time).
 >>> And once you dig into finer grained analysis like latency induced
 >>> by dependencies (take lock A and then take lock B under A, latency
 >>> of B depends of A), then you're screwed, because you only know
 >>> you've released locks at given times but you don't know when you
 >>> acquired them, hence you can't build a tree of dependencies with
 >>> sequences inside.
 >>
 >> In my imagination, composing 3 or 4 events into one is meaning
 >> timestamp of itself(it is also one of release) + lock addr
 >> + timestamp of acquire + timestamp of acquired
 >> (+ timestamp of contended) + misc information
 >> like flags.
 >
 >
 >
 > Ah I see.
 >
 >
 >
 >> I'd like to call this new event as "batch event" in below.
 >>
 >> If perf lock reads one batch event, original events of 3 or 4
 >> can be reconstructed in userspace.
 >> So I think dependency relation between locks can be obtained
 >> with sorting reconstructed events with timestamp.
 >>
 >> For this way, each threads have to hold memory for
 >> size of batch event * MAX_LOCK_DEPTH.
 >>
 >> I'm not sure about possibility and effect of this way :(
 >> and if I misunderstood something about your opinion, please correct me
 >
 >
 >
 > Ok it would be indeed more efficient for what we want with perf lock.
 > But I see drawbacks with this: other people might be interested
 > in only few of these events. Someone may want to count lock_contended
 > events only to produce simple contention stats for example, and this
 > user will have in turn larger traces than he was supposed to with
 > this batch event.
 >
 > I think it's usually better to divide the problems into smaller
 > problems. And here it's about dividing a high level meaning
 > (a lock sequence) into smaller and lower level meanings (a lock
 > event). Following this rule makes tracing much more powerful IMO.
 >
 > A lock acquire event has also an isolated meaning outside the
 > whole lock sequence, like in my above lock_contended example,
 > it can be useful alone for someone.

Ah, I would understood your opinion.
Current perf lock records all types of lock events,
but it is not efficient.

For example, users want to make critical section short
might require lock_acquire and lock_release only.
Another example, users want to solve scalability of multi thread/process
program might require recording lock_contended only.

So, perf lock should record only required types of event
for purpose of analyzing lock.
Is this your opinion?

If so, I completely agree with this.
Limiting types of events to record is not only
smart but also will be reduce overhead :)

 >
 >
 >
 >>> We could even remove lock_acquire and only play with lock_acquired,
 >>> changing a bit the rules, but that will make us lose all the 
dependencies
 >>> "intra-lock". I mean there are locks which slowpath are implemented on
 >> top
 >>> of other locks: mutexes use mutex->wait_lock spinlock for example.
 >>>
 >>>
 >>
 >> Do you mean that the relation like acquire(mutex) ->  acquire(spinlock)
 >> ->  acquired(spinlock) ->  acquired(mutex) ->  release(spinlock)
 >> will be lost?
 >
 >
 > Yep.
 >
 >
 >> It seems taht locks on other locks are only mutex and rwsem.
 >> I think that we have a way to rewrite their lock events
 >> of mutex and rwsem for intra-lock dependencies.
 >>
 >> But I cannot measure the actual cost of it :(
 >> So I cannot say easily this is possible...
 >
 >
 > But still I think it's useful to keep lock_contended and
 > lock_acquired. They have an important meaning alone.
 >
 >

Yeah, I agree with this too.
	
