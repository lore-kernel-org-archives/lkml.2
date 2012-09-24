Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab2IXO5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 10:57:49 -0400
Received: from fieldses.org ([174.143.236.118]:57382 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab2IXO5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 10:57:47 -0400
Date: Mon, 24 Sep 2012 10:57:43 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Namjae Jeon <linkinjeon@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v3 2/5] fat: allocate persistent inode numbers
Message-ID: <20120924145743.GA3301@fieldses.org>
References: <87ipb45914.fsf@devron.myhome.or.jp>
 <CAKYAXd9EzKH_x1GaXvSZ7pRebfOcwQqNp6-oEnc2z2evuNo23g@mail.gmail.com>
 <87ehls53ug.fsf@devron.myhome.or.jp>
 <87a9wg53mc.fsf@devron.myhome.or.jp>
 <CAKYAXd9_DcS+pqGRuwvHNfHQTpUScSfvM1EDSPHeo4ZP70D0hw@mail.gmail.com>
 <87392768dj.fsf@devron.myhome.or.jp>
 <CAKYAXd_fJwoPrX4zKW0sBDGsBGDWUj-_TtkFYws7z3xvgsnuRw@mail.gmail.com>
 <87y5jz4rio.fsf@devron.myhome.or.jp>
 <CAKYAXd_OmVgxtmHOLRdi5yr=yTa9ppmatQUf1GO6Qjg5ym8LuA@mail.gmail.com>
 <87txun4n5r.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txun4n5r.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 09:32:00PM +0900, OGAWA Hirofumi wrote:
> Namjae Jeon <linkinjeon@gmail.com> writes:
> 
> > 2012/9/24, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> >> Namjae Jeon <linkinjeon@gmail.com> writes:
> >>
> >>>> I see. fileid seems to be stat.ino on nfsd4. inode->i_ino is actually
> >>>> just a hash key of inode hash (exception is only in audit, iirc).
> >>>>
> >>>> So, what happens if we set "stat->ino = i_pos" on fat_getattr().
> >>>>
> >>>> int fat_getattr(struct vfsmount *mnt, struct dentry *dentry, struct
> >>>> kstat
> >>>> *stat)
> >>>> {
> >>>> 	struct inode *inode = dentry->d_inode;
> >>>> 	generic_fillattr(inode, stat);
> >>>> 	stat->blksize = MSDOS_SB(inode->i_sb)->cluster_size;
> >>>> 	if (opts->nfs == FAT_NFS_LIMITED) {
> >>>> 		/* Use i_pos for ino. This is used as fileid of nfs. */
> >>>> 		stat->ino = MSDOS_SB(inode->i_sb)->i_pos;
> >>
> >> 		stat->ino = fat_i_pos_read(MSDOS_SB(inode->i_sb), inode);
> >>
> >> Ouch, I forgot to use fat_i_pos_read().
> >>
> > There is some unclear thing.
> > When I see first mail, I think maybe you don't want to use i_pos for inode->ino.
> > FAT allocate inode->ino from i_unique on server side and If NFS client
> > use i_pos for inode->ino in fat_get_attr, inode numbers on each
> > client/server will still be mismatched.
> >
> > Would you plz give me hint ?
> 
> ->i_ino is long. It can't hold i_pos fully on 32bit arch, so we can't
> use ->i_no to store i_pos, and changing ->i_ino is unnecessary. If
> getattr() returned i_pos as ino, nobody see ->i_ino anymore except
> internal of kernel.

The NFS server must always return the same inode number for the same
filehandle.  To do otherwise is a bug.

> Furthermore I think there is no issue even if server and client didn't
> have same ino. Because client just uses FH (nfs4 seems to be using
> stat.ino though).

The client may expose a different inode number to userspace, but it's
probably the server-provided inode number that it's checking.

(And even if the Linux client didn't currently happen to do that check,
this would still be a bug.)

--b.
