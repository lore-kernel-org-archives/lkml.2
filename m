Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab3AGXro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 18:47:44 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:48502 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab3AGXrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 18:47:41 -0500
Date: Mon, 7 Jan 2013 15:47:37 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Subject: Re: [PATCH 23/32] Generic dynamic per cpu refcounting
Message-ID: <20130107234737.GI26407@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
 <1356573611-18590-26-git-send-email-koverstreet@google.com>
 <20130103144839.7a514924.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130103144839.7a514924.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 02:48:39PM -0800, Andrew Morton wrote:
> On Wed, 26 Dec 2012 18:00:02 -0800
> Kent Overstreet <koverstreet@google.com> wrote:
> 
> > This implements a refcount with similar semantics to
> > atomic_get()/atomic_dec_and_test(), that starts out as just an atomic_t
> > but dynamically switches to per cpu refcounting when the rate of
> > gets/puts becomes too high.
> > 
> > It also implements two stage shutdown, as we need it to tear down the
> > percpu counts. Before dropping the initial refcount, you must call
> > percpu_ref_kill(); this puts the refcount in "shutting down mode" and
> > switches back to a single atomic refcount with the appropriate barriers
> > (synchronize_rcu()).
> > 
> > It's also legal to call percpu_ref_kill() multiple times - it only
> > returns true once, so callers don't have to reimplement shutdown
> > synchronization.
> > 
> > For the sake of simplicity/efficiency, the heuristic is pretty simple -
> > it just switches to percpu refcounting if there are more than x gets
> > in one second (completely arbitrarily, 4096).
> > 
> > It'd be more correct to count the number of cache misses or something
> > else more profile driven, but doing so would require accessing the
> > shared ref twice per get - by just counting the number of gets(), we can
> > stick that counter in the high bits of the refcount and increment both
> > with a single atomic64_add(). But I expect this'll be good enough in
> > practice.
> 
> I still don't "get" why this code exists.  It is spectacularly,
> stunningly undocumented and if someone were to ask me "under what
> circumstances should I use percpu-refcount", I would not be able to
> help them.

Yeah... that was unfinished. Here's a patch on top of your git tree with
the missing documentation:

