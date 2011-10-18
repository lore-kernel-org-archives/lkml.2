Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab1JRJRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 05:17:00 -0400
Received: from smtp-out.google.com ([74.125.121.67]:35670 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757162Ab1JRJQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 05:16:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=YaPhGoHno804yBNmJSEnRKsenIotIRTHu/qn7HL8MYwTPggxkeNb/SHvUYNw1ud68
	RBDG8VZujOcQWMMKX3z4g==
MIME-Version: 1.0
In-Reply-To: <1318872925.4172.81.camel@twins>
References: <1318872925.4172.81.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Tue, 18 Oct 2011 02:16:23 -0700
Message-ID: <CAPM31RJ5nb4kk+7-d6cVoUfcZ_tUv+qnZ0JkWkQ9DHNinRM39Q@mail.gmail.com>
Subject: Re: Scheduler BOF @ LinuxCon.EU/ELCE
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        rostedt <rostedt@goodmis.org>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Glauber Costa <glommer@parallels.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 10:35 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> Hi,
>
> several people have expressed interest of talking to me about the
> scheduler during the RTLWS/KS/LinuxCon.EU time-frame. Since I've just
> about lost track of who all wanted to talk about what and who can and
> can not make it out to Prague I need help ;-)
>
> Also, since I'm too dis-organized (and mostly busy) to really arrange
> something, can someone volunteer to arrange a BOF or cafe with beer to
> discuss things?
>
> The topics I'm most interested in are:
>
>  - power optimized load-balancing;
>    do packing based on cpu utilization
>    fix the current interface of sched_{mc,ht}_power_savings
>

We're also interested in this.  Judging by the recent wreckage in
SMT-balancing I don't have much faith in this code currently.  Even in
the non balance-for-performance case, stuffing one socket on a
multi-socket system at low load levels is probably starting to become
attractive with the new package level idle states.

Venki pointed out that there were a few talks at LPC regarding
off-lining cores for power-saving.  We should try to provide some
saner policy.

I'll also note that if we're looking to make any fundmental changes
here that testing is kind of a nightmare.  But then, I guess that's
one of the things I've got to talk about already :-(

>  - integration of the cpufreq/idle governors and the scheduler
>    use the idle guestimate for NO_HZ
>    use $foo for $prev-topic to reduce double accounting etc.
>

I'd extend this to can we unify some of the accounting in general.

Also the knobs that attach to these such as wake_idx are questionable.

>  - what can we do about the cgroup crap and how can we win some
>   of the performance back;
>    start with fixing the cgroup enabled but unused case
>    continue from there..
>

Emphatic YES.  I will toss: 'can we kill cpuacct (over time) out
there'?  If not kill, at least migrate the useful fields to cpu and
nack any new fields on it so that it can be deprecated.  We already
track the useful state (via sum_exec_runtime) at an entity level in
cpu_cgroup anyway.

>    pjt was rewriting load tracking, do tell us about it

So the details are a little fiddly to get right but it's not too bad
to explain... although now that I've written the 'longer' version it
looks a little dense, short version now prepended!

I'll try to send out the initial draft of the patches but here's how it goes:
Short version:
runnable_i = usage_n_ticks_ago[i] * y^i where y^32 = 1/2
load_i = runnable_i * weight_i

cfs_rq->load_avg = \Sum runnable_load_i (1) + \Sum blocked_load_j (2)
For each tick that load remains blocked in (2) we can multiply the
whole thing by y to account an additional idle tick.

Longer version and background:
So we currently track the load average at a cfs_rq level, that is

Within each "window" w_j we track: \Sum load_i * t_i where \Sum t_i =
w and each load_i represents a disjoint load level.

The load average is then \Sum w_j / 2^n.

Now this works reasonably well but there's a few problems (some of
this next bit is a bit of a slog, feel free to skip if not
interested):

1) Since decay occurs at boundary (w/2) there are a few 'skews' in the
averaging:

- At a window boundary the 'foreground' time has a bias against the
time immediately preceding it (as a result of the folding division by
2)
e.g.  __xx_|_yyyy___ vs __xx_yyyy_|___ (where '|' is a window
boundary).  The accounting here is 2x + 4y/2 or 2x + 4y, depending on
which side of 'w' you land on.

- Everything within a window 'w' is accounted equally, we only fold at
the boundaries.  This actually means you can't set 'w' large enough to
really have meaningful coverage of the sched period without throwing
decay out the window.  But then with w/2 << sched_period (currently
w/2=5ms) the average ends up having fairly drastic swings even with
stable loads.

(One of the first things we looked at improving the tracking here was
actually not folding the foreground window into the considered average
until it is again folded -- when there's more than one window -- this
actually did improve the stability a fair amount modulo task
migration).

2) Since the load sum average is per-cfs_rq and not per-entity when a
task entity migrates we lose its contribution to load-sum and
effectively double count it while it former sum decays.

We were actually able to improve the tracking in the pinned case on a
stable load to produce a nice stable result, however things fell apart
again once you let things move around the system again, even with no
load external to the group.

*So*, what do we do?

Instead of tracking load on a per-cfs_rq basis we do it on a
per-sched_entity basis.  The load sum for a cfs_rq is then just the
sum of its childrens' load averages.  The obvious immediately nice
property is that when we migrate thread A from cpu1-->cpu2, we carry
its load with it; leaving the global load sum unmodified.

The 'windows' above are replaced with more fine-grained tracking, that is:

runnable_j = u_i * y^i , load_avg_j = runnable_j * weight_j [*]

