Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab1BOR0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 12:26:06 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:53413 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188Ab1BOR0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 12:26:03 -0500
MIME-Version: 1.0
Message-ID: <e364df61-7ff5-40dd-8882-0d01df5fe324@default>
Date: Tue, 15 Feb 2011 09:23:36 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: gregkh@suse.de, Chris Mason <chris.mason@oracle.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        matthew@wil.cx, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        ngupta@vflare.org, jeremy@goop.org,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        riel@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>, mel@csn.ul.ie,
        kosaki.motohiro@jp.fujitsu.com, sfr@canb.auug.org.au,
        wfg@mail.ustc.edu.cn, tytso@mit.edu, viro@zeniv.linux.org.uk,
        hughd@google.com, hannes@cmpxchg.org
Subject: RE: [PATCH V2 1/3] drivers/staging: zcache: in-kernel tmem code
References: <20110207032508.GA27432@ca-server1.us.oracle.com
 AANLkTimN0DYUbdPrVb+HvQC=HksVMngwqB=tFSV0reYA@mail.gmail.com>
In-Reply-To: <AANLkTimN0DYUbdPrVb+HvQC=HksVMngwqB=tFSV0reYA@mail.gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6550.5003]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D5AB6CD.0097:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan --

Thanks very much for the review!

Unless you disagree, I don't think you found anything that must be
fixed before zcache is included in-tree in drivers/staging, though
some of the comments should probably be addressed if/when zcache
is moved out of drivers/staging into, at some point, the mm tree.

> > +/*
> > + * A tmem host implementation must use this function to register
> callbacks
> > + * for memory allocation.
> > + */
> 
> I think it would better to use "object management(ex, allocation,
> free) " rather than vague "memory allocation".

Agreed, too vague.  Probably "metadata allocation/free"?

