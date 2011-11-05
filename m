Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab1KEP2R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 11:28:17 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:37481 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab1KEP2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 11:28:15 -0400
Date: Sat, 5 Nov 2011 11:27:49 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andres Freund <andres@anarazel.de>, Andi Kleen <andi@firstfloor.org>,
        robertmhaas@gmail.com, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] LSEEK: BTRFS: Avoid i_mutex for SEEK_{CUR,SET,END}
Message-ID: <20111105152749.GA5576@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andres Freund <andres@anarazel.de>,
	Andi Kleen <andi@firstfloor.org>, robertmhaas@gmail.com,
	viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org>
 <201110012246.13801.andres@anarazel.de>
 <201110012249.27834.andres@anarazel.de>
 <20111102082915.GA28153@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111102082915.GA28153@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4EB555FF.0075,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 04:29:15AM -0400, Christoph Hellwig wrote:
> Andres, can you check with Chris that the btrfs changes made it to
> his tree?  The core lseek changes from Andi are in mainline now, but
> I think these bits are better off going through Chrises btrfs tree.

I'm pulling these in, thanks!

-chris

> 
> On Sat, Oct 01, 2011 at 10:49:27PM +0200, Andres Freund wrote:
> > 
> > Don't need the i_mutex for those cases, only for SEEK_HOLE/DATA.
> > 
> > Really-From: Andi Kleen <ak@linux.intel.com>
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > Signed-off-by: Andres Freund <andres@anarazel.de>
> > ---
> >  fs/btrfs/file.c |   27 +++++++++++----------------
> >  1 files changed, 11 insertions(+), 16 deletions(-)
> > 
> > diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> > index 7a13337..5bc7116 100644
> > --- a/fs/btrfs/file.c
> > +++ b/fs/btrfs/file.c
> > @@ -1809,24 +1809,19 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int origin)
> >  	struct inode *inode = file->f_mapping->host;
> >  	int ret;
> >  
> > +	if (origin != SEEK_DATA && origin != SEEK_HOLE)
> > +		return generic_file_llseek(file, offset, origin);
> > +
> >  	mutex_lock(&inode->i_mutex);
> > -	switch (origin) {
> > -	case SEEK_END:
> > -	case SEEK_CUR:
> > -		offset = generic_file_llseek(file, offset, origin);
> > -		goto out;
> > -	case SEEK_DATA:
> > -	case SEEK_HOLE:
> > -		if (offset >= i_size_read(inode)) {
> > -			mutex_unlock(&inode->i_mutex);
> > -			return -ENXIO;
> > -		}
> > +	if (offset >= i_size_read(inode)) {
> > +		mutex_unlock(&inode->i_mutex);
> > +		return -ENXIO;
> > +	}
> >  
> > -		ret = find_desired_extent(inode, &offset, origin);
> > -		if (ret) {
> > -			mutex_unlock(&inode->i_mutex);
> > -			return ret;
> > -		}
> > +	ret = find_desired_extent(inode, &offset, origin);
> > +	if (ret) {
> > +		mutex_unlock(&inode->i_mutex);
> > +		return ret;
> >  	}
> >  
> >  	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET)) {
> > -- 
> > 1.7.6.409.ge7a85.dirty
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> ---end quoted text---
