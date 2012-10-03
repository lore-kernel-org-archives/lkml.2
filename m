Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab2JCClt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 22:41:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46258 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab2JCClp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 22:41:45 -0400
Date: Tue, 2 Oct 2012 19:41:10 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tytso@google.com, tj@kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@zabbo.net>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        michael.mesnier@intel.com, jeffrey.d.skirvin@intel.com, pjt@google.com
Subject: Re: [RFC, PATCH] Extensible AIO interface
Message-ID: <20121003024110.GA19788@moria.home.lan>
References: <20121001222341.GF26488@google.com>
 <x49zk44ojpe.fsf@segfault.boston.devel.redhat.com>
 <20121003002029.GY26488@google.com>
 <20121003012825.GX23520@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003012825.GX23520@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 11:28:25AM +1000, Dave Chinner wrote:
> On Tue, Oct 02, 2012 at 05:20:29PM -0700, Kent Overstreet wrote:
> > On Tue, Oct 02, 2012 at 01:41:17PM -0400, Jeff Moyer wrote:
> > > Kent Overstreet <koverstreet@google.com> writes:
> > > 
> > > > So, I and other people keep running into things where we really need to
> > > > add an interface to pass some auxiliary... stuff along with a pread() or
> > > > pwrite().
> > > >
> > > > A few examples:
> > > >
> > > > * IO scheduler hints. Some userspace program wants to, per IO, specify
> > > > either priorities or a cgroup - by specifying a cgroup you can have a
> > > > fileserver in userspace that makes use of cfq's per cgroup bandwidth
> > > > quotas.
> > > 
> > > You can do this today by splitting I/O between processes and placing
> > > those processes in different cgroups.  For io priority, there is
> > > ioprio_set, which incurs an extra system call, but can be used.  Not
> > > elegant, but possible.
> > 
> > Yes - those are things I'm trying to replace. Doing it that way is a
> > real pain, both as it's a lousy interface for this and it does impact
> > performance (ioprio_set doesn't really work too well with aio, too).
> > 
> > > > * Cache hints. For bcache and other things, userspace may want to specify
> > > > "this data should be cached", "this data should bypass the cache", etc.
> > > 
> > > Please explain how you will differentiate this from posix_fadvise.
> > 
> > Oh sorry, I think about SSD caching so much I forget to say that's what
> > I'm talking about. posix_fadvise is for the page cache, we want
> > something different for an SSD cache (IMO it'd be really ugly to use it
> > for both, and posix_fadvise() can't really specifify everything we'd
> > want to for an SSD cache).
> 
> Similar discussions about posix_fadvise() are being had for marking
> ranges of files as volatile (i.e. useful for determining what can be
> evicted from a cache when space reclaim is required).
> 
> https://lkml.org/lkml/2012/10/2/501

Hmm, interesting

Speaking as an implementor though, hints that aren't associated with any
specific IO are harder to make use of - stuff is in the cache. What you
really want is to know, for a given IO, whether to cache it or not, and
possibly where in the LRU to stick it.

Well, it's quite possible that different implementations would have no
trouble making use of those kinds of hints, I'm no doubt biased by
having implemented bcache. With bcache though, cache replacement is done
in terms of physical address space, not logical (i.e. the address space
of the device being cached). 

So to handle posix_fadvise, we'd have to walk the btree and chase
pointers to buckets, and modify the bucket priorities up or down... but
what about the other data in those buckets? It's not clear what should
happen, but there isn't any good way to take that into account.

(The exception is dropping data from the cache entirely, we can just
invalidate that part of the keyspace and garbage collection will reclaim
the buckets they pointed to. Bcache does that for discard requests,
currently).

> If you have requirements for specific cache management, then it
> might be worth seeing if you can steer an existing interface
> proposal for some form of cache management in the direction you
> need.

Certainly - I don't plan on implementing anything bcache specific, or
implementing anything from scratch if there's a good proposal out there.
But a per-io interface does seem useful from an implementation pov and
natural to use for at least some classes of applications.