commit a40826abf9f74ab8c7d316fb3c0bee7f7a5aa8df
Author: Kent Overstreet <koverstreet@google.com>
Date:   Mon Jan 7 15:05:58 2013 -0800

    percpu-refcount: Documentation
    
    Signed-off-by: Kent Overstreet <koverstreet@google.com>

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 1268010..1654a5b 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -1,3 +1,71 @@
+/*
+ * Dynamic percpu refcounts:
+ * (C) 2012 Google, Inc.
+ * Author: Kent Overstreet <koverstreet@google.com>
+ *
+ * This implements a refcount with similar semantics to atomic_t - atomic_inc(),
+ * atomic_dec_and_test() - but potentially percpu.
+ *
+ * There's one important difference between percpu refs and normal atomic_t
+ * refcounts; you have to keep track of your initial refcount, and then when you
+ * start shutting down you call percpu_ref_kill() _before_ dropping the initial
+ * refcount.
+ *
+ * Before you call percpu_ref_kill(), percpu_ref_put() does not check for the
+ * refcount hitting 0 - it can't, if it was in percpu mode. percpu_ref_kill()
+ * puts the ref back in single atomic_t mode, collecting the per cpu refs and
+ * issuing the appropriate barriers, and then marks the ref as shutting down so
+ * that percpu_ref_put() will check for the ref hitting 0.  After it returns,
+ * it's safe to drop the initial ref.
+ *
+ * BACKGROUND:
+ *
+ * Percpu refcounts are quite useful for performance, but if we blindly
+ * converted all refcounts to percpu counters we'd waste quite a bit of memory
+ * think about all the refcounts embedded in kobjects, files, etc. most of which
+ * aren't used much.
+ *
+ * These start out as simple atomic counters - a little bigger than a bare
+ * atomic_t, 16 bytes instead of 4 - but if we exceed some arbitrary number of
+ * gets in one second, we then switch to percpu counters.
+ *
+ * This heuristic isn't perfect because it'll fire if the refcount was only
+ * being used on one cpu; ideally we'd be able to count the number of cache
+ * misses on percpu_ref_get() or something similar, but that'd make the non
+ * percpu path significantly heavier/more complex. We can count the number of
+ * gets() without any extra atomic instructions, on arches that support
+ * atomic64_t - simply by changing the atomic_inc() to atomic_add_return().
+ *
+ * USAGE:
+ *
+ * See fs/aio.c for some example usage; it's used there for struct kioctx, which
+ * is created when userspaces calls io_setup(), and destroyed when userspace
+ * calls io_destroy() or the process exits.
+ *
+ * In the aio code, kill_ioctx() is called when we wish to destroy a kioctx; it
+ * calls percpu_ref_kill(), then hlist_del_rcu() and sychronize_rcu() to remove
+ * the kioctx from the proccess's list of kioctxs - after that, there can't be
+ * any new users of the kioctx (from lookup_ioctx()) and it's then safe to drop
+ * the initial ref with percpu_ref_put().
+ *
+ * Code that does a two stage shutdown like this often needs some kind of
+ * explicit synchronization to ensure the initial refcount can only be dropped
+ * once - percpu_ref_kill() does this for you, it returns true once and false if
+ * someone else already called it. The aio code uses it this way, but it's not
+ * necessary if the code has some other mechanism to synchronize teardown.
+ *
+ * As mentioned previously, we decide when to convert a ref to percpu counters
+ * in percpu_ref_get(). However, since percpu_ref_get() will often be called
+ * with rcu_read_lock() held, it's not done there - percpu_ref_get() returns
+ * true if the ref should be converted to percpu counters.
+ *
+ * The caller should then call percpu_ref_alloc() after dropping
+ * rcu_read_lock(); if there is an uncommonly used codepath where it's
+ * inconvenient to call percpu_ref_alloc() after get(), it may be safely skipped
+ * and percpu_ref_get() will return true again the next time the counter wraps
+ * around.
+ */
+
 #ifndef _LINUX_PERCPU_REFCOUNT_H
 #define _LINUX_PERCPU_REFCOUNT_H
 
@@ -16,11 +84,29 @@ int percpu_ref_put(struct percpu_ref *ref);
 int percpu_ref_kill(struct percpu_ref *ref);
 int percpu_ref_dead(struct percpu_ref *ref);
 
+/**
+ * percpu_ref_get - increment a dynamic percpu refcount
+ *
+ * Increments @ref and possibly converts it to percpu counters. Must be called
+ * with rcu_read_lock() held, and may potentially drop/reacquire rcu_read_lock()
+ * to allocate percpu counters - if sleeping/allocation isn't safe for some
+ * other reason (e.g. a spinlock), see percpu_ref_get_noalloc().
+ *
+ * Analagous to atomic_inc().
+  */
 static inline void percpu_ref_get(struct percpu_ref *ref)
 {
 	__percpu_ref_get(ref, true);
 }
 
