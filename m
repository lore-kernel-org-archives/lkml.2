Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab0FDE0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 00:26:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37731 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab0FDE0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 00:26:08 -0400
Date: Fri, 4 Jun 2010 05:26:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCHv4 17/17] writeback: lessen sync_supers wakeup count
Message-ID: <20100604042606.GA31073@ZenIV.linux.org.uk>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
 <1274795352-3551-18-git-send-email-dedekind1@gmail.com>
 <20100527065041.GA31073@ZenIV.linux.org.uk>
 <1275314820.2678.153.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275314820.2678.153.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 05:07:00PM +0300, Artem Bityutskiy wrote:
> you requested me to review s_dirt usage, well, I'm trying now. One thing
> I do not understand is s_dirt serialization, which seems to be just
> absent in some FSes. I checked affs and ext2. E.g., affs does:
> 
> affs_alloc_block()
> {
>         mark_buffer_dirty(bh);
>         sb->s_dirt = 1;
> }
> 
> vs
> 
> affs_write_super()
> {
> 	affs_commit_super();
> 	/* YYY: what if sb is marked as dirty right here? */
> 	sb->s_dirt = 0;
> }
> 
> vs
> 
> /* This wakes up periodically */
> sync_super()
> {
> 	if (sb->s_root && sb->s_dirt)
> 		sb->s_op->write_super(sb);
> }
> 
> ext2 seems to be doing something similar. It seems to me that FSes
> should serialize s_dirt changes somehow, but they don't? Why this is not
> a problem?

I suspect that most of those used to rely on lock_super() way back.
In case of ext2_sync_super() we probably want just to move ->s_dirt = 0
into the very beginning; no serialization is really needed beyond (_maybe_)
some barriers.  No idea about affs, needs to be checked.
