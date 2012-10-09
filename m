Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab2JIMCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:02:30 -0400
Received: from twin.jikos.cz ([89.185.236.188]:48133 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab2JIMCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:02:23 -0400
Date: Tue, 9 Oct 2012 14:02:08 +0200
From: David Sterba <dave@jikos.cz>
To: Chul Lee <chur.lee@samsung.com>
Cc: dave@jikos.cz, "'?????????'" <jaegeuk.kim@samsung.com>,
        viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 03/16] f2fs: add superblock and major in-memory structures
Message-ID: <20121009120208.GN4405@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: Chul Lee <chur.lee@samsung.com>, dave@jikos.cz,
	'?????????' <jaegeuk.kim@samsung.com>, viro@zeniv.linux.org.uk,
	'Theodore Ts'o' <tytso@mit.edu>, gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org, cm224.lee@samsung.com,
	jooyoung.hwang@samsung.com, linux-fsdevel@vger.kernel.org
References: <000a01cda2f0$a2375b40$e6a611c0$%kim@samsung.com>
 <20121006232240.GB4405@twin.jikos.cz>
 <007101cda5dc$d22c01e0$768405a0$%lee@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <007101cda5dc$d22c01e0$768405a0$%lee@samsung.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 02:13:29PM +0900, Chul Lee wrote:
> > > +	block_t	data_blkaddr;
> > > +};
> > > +
> > > +struct f2fs_sb_info {
> > > +	struct super_block *sb;			/* Pointer to VFS super
> > block */
> > > +	int s_dirty;
> > 
> > Is s_dirty actually used? I can see it only set and reset at checkpoint,
> > not eg. synced with an on-disk block to signalize a dirty status.
> 
> The s_dirty is checked, when sync_fs is called.

I've checked again, you're right, I did not see it before.

> > > +	struct mutex gc_mutex;			/* mutex for GC */
> > > +	struct mutex fs_lock[NR_LOCK_TYPE];	/* mutex for GP */
> > > +	struct mutex write_inode;		/* mutex for write inode */
> > > +	struct mutex writepages;		/* mutex for writepages() */
> > 
> > wow, thats 1+8+2 = 11 mutexes in a row! The ones hidden under
> > NR_LOCK_TYPE may hurt, as they seem to protect various and common file
> > opterations (guesed from the lock_type names).
> 
> Yes, they protect global variables shared by various operations and
> checkpoint.
> Could you tell me what you recommend? Each fs_lock's under NR_LOCK_TYPE
> would have had different lock names?

I think this was too eager from me to point out the perf problems with
the mutexes, this sure would be a problem with spinlocks but mutexes can
sleep and I can see that there are IO operations enclosed in the mutex
section almost always. There may be a subset of operations that are
both frequent and lightweight.

Seems to me that DATA_NEW, NODE_NEW and DATA_WRITE are candidates for
profiling and subject to futher optimizations (ie. split the locks from
the same cacheline).
(This is not something that would prevent inclusion of F2FS into kernel)

Also, if you target only embedded devices, the scaling problems are not
critical, however a NAND device are not limited to embedded world.

david
