Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab0JYXXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 19:23:48 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:56153 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758124Ab0JYXXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 19:23:46 -0400
Date: Tue, 26 Oct 2010 10:22:30 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, zohar@us.ibm.com,
        warthog9@kernel.org, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 01/11] IMA: use rbtree instead of radix tree for inode
 information cache
Message-ID: <20101025232230.GW32255@dastard>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 02:41:18PM -0400, Eric Paris wrote:
> The IMA code needs to store the number of tasks which have an open fd
> granting permission to write a file even when IMA is not in use.  It needs
> this information in order to be enabled at a later point in time without
> losing it's integrity garantees.  At the moment that means we store a
> little bit of data about every inode in a cache.  We use a radix tree key'd
> on the inode's memory address.  Dave Chinner pointed out that a radix tree
> is a terrible data structure for such a sparse key space.  This patch
> switches to using an rbtree which should be more efficient.

I'm not sure this is the right fix, though.

Realistically, there is a 1:1 relationship between the inode and the
IMA information. I fail to see why an external index is needed here
at all - just use a separate structure to store the IMA information
that the inode points to. That makes the need for a new global index
and global lock go away completely.

You're already adding 8 bytes to the inode, so why not make it a
pointer. We've got 4 conditions:

1. not configured - no overhead
2. configured, boot time disabled - 8 bytes per inode
3. configured, boot time enabled, runtime disabled - 8 bytes per
inode + small IMA structure
4. configured, boot time enabled, runtime enabled - 8 bytes per
inode + large IMA structure

Anyone who wants the option of runtime enablement can take the extra
allocation overhead, but otherwise nobody is affected apart from 8
bytes of additional memory per inode. I doubt that will change
anything unless it increases the size of the inode enough to push it
over slab boundaries. And if LSM stacking is introduced, then that 8
bytes per inode overhead will go away, anyway.

This approach doesn't introduce new global lock and lookup overhead
into the main VFS paths, allows you to remove a bunch of code and
has a path forward for removing the 8 byte per inode overhead as
well. Seems like the best compromise to me....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
