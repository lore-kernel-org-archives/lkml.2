Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab0JLKrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 06:47:33 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:37381 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757139Ab0JLKrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 06:47:32 -0400
Date: Tue, 12 Oct 2010 21:47:27 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/18] fs: split __inode_add_to_list
Message-ID: <20101012104727.GC32255@dastard>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <20101009080854.GA15943@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101009080854.GA15943@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 09, 2010 at 04:08:54AM -0400, Christoph Hellwig wrote:
> __inode_add_to_list does two things that aren't related.  First it adds
> the inode to the s_inodes list in the superblock, and second it optionally
> adds the inode to the inode hash.  Now that these don't even share the
> same lock there is no need to keeps this functionally together.  Split
> out an add_to_inode_hash helper from __insert_inode_hash to add an inode
> to a pre-calculated hash bucket for use by the various iget version, and
> a inode_add_to_sb_list helper from __inode_add_to_list to just add an
> inode to the per-sb list.  The inode.c-internal callers of
> __inode_add_to_list are converted to a sequence of inode_add_to_sb_list
> and __insert_inode_hash (if needed), and the only use of inode_add_to_list
> in XFS is replaced with a call to inode_add_to_sb_list and insert_inode_hash.

The only reason XFS hashed the inodes was to avoid problems in the
generic code that checked for unhashed inodes during clear_inode(). The
evict() changeover moved that unhashed check into
generic_drop_inode(), which the filesystem can override. Hence if
you add a ->drop_inode() method for XFS that just checks the link
count, we can avoid haѕhing the inodes altogether for XFS.

I can add another patch on top of this one to do that if you want...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
