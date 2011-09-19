Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab1ISJKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 05:10:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab1ISJKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 05:10:07 -0400
Date: Mon, 19 Sep 2011 11:09:27 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost6.localdomain6
To: Thomas Gleixner <tglx@linutronix.de>, linux-rt-users@vger.kernel.org
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org
Subject: =?ISO-8859-7?Q?=5BPATCH=5D_preempt-rt=3A_VERSION_2=3A_Fix_build_error=3A_section_of_=A1tasklist=5Flock=A2_conflicts?=
Message-ID: <alpine.LFD.2.00.1109191104010.23118@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1475679927-1124203029-1316423373=:23118"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1475679927-1124203029-1316423373=:23118
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

>From 60b91dea371067c529587c504be0543350d1c0e5 Mon Sep 17 00:00:00 2001
From: John Kacur <jkacur@redhat.com>
Date: Mon, 19 Sep 2011 10:29:42 +0200
Subject: [PATCH] =?UTF-8?q?preempt-rt:=20VERSION=202:=20Fix=20build=20error:=20section=20of=20=E2=80=98tasklist=5Flock=E2=80=99=20conflicts=20with=20previous=20declaration?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This fixes the following build error for the preempt-rt kernel.

make kernel/fork.o
  CC      kernel/fork.o
kernel/fork.c:90: error: section of ¡tasklist_lock¢ conflicts with previous declaration
make[2]: *** [kernel/fork.o] Error 1
make[1]: *** [kernel/fork.o] Error 2

The rt kernel cache aligns the RWLOCK in DEFINE_RWLOCK by default.
The non-rt kernels explicitly cache align only the tasklist_lock in
kernel/fork.c
That can create a build conflict. This fixes the build problem by making the
non-rt kernels cache align RWLOCKs by default. The side effect is that
the other RWLOCKs are also cache aligned for non-rt.

This is a short term solution for rt only.
The longer term solution would be to push the cache aligned DEFINE_RWLOCK
to mainline. If there are objections, then we could create a
DEFINE_RWLOCK_CACHE_ALIGNED or something of that nature.

Comments? Objections?

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 include/linux/rwlock_types.h |    3 ++-
 kernel/fork.c                |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/rwlock_types.h b/include/linux/rwlock_types.h
index 5317cd9..d0da966 100644
--- a/include/linux/rwlock_types.h
+++ b/include/linux/rwlock_types.h
@@ -47,6 +47,7 @@ typedef struct {
 				RW_DEP_MAP_INIT(lockname) }
 #endif
 
-#define DEFINE_RWLOCK(x)	rwlock_t x = __RW_LOCK_UNLOCKED(x)
+#define DEFINE_RWLOCK(name) \
+	rwlock_t name __cacheline_aligned_in_smp = __RW_LOCK_UNLOCKED(name)
 
 #endif /* __LINUX_RWLOCK_TYPES_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index aa5fe26..8487ae7 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -87,7 +87,7 @@ int max_threads;		/* tunable limit on nr_threads */
 
 DEFINE_PER_CPU(unsigned long, process_counts) = 0;
 
-__cacheline_aligned DEFINE_RWLOCK(tasklist_lock);  /* outer */
+DEFINE_RWLOCK(tasklist_lock);  /* outer */
 
 #ifdef CONFIG_PROVE_RCU
 int lockdep_tasklist_lock_is_held(void)
-- 
1.7.2.3

---1475679927-1124203029-1316423373=:23118--
