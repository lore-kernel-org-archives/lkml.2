Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965043Ab2JDBEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 21:04:20 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:32889 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964795Ab2JDBES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 21:04:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkAiAN/fbFB5LbKy/2dsb2JhbABFuRiEZQSBDoEJgiABAQQBOhwjBQsIAw4KFRkUJQMhExuHZAUMuCcEFIsPICCCToMsA5VokCyCf4FJ
Date: Thu, 4 Oct 2012 11:04:14 +1000
From: Dave Chinner <david@fromorbit.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tytso@google.com, tj@kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@zabbo.net>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        michael.mesnier@intel.com, jeffrey.d.skirvin@intel.com, pjt@google.com
Subject: Re: [RFC, PATCH] Extensible AIO interface
Message-ID: <20121004010414.GY23520@dastard>
References: <20121001222341.GF26488@google.com>
 <x49zk44ojpe.fsf@segfault.boston.devel.redhat.com>
 <20121003002029.GY26488@google.com>
 <20121003012825.GX23520@dastard>
 <20121003024110.GA19788@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003024110.GA19788@moria.home.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 07:41:10PM -0700, Kent Overstreet wrote:
> On Wed, Oct 03, 2012 at 11:28:25AM +1000, Dave Chinner wrote:
> > On Tue, Oct 02, 2012 at 05:20:29PM -0700, Kent Overstreet wrote:
> > > On Tue, Oct 02, 2012 at 01:41:17PM -0400, Jeff Moyer wrote:
> > > > Kent Overstreet <koverstreet@google.com> writes:
> > > > 
> > > > > So, I and other people keep running into things where we really need to
> > > > > add an interface to pass some auxiliary... stuff along with a pread() or
> > > > > pwrite().
> > > > >
> > > > > A few examples:
> > > > >
> > > > > * IO scheduler hints. Some userspace program wants to, per IO, specify
> > > > > either priorities or a cgroup - by specifying a cgroup you can have a
> > > > > fileserver in userspace that makes use of cfq's per cgroup bandwidth
> > > > > quotas.
> > > > 
> > > > You can do this today by splitting I/O between processes and placing
> > > > those processes in different cgroups.  For io priority, there is
> > > > ioprio_set, which incurs an extra system call, but can be used.  Not
> > > > elegant, but possible.
> > > 
> > > Yes - those are things I'm trying to replace. Doing it that way is a
> > > real pain, both as it's a lousy interface for this and it does impact
> > > performance (ioprio_set doesn't really work too well with aio, too).
> > > 
> > > > > * Cache hints. For bcache and other things, userspace may want to specify
> > > > > "this data should be cached", "this data should bypass the cache", etc.
> > > > 
> > > > Please explain how you will differentiate this from posix_fadvise.
> > > 
> > > Oh sorry, I think about SSD caching so much I forget to say that's what
> > > I'm talking about. posix_fadvise is for the page cache, we want
> > > something different for an SSD cache (IMO it'd be really ugly to use it
> > > for both, and posix_fadvise() can't really specifify everything we'd
> > > want to for an SSD cache).
> > 
> > Similar discussions about posix_fadvise() are being had for marking
> > ranges of files as volatile (i.e. useful for determining what can be
> > evicted from a cache when space reclaim is required).
> > 
> > https://lkml.org/lkml/2012/10/2/501
> 
> Hmm, interesting
> 
> Speaking as an implementor though, hints that aren't associated with any
> specific IO are harder to make use of - stuff is in the cache. What you
> really want is to know, for a given IO, whether to cache it or not, and
> possibly where in the LRU to stick it.

I can see how it might be useful, but it needs to have a defined set
of attributes that a file IO is allowed to have. If you don't define
the set, then what really have is an arbitrary set of storage-device
specific interfaces.

Of course, once we have a defined set of per-file IO policy
attributes, we don't really need per-IO attributes - you can just
set them through a range interface like fadvise() or fallocate().

> Well, it's quite possible that different implementations would have no
> trouble making use of those kinds of hints, I'm no doubt biased by
> having implemented bcache. With bcache though, cache replacement is done
> in terms of physical address space, not logical (i.e. the address space
> of the device being cached). 
> 
> So to handle posix_fadvise, we'd have to walk the btree and chase
> pointers to buckets, and modify the bucket priorities up or down... but
> what about the other data in those buckets? It's not clear what should
> happen, but there isn't any good way to take that into account.
> 
> (The exception is dropping data from the cache entirely, we can just
> invalidate that part of the keyspace and garbage collection will reclaim
> the buckets they pointed to. Bcache does that for discard requests,
> currently).

It sounds to me like you are saying is that the design of bcache is
unsuited to file-level management of caching policy, and that is why
you want to pass attributes directly to bcache with specific IOs. Is
that a fair summary of the problem you are describing here?

My problem with this approach has nothing to do with the per-IO
nature of it - it's to do with the layering violations and the
amount of storage specific knowledge needed to make effective use of
it. i.e. it seems like an interface that can only be used by people
intimately familiar with underlying storage implementation. You
happen to be one of those people, so I figure that you don't see a
problem with that. ;)

However, it also implies that an application must understand and use
a specific storage configuration that matches the attributes an
application sends. I understand how this model is appealling to
Google because they control the whole application and storage stack
(hardware and software) from top to bottom. However, I just don't
think that it is a solution that the rest of the world can use
effectively.

The scope of data locality, aging and IO priority policy
control is much larger than just controlling SSD caching.
SSD caching is just a another implementation of automatic tiering,
and HSMs have been doing this for years and years. It's the same
problem - space management and deciding what to leave in the
frequently accessed pool of fast storage for best performance.

Given that we have VFS level hot inode and offset range tracking not
that far away, we're soon going to have file-level access frequency
data available to both userspace and filesystems. Hence widespread
support for automatic heterogenous data teiring controlled at the
file range level isn't that far away.

As such, it follows that the management interface for data locality
policy (e.g. access frequency hints) needs to align with the method
of tracking access frequency that is be proposed. i.e. it should
also be be file range based. And if the hints are abstract, then the
underlying storage layers can translate that hint into something
appropriate for the given storage layer. Storage layer specific
hints (e.g. cache this IO) do not mean anything to layers that
don't have the functionality that is being asked for.

I'll also point out that a file range interface is the natural level
at which to manage access policies from an application developer's
POV, as it matches their existing view of how they store data. Most
applications don't know anything about how storage is implemented,
but they do know which files or parts of files they access
frequently.

Realistically, this is a complex problem, but I think we need to
solve the general access policy management problem rather inventing
ways of punching application/storage specific access information
through to random layers of the storage stack from userspace....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
