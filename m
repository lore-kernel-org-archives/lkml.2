Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab0JZAMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 20:12:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758554Ab0JZAMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 20:12:46 -0400
Subject: Re: [PATCH 01/11] IMA: use rbtree instead of radix tree for inode
 information cache
From: Eric Paris <eparis@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, zohar@us.ibm.com,
        warthog9@kernel.org, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, viro@zeniv.linux.org.uk
In-Reply-To: <20101025232230.GW32255@dastard>
References: <20101025184118.20504.24290.stgit@paris.rdu.redhat.com>
	 <20101025232230.GW32255@dastard>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Oct 2010 20:12:12 -0400
Message-ID: <1288051932.2655.93.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-26 at 10:22 +1100, Dave Chinner wrote:
> On Mon, Oct 25, 2010 at 02:41:18PM -0400, Eric Paris wrote:
> > The IMA code needs to store the number of tasks which have an open fd
> > granting permission to write a file even when IMA is not in use.  It needs
> > this information in order to be enabled at a later point in time without
> > losing it's integrity garantees.  At the moment that means we store a
> > little bit of data about every inode in a cache.  We use a radix tree key'd
> > on the inode's memory address.  Dave Chinner pointed out that a radix tree
> > is a terrible data structure for such a sparse key space.  This patch
> > switches to using an rbtree which should be more efficient.
> 
> I'm not sure this is the right fix, though.
> 
> Realistically, there is a 1:1 relationship between the inode and the
> IMA information. I fail to see why an external index is needed here
> at all - just use a separate structure to store the IMA information
> that the inode points to. That makes the need for a new global index
> and global lock go away completely.

I guess I did a bad job explaining my 1:1 relationship comments.  I only
need the i_readcount in a 1:1 manor.  (I'm also using the already
existing i_writecount)  So IMA needs some information in a 1:1
relationship, but everything else in the IMA structure is only needed
when 'a measurement policy is loaded.'

I believe that IBM is going to look into making i_readcount a first
class citizen which can be used by both IMA and generic_setlease().
Then people could say IMA had 0 per inode overhead   :)

> You're already adding 8 bytes to the inode, so why not make it a
> pointer.

4 + 4 padding.  Yes.

> We've got 4 conditions:

You're suggesting we go to 4 conditions?  Today we have 3.

> 1. not configured - no overhead
> 2. configured, boot time disabled - 8 bytes per inode
> 3. configured, boot time enabled, runtime disabled - 8 bytes per
> inode + small IMA structure

2 and 3 are the same today, and both are 4+4.  I believe your suggestion
would be for #3 would be 8 bytes in inode pointing to a 4+4 byte
structure.  I don't really know if that gets us anything.

> 4. configured, boot time enabled, runtime enabled - 8 bytes per
> inode + large IMA structure

> Anyone who wants the option of runtime enablement can take the extra
> allocation overhead, but otherwise nobody is affected apart from 8
> bytes of additional memory per inode. I doubt that will change
> anything unless it increases the size of the inode enough to push it
> over slab boundaries. And if LSM stacking is introduced, then that 8
> bytes per inode overhead will go away, anyway.

At least it gets shifted so you don't see it.  Can't say it goes
away....

> This approach doesn't introduce new global lock and lookup overhead
> into the main VFS paths, allows you to remove a bunch of code and
> has a path forward for removing the 8 byte per inode overhead as
> well. Seems like the best compromise to me....

End of my patch series there are no global locks in main VFS paths
(unless you load an ima measurement policy).  I realize that this patch
switches an rcu_readlock() to a spin_lock() and maybe that's what you
means, but you'll find that I drop ALL locking on core paths when you
don't load a measurement policy in 10/11

http://marc.info/?l=linux-kernel&m=128803236419823&w=2

-Eric

