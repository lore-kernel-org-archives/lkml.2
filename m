Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558Ab1LLPGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:06:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56407 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab1LLPGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:06:36 -0500
Date: Mon, 12 Dec 2011 15:22:27 +0100
From: Jan Kara <jack@suse.cz>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Matthias Matiak <netzpython@mail-on.us>
Subject: Re: [PATCH] udf: Fix deadlock when converting file from in-ICB one
 to normal one
Message-ID: <20111212142227.GB5473@quack.suse.cz>
References: <1323483097-24210-1-git-send-email-jack@suse.cz>
 <CAKYAXd9jYMZMht02n=W4T8+hq8hU8owoZk07TbLb-myk52PNKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKYAXd9jYMZMht02n=W4T8+hq8hU8owoZk07TbLb-myk52PNKw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 10-12-11 13:40:53, Namjae Jeon wrote:
> 2011/12/10 Jan Kara <jack@suse.cz>:
> > During BKL removal, conversion of files from in-ICB format to normal format got
> > broken. We call ->writepage with i_data_sem held but udf_get_block() also
> > acquires i_data_sem thus creating A-A deadlock.
> >
> > We fix the problem by dropping i_data_sem before calling ->writepage() which is
> > safe since i_mutex still protects us against any changes in the file. Also fix
> > pagelock - i_data_sem lock inversion in udf_expand_file_adinicb() by dropping
> > i_data_sem before calling find_or_create_page().
> >
> > Reported-by: Matthias Matiak <netzpython@mail-on.us>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
  Thanks.

> > ---
> >  fs/udf/file.c  |    6 +++---
> >  fs/udf/inode.c |   20 +++++++++++++++++---
> >  2 files changed, 20 insertions(+), 6 deletions(-)
> >
> >  I plan to merge this fix through my tree soon.
> >
> > +/*
> > + * Expand file stored in ICB to a normal one-block-file
> > + *
> > + * This function requires i_data_sem for writing and releases it.
> > + * This function requires i_mutex held
> > + */
> >  int udf_expand_file_adinicb(struct inode *inode)
> >  {
> >        struct page *page;
> > @@ -171,6 +177,11 @@ int udf_expand_file_adinicb(struct inode *inode)
> >                mark_inode_dirty(inode);
>                   up_write(&iinfo->i_data_sem);
> Hi Jan.
> I do not know if that helps, Would it need here ?
  Thanks for spotting this! Indeed it was a bug not to release i_data_sem
here! I have fixed it now.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
