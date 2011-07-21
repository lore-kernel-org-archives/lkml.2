Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab1GUSfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 14:35:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55368 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab1GUSf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 14:35:28 -0400
Date: Thu, 21 Jul 2011 20:35:23 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Curt Wohlgemuth <curtw@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: [PATCH] writeback: Don't wait for completion in
 writeback_inodes_sb_nr
Message-ID: <20110721183523.GA4509@quack.suse.cz>
References: <20110711170042.GE5482@quack.suse.cz>
 <CAO81RMairX_L5qGOcKKpw7gWdcTd2Y+5NL=+BA9EwTCNLCNmLw@mail.gmail.com>
 <20110711194835.GI5482@quack.suse.cz>
 <20110711201157.GA21460@infradead.org>
 <20110712103453.GC31226@quack.suse.cz>
 <20110712104132.GA14189@infradead.org>
 <20110712223715.GC13656@quack.suse.cz>
 <CAO81RMYJ76kdQ0qVuSSrfxugrTKAveSP98XQ2QF+VdbtjzJ--w@mail.gmail.com>
 <20110714230854.GA29160@quack.suse.cz>
 <20110719165639.GC11540@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110719165639.GC11540@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 19-07-11 12:56:39, Christoph Hellwig wrote:
> On Fri, Jul 15, 2011 at 01:08:54AM +0200, Jan Kara wrote:
> >   Actually, it's the other way around writeback_inodes_sb() is superfluous
> > because of wakeup_flusher_threads(). So something like attached patch could
> > improve sync times (especially in presence of other IO). So far I have only
> > checked that sync times look reasonable with it but didn't really compare
> > them with original kernel...
> 
> This changes the order in which ->quota_sync is called relatively to
> other operations, see my other mail about it.  Also the code gets really
> confusing at this point, I think you're better of stopping to try to
> shared code between syncfs, umount & co and sys_sync with these bits.
  Good point. I'll stop sharing the code for these two cases.

> You're also skipping the ->sync_fs and quotasync calls the first round.
  Well, kind of. Since writeback is running asynchronously, we have no way
to call ->sync_fs(sb, 0) just after async inode writeback is done (and it
doesn't really make sense to call it before that moment). So we call
synchronous inode writeback first and only then ->sync_fs().

> I know for XFS sync_fs without wait is already mostly a no-op, but we'll
> need to benchmark and document this change, and apply it to the non-sync
> caller as well.
  I already have some numbers:
I've checked pure sync overhead by
  sync; time for (( i = 0; i < 100; i++ )); do sync; done
the results of 5 runs are:
  avg 1.130400s, stddev 0.027369 (unpatched kernel)
  avg 1.073200s, stddev 0.040848 (patched kernel)
so as expected slightly better for patched kernel.

And test with 20000 4k files in 100 directories on xfs:
  avg 155.995600s, stddev 1.879084 (unpatched kernel)
  avg 155.942200s, stddev 1.843881 (patched kernel)
so no real difference.

The same test with ext3:
  avg 154.597200s, stddev 1.556965 (unpatched kernel)
  avg 153.109800s, stddev 1.339094 (patched kernel)
again almost no difference.

  Where would you like to document the change?

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
