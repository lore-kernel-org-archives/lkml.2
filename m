Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab2JJV4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 17:56:07 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:36657 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755199Ab2JJV4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 17:56:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArErAK3tdVB5LIL3/2dsb2JhbABEhSm0JoRjAgJ7gQmCIAEBBTocIxAIAxIGLhQlAw0UE4gDuBoUizM7gSiEPQOVa5AxgwE
Date: Thu, 11 Oct 2012 08:56:00 +1100
From: Dave Chinner <david@fromorbit.com>
To: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Mel Gorman <mgorman@suse.de>, linux-s390@vger.kernel.org
Subject: Re: [PATCH] mm: Fix XFS oops due to dirty pages without buffers on
 s390
Message-ID: <20121010215600.GX23644@dastard>
References: <1349108796-32161-1-git-send-email-jack@suse.cz>
 <alpine.LSU.2.00.1210082029190.2237@eggly.anvils>
 <20121009162107.GE15790@quack.suse.cz>
 <alpine.LSU.2.00.1210091824390.30802@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1210091824390.30802@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 07:19:09PM -0700, Hugh Dickins wrote:
> On Tue, 9 Oct 2012, Jan Kara wrote:
> > On Mon 08-10-12 21:24:40, Hugh Dickins wrote:
> > > On Mon, 1 Oct 2012, Jan Kara wrote:
> > > 
> > > > On s390 any write to a page (even from kernel itself) sets architecture
> > > > specific page dirty bit. Thus when a page is written to via standard write, HW
> > > > dirty bit gets set and when we later map and unmap the page, page_remove_rmap()
> > > > finds the dirty bit and calls set_page_dirty().
> > > > 
> > > > Dirtying of a page which shouldn't be dirty can cause all sorts of problems to
> > > > filesystems. The bug we observed in practice is that buffers from the page get
> > > > freed, so when the page gets later marked as dirty and writeback writes it, XFS
> > > > crashes due to an assertion BUG_ON(!PagePrivate(page)) in page_buffers() called
> > > > from xfs_count_page_state().
> > > 
> > > What changed recently?  Was XFS hardly used on s390 until now?
> >   The problem was originally hit on SLE11-SP2 which is 3.0 based after
> > migration of our s390 build machines from SLE11-SP1 (2.6.32 based). I think
> > XFS just started to be more peevish about what pages it gets between these
> > two releases ;) (e.g. ext3 or ext4 just says "oh, well" and fixes things
> > up).
> 
> Right, in 2.6.32 xfs_vm_writepage() had a !page_has_buffers(page) case,
> whereas by 3.0 that had become ASSERT(page_has_buffers(page)), with the
> ASSERT usually compiled out, stumbling later in page_buffers() as you say.

What that says is that no-one is running xfstests-based QA on s390
with CONFIG_XFS_DEBUG enabled, otherwise this would have been found.
I've never tested XFS on s390 before, and I doubt any of the
upstream developers have, either, because not many peopl ehave s390
machines in their basement. So this is probably just an oversight
in the distro QA environment more than anything....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
