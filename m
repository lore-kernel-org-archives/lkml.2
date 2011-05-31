Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab1EaVIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 17:08:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40795 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab1EaVIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 17:08:41 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Hugh Dickins <hughd@google.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: RE: [PATCH 1/14] mm: invalidate_mapping_pages flush cleancache
In-reply-to: <alpine.LSU.2.00.1105310951160.1719@sister.anvils>
References: <ba74b4e5-500e-4662-ade0-c0b714b8f570@default> <alpine.LSU.2.00.1105310951160.1719@sister.anvils>
Date: Tue, 31 May 2011 17:08:25 -0400
Message-Id: <1306875919-sup-647@shiny>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DE558D5.00AF:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Hugh Dickins's message of 2011-05-31 13:05:27 -0400:
> On Tue, 31 May 2011, Dan Magenheimer wrote:
> > > 
> > > truncate_inode_pages_range() and invalidate_inode_pages2_range()
> > > call cleancache_flush_inode(mapping) before and after: shouldn't
> > > invalidate_mapping_pages() be doing the same?
> > 
> > I don't claim to be an expert on VFS, and so I have cc'ed
> > Chris Mason who originally placed the cleancache hooks
> > in VFS, but I think this patch is unnecessary.  Instead
> > of flushing ALL of the cleancache pages belonging to
> > the inode with cleancache_flush_inode, the existing code
> > eventually calls __delete_from_page_cache on EACH page
> > that is being invalidated.
> 
> On each one that's in pagecache (and satisfies the other "can we
> do it easily?" conditions peculiar to invalidate_mapping_pages()).
> But there may be other slots in the range that don't reach
> __delete_from_page_cache() e.g. because not currently in pagecache,
> but whose cleancache ought to be flushed.  I think that's what a
> caller of invalidate_mapping_pages(), e.g. drop caches, expects.

We call invalidate_mapping_pages from prune_icache, so if we drop the
cleancache there we lose the cache entries any time the inode is dropped
from ram.

Is there a specific case you're thinking of where we want to drop the
cleancache but don't have the pages?

O_DIRECT perhaps?

-chris
