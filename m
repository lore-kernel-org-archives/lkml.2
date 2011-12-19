Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab1LSHcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 02:32:04 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:54980 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab1LSHcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 02:32:01 -0500
Message-ID: <4EEEE866.2000203@linux.vnet.ibm.com>
Date: Mon, 19 Dec 2011 13:01:50 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: mc@linux.vnet.ibm.com
CC: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>,
        david@fromorbit.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
References: <1324265775.25089.20.camel@mengcong>
In-Reply-To: <1324265775.25089.20.camel@mengcong>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11121821-7014-0000-0000-00000047645A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I feel the following patch is a better fix for 2 reasons:

1. As Al Viro pointed out, if we do for_each_possible_cpus() then we might
encounter unnecessary performance hit in some scenarios. So working with
only online cpus, safely(a.k.a race-free), if possible, would be a good
solution (which this patch implements).

2. *_global_lock_online() and *_global_unlock_online() needs fixing as well
because, the names suggest that they lock/unlock per-CPU locks of only the
currently online CPUs, but unfortunately they do not have any synchronization
to prevent offlining those CPUs in between, if it happens to race with a CPU
hotplug operation.

And if we solve issue 2 above "carefully" (as mentioned in the changelog below),
it solves this whole thing!

---
From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] VFS: Fix race between CPU hotplug and *_global_[un]lock_online()


The *_global_[un]lock_online() macros defined in include/linux/lglock.h
can race with CPU hotplug operations. Fix this race by using the pair
get_online_cpus() and put_online_cpus() around them, so as to prevent CPU
hotplug happening at the same time.

But be careful to note the semantics here: if we enable CPU hotplug in-between
a lock_online() and the corresponding unlock_online(), the lock states can
get messed up, since we might end up for example, in a situation such as taking
a lock on an online CPU but not releasing it because that CPU was offline when
unlock_online() was invoked (thanks to Cong Meng for debugging this issue).
[Soft-lockups detected as a consequence of this issue was reported earlier in
https://lkml.org/lkml/2011/8/24/185.]

So, we are careful to allow CPU hotplug only after the lock-unlock sequence
is complete.

Debugged-by: Cong Meng <mc@linux.vnet.ibm.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 include/linux/lglock.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/lglock.h b/include/linux/lglock.h
index f549056..583d1a8 100644
--- a/include/linux/lglock.h
+++ b/include/linux/lglock.h
@@ -22,6 +22,7 @@
 #include <linux/spinlock.h>
 #include <linux/lockdep.h>
 #include <linux/percpu.h>
+#include <linux/cpu.h>
 
 /* can make br locks by using local lock for read side, global lock for write */
 #define br_lock_init(name)	name##_lock_init()
@@ -126,6 +127,7 @@
 	int i;								\
 	preempt_disable();						\
 	rwlock_acquire(&name##_lock_dep_map, 0, 0, _RET_IP_);		\
+	get_online_cpus();						\
 	for_each_online_cpu(i) {					\
 		arch_spinlock_t *lock;					\
 		lock = &per_cpu(name##_lock, i);			\
@@ -142,6 +144,7 @@
 		lock = &per_cpu(name##_lock, i);			\
 		arch_spin_unlock(lock);					\
 	}								\
+	put_online_cpus();						\
 	preempt_enable();						\
  }									\
  EXPORT_SYMBOL(name##_global_unlock_online);				\



