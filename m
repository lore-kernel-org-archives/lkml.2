Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab2HPHKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 03:10:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37419 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab2HPHKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 03:10:49 -0400
Date: Thu, 16 Aug 2012 00:01:04 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        Pekka Enberg <penberg@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Christoph Lameter <cl@linux.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Colin Cross <ccross@android.com>, linux-mm@kvack.org,
        patches@linaro.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org,
        ce-android-mainline@lists.linuxfoundation.org
Subject: [ANN] Userspace low memory killer daemon
Message-ID: <20120816070103.GA18949@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This quite long email (sorry!) has two purposes: to announce userland
lowmemory killer daemon to a broader audience, and to resume discussion
on lowmemory notifications.

The userland lowmemory killer daemon (ulmkd), behaves the same way as
kernel's lowmemorykiller (LMK) driver, except that the policy now lives
in the userland, and the daemon expects some 'low memory notification'
services from the kernel (currently, the main backend is cgroups).

Plus, with userland approach now we can send not only SIGKILL, but also
user-specific events, upon which programs would not just quit, but would
e.g.  release/garbage collect memory or we could even try to
preemptively suspend and put selected "currently not important"
processes into swap (something, I believe, Windows 8 does nowadays,
sorry for the analogy.  :-) This also seem to slightly relate to
fallocate volatile work: the trend is to make resource management a bit
smarter, export userland's knowledge about resources to the kernel, give
the kernel some hints.

ulmkd is a drop-in replacement for lowmemorykiller driver; one can
disable CONFIG_ANDROID_LOW_MEMORY_KILLER in the kernel config, start
ulmkd, and everything should behave the same way.

Also, I do hope the code would be useful not only for Android, so if
anybody wants to extend it, you're more than welcome.

The code is tiny, and is available in this git repo:

	git://git.infradead.org/users/cbou/ulmkd.git

(The repo is three months old since the stuff seem to just work, at
least with cgroups.)

The daemon consists of two parts,

- Low memory notifications handling;
- Task list management.

For notifications, there are two backends: cgroups and vmevent. Vmevent
support is quite outdated, but it is still there just to show the idea.
I plan to substitute it with deferred timer polling + shrinker
notifications (see below).

For task list management, two methods implemented: /proc based (the
daemon reads PIDs and oom_adj values from the /proc directory), and
shared memory based, where it is expected that Android Activity Manager
(or Maemo, or Tizen manager, or whatever) would keep the task list in
the memory, and share it with the killer daemon. The demo_shm.c file
provides a small example, it "proxies" task list from /proc to a shared
memory.  (The Android Activity Manager already manages its own task
list, we just need to teach it to share it with the daemon.)

Note that we have to implement LMK as a separate small daemon, the
reason behind this is best described in Android example: in JVM we can't
guarantee 'no new new memory allocations', we're out of control of what
JVM does with memory. Plus, we don't want the killer to be swapped out,
and so in ulmkd we call mlockall(), thus locking just the small daemon,
not the whole JVM.

Some words about latency: the reaction time is not a big issue in "Low
Memory Killer" duties, this is because LMK triggers when we have plenty
of free memory and time (tens and hundreds of megabytes), and OOMK
(in-kernel OOM killer) will help us if we're too slow. So ulmkd by no
means is going to "replace" OOMK.

Note that no matter if we choose to kill processes from kernel or
userspace, current in-kernel LMK driver would still need a lot of rework
to get it right.

The main problem is vm_stat counters. The vm_stat counters are per-node,
per-cpu, and gathering the statistics from all the nodes might be quite
expensive: e.g. on SMP to synchronize global counters, we'd need to
issue an IPI, which, if we presume that we need a low-latency LMK, would
disturb the system quite a lot, and the whole point of "light weight"
LMK driver defeats itself.

In-kernel LMK started when most users where UP/"embedded", so it was all
straightforward. But now SMP is quite common setup even on embedded
devices, and so we will need to "adjust" LMK to a new reality, sooner or
later. And we'd better do it in the best possible way, right from the
start.

(Note that adding another LRUs, like "easily reclaimable list", doesn't
solve the vm_stat issue. Identifying which pages are easily reclaimable
is one thing, but statistics is another.)

So, in-kernel LMK shares the same issues with vmevent lowmemory
notification approach, because both use vm_stat, which we can't update
frequently, and so the statistics are not up to date anyway.

In ulmkd I want to try another approach (in addition to cgroups):

- Considering that we don't have to be super-low-latency, we can just
  poll /proc/vmstat from userland very infrequently *and* using deferred
  timers approach to save power, as we did in vmevents -- we won't wake
  up the system needlessly. As far as I can see, there is no such thing
  as deferred timers for userland yet, so this is going to be a key
  part.

- Export shrinker notifications to userland (via vmevents API?). This
  would zap all the discussions about what to consider "low memory", as
  shrinker is just a small hint that kernel is short on the memory, and
  we'll OOM pretty soon (assuming no swap).

Does it sound viable? Note that nothing is set in stone here, before
going all-in into it, I'd really want to hear opinions and more ideas.

Thanks!

Anton.
