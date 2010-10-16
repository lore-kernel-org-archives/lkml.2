Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab0JPHyZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:54:25 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:1494 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753173Ab0JPHyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:54:23 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFP1uEx5LcB2/2dsb2JhbAChMXK8eIVJBI9K
Date: Sat, 16 Oct 2010 18:54:21 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/17] fs: icache lock i_state
Message-ID: <20101016075421.GB19147@amd>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-5-git-send-email-david@fromorbit.com>
 <20101001055433.GC32349@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101001055433.GC32349@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 01:54:33AM -0400, Christoph Hellwig wrote:
> > +		spin_lock(&inode->i_lock);
> > +		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)
> > +				|| inode->i_mapping->nrpages == 0) {
> 
> 
> This is some pretty strange formatting.
> 
> 		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
> 		    inode->i_mapping->nrpages == 0) {
> 
> would be more standard.
> 
> >  	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> >  		struct address_space *mapping;
> >  
> > -		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW))
> > -			continue;
> >  		mapping = inode->i_mapping;
> >  		if (mapping->nrpages == 0)
> >  			continue;
> > +		spin_lock(&inode->i_lock);
> > +		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
> > +			spin_unlock(&inode->i_lock);
> > +			continue;
> > +		}
> 
> Can we access the mapping safely when the inode isn't actually fully
> setup?  Even if we can I'd rather not introduce this change hidden
> inside an unrelated patch.

Good point, fixed.

