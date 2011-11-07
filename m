Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab1KGP2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:28:22 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65449 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab1KGP2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:28:21 -0500
MIME-Version: 1.0
In-Reply-To: <1320669279.18053.29.camel@twins>
References: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
	<1320398790-21663-2-git-send-email-yong.zhang0@gmail.com>
	<1320669279.18053.29.camel@twins>
Date: Mon, 7 Nov 2011 16:28:19 +0100
Message-ID: <CAOMGZ=EC0eHahfHy2K=5HwBwOCWEdF6u-mDaeLhb4GQVKVxLLA@mail.gmail.com>
Subject: Re: [PATCH 1/4] lockdep: lock_set_subclass() fix
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        sergey.senozhatsky@gmail.com, bp@alien8.de,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>, casteyde.christian@free.fr
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 November 2011 13:34, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> Arguably kmemcheck is on crack or so since both name and key pointers
> should be in .data so there cannot be a leak by copying the thing over.

There is no leak, it's only about uninitialised memory.

The problem is that kmemcheck cannot track "initialisedness" of stack
data and we're doing a heap-to-stack copy in process_one_work(), as
Tejun pointed out:

        struct lockdep_map lockdep_map = work->lockdep_map;

This is of course fine in itself. But how can we tell kmemcheck that
it's fine? There are basically two options:

1. Initialise the thing completely before doing the copy, or
2. Ignore the warning.

The memset() patch (f59de8992aa6dc85e81aadc26b0f69e17809721d) attempts
to do the first, i.e. to clear the whole struct in lockdep_init_map().

I think nr. 1 is the best way to go in principle, but I don't know
what it takes for this to work properly. The blanket-clear memset()
presumably doesn't work because it clears out something that was
already initialised by the caller (right?).

Yong Zhang, can you think of a way to avoid the race you described,
perhaps by memset()ing only the right/relevant parts of struct
lockdep_map in lockdep_init_map()?

Peter Zijlstra, if you prefer, we can also just tell kmemcheck that
this particular copy is fine, but it means that kmemcheck will not be
able to detect any real bugs in this code. It can be done with
something like:

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index e69434b..08a2b1b 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2948,7 +2948,7 @@ static int mark_lock(struct task_struct *curr,
struct held_lock *this,
 void lockdep_init_map(struct lockdep_map *lock, const char *name,
                      struct lock_class_key *key, int subclass)
 {
-       memset(lock, 0, sizeof(*lock));
+       kmemcheck_mark_initialized(lock, sizeof(*lock));

 #ifdef CONFIG_LOCK_STAT
        lock->cpu = raw_smp_processor_id();

Christian Casteyde, do you mind testing this patch as well?

(Yong Zhang, do you think this would still be vulnerable to the race
you described?)

Thanks,

And sorry for the inconvenience.

I've been thinking about chucking kmemcheck and reimplementing it
using LibVEX (the dynamic translation framework used by Valgrind
itself). Whoever is interested, feel free to have a look:

https://github.com/vegard/linux-2.6/tree/kmemcheck2


Vegard
