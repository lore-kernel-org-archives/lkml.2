Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294Ab1EJMid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 08:38:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41735 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756426Ab1EJMia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 08:38:30 -0400
Date: Tue, 10 May 2011 14:38:19 +0200
From: Jan Kara <jack@suse.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Theodore Tso <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jeff Layton <jlayton@redhat.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        Chris Mason <chris.mason@oracle.com>, Joel Becker <jlbec@evilplan.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>
Subject: Re: [PATCHSET v3.1 0/7] data integrity: Stabilize pages during
 writeback for various fses
Message-ID: <20110510123819.GB4402@quack.suse.cz>
References: <20110509230318.19566.66202.stgit@elm3c44.beaverton.ibm.com>
 <87tyd31fkc.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tyd31fkc.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 10-05-11 10:59:15, OGAWA Hirofumi wrote:
> "Darrick J. Wong" <djwong@us.ibm.com> writes:
> 
> > To assess the performance impact of stable page writes, I moved to a disk that
> > doesn't have DIF support so that I could measure just the impact of waiting for
> > writeback.  I first ran wac with 64 threads madly scribbling on a 64k file and
> > saw about a 12 percent performance decrease.  I then reran the wac program with
> > 64 threads and a 64MB file and saw about the same performance numbers.  As I
> > suspected, the patchset only seems to impact workloads that rewrite the same
> > memory page frequently.
> >
> > I am still chasing down what exactly is broken in ext3.  data=writeback mode
> > passes with no failures.  data=ordered, however, does not pass; my current
> > suspicion is that jbd is calling submit_bh on data buffers but doesn't call
> > page_mkclean to kick the userspace programs off the page before writing it.
> >
> > Per various comments regarding v3 of this patchset, I've integrated his
> > suggestions, reworked the patch descriptions to make it clearer which ones
> > touch all the filesystems and which ones are to fix remaining holes in specific
> > filesystems, and expanded the scope of filesystems that got fixed.
> >
> > As always, questions and comments are welcome; and thank you to all the
> > previous reviewers of this patchset.  I am also soliciting people's opinions on
> > whether or not these patches could go upstream for .40.
> 
> I'd like to know those patches are on what state. Waiting in writeback
> page makes slower, like you mentioned it (I guess it would more
> noticeable if device was slower that like FAT uses). And I think
> currently it doesn't help anything others for blk-integrity stuff
> (without other technic, it doesn't help FS consistency)?
> 
> So, why is this locking stuff enabled always? I think it would be better
> to enable only if blk-integrity stuff was enabled.
> 
> If it was more sophisticate but more complex stuff (e.g. use
> copy-on-write technic for it), I would agree always enable though.
  Well, also software RAID generally needs this feature (so that parity
information / mirror can be properly kept in sync). Not that I'd advocate
that this feature must be always enabled, it's just that there are also
other users besides blk-integrity.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