> And I am not sure it's good that support allocation flexibility.
> (The flexibility is rather limited since user should implement it as
> considering rb tree. We don't need to export policy to user)
> I think we can implement general obj/objnode allocation in tmem to
> hide it from host.
> It can make client simple to use tmem but lost flexibility.
> Do we really need the flexibility?

In the existing implementation, I agree the flexibility is overkill.
But when zcache is extended to handle multiple clients (e.g. for
cgroups or KVM) the callbacks will be useful for memory accounting.
And even with a single client, it would be nice to be able to
track true memory usage (including the space consumed by the
metadata).

> > +/*
> > + * A tmem host implementation must use this function to register
> > + * callbacks for a page-accessible memory (PAM) implementation
> > + */
> 
> You said tmem_hostops is for memory allocation.
> But said tmem_pamops is for PAM implementation?
> It's not same level explanation.
> I hope you write down it more clearly by same level.
> (Ex, is for add/delete/get the page into PAM)

Agreed.  Hostops is really for metadata allocation.  In earlier
implementation, hostops had more functions than just metadata
but those are gone now.

> > +/* searches for object==oid in pool, returns locked object if found
> */
> 
> Returns locked object if found?
> I can't find it in the code and merge the comment above, not separate
> phrase.

This is an old comment from an earlier locking model so I
will remove it.

> > +       BUG_ON(obj == NULL);
> 
> We don't need this BUG_ON. If obj is NULL, obj->pool is crashed then
> we can know it.

Right.  Will remove.

> > +       atomic_dec(&pool->obj_count);
> 
> Does we really need the atomic operation?
> It seems it's protected by hash bucket lock.

No, it's not protected by the hashbucket lock.  The objects are
spread across all the hashbuckets in a pool so
atomic operation is necessary I think.
 
> Another topic.
> I think hb->lock is very coarse-grained.
> Maybe we need more fine-grained lock design to emphasis on your
> concurrent benefit.

I agree, but was struggling with getting multiple levels
of locking to work (see the Draft0 posting of kztmem).
Jeremy suggested I simplify the locking model as much as
possible to ensure that it worked, and then
worry about performance if measurements showed there was a
problem.

The big problem with multiple levels of locking is that
the data structures are accessed both top-down (through
get/put/flush/etc) and bottom-up (through the shrinker
interface).  This creates many races and deadlock possibilities
The simplified locking model made much of that go away.

> > +       BUG_ON(atomic_read(&pool->obj_count) < 0);
> > +       INVERT_SENTINEL(obj, OBJ);
> > +       obj->pool = NULL;
> > +       tmem_oid_set_invalid(&obj->oid);
> > +       rb_erase(&obj->rb_tree_node, &hb->obj_rb_root);
> 
> For example, we can remove obj in rb tree and then we can clean up the
> object.
> It can reduce lock hold time.

Because of the bottoms up race conditions, I don't think this
can be done safely.  Assume the obj is removed from the
rb tree, and is asynchronously walked to clean it up.
Suppose an object with the same object-id is created before
the cleanup is complete, and a shrinker request is also
started which wanted to "evict" pages and finds pages with
that object-id.  What gets evicted?

It *might* be possible though to mark the obj as a zombie
and reject all puts/gets to it until the asynchronous
cleanup is complete.  I'll think about that.

BTW, I think this *can* be done safely when an entire pool
is deleted, because the pool-id is chosen inside the
host and we can avoid recycling the pool id until all
pages belonging to it have been reclaimed.

> > +       if (destroy)
> 
> I don't see any use case of not-destroy.
> What do you have in your mind?

The Xen implementation of tmem has a "flush but don't destroy"
interface intended to be a quick way to reclaim lots of
memory.  I'm not sure if this will be useful for zcache
yet, but left it in just in case.

> I remember you sent the patch which point out current radix-tree
> problem.
> Sorry for not follow that.
> 
> Anyway, I think it would be better to separate this patch into another
> tmem-radix-tree.c and write down the description in the patch why we
> need new radix-tree in detail.
> Sorry for bothering you.

It seemed best to leave this for another day as anything
that affects core radix-tree.c code probably deserves a
lot more care and attention than I can give it.

> > +       spin_lock(&hb->lock);
> 
> This spin_lock means we can't call *put* in interrupt context.
> But now we can call put_page in intrrupt context.
> I see zcache_put_page checks irqs_disabled so now it's okay.
> But zcache is just only one client of tmem. In future, another client
> can call it in interrupt context.
> 
> Do you intent to limit calling it in only not-interrupt context by
> design?

For now, yes.  If someone smarter than me can figure out how
to ensure concurrency while allowing "put" to be called in
an interrupt context, that might be nice.

> > +       if (ephemeral)
> > +               pampd = tmem_pampd_delete_from_obj(obj, index);
> 
> I hope you write down about this exclusive characteristic of ephemeral
> in description.

Yes... in fact I was thinking there should be a "tmem_get" and a
separate "tmem_get_and_flush" call and the decision should be
made (and documented) in the host.

> > +       bool persistent;
> > +       bool shared;
> 
> Just nitpick.
> Do we need two each variable for persist and shared?
> Couldn't we merge it into just one "flag variable"?

Yes, though there are very few pool data structures so
the extra clarity seemed better than saving a few bytes.
If you think this is a "kernel style" issue, I could
easily change it.

> > +/* pampd abstract datatype methods provided by the PAM
> implementation */
> > +struct tmem_pamops {
> > +       void *(*create)(struct tmem_pool *, struct tmem_oid *,
> uint32_t,
> > +                       struct page *);
> > +       int (*get_data)(struct page *, void *, struct tmem_pool *);
> > +       void (*free)(void *, struct tmem_pool *);
> > +};
> 
> Hmm.. create/get_data/free isn't good naming, I think.
> How about add/get/delete like page/swap cache operation?

Do you think the semantics are the same?  I suppose they are
very similar for create and free, but I think the get_data
is different isn't it?

> > +extern void tmem_register_pamops(struct tmem_pamops *m);
> > +
> > +/* memory allocation methods provided by the host implementation */
> > +struct tmem_hostops {
> > +       struct tmem_obj *(*obj_alloc)(struct tmem_pool *);
> > +       void (*obj_free)(struct tmem_obj *, struct tmem_pool *);
> > +       struct tmem_objnode *(*objnode_alloc)(struct tmem_pool *);
> > +       void (*objnode_free)(struct tmem_objnode *, struct tmem_pool
> *);
> > +};
> 
> As I said, I am not sure the benefit of hostop.
> If we can do, I want to hide it from host.

See above.  I'd like to leave it that way for awhile until there
are other hosts (especially with multiple clients).  If they
don't need it, I agree, we should remove it.

> It's very quick review so maybe I miss your design/goal.
> Sorry if I am doing such a thing.
> 
> --
> Kind regards,
> Minchan Kim

Actually, it was a good review and I very much appreciate it!
I think maybe the only goal you missed is that I plan to extend
this beyond a single client so I think accounting of space
for metadata will be useful and important (which led me to
use the hostops "metadata allocation and free".)

Thanks again!
Dan
