Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab2D3QUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 12:20:23 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:54840 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095Ab2D3QUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 12:20:20 -0400
Date: Mon, 30 Apr 2012 09:19:37 -0700
From: djwong <djwong@us.ibm.com>
To: "Ted Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Sunil Mushran <sunil.mushran@oracle.com>,
        Martin K Petersen <martin.petersen@oracle.com>,
        Greg Freemyer <greg.freemyer@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Mingming Cao <cmm@us.ibm.com>,
        Joel Becker <jlbec@evilplan.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
Subject: Re: [PATCH 05/23] ext4: Calculate and verify superblock checksum
Message-ID: <20120430161937.GD6938@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20120306204750.1663.96751.stgit@elm3b70.beaverton.ibm.com>
 <20120306204828.1663.39312.stgit@elm3b70.beaverton.ibm.com>
 <20120427200500.GA29481@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427200500.GA29481@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12043016-6148-0000-0000-0000056FF33C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 04:05:00PM -0400, Ted Ts'o wrote:
> On Tue, Mar 06, 2012 at 12:48:28PM -0800, Darrick J. Wong wrote:
> > diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
> > index aca1790..90f7c2e 100644
> > --- a/fs/ext4/ext4_jbd2.c
> > +++ b/fs/ext4/ext4_jbd2.c
> > @@ -138,16 +138,23 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
> >  }
> >  
> >  int __ext4_handle_dirty_super(const char *where, unsigned int line,
> > -			      handle_t *handle, struct super_block *sb)
> > +			      handle_t *handle, struct super_block *sb,
> > +			      int now)
> >  {
> >  	struct buffer_head *bh = EXT4_SB(sb)->s_sbh;
> >  	int err = 0;
> >  
> >  	if (ext4_handle_valid(handle)) {
> > +		ext4_superblock_csum_set(sb,
> > +				(struct ext4_super_block *)bh->b_data);
> >  		err = jbd2_journal_dirty_metadata(handle, bh);
> >  		if (err)
> >  			ext4_journal_abort_handle(where, line, __func__,
> >  						  bh, handle, err);
> > +	} else if (now) {
> > +		ext4_superblock_csum_set(sb,
> > +				(struct ext4_super_block *)bh->b_data);
> > +		mark_buffer_dirty(bh);
> >  	} else
> >  		sb->s_dirt = 1;
> >  	return err;
> 
> What's the point of having the ext4_handle_dirty_super_now() variant?
> 
> I don't see the point of having this?

I believe I was trying to get rid of the open-coded mark_buffer_dirty(sb)
calls.  There isn't much of reason to have the now=0 path, though; if a caller
really wants to mark s_dirt and nothing else, there's ext4_mark_super_dirty()
for that.  That said, I wonder about that -- is it desirable to be able to say
"I've changed the superblock, now update the checksum but don't do anything to
write it out to disk right now"?

After a few months' break, it seems clear to me that we could make the "else if
(now)" clause the "else" clause and get rid of the now parameter.  Anything
that really wants to set s_dirt=1 with no further action can call
ext4_mark_super_dirty().

--D
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