Where: u_i is the usage in the last i`th ~ms and y is chosen such that
y^k = 1/2.  We currently choose k to be 32 which roughly translates to
about a sched period.  This means that load tracked 1 P ago
contributes about ~50% as the tracking of its immediate runnable
state.

Now, the real problem of tracking per-entity is how do you handle the
blocked entities?  Obviously runnable entities will be updated
naturally as we iterate through them but there could be O(many)
blocked entities so we can't afford to iterate through them and update
their tracking.

The fact that y^i above is continuous though has a particularly nice
property for this:

We can separate the contributed load on a cfs_rq into blocked and
runnable.  Runnable load is just the sum of all load_avg_j above,
maintained by the entities themselves as they run and self update
(when they update their load_avg_j they just add the delta to the sum
also).

The blocked load looks like: \Sum load_avg_k = \Sum weight_k
\Sum(n->inf) u[k]_n * y^n

First consider an individual blocked entity's load: load_avg_k = \Sum
u[k]_n * y^n
If we were to account an a new idle 0-th period then u[k]_i+1` =
u[k]_i and u[k]_0 = 0, but this is equivalent to just multiplying by
y.  Since we then get \Sum u[k]_n * y^(n+1)

So then to account an idle tick for all blocked entities all we need
to do is multiply the blocked-load sum by y and it's as if everything
decayed.

Now to keep this running in constant time we have to be a little more
sneaky since we don't get to do this every tick and we don't really
want to evaluate load_avg_j * y^n for arbitrary n.

Luckily here we can combine a small look-up table with the fact that
we chose y^k = 1/2 to make this always constant time.  (specifically
y^n = (1/2)^(n/32) * y^(n%32)).

So that gives us the blocked and running load averages.. well almost.
See [*] above is not technically an average until you divide by the
elapsed time.    We can actually employ further trickery here and
actually never do a division at all for this since: total_time being
averaged = \Sum(n->inf) 1 * y^n.
But this is an infinite geometric series and so converges to a/(1-r)
which allows us to treat the whole thing as a constant.  I'm a little
torn on whether to use that or not since having the actual time
available does potentially let us do some other things and it also
starts to push a little close to 64-bits in the large-blocked-load-sum
case if you leave it multiplied in (~45k for y^32=1/2).  We only have
to do this division at most once a ms though even without the infinite
series so it's a non-factor performance wise.

So that was a little dense, the other finicky bits are:
- doing the right thing on root_cgroup since it's not in the entity hierarchy
- accounting the removed load on an affine-wakeup (since we no longer
hold the remote rq-lock; an atomic removed-load sum suffices fine
here)
- making sure we synchronize with the 'decay' ticks in blocked load
when pulling things between the runnable/blocked sums

This ends up being orders of magnitude more accurate than the current
tracking schema, even with the old shares_window massively dilated to
better capture a stable load-state.  It's also obviously stable under
migration.

The property of a per-entity load-contribution could also allows us to
make some better decisions in the load-balancer.
e.g. consider 1x80% task  and 2x40% tasks on a 2-core machine.  It's
currently a bit of a crapshoot as to whether you get an {AB, B} or {A,
BB} split since they have equal weight (assume 1024).  With per-task
tracking we can actually consider them at their contributed weight and
see a stable ~{800,{400, 400}} load-split.


>        also tell us what the status of ncrao's hackery is,
>        or does your hackery replace that?

Nikhil was never able to reproduce the difference and also wasn't able
to get much traction in getting the reporter to collect debugging data
to investigate further.  This actually does make a pretty big
difference for the low-weight balance case so we might want to just
consider enabling it again and perhaps then data will be more
forthcoming =/.

This should probably be a quick discussion topic since we can probably
agree on a sane next step within a few minutes of talking about it.
I'll try to dig up where Nikhil's discussions tailed off in the
meanwhile.

>
> Things I specifically do not want to talk about:
>
>  - systemd, its shit, go away.
>

Things I would throw into the mix:

- wake_idle
We see a measurable benefit from this on a number of applications.
Migration latency within a socket is quite reasonable and frequently
dominates the run-delay caused by waking on an already running core.
This is something it would be nice to talk about bringing back, even
if only as a tunable.

- making soft_expires on hrtimers actually useful/usable in ganging wake-ups
  - the more general topic of trying to gang background wake-ups

- group level sched-idle; a non-check_preempt_curr ttwu in general

- vruntime for cgroups.  The per-entity timelines have a number of
problems (e.g. A) for groups g1, g2 we might have g1 < g2 on cpu1, but
g2 > g1 on cpu2 -- pre-emption decision is now dependent on where you
choose to wake up B) we charge against the group entities current
weight, but we're constantly fiddling with that same weight.  This can
actually work out quite badly when you consider that this fiddling
normally has an upwards slope (the longer a task runs the more
load_sum_avg on the cfs moves) which results in a lot of local
over-charging for time).  The stability of the load-tracking above
lets us reformulate some things to get a more global notion of
vruntime.  While this stuff is still quite preliminary we've had some
very positive performance results for mysql-oltp vs a cpu-antagonist;
it would be interesting to discuss at least.

I would propose Weds/Thurs at LinuxCon/RTLWS.  Perhaps Weds afternoon
would be better as that would give us Thurs/Fri to continue
hallway-tracking any discussion.

I'm happy to co-ordinate;  if people want to send me (anywhere on this
thread is fine), I can collate everything into a topic list and find
out what we need to do to get some BoF space.

Thanks,

- Paul
