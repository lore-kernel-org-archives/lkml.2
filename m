Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab0D3RJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:09:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932747Ab0D3RJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:09:21 -0400
Date: Thu, 29 Apr 2010 14:39:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 3/4] writeback: pay attention to wbc->nr_to_write in
 write_cache_pages
Message-Id: <20100429143931.331c2bab.akpm@linux-foundation.org>
In-Reply-To: <1271731314-5893-4-git-send-email-david@fromorbit.com>
References: <1271731314-5893-1-git-send-email-david@fromorbit.com>
	<1271731314-5893-4-git-send-email-david@fromorbit.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Apr 2010 12:41:53 +1000
Dave Chinner <david@fromorbit.com> wrote:

> If a filesystem writes more than one page in ->writepage, write_cache_pages
> fails to notice this and continues to attempt writeback when wbc->nr_to_write
> has gone negative - this trace was captured from XFS:
> 
> 
>     wbc_writeback_start: towrt=1024
>     wbc_writepage: towrt=1024
>     wbc_writepage: towrt=0
>     wbc_writepage: towrt=-1
>     wbc_writepage: towrt=-5
>     wbc_writepage: towrt=-21
>     wbc_writepage: towrt=-85
> 

Bug.

AFAIT it's a regression introduced by

: commit 17bc6c30cf6bfffd816bdc53682dd46fc34a2cf4
: Author:     Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
: AuthorDate: Thu Oct 16 10:09:17 2008 -0400
: Commit:     Theodore Ts'o <tytso@mit.edu>
: CommitDate: Thu Oct 16 10:09:17 2008 -0400
: 
:     vfs: Add no_nrwrite_index_update writeback control flag

I suggest that what you do here is remove the local `nr_to_write' from
write_cache_pages() and go back to directly using wbc->nr_to_write
within the loop.

And thus we restore the convention that if the fs writes back more than
a single page, it subtracts (nr_written - 1) from wbc->nr_to_write.

