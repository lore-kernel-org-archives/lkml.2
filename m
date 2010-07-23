Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab0GWIia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 04:38:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:55293 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090Ab0GWIi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 04:38:27 -0400
Date: Fri, 23 Jul 2010 10:37:59 +0200
From: Jan Kara <jack@suse.cz>
To: shenghui <crosslonelyover@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] check name_len before down_read xattr_sem and sb_read
 in ext2_xattr_get
Message-ID: <20100723083759.GA3305@quack.suse.cz>
References: <201007122229025316610@gmail.com>
 <20100721174457.GE1215@atrey.karlin.mff.cuni.cz>
 <AANLkTikXSOHrIw0SVJMYqsQy1aG5sCXkvvOFU4XLDNGv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikXSOHrIw0SVJMYqsQy1aG5sCXkvvOFU4XLDNGv@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 22-07-10 08:03:18, shenghui wrote:
> 2010/7/22 Jan Kara <jack@suse.cz>:
> >> Hi,
> >>        I walked through ext2_xattr_get, and felt that we can
> >> do some optimization on it. For name_len check, it's done
> >> after down xattr_sem and sb_read, both of which are time
> >> consuming operation compared with strlen:
> >>          down_read(&EXT2_I(inode)->xattr_sem);
> >>  ...
> >>          bh = sb_bread(inode->i_sb, EXT2_I(inode)->i_file_acl);
> >>  ...
> >>          /* find named attribute */
> >>          name_len = strlen(name);
> >>
> >>          error = -ERANGE;
> >>          if (name_len > 255)
> >>                  goto cleanup;
> >>
> >>        Most of the case, you'll get one valid block, but if the
> >> name len > 255, then the xattr_sem down and sb_bread operation
> >> can be seen as a waste of time. So I think we'd better do
> >> name len check as early as possible.
> >>        Following is my patch, and it's against 2.6.35-rc4.
> >> Please check it.
> >>
> >> Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>
> >> ---
> >>  fs/ext2/xattr.c |   12 +++++++-----
> >>  1 files changed, 7 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> >> index 7c39157..0b94d61 100644
> >> --- a/fs/ext2/xattr.c
> >> +++ b/fs/ext2/xattr.c
> >> @@ -161,6 +161,13 @@ ext2_xattr_get(struct inode *inode, int name_index, const char *name,
> >>
> >>       if (name == NULL)
> >>               return -EINVAL;
> >> +
> >> +     /* find named attribute */
> >> +     name_len = strlen(name);
> >> +     error = -ERANGE;
> >> +     if (name_len > 255)
> >> +             goto cleanup;
> >  But you cannot go to cleanup here because you don't hold xattr_sem...
> >
> 
> Sorry, I'm a little confused by your words.
> The patch just checks name_len, and it
> doesn't need xattr_sem.
  Checking of name_len is fine as you did it. But I wanted to point out
that if name_len is greater than 255, you then go to 'cleanup' label which
tries to do up_read(&EXT2_I(inode)->xattr_sem). But that's a bug because
after you moved the code, we don't hold xattr_sem at the moment we check
name_len.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
