Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab0E0Gun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 02:50:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60099 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab0E0Gum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 02:50:42 -0400
Date: Thu, 27 May 2010 07:50:41 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCHv4 17/17] writeback: lessen sync_supers wakeup count
Message-ID: <20100527065041.GA31073@ZenIV.linux.org.uk>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
 <1274795352-3551-18-git-send-email-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274795352-3551-18-git-send-email-dedekind1@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 04:49:12PM +0300, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> The 'sync_supers' thread wakes up every 5 seconds (by default) and
> writes back all super blocks. It keeps waking up even if there
> are no dirty super-blocks. For many file-systems the superblock
> becomes dirty very rarely, if ever, so 'sync_supers' does not do
> anything most of the time.
> 
> This patch improves 'sync_supers' and makes sleep if all superblocks
> are clean and there is nothing to do. This helps saving the power.
> This optimization is important for small battery-powered devices.

> +void mark_sb_dirty(struct super_block *sb)
> +{
> +	sb->s_dirty = 1;
> +
> +	spin_lock(&supers_timer_lock);
> +	if (!supers_timer_armed) {
> +		bdi_arm_supers_timer();
> +		supers_timer_armed = 1;
> +	} else if (supers_timer_armed == -1)
> +		supers_timer_armed = 1;
> +	spin_unlock(&supers_timer_lock);
> +}
> +EXPORT_SYMBOL(mark_sb_dirty);

Ouch...   That turns a previously trivial operation into something
much heavier; moreover, I'd rather see serious review of s_dirt
uses.

Note, e.g., that in your series you've touched udf; it can set s_dirt
until the cows come home, but without ->write_super() it'll be ignored
by everything in VFS and fs/udf itself never looks at the damn thing.

A look around it shows fs/sysv, where we never clean the damn flag anymore
for r/w mounts.  Yes, really (got broken a year ago, nobody noticed).

Or, e.g., BFS - there we have ->write_super() mark the buffer_head that
contains on-disk sb dirty, and the only place that sets ->s_dirt is doing
that immediately after having marked the same bh dirty itself.  Interesting
place, at that - bfs_fill_super() at r/w mount time...  Note that ->sync_fs()
there does *not* wait for anything, which is not the right thing to do.

IOW, this thing is a good topic for code review; I suspect that quite a few
users might be gone as the result.
