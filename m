Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030213Ab2KUVPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 16:15:13 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:36550 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964878Ab2KUVPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 16:15:11 -0500
Date: Wed, 21 Nov 2012 13:13:19 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: axboe@kernel.dk, lucho@ionkov.net, ericvh@gmail.com, tytso@mit.edu,
        rminnich@sandia.gov, viro@zeniv.linux.org.uk,
        martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
        v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 4/4] ext3: Warn if mounting rw on a disk requiring stable
 page writes
Message-ID: <20121121211319.GA32202@blackbox.djwong.org>
References: <20121121020027.10225.43206.stgit@blackbox.djwong.org>
 <20121121020056.10225.15220.stgit@blackbox.djwong.org>
 <20121121021543.GI10507@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121121021543.GI10507@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 03:15:43AM +0100, Jan Kara wrote:
> On Tue 20-11-12 18:00:56, Darrick J. Wong wrote:
> > ext3 doesn't properly isolate pages from changes during writeback.  Since the
> > recommended fix is to use ext4, for now we'll just print a warning if the user
> > tries to mount in write mode.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/ext3/super.c |    8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > 
> > diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> > index 5366393..5b3725d 100644
> > --- a/fs/ext3/super.c
> > +++ b/fs/ext3/super.c
> > @@ -1325,6 +1325,14 @@ static int ext3_setup_super(struct super_block *sb, struct ext3_super_block *es,
> >  			"forcing read-only mode");
> >  		res = MS_RDONLY;
> >  	}
> > +	if (!read_only &&
> > +	    queue_requires_stable_pages(bdev_get_queue(sb->s_bdev))) {
> > +		ext3_msg(sb, KERN_ERR,
> > +			"error: ext3 cannot safely write data to a disk "
> > +			"requiring stable pages writes; forcing read-only "
> > +			"mode.  Upgrading to ext4 is recommended.");
> > +		res = MS_RDONLY;
> > +	}
> >  	if (read_only)
> >  		return res;
> >  	if (!(sbi->s_mount_state & EXT3_VALID_FS))
>   Why this? ext3 should be fixed by your change to
> filemap_page_mkwrite()... Or does testing show otherwise?

Yes, it's still broken even with this new set of changes.  Now that I think
about it a little more, I recall that writeback mode was actually fine, so this
is a little harsh.

Hm... looking at the ordered code a little more, it looks like
ext3_ordered_write_end is calling journal_dirty_data_fn, which (I guess?) tries
to write mapped buffers back through the journal?  Taking it out seems to fix
ordered mode, though I have a suspicion that it might very well break ordered
mode too.

--D
> 
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