+/**
+ * percpu_ref_get_noalloc - increment a dynamic percpu refcount
+ *
+ * Increments @ref, to be used when it's not safe to allocate percpu counters.
+ * Must be called with rcu_read_lock() held.
+ *
+ * Analagous to atomic_inc().
+  */
 static inline void percpu_ref_get_noalloc(struct percpu_ref *ref)
 {
 	__percpu_ref_get(ref, false);
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index e2d8d12..e018f01 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -5,6 +5,51 @@
 #include <linux/percpu-refcount.h>
 #include <linux/rcupdate.h>
 
+/*
+ * A percpu refcount can be in 4 different modes. The state is tracked in the
+ * low two bits of percpu_ref->pcpu_count:
+ *
+ * PCPU_REF_NONE - the initial state, no percpu counters allocated.
+ *
+ * PCPU_REF_PTR - using percpu counters for the refcount.
+ *
+ * PCPU_REF_DYING - we're shutting down so get()/put() should use the embedded
+ * atomic counter, but we're not finished updating the atomic counter from the
+ * percpu counters - this means that percpu_ref_put() can't check for the ref
+ * hitting 0 yet.
+ *
+ * PCPU_REF_DEAD - we've finished the teardown sequence, percpu_ref_put() should
+ * now check for the ref hitting 0.
+ *
+ * In PCPU_REF_NONE mode, we need to count the number of times percpu_ref_get()
+ * is called; this is done with the high bits of the raw atomic counter. We also
+ * track the time, in jiffies, when the get count last wrapped - this is done
+ * with the remaining bits of percpu_ref->percpu_count.
+ *
+ * So, when percpu_ref_get() is called it increments the get count and checks if
+ * it wrapped; if it did, it checks if the last time it wrapped was less than
+ * one second ago; if so, we want to allocate percpu counters.
+ *
+ * PCPU_COUNT_BITS determines the threshold where we convert to percpu: of the
+ * raw 64 bit counter, we use PCPU_COUNT_BITS for the refcount, and the
+ * remaining (high) bits to count the number of times percpu_ref_get() has been
+ * called. It's currently (completely arbitrarily) 16384 times in one second.
+ *
+ * Percpu mode (PCPU_REF_PTR):
+ *
+ * In percpu mode all we do on get and put is increment or decrement the cpu
+ * local counter, which is a 32 bit unsigned int.
+ *
+ * Note that all the gets() could be happening on one cpu, and all the puts() on
+ * another - the individual cpu counters can wrap (potentially many times).
+ *
+ * But this is fine because we don't need to check for the ref hitting 0 in
+ * percpu mode; before we set the state to PCPU_REF_DEAD we simply sum up all
+ * the percpu counters and add them to the atomic counter. Since addition and
+ * subtraction in modular arithmatic is still associative, the result will be
+ * correct.
+ */
+
 #define PCPU_COUNT_BITS		50
 #define PCPU_COUNT_MASK		((1LL << PCPU_COUNT_BITS) - 1)
 
@@ -18,6 +63,12 @@
 
 #define REF_STATUS(count)	((unsigned long) count & PCPU_STATUS_MASK)
 
+/**
+ * percpu_ref_init - initialize a dynamic percpu refcount
+ *
+ * Initializes the refcount in single atomic counter mode with a refcount of 1;
+ * analagous to atomic_set(ref, 1).
+ */
 void percpu_ref_init(struct percpu_ref *ref)
 {
 	unsigned long now = jiffies;
@@ -78,6 +129,13 @@ void __percpu_ref_get(struct percpu_ref *ref, bool alloc)
 	}
 }
 
+/**
+ * percpu_ref_put - decrement a dynamic percpu refcount
+ *
+ * Returns true if the result is 0, otherwise false; only checks for the ref
+ * hitting 0 after percpu_ref_kill() has been called. Analagous to
+ * atomic_dec_and_test().
+ */
 int percpu_ref_put(struct percpu_ref *ref)
 {
 	unsigned __percpu *pcpu_count;
@@ -109,6 +167,17 @@ int percpu_ref_put(struct percpu_ref *ref)
 	return ret;
 }
 
+/**
+ * percpu_ref_kill - prepare a dynamic percpu refcount for teardown
+ *
+ * Must be called before dropping the initial ref, so that percpu_ref_put()
+ * knows to check for the refcount hitting 0. If the refcount was in percpu
+ * mode, converts it back to single atomic counter mode.
+ *
+ * Returns true the first time called on @ref and false if @ref is already
+ * shutting down, so it may be used by the caller for synchronizing other parts
+ * of a two stage shutdown.
+ */
 int percpu_ref_kill(struct percpu_ref *ref)
 {
 	unsigned __percpu *old, *new, *pcpu_count = ref->pcpu_count;
@@ -156,6 +225,11 @@ int percpu_ref_kill(struct percpu_ref *ref)
 	return 1;
 }
 
+/**
+ * percpu_ref_dead - check if a dynamic percpu refcount is shutting down
+ *
+ * Returns true if percpu_ref_kill() has been called on @ref, false otherwise.
+ */
 int percpu_ref_dead(struct percpu_ref *ref)
 {
 	unsigned status = REF_STATUS(ref->pcpu_count);
