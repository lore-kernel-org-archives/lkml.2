Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab2EWFeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 01:34:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48762 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab2EWFeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 01:34:03 -0400
Date: Wed, 23 May 2012 01:34:03 -0400
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Tejun Heo <tejun@google.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 11/16] bcache: Core btree code
Message-ID: <20120523053403.GB14312@dhcp-172-18-216-138.mtv.corp.google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <7f1de39b6d7040b3fe271500776f4b985b21ea82.1336619038.git.koverstreet@google.com>
 <20120522221259.GJ14339@google.com>
 <20120523034546.GB607@dhcp-172-18-216-138.mtv.corp.google.com>
 <20120523052054.GB29976@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120523052054.GB29976@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 10:20:54PM -0700, Tejun Heo wrote:
> Hmmm... I would prefer it to be defined explicitly as union.  It's
> rather easy to define it incorrectly (ie. using struct bkey) and then
> pass it around expecting it to have the pad.

Thing is, things don't expect the pad - bkeys are normally just in a big
chunk of memory concatenated together, and the same functions have to
work both with those and with bare bkeys the code occasionally
manipulates.

> It doesn't have to be full bcache.  e.g. words starting with cache can
> simply have 'b' in front and others can use things like bc_ or
> whatever.

Ok, that sounds quite reasonable.

> 
> > > So, apart from the the macros, key is 64bit containing the backend
> > > device and extent offset and size with the ptr fields somehow point to
> > > cache.  Am I understanding it correctly?  If right, I'm *tiny* bit
> > > apprehensive about using only 43bits for offset.  While the block 9
> > > bits means 52bit addressing, the 9 bit block size is now there mostly
> > > to work as buffer between memory bitness growth and storage device
> > > size growth so that we have 9 bit buffer as storage device reaches
> > > ulong addressing limit.  Probably those days are far out enough.
> > 
> > You're exactly right. I had similar thoughts about the offset size,
> > but... it'll last until we have 8 exabyte cache devices, and I can't
> 
> I'm a bit confused.  Cache device or cached device?  Isn't the key
> dev:offset:size of the cached device?

No - bkey->key is the offset on the cached device, PTR_OFFSET is on the
cache.

Confusing, I know. Any ideas for better terminology?

> 
> > > mca_data_alloc() failure path seems like a resource leak but it isn't
> > > because mca_data_alloc() puts it in free list.  Is the extra level of
> > > caching necessary?  How is it different from sl?b allocator cache?
> > > And either way, comments please.
> > 
> > This btree in memory cache code is probably the nastiest, subtlest,
> > trickiest code in bcache. I have some cleanups in a branch somewhere as
> > part of some other work that I need to finish off.
> > 
> > The btree_cache_freed list isn't for caching - we never free struct
> > btrees except on shutdown, to simplify the code. It doesn't cost much
> > memory since the memory usage is dominated by the buffers struct btree
> > points to, and those are freed when necessary.
> 
> Out of curiosity, how does not freeing make the code simpler?  Is it
> something synchronization related?

Yeah - looking up btree nodes in the in memory cache involves checking a
lockless hash table (i.e. using hlist_for_each_rcu()).

It would be fairly trivial to free them with kfree_rcu(), but I'd have
to go through and make sure there aren't any other places where there
could be dangling references - i.e. io related stuff. And I wouldn't be
able to delete any code - I need the btree_cache_freed list anyways so I
can preallocate a reserve at startup.

I all the changes I've made based on your review feedback so far up -
git://evilpiepirate.org/~kent/linux-bcache.git bcache-3.3-dev

Kent Overstreet (7):
      Document some things and incorporate some review feedback
      bcache: Fix a bug in submit_bbio_split()
      bcache: sprint_string_list() -> snprint_string_list()
      Add human-readable units modifier to vsnprintf()
      bcache: Kill hprint()
      bcache: Review feedback
      bcache: Kill popcount()
