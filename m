Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab2JKHoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 03:44:16 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:33565 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757451Ab2JKHoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 03:44:12 -0400
Date: Thu, 11 Oct 2012 09:44:05 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com, Mel Gorman <mgorman@suse.de>,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH] mm: Fix XFS oops due to dirty pages without buffers on
 s390
Message-ID: <20121011094405.1c5990c9@mschwide>
In-Reply-To: <20121010215600.GX23644@dastard>
References: <1349108796-32161-1-git-send-email-jack@suse.cz>
	<alpine.LSU.2.00.1210082029190.2237@eggly.anvils>
	<20121009162107.GE15790@quack.suse.cz>
	<alpine.LSU.2.00.1210091824390.30802@eggly.anvils>
	<20121010215600.GX23644@dastard>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12101107-3548-0000-0000-000003595173
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2012 08:56:00 +1100
Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Oct 09, 2012 at 07:19:09PM -0700, Hugh Dickins wrote:
> > On Tue, 9 Oct 2012, Jan Kara wrote:
> > > On Mon 08-10-12 21:24:40, Hugh Dickins wrote:
> > > > On Mon, 1 Oct 2012, Jan Kara wrote:
> > > > 
> > > > > On s390 any write to a page (even from kernel itself) sets architecture
> > > > > specific page dirty bit. Thus when a page is written to via standard write, HW
> > > > > dirty bit gets set and when we later map and unmap the page, page_remove_rmap()
> > > > > finds the dirty bit and calls set_page_dirty().
> > > > > 
> > > > > Dirtying of a page which shouldn't be dirty can cause all sorts of problems to
> > > > > filesystems. The bug we observed in practice is that buffers from the page get
> > > > > freed, so when the page gets later marked as dirty and writeback writes it, XFS
> > > > > crashes due to an assertion BUG_ON(!PagePrivate(page)) in page_buffers() called
> > > > > from xfs_count_page_state().
> > > > 
> > > > What changed recently?  Was XFS hardly used on s390 until now?
> > >   The problem was originally hit on SLE11-SP2 which is 3.0 based after
> > > migration of our s390 build machines from SLE11-SP1 (2.6.32 based). I think
> > > XFS just started to be more peevish about what pages it gets between these
> > > two releases ;) (e.g. ext3 or ext4 just says "oh, well" and fixes things
> > > up).
> > 
> > Right, in 2.6.32 xfs_vm_writepage() had a !page_has_buffers(page) case,
> > whereas by 3.0 that had become ASSERT(page_has_buffers(page)), with the
> > ASSERT usually compiled out, stumbling later in page_buffers() as you say.
> 
> What that says is that no-one is running xfstests-based QA on s390
> with CONFIG_XFS_DEBUG enabled, otherwise this would have been found.
> I've never tested XFS on s390 before, and I doubt any of the
> upstream developers have, either, because not many peopl ehave s390
> machines in their basement. So this is probably just an oversight
> in the distro QA environment more than anything....

Our internal builds indeed have CONFIG_XFS_DEBUG=n, I'll change that and
watch for the fallout.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

