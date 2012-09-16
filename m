Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab2IPTdw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 15:33:52 -0400
Received: from mail.openrapids.net ([64.15.138.104]:51122 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751055Ab2IPTdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 15:33:51 -0400
Date: Sun, 16 Sep 2012 15:33:48 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: torvalds@linux-foundation.org, tj@kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        ebiederm@xmission.com, neilb@suse.de, bfields@fieldses.org,
        ejt@redhat.com, snitzer@redhat.com, edumazet@google.com,
        josh@joshtriplett.org, David.Laight@aculab.com, rmallon@gmail.com,
        palves@redhat.com
Subject: Re: [PATCH v5] hashtable: introduce a small and naive hashtable
Message-ID: <20120916193348.GA13726@Krystal>
References: <1347702798-19202-1-git-send-email-levinsasha928@gmail.com> <20120915151428.GA30459@Krystal> <CA+1xoqcO73Q7KOkoPKGCcWL3CfwpoTSXjhqk+JPwooeQdeYRhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1xoqcO73Q7KOkoPKGCcWL3CfwpoTSXjhqk+JPwooeQdeYRhA@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sasha Levin (levinsasha928@gmail.com) wrote:
> On Sat, Sep 15, 2012 at 5:14 PM, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> > * Sasha Levin (levinsasha928@gmail.com) wrote:
> >> This hashtable implementation is using hlist buckets to provide a simple
> >> hashtable to prevent it from getting reimplemented all over the kernel.
> >>
> >> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> >> ---
> >>
> >> Changes from v4:
> >>
> >>  - Addressed comments by Mathieu Desnoyers.
> >>
> >>  include/linux/hashtable.h | 190 ++++++++++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 190 insertions(+)
> >>  create mode 100644 include/linux/hashtable.h
> >>
> >> diff --git a/include/linux/hashtable.h b/include/linux/hashtable.h
> >> new file mode 100644
> >> index 0000000..6d0c6c2
> >> --- /dev/null
> >> +++ b/include/linux/hashtable.h
> >> @@ -0,0 +1,190 @@
> >> +/*
> >> + * Hash table implementation
> >> + * (C) 2012  Sasha Levin <levinsasha928@gmail.com>
> >> + */
> >> +
> >> +#ifndef _LINUX_HASHTABLE_H
> >> +#define _LINUX_HASHTABLE_H
> >> +
> >> +#include <linux/list.h>
> >> +#include <linux/types.h>
> >> +#include <linux/kernel.h>
> >> +#include <linux/hash.h>
> >> +#include <linux/rculist.h>
> >> +
> >> +#define DEFINE_HASHTABLE(name, bits)                                         \
> >> +     struct hlist_head name[HASH_SIZE(bits)] =                               \
> >> +                     { [0 ... HASH_SIZE(bits) - 1] = HLIST_HEAD_INIT }
> >> +
> >> +#define DECLARE_HASHTABLE(name, bits)                                        \
> >> +     struct hlist_head name[1 << (bits)]
> >> +
> >> +#define HASH_SIZE(name) (1 << HASH_BITS(name))
> >> +#define HASH_BITS(name) ilog2(ARRAY_SIZE(name))
> >> +
> >> +/* Use hash_32 when possible to allow for fast 32bit hashing in 64bit kernels. */
> >> +#define hash_min(val, bits)                                                  \
> >> +({                                                                           \
> >> +     sizeof(val) <= 4 ?                                                      \
> >> +     hash_32(val, bits) :                                                    \
> >> +     hash_long(val, bits);                                                   \
> >> +})
> >> +
> >> +/**
> >> + * hash_init - initialize a hash table
> >> + * @hashtable: hashtable to be initialized
> >> + *
> >> + * Calculates the size of the hashtable from the given parameter, otherwise
> >> + * same as hash_init_size.
> >> + *
> >> + * This has to be a macro since HASH_BITS() will not work on pointers since
> >> + * it calculates the size during preprocessing.
> >> + */
> >> +#define hash_init(hashtable)                                                 \
> >> +({                                                                           \
> >> +     int __i;                                                                \
> >> +                                                                             \
> >> +     for (__i = 0; __i < HASH_BITS(hashtable); __i++)                        \
> >
> > I think this fails to initialize the whole table. You'd need
> >
> >   HASH_BITS -> HASH_SIZE
> 
> Right.
> 
> Unfortunately it's pretty hard catching something like this :/
> 
> > Which brings the following question: how did you test this code ? It
> > would be nice to have a small test module along with this patchset that
> > stress-tests this simple hash table in various configurations (on stack,
> > in data, etc).
> 
> I do two things:
> 
>  - A small userspace test (since this header works just fine from
> userspace as well).
>  - Build a kernel with all ~20 commits and stresstest it a bit, since
> things like workqueue were converted, it finds issues pretty fast.
> 
> I agree that there should be something similar to the list sort test
> we currently have, but I'm not sure if it should be in the scope of
> this initial patch.

Fair enough.

> 
> > Also, I don't see how hash_init() can be useful, since DEFINE_HASHTABLE
> > already initialize the array entries. If it is for dynamically allocated
> > hash tables, this also won't work, considering the comment "This has to
> > be a macro since HASH_BITS() will not work on pointers since it
> > calculates the size during preprocessing."
> 
> hash_init() is actually used to clear the hashtable in two of the
> commits I've used to send along with this one. Since as you've said we
> now have DEFINE_HASHTABLE and DECLARE_HASHTABLE, maybe it should be
> now called hash_clear() or something similar. I don't have a strong
> opinion about this.

If it's used somewhere, then it's fine. People are used to "*_init"
functions, so I don't think there is a point in renaming this to
"clear".

> 
> >> +             INIT_HLIST_HEAD(&hashtable[__i]);                               \
> >> +})
> >> +
> >> +/**
> >> + * hash_add - add an object to a hashtable
> >> + * @hashtable: hashtable to add to
> >> + * @node: the &struct hlist_node of the object to be added
> >> + * @key: the key of the object to be added
> >> + */
> >> +#define hash_add(hashtable, node, key)                                               \
> >> +     hlist_add_head(node, &hashtable[hash_min(key, HASH_BITS(hashtable))]);
> >> +
> >> +/**
> >> + * hash_add_rcu - add an object to a rcu enabled hashtable
> >> + * @hashtable: hashtable to add to
> >> + * @node: the &struct hlist_node of the object to be added
> >> + * @key: the key of the object to be added
> >> + */
> >> +#define hash_add_rcu(hashtable, node, key)                                   \
> >> +     hlist_add_head_rcu(node, &hashtable[hash_min(key, HASH_BITS(hashtable))]);
> >> +
> >> +/**
> >> + * hash_hashed - check whether an object is in any hashtable
> >> + * @node: the &struct hlist_node of the object to be checked
> >> + */
> >> +#define hash_hashed(node) (!hlist_unhashed(node))
> >> +
> >> +/**
> >> + * hash_empty - check whether a hashtable is empty
> >> + * @hashtable: hashtable to check
> >> + *
> >> + * This has to be a macro since HASH_BITS() will not work on pointers since
> >> + * it calculates the size during preprocessing.
> >
> > So I get that hash_empty is only expected to be used for statically
> > defined hash tables ? Does it support hash tables in dynamically
> > allocated memory ? On the stack ? If these are never expected to be
> > supported, this should be documented.
> 
> Like the rest of the code, this hashtable implementation only works
> with non-dynamically allocated hashtables (on the stack/statically
> defined/etc are supported).
> 
> How would you create a dynamic hashtable with this code to begin with?

With a var. sized array in a structure, e.g.:

struct hashtable {
        size_t len;
        struct hlist_head t[];
};

Then create a hash table allocation function, and turn both hash_empty
and hash_init into functions that take a struct simplehash pointer as
parameter. The downside is to consume extra space (especially because
the array always has a power of 2 len), but the nice thing is that we
could use this code with a kmalloc'd/vmalloc'd hash table.

I'm not saying we need to do it (due to the space consumption downside),
but that we should at least document this limitation.

Thanks,

Mathieu


> 
> 
> Thanks,
> Sasha

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
