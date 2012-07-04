Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab2GDSL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 14:11:58 -0400
Received: from mail.digidescorp.com ([50.73.98.161]:6638 "EHLO
	mail.digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab2GDSLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 14:11:55 -0400
X-Greylist: delayed 520 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jul 2012 14:11:55 EDT
DomainKey-Signature: a=rsa-sha1; s=MDaemon; d=digidescorp.com;
	c=simple; q=dns; h=from:message-id;
	b=EIqH8rbdpihJMYcK//g3TE9VrrCZlDL0TApwzFn6utg2aXreqS7LH6Z0prwL
	Q19YHto5UJhoL78++gd5CCsuSzHDa8rvs3jfUnjsiCcvnkomgCSgCAKOW
	+E8tJzFOChNlfk2b3lE43rLWwHJydzs9xbrF8ac/xtXdTuNPhJ5hPw=;
X-Spam-Processed: mail.digidescorp.com, Wed, 04 Jul 2012 13:03:14 -0500
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=15322b18cf=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Date: Wed, 04 Jul 2012 13:03:12 -0500
From: "Steve Magnani" <steve@digidescorp.com>
To: "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] fat (exportfs): reconnect file handles to evicted
	inodes/dentries
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <WC20120704180312.82023C@digidescorp.com>
X-Mailer: WorldClient 12.5.5
In-Reply-To: <87pq8bokcp.fsf@devron.myhome.or.jp>
References: <1341342576-15394-1-git-send-email-steve@digidescorp.com> <1341342576-15394-3-git-send-email-steve@digidescorp.com> <87pq8bokcp.fsf@devron.myhome.or.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
> "Steven J. Magnani" <steve@digidescorp.com> writes:
> 
> > This patch adds code to support reconstruction of evicted inodes.
> > We walk the on-disk structures where necessary to fill in information
> > not available in the NFS file handle.
> >
> > One important point is that when reconstructing an inode, in order to
> > avoid the *client* declaring ESTALE we have to ensure that the NFS
> > file handle of the reconstruction is identical to that of the
> > original. 

> We would like to add the comment of [0/2] explanation here. Here is
> missing the explanation of the problem.

OK

> And the codes of nfs support became larger, and I think we should give
> the place for it. I.e. we would like to add new file (maybe, export.c,
> nfs.c, or something), move nfs code into it.
> 
> With it, we don't need to add "NFS ..." annotation in the comment, and
> it would make more clear.

Sure.

> And can you add explanation the test of this? What were tested?

I set up a memory-limited virtual machine with a 2 GB FAT partition 
containing a kernel tree (~770 MB, ~40000 files, 9 levels) and did some 
'cp -r' and 'ls -lR' operations on it, some overlapping, some not.

> > +int fat_get_name(struct dentry *parent, char *name,
> > +		 struct dentry *child)
> > +{
> > +	struct super_block *sb = parent->d_inode->i_sb;
> > +
> > +	loff_t child_loc = MSDOS_I(child->d_inode)->i_pos;
> > +	int err;
> > +
> > +	lock_super(sb);
> > +
> > +	if (child_loc) {
> > +		err = fat_name_for_ipos(parent->d_inode, name, NAME_MAX+1,
> > +					child_loc);
> > +	} else {
> > +		child_loc = MSDOS_I(child->d_inode)->i_logstart;
> > +		err = fat_name_for_logstart(parent->d_inode, name, 
NAME_MAX+1,
> > +					    child_loc);
> > +	}
> > +
> > +	unlock_super(sb);
> > +	return err;
> > +}
> 
> Please don't add new lock_super() usage if it is not necessary. Almost
> all of lock_super() just replaced lock_kernel() usage. It rather should
> be removed in future.  Probably, this should use inode->i_mutex
> instead.

I will look into this. My concern was freezing the filesystem while we 
walk the on-disk structures. Also I developed this patch against 2.6.35 
(the Bad Old BKL days) and ported it forward to 3.5.

> BTW, the above issue is same with all of directory read.
> 
> And although this is using i_pos, is there no possibility to be passed
> the detached inode (i.e. open but unlinked inode, i_pos == 0)?

It is possible, that's why I added code to fall back to using logstart.

I may yet rip out the get_name code. The testing I did before posting the 
patch seemed to indicate that it was needed - I saw ESTALE errors without 
get_name support that I did not see with it present. But I've been 
digging into this some more and I think that was just a coincidence; 
probably I just generated more extreme memory pressure when testing 
without get_name. I should know more tomorrow.

Thanks for the quick feedback.
Steve


