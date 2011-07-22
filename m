Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab1GVPLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:11:46 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44500
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754524Ab1GVPLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:11:44 -0400
Date: Fri, 22 Jul 2011 11:11:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Curt Wohlgemuth <curtw@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: [PATCH] writeback: Don't wait for completion in
 writeback_inodes_sb_nr
Message-ID: <20110722151139.GB30317@infradead.org>
References: <BANLkTinndb4oHi6kNQrTsL86UrKDB=2rK6-gA8FM1Nj8CKYZ+w@mail.gmail.com>
 <20110711170042.GE5482@quack.suse.cz>
 <CAO81RMairX_L5qGOcKKpw7gWdcTd2Y+5NL=+BA9EwTCNLCNmLw@mail.gmail.com>
 <20110711194835.GI5482@quack.suse.cz>
 <20110711201157.GA21460@infradead.org>
 <20110712103453.GC31226@quack.suse.cz>
 <20110712104132.GA14189@infradead.org>
 <20110712223715.GC13656@quack.suse.cz>
 <20110719165149.GA11540@infradead.org>
 <20110720220012.GA23529@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110720220012.GA23529@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 12:00:12AM +0200, Jan Kara wrote:
> > Removing this call breaks sys_syncfs and similar semantics on filesystem
> > just pushing metadata into buffers in ->write_inode or ->sync_fs and
> > then expecting the caller to write them out.  This list of filesystem
> > includes ext2 and in general most filesystems without journaling or
> > similar technics.
>   Note that for sys_syncfs() the __sync_blockdev() has just moved from
> __sync_filesystem() to sync_filesystem(). So nothing should change.

Sorry, I missed that.

> > I'm perfectly fine with pushing the sync_blockdev call into the
> > filesystem for these, but we'll need a way to handle them.
>   Yes, calling sync_blockdev() from sync_fs() might actually make sence
> (e.g. ext3 and ext4 don't need it) but I didn't want to go that far in
> this patch.

The more fine-grained we can split the patches, the better.  It'll help
to explain what we're doing to thise trying to figure out a few years
down the road.

> > At which point we could fold this code into a blkdev_sync_fs method for
> > now.  Long term we'll need to support multiple BDIs per SB anyway, at
> > which point the code can go away again.
>   Ah, I had to think a bit before I understood what you mean :). It's kind
> of elegant but also slightly subtle (it's not immediately obvious how
> blockdevs are synced during sync when you look at the code). Umm, and you
> don't have any guarantee in which order superblocks are on the sb list so
> you could sync block devices before some filesystems are finished. So I
> don't think using blkdev_sync_fs() is a good idea after all.

This required calling sync_blkdev from ->sync_fs of those filesystems
that actually need it as a pre-requisite of course.

