Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab0EaOJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 10:09:25 -0400
Received: from smtp.nokia.com ([192.100.122.230]:16797 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342Ab0EaOJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 10:09:22 -0400
Subject: Re: [PATCHv4 17/17] writeback: lessen sync_supers wakeup count
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20100527065041.GA31073@ZenIV.linux.org.uk>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
	 <1274795352-3551-18-git-send-email-dedekind1@gmail.com>
	 <20100527065041.GA31073@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 May 2010 17:07:00 +0300
Message-ID: <1275314820.2678.153.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-6.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 31 May 2010 14:09:04.0029 (UTC) FILETIME=[D3666CD0:01CB00CA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 07:50 +0100, Al Viro wrote:
> Note, e.g., that in your series you've touched udf; it can set s_dirt
> until the cows come home, but without ->write_super() it'll be ignored
> by everything in VFS and fs/udf itself never looks at the damn thing.
> 
> A look around it shows fs/sysv, where we never clean the damn flag anymore
> for r/w mounts.  Yes, really (got broken a year ago, nobody noticed).
> 
> Or, e.g., BFS - there we have ->write_super() mark the buffer_head that
> contains on-disk sb dirty, and the only place that sets ->s_dirt is doing
> that immediately after having marked the same bh dirty itself.  Interesting
> place, at that - bfs_fill_super() at r/w mount time...  Note that ->sync_fs()
> there does *not* wait for anything, which is not the right thing to do.
> 
> IOW, this thing is a good topic for code review; I suspect that quite a few
> users might be gone as the result.

Al,

you requested me to review s_dirt usage, well, I'm trying now. One thing
I do not understand is s_dirt serialization, which seems to be just
absent in some FSes. I checked affs and ext2. E.g., affs does:

affs_alloc_block()
{
        mark_buffer_dirty(bh);
        sb->s_dirt = 1;
}

vs

affs_write_super()
{
	affs_commit_super();
	/* YYY: what if sb is marked as dirty right here? */
	sb->s_dirt = 0;
}

vs

/* This wakes up periodically */
sync_super()
{
	if (sb->s_root && sb->s_dirt)
		sb->s_op->write_super(sb);
}

ext2 seems to be doing something similar. It seems to me that FSes
should serialize s_dirt changes somehow, but they don't? Why this is not
a problem?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

