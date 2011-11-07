Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab1KGQLl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:11:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:56202 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab1KGQLk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:11:40 -0500
Subject: Re: [PATCH 1/4] lockdep: lock_set_subclass() fix
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        sergey.senozhatsky@gmail.com, bp@alien8.de,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>, casteyde.christian@free.fr
Date: Mon, 07 Nov 2011 17:10:29 +0100
In-Reply-To: <CAOMGZ=EC0eHahfHy2K=5HwBwOCWEdF6u-mDaeLhb4GQVKVxLLA@mail.gmail.com>
References: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
	 <1320398790-21663-2-git-send-email-yong.zhang0@gmail.com>
	 <1320669279.18053.29.camel@twins>
	 <CAOMGZ=EC0eHahfHy2K=5HwBwOCWEdF6u-mDaeLhb4GQVKVxLLA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320682230.17809.11.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-07 at 16:28 +0100, Vegard Nossum wrote:
> On 7 November 2011 13:34, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > Arguably kmemcheck is on crack or so since both name and key pointers
> > should be in .data so there cannot be a leak by copying the thing over.
> 
> There is no leak, it's only about uninitialised memory.
> 
> The problem is that kmemcheck cannot track "initialisedness" of stack
> data and we're doing a heap-to-stack copy in process_one_work(), as
> Tejun pointed out:
> 
>         struct lockdep_map lockdep_map = work->lockdep_map;
> 
> This is of course fine in itself. But how can we tell kmemcheck that
> it's fine? There are basically two options:
> 
> 1. Initialise the thing completely before doing the copy, or
> 2. Ignore the warning.
> 
> The memset() patch (f59de8992aa6dc85e81aadc26b0f69e17809721d) attempts
> to do the first, i.e. to clear the whole struct in lockdep_init_map().
> 
> I think nr. 1 is the best way to go in principle, but I don't know
> what it takes for this to work properly. The blanket-clear memset()
> presumably doesn't work because it clears out something that was
> already initialised by the caller (right?).
> 
> Yong Zhang, can you think of a way to avoid the race you described,
> perhaps by memset()ing only the right/relevant parts of struct
> lockdep_map in lockdep_init_map()?

We could move the key and name pointer to the start of the structure and
memset everything after that, however wouldn't that leave kmemcheck with
the same problem? It wouldn't know those two pointers would be
initialized properly.

> Peter Zijlstra, if you prefer, we can also just tell kmemcheck that
> this particular copy is fine, but it means that kmemcheck will not be
> able to detect any real bugs in this code. It can be done with
> something like:

Something like this, although it would be best to come up with a nicer
way to write it..

---
 include/linux/lockdep.h |    2 +-
 kernel/lockdep.c        |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index b6a56e3..7d66268 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -148,9 +148,9 @@ void clear_lock_stats(struct lock_class *class);
  * This is embedded into specific lock instances:
  */
 struct lockdep_map {
+	const char			*name;
 	struct lock_class_key		*key;
 	struct lock_class		*class_cache[NR_LOCKDEP_CACHING_CLASSES];
-	const char			*name;
 #ifdef CONFIG_LOCK_STAT
 	int				cpu;
 	unsigned long			ip;
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index e69434b..81855cf 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2948,7 +2948,8 @@ static int mark_lock(struct task_struct *curr, struct held_lock *this,
 void lockdep_init_map(struct lockdep_map *lock, const char *name,
 		      struct lock_class_key *key, int subclass)
 {
-	memset(lock, 0, sizeof(*lock));
+	kmemcheck_mark_initialized(lock, 2*sizeof(void *));
+	memset(&lock->class_cache[0], 0, sizeof(*lock)-2*sizeof(void *));
 
 #ifdef CONFIG_LOCK_STAT
 	lock->cpu = raw_smp_processor_id();

