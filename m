Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab1AVEqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 23:46:19 -0500
Received: from smtp-out.google.com ([74.125.121.67]:39183 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab1AVEqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 23:46:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Bc6zOtw8rphEoLUcIv2nX0HoHsPzaTIJ1I9GUQnExQtWFo4/KrQrCw6z9ll4ZD5JGc
         h+6yTlYHE3Ko65elUhTA==
Date: Fri, 21 Jan 2011 20:46:00 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Miklos Szeredi <miklos@szeredi.hu>
cc: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
        gurudas.pai@oracle.com, lkml20101129@newton.leun.net,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: prevent concurrent unmap_mapping_range() on the same
 inode
In-Reply-To: <E1PfvGx-00086O-IA@pomaz-ex.szeredi.hu>
Message-ID: <alpine.LSU.2.00.1101212014330.4301@sister.anvils>
References: <E1PftfG-0007w1-Ek@pomaz-ex.szeredi.hu> <20110120124043.GA4347@infradead.org> <E1PfvGx-00086O-IA@pomaz-ex.szeredi.hu>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011, Miklos Szeredi wrote:
> On Thu, 20 Jan 2011, Christoph Hellwig wrote:
> > On Thu, Jan 20, 2011 at 01:30:58PM +0100, Miklos Szeredi wrote:
> > > 
> > > Truncate and hole punching already serialize with i_mutex.  Other
> > > callers of unmap_mapping_range() do not, and it's difficult to get
> > > i_mutex protection for all callers.  In particular ->d_revalidate(),
> > > which calls invalidate_inode_pages2_range() in fuse, may be called
> > > with or without i_mutex.
> > 
> > 
> > Which I think is mostly a fuse problem.  I really hate bloating the
> > generic inode (into which the address_space is embedded) with another
> > mutex for deficits in rather special case filesystems. 
> 
> As Hugh pointed out unmap_mapping_range() has grown a varied set of
> callers, which are difficult to fix up wrt i_mutex.  Fuse was just an
> example.
> 
> I don't like the bloat either, but this is the best I could come up
> with for fixing this problem generally.  If you have a better idea,
> please share it.

If we start from the point that this is mostly a fuse problem (I expect
that a thorough audit will show up a few other filesystems too, but
let's start from this point): you cite ->d_revalidate as a particular
problem, but can we fix up its call sites so that it is always called
either with, or much preferably without, i_mutex held?  Though actually
I couldn't find where ->d_revalidate() is called while holding i_mutex.

Failing that, can fuse down_write i_alloc_sem before calling
invalidate_inode_pages2(_range), to achieve the same exclusion?
The setattr truncation path takes i_alloc_sem as well as i_mutex,
though I'm not certain of its full coverage.

I did already consider holding and dropping i_alloc_sem inside
invalidate_inode_pages2_range(); but direct-io.c very much wants
to take mmap_sem (when get_user_pages_fast goes slow) after taking
i_alloc_sem, whereas fuse_direct_mmap() very much wants to call
invalidate_inode_pages2() while mmap_sem is held.

Hugh
