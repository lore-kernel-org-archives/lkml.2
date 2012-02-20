Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab2BTLGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 06:06:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53486 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab2BTLG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 06:06:29 -0500
Date: Mon, 20 Feb 2012 12:06:27 +0100
From: Jan Kara <jack@suse.cz>
To: Alex Elder <elder@dreamhost.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Sage Weil <sage@newdream.net>, ceph-devel@vger.kernel.org
Subject: Re: [PATCH 04/11] ceph: Push file_update_time() into
 ceph_page_mkwrite()
Message-ID: <20120220110627.GB6799@quack.suse.cz>
References: <1329399979-3647-1-git-send-email-jack@suse.cz>
 <1329399979-3647-5-git-send-email-jack@suse.cz>
 <1329419077.3121.38.camel@doink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329419077.3121.38.camel@doink>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 16-02-12 13:04:37, Alex Elder wrote:
> On Thu, 2012-02-16 at 14:46 +0100, Jan Kara wrote:
> > CC: Sage Weil <sage@newdream.net>
> > CC: ceph-devel@vger.kernel.org
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> 
> This will update the timestamp even if a write
> fault fails, which is different from before.
>
> Hard to avoid though.
  Yes. Relatively easy solution for this (at least for some filesystems)
is to include time update into other operations filesystem is doing.
Usually filesystem can do some preparations, then take page lock and then
update time stamps together with other things it wants to do. It usually
will be even faster than current scheme. But I decided to leave that to
fs maintainers because page_mkwrite() code tends to be tricky wrt locking
etc.


> Looks good to me.
> 
> Signed-off-by: Alex Elder <elder@dreamhost.com>
  Thanks.

								Honza

> >  fs/ceph/addr.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > index 173b1d2..12b139f 100644
> > --- a/fs/ceph/addr.c
> > +++ b/fs/ceph/addr.c
> > @@ -1181,6 +1181,9 @@ static int ceph_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> >  	loff_t size, len;
> >  	int ret;
> >  
> > +	/* Update time before taking page lock */
> > +	file_update_time(vma->vm_file);
> > +
> >  	size = i_size_read(inode);
> >  	if (off + PAGE_CACHE_SIZE <= size)
> >  		len = PAGE_CACHE_SIZE;
> 
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
