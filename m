Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab0GLQ4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 12:56:54 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49273 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab0GLQ4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 12:56:53 -0400
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
CC: miklos@szeredi.hu, hch@infradead.org, viro@zeniv.linux.org.uk,
        adilger@sun.com, corbet@lwn.net, neilb@suse.de, npiggin@suse.de,
        hooanon05@yahoo.co.jp, bfields@fieldses.org,
        linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
        philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
In-reply-to: <87d3utyr2o.fsf@linux.vnet.ibm.com>
	(aneesh.kumar@linux.vnet.ibm.com)
Subject: Re: [PATCH -V16 04/12] vfs: Allow handle based open on symlinks
References: <1278916545-19751-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1278916545-19751-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <E1OYEIL-0005si-EO@pomaz-ex.szeredi.hu> <87d3utyr2o.fsf@linux.vnet.ibm.com>
Message-Id: <E1OYMIx-0006z5-F9@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 12 Jul 2010 18:56:31 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010, Aneesh Kumar K. V wrote:
> On Mon, 12 Jul 2010 10:23:21 +0200, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > On Mon, 12 Jul 2010, Aneesh Kumar K.V wrote:
> > > The patch update may_open to allow handle based open on symlinks.
> > > The file handle based API use file descritor returned from open_by_handle_at
> > > to do different file system operations. To find the link target name we
> > > need to get a file descriptor on symlinks.
> > > 
> > > We should be able to read the link target using file handle. The exact
> > > usecase is with respect to implementing READLINK operation on a
> > > userspace NFS server. The request contain the file handle and the
> > > response include target name.
> > > 
> > > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > > ---
> > >  fs/namei.c         |   10 +++++++++-
> > >  fs/open.c          |    9 ++++++++-
> > >  include/linux/fs.h |    1 +
> > >  3 files changed, 18 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/namei.c b/fs/namei.c
> > > index 4d590a3..a6a8093 100644
> > > --- a/fs/namei.c
> > > +++ b/fs/namei.c
> > > @@ -1456,7 +1456,15 @@ int may_open(struct path *path, int acc_mode, int flag)
> > >  
> > >  	switch (inode->i_mode & S_IFMT) {
> > >  	case S_IFLNK:
> > > -		return -ELOOP;
> > > +		/*
> > > +		 * Allow only if acc_mode contain
> > > +		 * open link request and read request.
> > > +		 */
> > > +		if (acc_mode != (MAY_OPEN_LINK | MAY_READ))
> > 
> > Why require MAY_READ? 
> 
> a value of 0x0 for flag in open(2) implies a read ?

Yes.

However a value of 0x3 is not defined in POSIX, and in linux it's a
sort of weird O_NOACCESS: it requires both read and write permission
on the file but allows neither read or write.

Requiring permission is because on device files the open can have side
effects.  Not sure if open_by_handle() really wants to allow device
opens, that's another thing to think about.

Thanks,
Miklos
