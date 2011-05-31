Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932752Ab1EaWBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 18:01:49 -0400
Received: from smtp-out.google.com ([74.125.121.67]:25640 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758298Ab1EaWBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 18:01:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Wsc1f7ENXviyuisbNtKUWxYxyW35zKKXBJ5LFSG6HOOk+Hxg2TVTqmv6M/JjndVqdX
         HdtmUm+zn+Qybf7yWoMg==
Date: Tue, 31 May 2011 15:01:36 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Chris Mason <chris.mason@oracle.com>
cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: RE: [PATCH 1/14] mm: invalidate_mapping_pages flush cleancache
In-Reply-To: <1306875919-sup-647@shiny>
Message-ID: <alpine.LSU.2.00.1105311500440.20988@sister.anvils>
References: <ba74b4e5-500e-4662-ade0-c0b714b8f570@default> <alpine.LSU.2.00.1105310951160.1719@sister.anvils> <1306875919-sup-647@shiny>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011, Chris Mason wrote:
> Excerpts from Hugh Dickins's message of 2011-05-31 13:05:27 -0400:
> > On Tue, 31 May 2011, Dan Magenheimer wrote:
> > > > 
> > > > truncate_inode_pages_range() and invalidate_inode_pages2_range()
> > > > call cleancache_flush_inode(mapping) before and after: shouldn't
> > > > invalidate_mapping_pages() be doing the same?
> > > 
> > > I don't claim to be an expert on VFS, and so I have cc'ed
> > > Chris Mason who originally placed the cleancache hooks
> > > in VFS, but I think this patch is unnecessary.  Instead
> > > of flushing ALL of the cleancache pages belonging to
> > > the inode with cleancache_flush_inode, the existing code
> > > eventually calls __delete_from_page_cache on EACH page
> > > that is being invalidated.
> > 
> > On each one that's in pagecache (and satisfies the other "can we
> > do it easily?" conditions peculiar to invalidate_mapping_pages()).
> > But there may be other slots in the range that don't reach
> > __delete_from_page_cache() e.g. because not currently in pagecache,
> > but whose cleancache ought to be flushed.  I think that's what a
> > caller of invalidate_mapping_pages(), e.g. drop caches, expects.
> 
> We call invalidate_mapping_pages from prune_icache, so if we drop the
> cleancache there we lose the cache entries any time the inode is dropped
> from ram.

I hadn't noticed that use of invalidate_mapping_pages().  Right,
I can understand that you wouldn't want to drop the cleancache there.

I was more conscious of the dispose_list() at the end of prune_icache(),
which would call truncate_inode_pages(), which would flush cleancache.

Ah, but inode only gets on the freeable list if can_unuse(inode),
and one of the reasons to retain the inode is if nrpages is non-0.

All rather odd, and what it adds up to, I think, is that if that
invalidate_mapping_pages() succeeds in removing all the pages from
the page cache (but leaving some in cleancache), then the inode may
advance to truncate_inode_pages(), and meet cleancache_flush_inode()
there.  (It happens to be called before the mapping->nrpages test.)

All rather odd, both the pruning decisions and the cleancache decisions.

> 
> Is there a specific case you're thinking of where we want to drop the
> cleancache but don't have the pages?

The case I was thinking of, where I'd met invalidate_mapping_pages()
before, is fs/drop_caches.c ... which is about, er, dropping caches.

(But in general, why would you care to keep the cleancache when you
do have the pages?  I thought its use was for the pages we don't have.)

> 
> O_DIRECT perhaps?

Hadn't given it a thought.  But now you mention it, yes,
that one looks like a worry too.

Hugh
