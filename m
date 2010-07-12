Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab0GLWOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 18:14:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753852Ab0GLWOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 18:14:02 -0400
Date: Mon, 12 Jul 2010 15:13:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] writeback: dont redirty tail an inode with dirty
 pages
Message-Id: <20100712151317.bd9d656c.akpm@linux-foundation.org>
In-Reply-To: <20100712153127.GB30222@localhost>
References: <20100711020656.340075560@intel.com>
	<20100711021749.021449821@intel.com>
	<20100712020109.GB25335@dastard>
	<20100712153127.GB30222@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jul 2010 23:31:27 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> > > +		} else if (inode->i_state & I_DIRTY) {
> > > +			/*
> > > +			 * At least XFS will redirty the inode during the
> > > +			 * writeback (delalloc) and on io completion (isize).
> > > +			 */
> > > +			redirty_tail(inode);
> > 
> > I'd drop the mention of XFS here - any filesystem that does delayed
> > allocation or unwritten extent conversion after Io completion will
> > cause this. Perhaps make the comment:
> > 
> > 	/*
> > 	 * Filesystems can dirty the inode during writeback
> > 	 * operations, such as delayed allocation during submission
> > 	 * or metadata updates after data IO completion.
> > 	 */
> 
> Thanks, comments updated accordingly.
> 
> ---
> writeback: don't redirty tail an inode with dirty pages
> 
> This avoids delaying writeback for an expired (XFS) inode with lots of
> dirty pages, but no active dirtier at the moment. Previously we only do
> that for the kupdate case.
> 

You didn't actually explain the _reason_ for making this change. 
Please always do that.

The patch is...  surprisingly complicated, although the end result
looks OK.  This is not aided by the partial duplication between
mapping_tagged(PAGECACHE_TAG_DIRTY) and I_DIRTY_PAGES.  I don't think
we can easily remove I_DIRTY_PAGES because it's used for the
did-someone-just-dirty-a-page test here.

This code is way too complex and fragile and I fear that anything we do
to it will break something :(

