Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab0G2S7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 14:59:12 -0400
Received: from THUNK.ORG ([69.25.196.29]:40459 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875Ab0G2S7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 14:59:09 -0400
Date: Thu, 29 Jul 2010 14:58:49 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>,
        jaxboe@fusionio.com, James.Bottomley@suse.de,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        chris.mason@oracle.com, swhiteho@redhat.com,
        konishi.ryusuke@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
        kernel-bugs@lists.ubuntu.com
Subject: Re: extfs reliability
Message-ID: <20100729185849.GH4506@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Vladislav Bolkhovitin <vst@vlnb.net>,
	Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>,
	Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>,
	jaxboe@fusionio.com, James.Bottomley@suse.de,
	linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
	chris.mason@oracle.com, swhiteho@redhat.com,
	konishi.ryusuke@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
	kernel-bugs@lists.ubuntu.com
References: <20100728082447.GA7668@lst.de>
 <4C4FECFE.9040509@kernel.org>
 <20100728085048.GA8884@lst.de>
 <4C4FF136.5000205@kernel.org>
 <20100728090025.GA9252@lst.de>
 <4C4FF592.9090800@kernel.org>
 <20100728092859.GA11096@lst.de>
 <20100729014431.GD4506@thunk.org>
 <20100729083142.GA30077@lst.de>
 <4C517B5A.3020905@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C517B5A.3020905@vlnb.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 05:00:10PM +0400, Vladislav Bolkhovitin wrote:
> Christoph Hellwig, on 07/29/2010 12:31 PM wrote:
> > My reading of the ext3/jbd code we explicitly wait on I/O completion
> > of dependent writes, and only require those to actually be stable
> > by issueing a flush.   If that wasn't the case the default ext3
> > barriers off behaviour would not only be dangerous on devices with
> > volatile write caches, but also on devices that do not have them,
> > which in addition to the reading of the code is not what we've seen
> > in actual power fail testing, where ext3 does well as long as there
> > is no volatile write cache.
> 
> Basically, it is so, but, unfortunately, not absolutely. I've just tried 2 tests on ext4 with iSCSI:

Well, this thread was talking about something else (which is how
various file systems handle barriers), and not bugs about what happen
when a disk disappears from a system due to attachment failure --- but
that's fine, we can deal with that here.

> Segmentation fault

OK, I've looked at your kernel messages, and it looks like the problem
comes from this:

	/* Debugging code just in case the in-memory inode orphan list
	 * isn't empty.  The on-disk one can be non-empty if we've
	 * detected an error and taken the fs readonly, but the
	 * in-memory list had better be clean by this point. */
	if (!list_empty(&sbi->s_orphan))
		dump_orphan_list(sb, sbi);
	J_ASSERT(list_empty(&sbi->s_orphan));   <====

This is a "should never happen situation", and we crash so we can
figure out how we got there.  For production kernels, arguably it
would probably be better to print a message and a WARN_ON(1), and then
not force a crash from a BUG_ON (which is what J_ASSERT is defined to
use).

Looking at your messages and the ext4_delete_inode() warning, I think
I know what caused it.  Can you try this patch (attached below) and
see if it fixes things for you?

> I already reported such issues some time ago, but my reports were
> not too much welcomed, so I gave up. Anyway, anybody can easily do
> my tests at any time.

My apologies.  I've gone through the linux-ext4 mailing list logs, and
I can't find any mention of this problem from any username @vlnb.net.
I'm not sure where you reported it, and I'm sorry we dropped your bug
report.  All I can say is that we do the best that we can, and our
team is relatively small and short-handed.

							- Ted

>From a190d0386e601d58db6d2a6cbf00dc1c17d02136 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Thu, 29 Jul 2010 14:54:48 -0400
Subject: [PATCH] patch explicitly-drop-inode-from-orphan-list-on-ext4_delete_inode-failure

---
 fs/ext4/inode.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a52d5af..533b607 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -221,6 +221,7 @@ void ext4_delete_inode(struct inode *inode)
 				     "couldn't extend journal (err %d)", err);
 		stop_handle:
 			ext4_journal_stop(handle);
+			ext4_orphan_del(NULL, inode);
 			goto no_delete;
 		}
 	}
-- 
1.7.0.4

