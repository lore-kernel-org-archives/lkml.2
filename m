Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432Ab1AXTsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:48:08 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40271 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab1AXTsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:48:07 -0500
To: Hugh Dickins <hughd@google.com>
CC: miklos@szeredi.hu, hch@infradead.org, akpm@linux-foundation.org,
        gurudas.pai@oracle.com, lkml20101129@newton.leun.net,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <alpine.LSU.2.00.1101212014330.4301@sister.anvils> (message from
	Hugh Dickins on Fri, 21 Jan 2011 20:46:00 -0800 (PST))
Subject: Re: [PATCH] mm: prevent concurrent unmap_mapping_range() on the same
 inode
References: <E1PftfG-0007w1-Ek@pomaz-ex.szeredi.hu> <20110120124043.GA4347@infradead.org> <E1PfvGx-00086O-IA@pomaz-ex.szeredi.hu> <alpine.LSU.2.00.1101212014330.4301@sister.anvils>
Message-Id: <E1PhSO8-0005yN-Dp@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 24 Jan 2011 20:47:44 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jan 2011, Hugh Dickins wrote:
> On Thu, 20 Jan 2011, Miklos Szeredi wrote:
> > On Thu, 20 Jan 2011, Christoph Hellwig wrote:
> > > On Thu, Jan 20, 2011 at 01:30:58PM +0100, Miklos Szeredi wrote:
> > > > 
> > > > Truncate and hole punching already serialize with i_mutex.  Other
> > > > callers of unmap_mapping_range() do not, and it's difficult to get
> > > > i_mutex protection for all callers.  In particular ->d_revalidate(),
> > > > which calls invalidate_inode_pages2_range() in fuse, may be called
> > > > with or without i_mutex.
> > > 
> > > 
> > > Which I think is mostly a fuse problem.  I really hate bloating the
> > > generic inode (into which the address_space is embedded) with another
> > > mutex for deficits in rather special case filesystems. 
> > 
> > As Hugh pointed out unmap_mapping_range() has grown a varied set of
> > callers, which are difficult to fix up wrt i_mutex.  Fuse was just an
> > example.
> > 
> > I don't like the bloat either, but this is the best I could come up
> > with for fixing this problem generally.  If you have a better idea,
> > please share it.
> 
> If we start from the point that this is mostly a fuse problem (I expect
> that a thorough audit will show up a few other filesystems too, but
> let's start from this point): you cite ->d_revalidate as a particular
> problem, but can we fix up its call sites so that it is always called
> either with, or much preferably without, i_mutex held?  Though actually
> I couldn't find where ->d_revalidate() is called while holding i_mutex.

lookup_one_len
lookup_hash
  __lookup_hash
    do_revalidate
      d_revalidate

I don't see an easy way to get rid of i_mutex for lookup_one_len() and
lookup_hash().

> Failing that, can fuse down_write i_alloc_sem before calling
> invalidate_inode_pages2(_range), to achieve the same exclusion?
> The setattr truncation path takes i_alloc_sem as well as i_mutex,
> though I'm not certain of its full coverage.

Yeah, fuse could use i_alloc_sem or a private mutex, but that would
leave the other uses of unmap_mapping_range() to sort this out for
themsevels.

Thanks,
Miklos


