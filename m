Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809Ab0D3TId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:08:33 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:41536 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932533Ab0D3RBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:01:05 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 3/4] writeback: pay attention to wbc->nr_to_write in write_cache_pages
In-Reply-To: <20100429143931.331c2bab.akpm@linux-foundation.org>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com> <1271731314-5893-4-git-send-email-david@fromorbit.com> <20100429143931.331c2bab.akpm@linux-foundation.org>
User-Agent: Notmuch/0.3.1-16-g417274d (http://notmuchmail.org) Emacs/23.1.96.1 (i686-pc-linux-gnu)
Date: Fri, 30 Apr 2010 11:31:53 +0530
Message-ID: <87sk6dwka6.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Apr 2010 14:39:31 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 20 Apr 2010 12:41:53 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > If a filesystem writes more than one page in ->writepage, write_cache_pages
> > fails to notice this and continues to attempt writeback when wbc->nr_to_write
> > has gone negative - this trace was captured from XFS:
> > 
> > 
> >     wbc_writeback_start: towrt=1024
> >     wbc_writepage: towrt=1024
> >     wbc_writepage: towrt=0
> >     wbc_writepage: towrt=-1
> >     wbc_writepage: towrt=-5
> >     wbc_writepage: towrt=-21
> >     wbc_writepage: towrt=-85
> > 
> 
> Bug.
> 
> AFAIT it's a regression introduced by
> 
> : commit 17bc6c30cf6bfffd816bdc53682dd46fc34a2cf4
> : Author:     Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> : AuthorDate: Thu Oct 16 10:09:17 2008 -0400
> : Commit:     Theodore Ts'o <tytso@mit.edu>
> : CommitDate: Thu Oct 16 10:09:17 2008 -0400
> : 
> :     vfs: Add no_nrwrite_index_update writeback control flag
> 
> I suggest that what you do here is remove the local `nr_to_write' from
> write_cache_pages() and go back to directly using wbc->nr_to_write
> within the loop.
> 
> And thus we restore the convention that if the fs writes back more than
> a single page, it subtracts (nr_written - 1) from wbc->nr_to_write.
> 

My mistake i never expected writepage to write more than one page. The
interface said 'writepage' so it was natural to expect that it writes only
one page. BTW the reason for the change is to give file system which
accumulate dirty pages using write_cache_pages and attempt to write
them out later a chance to properly manage nr_to_write. Something like

ext4_da_writepages
-- write_cache_pages
---- collect dirty page
---- return
--return
--now try to writeout all the collected dirty pages ( say 100)
----Only able to allocate blocks for 50 pages
    so update nr_to_write -= 50 and mark rest of 50 pages as dirty
    again

So we want wbc->nr_to_write updated only by ext4_da_writepages. 


-aneesh
