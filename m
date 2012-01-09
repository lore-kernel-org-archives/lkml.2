Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab2AIV1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 16:27:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33477 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab2AIV1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 16:27:05 -0500
Date: Mon, 9 Jan 2012 21:26:55 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, gregkh@suse.de,
        akpm@linux-foundation.org
Subject: Re: [RFC PATCH] shrink_dcache_parent() deadlock
Message-ID: <20120109212654.GY23916@ZenIV.linux.org.uk>
References: <87ipkl87m9.fsf@tucsk.pomaz.szeredi.hu>
 <20120109171639.GA9359@infradead.org>
 <20120109173010.GX23916@ZenIV.linux.org.uk>
 <CA+55aFwikQQrpGoyxvY+y=B8NfKBSdcAnKME+xZh+N1TQfp8LA@mail.gmail.com>
 <20120109205907.GE4198@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120109205907.GE4198@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 07:59:07AM +1100, Dave Chinner wrote:
> > Comments?
> 
> Looks OK to me.

OK, grabbed.  And there's *more* fixes for obvious shite - by now I'm
really sick and tired of what people are doing with failure exits;
this morning catch just from looking through d_alloc_root() callers:
	isofs - inode leak
	ext4 - dentry leak + completely bogus handling of ext4_mb_init()
failure (stuff that hadn't been allocated gets freed, stuff that was
allocated isn't)
	ceph - d_alloc_root() can fail.  NULL pointer derefs galore...
)

Frankly, d_alloc_root() had been a bad API; it should've been doing
iput() on allocation failure.  I've added a trivial helper in the
local tree (d_make_root(inode) - same as d_alloc_root(inode) and do
iput(inode) if result turns out to be NULL).  Looks like *all* callers
of d_alloc_root() either turn out to be buggy or trivially convert to
d_make_root().  With a lot of boilerplate crap removed...

Hell knows...  Originally I thought about leaving both side-by-side, but
it really starts looking as if there's no reason to keep d_alloc_root()
at all...  I still have a couple of callers to check, though.
