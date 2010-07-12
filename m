Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab0GLJmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 05:42:39 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:46383 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555Ab0GLJmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 05:42:37 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@suse.de, hooanon05@yahoo.co.jp,
        bfields@fieldses.org, linux-fsdevel@vger.kernel.org,
        sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V16 04/12] vfs: Allow handle based open on symlinks
In-Reply-To: <E1OYEIL-0005si-EO@pomaz-ex.szeredi.hu>
References: <1278916545-19751-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1278916545-19751-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <E1OYEIL-0005si-EO@pomaz-ex.szeredi.hu>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Mon, 12 Jul 2010 15:12:07 +0530
Message-ID: <87d3utyr2o.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010 10:23:21 +0200, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, 12 Jul 2010, Aneesh Kumar K.V wrote:
> > The patch update may_open to allow handle based open on symlinks.
> > The file handle based API use file descritor returned from open_by_handle_at
> > to do different file system operations. To find the link target name we
> > need to get a file descriptor on symlinks.
> > 
> > We should be able to read the link target using file handle. The exact
> > usecase is with respect to implementing READLINK operation on a
> > userspace NFS server. The request contain the file handle and the
> > response include target name.
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> >  fs/namei.c         |   10 +++++++++-
> >  fs/open.c          |    9 ++++++++-
> >  include/linux/fs.h |    1 +
> >  3 files changed, 18 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/namei.c b/fs/namei.c
> > index 4d590a3..a6a8093 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -1456,7 +1456,15 @@ int may_open(struct path *path, int acc_mode, int flag)
> >  
> >  	switch (inode->i_mode & S_IFMT) {
> >  	case S_IFLNK:
> > -		return -ELOOP;
> > +		/*
> > +		 * Allow only if acc_mode contain
> > +		 * open link request and read request.
> > +		 */
> > +		if (acc_mode != (MAY_OPEN_LINK | MAY_READ))
> 
> Why require MAY_READ? 

a value of 0x0 for flag in open(2) implies a read ?

> 
> Actually, open_by_handle() should be a good place to start supporting
> O_NOACCESS from the start.  I.e. neigher read, nor write access is
> permitted on the file.

Yes that would be ideal. But that will include much larger change. I was
hoping we could get something in this merge window with the change
suggested above ?

> 
> 
> > +			return -ELOOP;
> > +		if (flag != O_RDONLY)
> > +			return -ELOOP;
> > +		break;
> >  	case S_IFDIR:
> >  		if (acc_mode & MAY_WRITE)
> >  			return -EISDIR;

-aneesh
