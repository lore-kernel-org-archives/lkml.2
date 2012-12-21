Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab2LUBex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 20:34:53 -0500
Received: from home.kolivas.org ([59.167.196.135]:51216 "EHLO mine.kolivas.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751626Ab2LUBep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 20:34:45 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Matthias Kohler <matthias.kohler2224@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Multiple run-queues for BFS
Date: Fri, 21 Dec 2012 12:34:41 +1100
Message-ID: <7642932.sVkG1EKMhP@hex>
User-Agent: KMail/4.9.4 (Linux/3.7.0-ck1; KDE/4.9.4; x86_64; ; )
In-Reply-To: <1355591803.23863.3.camel@findus-T530>
References: <1355591803.23863.3.camel@findus-T530>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthias, et al.

On Sat, 15 Dec 2012 18:16:43 Matthias Kohler wrote:
> I'm doing a CPU-Scheduler based on BFS by Con Kolivas with support for
> multiple run-queues. 

Nice to see you doing interesting hacking on BFS and thanks for your bugfixes 
previously. Well done making it this far! Multiple runqueues is something 
that's been on and off the boil for BFS right from the start. I've also done 
various experiments and some ground work along similar lines (I'll explain 
later), but soon lost interest since my experiments suggested I would need a 
heck of a lot of time to implement it the way I envisioned.

> BFS in itself uses only one run-queue for all
> CPU's. This avoids the load-balancing overhead, but does not scale well.

Actually describing it like this is a little bit of a generalisation that 
unfortunately has the tendency to point to the obvious culprit for scaling 
without really defining what the limitations are to scaling and how removing it 
might help. The culprit people point to is the single runqueue because of the 
potential for lock contention rising exponentially as the number of CPUs 
rises. However while some very early testing showed that scalability of -some- 
workloads did not match mainline once we reached 16 CPUs, it was just an 
assumption that it was lock contention that caused this. The most CPUs I can 
find someone to test BFS on previously was 16, and lock debugging actually did 
NOT show there to be significant contention as registering any more than 
mainline. This is not that surprising really since the critical sections under 
the global runqueue lock are kept as short as possible.

Scalability seems only affected on workloads that rely greatly on cache 
warmth, and very low cache requirement workloads like simple networking based 
tasks do not suffer at all (and some benchmarks have shown it to be better 
than mainline at these). This implies to me that complex balancing mechanisms 
designed to keep tasks cache warm is the reason mainline outperforms with 
these workloads. The main thrust of BFS is to offer -any- free CPU to the task 
that has waited the longest, thereby minimising latency at all times, and 
bringing it down the more CPUs you have. This approach is pretty much 
orthogonal to trying to keep tasks bound to their old CPU or a cache shared 
sibling if it means occasionally leaving a cold cache CPU free for a period 
instead. BFS uses only the simplest possible cache warmth approach which 
proves to help, but overrides it in the interests of latency. Certainly in the 
- now overworked example - of the make kernel benchmarks, it performs very 
well up to 16x.

Which brings up the question of just how many CPUs it requires for lock 
contention to be a problem. I don't have the answer to that question, but I 
would not be surprised if it was a significant problem at 64 or more. Luckily, 
while the general trend is for more and more threads even on commodity 
hardware, I don't see this size happening any time soon (note I'm not saying 
never). That said, it is a valid endpoint to scale beyond that if possible in 
the design if one wished BFS to be used outside the commodity hardware 
spectrum.

> One run-queue per CPU does scale well, but then the scheduler has
> load-balancing overhead. The scheduler I'm developing supports every
> possible run-queues configuration. You can have one single run-queue
> like in BFS, or you can have one run-queue per CPU, or something
> completely different like one run-queue every two CPU's. This, in theory
> would  allow the scheduler to be fine-tuned to the hardware and the
> workload.

I agree with you this is by far the most interesting way of tackling this 
problem, while trying to maintain the benefits of the shared runqueue as much 
as possible. Given that lock contention is not a problem even up to 16 
threads/CPUs, it gives scope to have clusters of CPUs benefiting from the 
shared runqueue aspects BFS has while still allowing it to scale beyond that. 
I would hazard a guess that optimal would simply be one runqueue per shared 
cache.

> 
> What state is it in?
> Currently it is very unstable, CPU-Hotplug is broken, scheduling
> statistics are broken, support for real-time tasks is broken. Load
> balancing when having more than one run-queue is working, but is nothing
> more than keeping the load on all run-queues equal. Associating a CPU
> and a run-queue is currently done with a system call and there is no
> access right checking. The source is in a very bad state.
> Uni-processor build is broken.
> It lacks proper Documentation.
> 
> Why allow the user to change the run-queue layout?
> To optimize the scheduler to specific hardware and workloads.
> You could use one run-queue for all CPU's if you want low latency and
> low scheduling overhead.
> You could use one run-queue per CPU if you want high scalability.
> You could use one run-queue per n CPU's is these n CPU's share cache and
> there is not much benefit in load balancing between them.

