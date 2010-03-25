Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab0CYR7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 13:59:50 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:45647 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab0CYR7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 13:59:49 -0400
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Benny Halevy <bhalevy@panasas.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Doug Nazar <nazard.lkml@gmail.com>
In-Reply-To: <4BAB9D53.4000909@panasas.com>
References: <20100325101231.GU30031@ZenIV.linux.org.uk>
	 <20100325105406.GW30031@ZenIV.linux.org.uk> <4BAB51F5.609@panasas.com>
	 <4BAB54B0.3080109@panasas.com> <20100325130610.GZ30031@ZenIV.linux.org.uk>
	 <4BAB656E.8020204@panasas.com> <20100325133746.GA30031@ZenIV.linux.org.uk>
	 <4BAB6911.5020009@panasas.com> <20100325140457.GB30031@ZenIV.linux.org.uk>
	 <4BAB72C1.6090002@panasas.com> <20100325152505.GD30031@ZenIV.linux.org.uk>
	 <4BAB9D53.4000909@panasas.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Mar 2010 13:59:41 -0400
Message-ID: <1269539981.3648.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 8 msgs/h 1 sum rcpts/h 12 sum msgs/h 1 total rcpts 2638 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: E690018184FA38D8CD539583A92460BF79F1E059
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 264 max/h 7 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-25 at 19:28 +0200, Boaz Harrosh wrote: 
> On 03/25/2010 05:25 PM, Al Viro wrote:

> > I'm going to send a fix for O_DIRECTORY case (restoring the behaviour
> > we had in 2.6.33) today, but NFS side of things also needs to be dealt
> > with.
> 
> Thank you Al for fixing this, I hope some capable NFS person will take
> that issue to heart.

The NFSv4 fix is a trivial 1 liner. Pushed to bugfixes.

Now to understand that screwed up xdr decode...

Trond
------------------------------------------------------------------------------------------ 
NFSv4: Fall back to ordinary lookup if nfs4_atomic_open() returns EISDIR
From: Trond Myklebust <Trond.Myklebust@netapp.com>

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index c6f2750..be46f26 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1025,12 +1025,12 @@ static struct dentry *nfs_atomic_lookup(struct inode *dir, struct dentry *dentry
 				res = NULL;
 				goto out;
 			/* This turned out not to be a regular file */
+			case -EISDIR:
 			case -ENOTDIR:
 				goto no_open;
 			case -ELOOP:
 				if (!(nd->intent.open.flags & O_NOFOLLOW))
 					goto no_open;
-			/* case -EISDIR: */
 			/* case -EINVAL: */
 			default:
 				goto out;


