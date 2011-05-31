Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804Ab1EaRFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 13:05:54 -0400
Received: from smtp-out.google.com ([74.125.121.67]:15295 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757767Ab1EaRFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 13:05:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=a2ZmrTlOMB+V+VXER7kVMZBqR2RM63pq/ku4iM0bI5TAqIJ97Bpy94auGIXQZGq146
         cOUzkJIuYnSQ00b7ahQA==
Date: Tue, 31 May 2011 10:05:27 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Dan Magenheimer <dan.magenheimer@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, chris.mason@oracle.com
Subject: RE: [PATCH 1/14] mm: invalidate_mapping_pages flush cleancache
In-Reply-To: <ba74b4e5-500e-4662-ade0-c0b714b8f570@default>
Message-ID: <alpine.LSU.2.00.1105310951160.1719@sister.anvils>
References: <alpine.LSU.2.00.1105301726180.5482@sister.anvils alpine.LSU.2.00.1105301733500.5482@sister.anvils> <ba74b4e5-500e-4662-ade0-c0b714b8f570@default>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011, Dan Magenheimer wrote:
> > 
> > truncate_inode_pages_range() and invalidate_inode_pages2_range()
> > call cleancache_flush_inode(mapping) before and after: shouldn't
> > invalidate_mapping_pages() be doing the same?
> 
> I don't claim to be an expert on VFS, and so I have cc'ed
> Chris Mason who originally placed the cleancache hooks
> in VFS, but I think this patch is unnecessary.  Instead
> of flushing ALL of the cleancache pages belonging to
> the inode with cleancache_flush_inode, the existing code
> eventually calls __delete_from_page_cache on EACH page
> that is being invalidated.

On each one that's in pagecache (and satisfies the other "can we
do it easily?" conditions peculiar to invalidate_mapping_pages()).
But there may be other slots in the range that don't reach
__delete_from_page_cache() e.g. because not currently in pagecache,
but whose cleancache ought to be flushed.  I think that's what a
caller of invalidate_mapping_pages(), e.g. drop caches, expects.

> And since __delete_from_page_cache
> calls cleancache_flush_page, only that subset of pages
> in the mapping that invalidate_mapping_pages() would
> invalidate (which, from the comment above the routine
> indicates, is only *unlocked* pages) is removed from
> cleancache.

It's nice to target the particular range asked for, rather than
throwing away all the cleancache for the whole mapping, I can
see that (though that's a defect in the cleancache_flush_inode()
interface).  But then why do truncate_inode_pages_range() and
invalidate_inode_pages2_range() throw it all away, despite
going down to __delete_from_page_cache on individual pages found?

Maybe the right patch is to remove cleancache_flush_inode() from
the two instead of adding it to the one?  But I think not.

Hugh
