Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147Ab1DNIsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 04:48:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:34517 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755949Ab1DNIso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 04:48:44 -0400
Date: Thu, 14 Apr 2011 10:48:42 +0200
From: Jan Kara <jack@suse.cz>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@suse.de>
Subject: Re: [Stable-review] [31/74] quota: Dont write quota info in
 dquot_commit()
Message-ID: <20110414084842.GA5054@quack.suse.cz>
References: <20110413155146.240695445@clark.kroah.org>
 <1302750585.5282.663.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302750585.5282.663.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 14-04-11 04:09:45, Ben Hutchings wrote:
> On Wed, 2011-04-13 at 08:50 -0700, Greg KH wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Jan Kara <jack@suse.cz>
> > 
> > commit b03f24567ce7caf2420b8be4c6eb74c191d59a91 upstream.
> > 
> > There's no reason to write quota info in dquot_commit(). The writing is a
> > relict from the old days when we didn't have dquot_acquire() and
> > dquot_release() and thus dquot_commit() could have created / removed quota
> > structures from the file. These days dquot_commit() only updates usage counters
> > / limits in quota structure and thus there's no need to write quota info.
> > 
> > This also fixes an issue with journaling filesystem which didn't reserve
> > enough space in the transaction for write of quota info (it could have been
> > dirty at the time of dquot_commit() because of a race with other operation
> > changing it).
> [...]
> > @@ -400,15 +400,10 @@ int dquot_commit(struct dquot *dquot)
> >  	spin_unlock(&dq_list_lock);
> >  	/* Inactive dquot can be only if there was error during read/init
> >  	 * => we have better not writing it */
> > -	if (test_bit(DQ_ACTIVE_B, &dquot->dq_flags)) {
> > +	if (test_bit(DQ_ACTIVE_B, &dquot->dq_flags))
> >  		ret = dqopt->ops[dquot->dq_type]->commit_dqblk(dquot);
> > -		if (info_dirty(&dqopt->info[dquot->dq_type])) {
> > -			ret2 = dqopt->ops[dquot->dq_type]->write_file_info(
> > -						dquot->dq_sb, dquot->dq_type);
> > -		}
> > -		if (ret >= 0)
> > -			ret = ret2;
> > -	}
> > +	else
> > +		ret = -EIO;
> [...]
> 
> Why is the return value for the flag-not-set case changed from 0 to
> -EIO?  Is this really part of the same bug fix?
  Yes, it is part of my original patch. It's a small unrelated cleanup I
did when already changing that code. Frankly, the effect won't be big
because
a) DQ_ACTIVE_B is not set only when we for some reason failed to read the
structure from disk.
b) Only dqput() currently checks the return value of this callback and it
calls it only when DQ_ACTIVE_B is set.

So I'm pretty sure it does not change anything.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