That is in agreement with what I said above :) Admittedly trying to find just 
the right balance would be tricky, but having infinite flexibility is an 
admirable quality that would allow the optimal design to be found.

> 
> Benchmarks?
> None, it is not stable enough to benchmark and the load balancing
> algorithm that is currently used, delivers very bad performance.

Well this would be crucial to get right given my experience with BFS. Fixing t 
he locking contention would only go partway to a solution since balancing is 
so important with our extremely cache fat CPUs these days, and localised 
memory and so on in the case of NUMA.
> 
> What advantages does it have when compared to other schedulers?
> It is more scalable than BFS.
> It could in future have all features of BFS and of CFS, especially
> throughput and low latency.
> It has far less lines of code than CFS.
> 
> What disadvantages does it have when compared to other schedulers?
> It is not stable.
> It is not tested on anything else than kvm and more than 4 CPU's.
> Many features are not yet working or not implemented at all (good load
> balancing).
> 
> Implementation details:
> All tasks that are runnable but not currently executing on a CPU, are
> queued on one of the global run-queues. Every global run-queue has its
> own spin-lock. When a task gets queued or dequeued this lock needs to be
> taken. All global run-queues are protected by one global read-write
> lock. When normal scheduling is done, this lock needs to be read_locked.
> When any change to the layout of the global run-queues is done,
> like adding new global run-queues or removing them, the global
> read-write lock needs to be write-locked.

This is where the parallels between your approach and my experiments starts 
becoming apparent. You will note in the last few -ck releases, there are extra 
patches that are not applied, that I mentioned in my blog.

http://ck-hack.blogspot.com/2012/06/upgradeable-rwlocks-and-bfs.html

These  patches have been updated slightly since then and the latest can be 
found here: 
http://ck.kolivas.org/patches/3.0/3.7/3.7-ck1/patches/

The reason I point these out are the problem with using read locks is that 
they're not upgradeable, and favour reads over writes. This means that if you 
had something time critical to do under the write lock, under heavy contention 
you may not be able to achieve it. The upgradeable rwlock favours writes over 
reads, and allows an intermediate stage between read and write which is 
upgradeable to a write lock or downgradeable to a read lock while still 
allowing read access to the critical sections. I have used it in place of the 
current global runqueue spinlock to create more read sections, although it has  
not had a massive impact on the hardware that I could test it on (up to 16x 
again). I wonder if you might find the urwlocks helpful for your code?

However the main reason for developing the upgradeable rwlocks was not just to 
create more critical sections that other CPUs can have read access. Ultimately 
I had a pipe dream that it could be used to create multiple runqueues as you 
have done in your patch. However, what I didn't want to do was to create a 
multi runqueue design that then needed a load balancer as that took away one 
of the advantages of BFS needing no balancer and keeping latency as low as 
possible.

I've not ever put a post up about what my solution was to this problem because 
the logistics of actually creating it, and the work required kept putting me 
off since it would require many hours, and I really hate to push vapourware. 
Code speaks louder than rhetoric. However since you are headed down creating 
multi runqueue code, perhaps you might want to consider it. 

What I had in mind was to create varying numbers of runqueues in a 
hierarchical fashion. Whenever possible, the global runqueue could be grabbed 
in order to find the best possible task to schedule on that CPU from the entire 
pool. If there was contention however on the global runqueue, it could step 
down in the hierarchy and just grab a runqueue effective for a numa node and 
schedule the best task from that. If there was contention on that it could 
step down and schedule the best task from a physical package, and then shared 
cache, then shared threads, and if all that failed only would it just grab a 
local CPU runqueue. The reason for doing this is it would create a load 
balancer by sheer virtue of the locking mechanism itself rather than there 
actually being a load balancer at all, thereby benefiting from the BFS approach 
in terms of minimising latency, finding the best global task, not requiring a 
load balancer, and at the same time benefit from having multiple runqueues to 
avoid lock contention - and in fact use that lock contention as a means to an 
endpoint.

Alas to implement it myself I'd have to be employed full time for months 
working on just this to get it working...

> Fair time distribution among tasks is done via the deadline mechanism of
> BFS.
> 

While I unfortunately do not have the time to review your code due to my own 
real life events, I greatly look forward to seeing how your code evolves and 
wish you luck.

-- 
-ck
