Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab0EXRGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 13:06:41 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:45970 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757833Ab0EXRGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 13:06:40 -0400
Subject: Re: [PATCH] VFS: fix recent breakage of FS_REVAL_DOT
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Neil Brown <neilb@suse.de>, "Dr. J. Bruce Fields" <bfields@fieldses.org>,
       Chuck Lever <chuck.lever@oracle.com>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100524164736.GR31073@ZenIV.linux.org.uk>
References: <20100524165756.2cfa54c4@notabene.brown>
	 <20100524115903.GP31073@ZenIV.linux.org.uk>
	 <20100524155031.GQ31073@ZenIV.linux.org.uk>
	 <1274718082.10795.31.camel@heimdal.trondhjem.org>
	 <20100524164736.GR31073@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 May 2010 13:06:31 -0400
Message-ID: <1274720791.10795.50.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-2.fc13) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 6 msgs/h 1 sum rcpts/h 10 sum msgs/h 2 total rcpts 332 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 1B264915D3FFA5A843A708DBDB5503FDD21A8FCD
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 169 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-24 at 17:47 +0100, Al Viro wrote: 
> On Mon, May 24, 2010 at 12:21:22PM -0400, Trond Myklebust wrote:
> > > Can an nfs4 server e.g. have /x/y being a symlink that resolves to /a/b and
> > > allow mounting of both /x/y/c and /a/b/c?  Which path would it return to
> > > client that has mounted both, walked to some referral point and called
> > > nfs_do_refmount(), triggering nfs4_proc_fs_locations()?
> > > 
> > > Trond, Neil?
> > 
> > When mounting /x/y/c in your example above, the NFSv4 protocol requires
> > the client itself to resolve the symlink, and then walk down /a/b/c
> > (looking up component by component), so it will in practice not see
> > anything other than /a/b/c.
> > 
> > If it walks down to a referral, and then calls nfs_do_refmount, it will
> > do the same thing: obtain a path /e/f/g on the new server, and then walk
> > down that component by component while resolving any symlinks and/or
> > referrals that it crosses in the process.
> 
> Ho-hum...  What happens if the same fs is mounted twice on server?  I.e.
> have ext2 from /dev/sda1 mounted on /a and /b on server, then on the client
> do mount -t nfs foo:/a /tmp/a; mount -t nfs foo:/b /tmp/b.  Which path
> would we get from GETATTR with fs_locations requested, if we do it for
> /tmp/a/x and /tmp/b/x resp.?  Dentry will be the same, since fsid would
> match.
> 
> Or would the server refuse to export things that way?


I believe that the answer is that most filehandle types include an
encoding of the inode number of the export directory. In other words, as
long as '/a' and '/b' are different directories, then they will result
in the generation of different filehandles for /a/x and /b/x.

It seems that is not always the case, though. According to the
definition of mk_fsid(), it looks as if the 'FSID_UUID8' and
'FSID_UUID16' filehandle types only encode the uuid of the filesystem,
and have no inode information. They will therefore not be able to
distinguish between an export through '/a' or '/b'.

Neil, Bruce am I right?

Cheers
  Trond

