Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab0JSUm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 16:42:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:34872 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662Ab0JSUm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 16:42:27 -0400
Date: Tue, 19 Oct 2010 22:41:28 +0200
From: Jan Kara <jack@suse.cz>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext3: Check return value of sb_getblk()
Message-ID: <20101019204127.GB3487@quack.suse.cz>
References: <1287470061-4158-1-git-send-email-namhyung@gmail.com>
 <1287475049.1705.2.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1287475049.1705.2.camel@leonhard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 19-10-10 16:57:29, Namhyung Kim wrote:
> 2010-10-19 (화), 15:34 +0900, Namhyung Kim:
> > Check return value of sb_getblk() is NULL. unlikely is addded here
> > since it is called from a loop and we've been OK without the check
> > until now.
> > 
> > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> > ---
> >  fs/ext3/inode.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> > index ef1c23a..a7ac778 100644
> > --- a/fs/ext3/inode.c
> > +++ b/fs/ext3/inode.c
> > @@ -655,6 +655,12 @@ static int ext3_alloc_branch(handle_t *handle, struct inode *inode,
> >  		 * parent to disk.
> >  		 */
> >  		bh = sb_getblk(inode->i_sb, new_blocks[n-1]);
> > +		if (unlikely(!bh)) {
> > +			n--;
> > +			err = -ENOMEM;
> > +			goto failed;
> > +		}
> > +
> >  		branch[n].bh = bh;
> >  		lock_buffer(bh);
> >  		BUFFER_TRACE(bh, "call get_create_access");
> 
> Maybe EIO would be more proper error code, I guess.
  Hmm, for ext3, sb_getblk() cannot really realistically fail. Block
numbers are 32-bit so they can never be big enough to overflow pagecache
index and grow_buffers() loops indefinitely if it cannot allocate buffers.
But OK, EIO might be a reasonable return value and we can have the check
there just in case sb_getblk() grows some other possiblility to fail.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
