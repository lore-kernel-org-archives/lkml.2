Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab0CVM0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:26:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:51054 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087Ab0CVM0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:26:36 -0400
Date: Mon, 22 Mar 2010 23:26:32 +1100
From: Nick Piggin <npiggin@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc][patch] mm, fs: warn on missing address space operations
Message-ID: <20100322122632.GM17637@laptop>
References: <20100322053937.GA17637@laptop>
 <20100322115508.GE30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322115508.GE30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 11:55:08AM +0000, Al Viro wrote:
> On Mon, Mar 22, 2010 at 04:39:37PM +1100, Nick Piggin wrote:
> > It's ugly and lazy that we do these default aops in case it has not
> > been filled in by the filesystem.
> > 
> > A NULL operation should always mean either: we don't support the
> > operation; we don't require any action; or a bug in the filesystem,
> > depending on the context.
> > 
> > In practice, if we get rid of these fallbacks, it will be clearer
> > what operations are used by a given address_space_operations struct,
> > reduce branches, reduce #if BLOCK ifdefs, and should allow us to get
> > rid of all the buffer_head knowledge from core mm and fs code.
> > 
> > We could add a patch like this which spits out a recipe for how to fix
> > up filesystems and get them all converted quite easily.
> 
> Um.  Seeing that part of that is for methods absent in mainline (->release(),
> ->sync()), I'd say that making it mandatory at that point is a bad idea.

Yea I didn't have patch order right for a real submission. And clearly
_most_ of the in-tree fses should be converted before actually merging
such warnings.

> 
> As for the rest...  We have 90 instances of address_space_operations
> in the kernel.  Out of those:
> 	28 have ->releasepage != NULL
> 	27 have ->set_page_dirty != NULL
> 	25 have ->invalidatepage != NULL
> 
> So I'm not even sure that adding that much boilerplate makes sense.

Fair position. The arguments pro are more about cleaner code than any
major improvement. Main thing I don't like that it isn't trivial to see
whether an address space class will use a given function or not. You'd
have to first check the aop to find it's NULL, then check callers to see
whether there is a fallback, then check the fs in case it can attach
buffers that will still be attached at point of calls.

I personally would prefer function pointers filled in.

