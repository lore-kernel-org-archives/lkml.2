Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab2K2GZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:25:29 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:54981 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab2K2GZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:25:28 -0500
Date: Thu, 29 Nov 2012 06:25:19 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Introduce a method to catch mmap_region (was: Recent
 kernel "mount" slow)
Message-ID: <20121129062519.GI4939@ZenIV.linux.org.uk>
References: <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com>
 <Pine.LNX.4.64.1211281422360.26389@file.rdu.redhat.com>
 <CA+55aFyXdtVJ=SG9bU4qfggCR6DPvz4vOFYxKJZx_WdyFv+3Fw@mail.gmail.com>
 <CA+55aFyXS0nkDB95c3pcdg1ctrNnUGO8aDuRNhKSEg3JrOqWhA@mail.gmail.com>
 <Pine.LNX.4.64.1211281540200.5283@file.rdu.redhat.com>
 <CA+55aFwbnQsvpsOLS6w_G35d4w+Ezv5tOx2SE7dShJhX4iP_0Q@mail.gmail.com>
 <Pine.LNX.4.64.1211281904010.3957@file.rdu.redhat.com>
 <CA+55aFz1Wv2S+3XVmZE1cfiN0TZ4gNA8yWbNgufDLTMc8sKf2A@mail.gmail.com>
 <CA+55aFxYCxsRM==WMGihQGOA7f5u2X_8boJypsxS2v=WMnr70g@mail.gmail.com>
 <CA+55aFxrkX_=4yNQ1TwjqU9=pkRY=ud+Kw3YnADJMJxA-ZqQUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxrkX_=4yNQ1TwjqU9=pkRY=ud+Kw3YnADJMJxA-ZqQUg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 10:16:21PM -0800, Linus Torvalds wrote:
> On Wed, Nov 28, 2012 at 6:58 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > But the fact that the code wants to do things like
> >
> >         block = (sector_t)page->index << (PAGE_CACHE_SHIFT - bbits);
> >
> > seriously seems to be the main thing that keeps us using
> > 'inode->i_blkbits'. Calculating bbits from bh->b_size is just costly
> > enough to hurt (not everywhere, but on some machines).
> >
> > Very annoying.
> 
> Hmm. Here's a patch that does that anyway. I'm not 100% happy with the
> whole ilog2 thing, but at the same time, in other cases it actually
> seems to improve code generation (ie gets rid of the whole unnecessary
> two dereferences through page->mapping->host just to get the block
> size, when we have it in the buffer-head that we have to touch
> *anyway*).
> 
> Comments? Again, untested.
> 
> And I notice that Al Viro hasn't been cc'd, which is sad, since he's
> been involved in much of fs/block_dev.c.
> 
> Al - this is an independent patch to fs/buffer.c to make
> fs/block_dev.c able to change the block size of a block device while
> there is IO in progress that may still use the old block size. The
> discussion has been on fsdevel and lkml, but you may have missed it...

	Umm...  set_blocksize() is calling kill_bdev(), which does
truncate_inode_pages(mapping, 0).  What's going to happen to data in
the dirty pages?  IO in progress is not the only thing to worry about...
