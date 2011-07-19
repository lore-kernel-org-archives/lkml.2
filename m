Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661Ab1GSQ4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 12:56:44 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38840
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750906Ab1GSQ4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 12:56:43 -0400
Date: Tue, 19 Jul 2011 12:56:39 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Curt Wohlgemuth <curtw@google.com>, Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: [PATCH] writeback: Don't wait for completion in
 writeback_inodes_sb_nr
Message-ID: <20110719165639.GC11540@infradead.org>
References: <BANLkTinndb4oHi6kNQrTsL86UrKDB=2rK6-gA8FM1Nj8CKYZ+w@mail.gmail.com>
 <20110711170042.GE5482@quack.suse.cz>
 <CAO81RMairX_L5qGOcKKpw7gWdcTd2Y+5NL=+BA9EwTCNLCNmLw@mail.gmail.com>
 <20110711194835.GI5482@quack.suse.cz>
 <20110711201157.GA21460@infradead.org>
 <20110712103453.GC31226@quack.suse.cz>
 <20110712104132.GA14189@infradead.org>
 <20110712223715.GC13656@quack.suse.cz>
 <CAO81RMYJ76kdQ0qVuSSrfxugrTKAveSP98XQ2QF+VdbtjzJ--w@mail.gmail.com>
 <20110714230854.GA29160@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110714230854.GA29160@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 01:08:54AM +0200, Jan Kara wrote:
>   Actually, it's the other way around writeback_inodes_sb() is superfluous
> because of wakeup_flusher_threads(). So something like attached patch could
> improve sync times (especially in presence of other IO). So far I have only
> checked that sync times look reasonable with it but didn't really compare
> them with original kernel...

This changes the order in which ->quota_sync is called relatively to
other operations, see my other mail about it.  Also the code gets really
confusing at this point, I think you're better of stopping to try to
shared code between syncfs, umount & co and sys_sync with these bits.

You're also skipping the ->sync_fs and quotasync calls the first round.
I know for XFS sync_fs without wait is already mostly a no-op, but we'll
need to benchmark and document this change, and apply it to the non-sync
caller as well.
