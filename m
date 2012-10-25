Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992723Ab2JYUfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 16:35:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992684Ab2JYUfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 16:35:14 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Jan Kara <jack@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <andi.kleen@intel.com>, Tony Luck <tony.luck@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Akira Fujita <a-fujita@rs.jp.nec.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 3/3] ext3: introduce ext3_error_remove_page
Date: Thu, 25 Oct 2012 16:35:02 -0400
Message-Id: <1351197302-14134-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20121025194551.GE3262@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 09:45:51PM +0200, Jan Kara wrote:
> On Thu 25-10-12 11:12:49, Naoya Horiguchi wrote:
> > What I suggested in the previous patch for ext4 is ditto with ext3,
> > so do the same thing for ext3.
> > 
> > Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > ---
> >  fs/ext3/inode.c | 33 ++++++++++++++++++++++++++++++---
> >  1 file changed, 30 insertions(+), 3 deletions(-)
> > 
> > diff --git v3.7-rc2.orig/fs/ext3/inode.c v3.7-rc2/fs/ext3/inode.c
> > index 7e87e37..7f708bf 100644
> > --- v3.7-rc2.orig/fs/ext3/inode.c
> > +++ v3.7-rc2/fs/ext3/inode.c
> > @@ -1967,6 +1967,33 @@ static int ext3_journalled_set_page_dirty(struct page *page)
> >  	return __set_page_dirty_nobuffers(page);
> >  }
> >  
> > +static int ext3_error_remove_page(struct address_space *mapping,
> > +				struct page *page)
> > +{
> > +	struct inode *inode = mapping->host;
> > +	struct buffer_head *bh, *head;
> > +	ext3_fsblk_t block = 0;
> > +
> > +	if (!PageDirty(page) || !page_has_buffers(page))
> > +		goto remove_page;
> > +
> > +	/* Lost data. Handle as critical fs error. */
> > +	bh = head = page_buffers(page);
> > +	do {
> > +		if (buffer_dirty(bh)) {
>   For ext3, you should check that buffer_mapped() is set because we can
> have dirty and unmapped buffers. Otherwise the patch looks OK.

OK, I'll add it.

Thanks,
Naoya
