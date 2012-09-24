Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab2IXCmg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 22:42:36 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:50172 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab2IXCme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 22:42:34 -0400
Date: Mon, 24 Sep 2012 10:42:21 +0800
From: Guo Chao <yan@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@zeniv.linux.org.uk, dchinner@redhat.com, hch@infradead.org,
        jack@suse.cz, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v4 Patch 0/4] fs/inode.c: optimization for inode lock usage
Message-ID: <20120924024221.GB7984@yanx>
References: <1348219866-1799-1-git-send-email-yan@linux.vnet.ibm.com>
 <20120921224912.GA20960@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120921224912.GA20960@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12092402-9264-0000-0000-00000262BD91
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2012 at 08:49:12AM +1000, Dave Chinner wrote:

> On Fri, Sep 21, 2012 at 05:31:02PM +0800, Guo Chao wrote:
> > This patchset optimizes several places which take the per inode spin lock.
> > They have not been fully tested yet, thus they are marked as RFC. 
> 
> Inodes are RCU freed. The i_lock spinlock on the i_state field forms
> part of the memory barrier that allows the RCU read side to
> correctly detect a freed inode during a RCU protected cache lookup
> (hash list traversal for the VFS, or a radix tree traversal for XFS).
> The i_lock usage around the hahs list operations ensures the hash
> list operations are atomic with state changes so that such changes
> are correctly detected during RCU-protected traversals...
> 
> IOWs, removing the i_lock from around the i_state transitions and
> inode hash insert/remove/traversal operations will cause races in
> the RCU lookups and result in incorrectly using freed inodes instead
> of failing the lookup and creating a new one.
> 
> So I don't think this is a good idea at all...
>

Hello, Dave:

  Thanks for your explanation.
 
  Though I can't fully understand it, your concern seems to be that
RCU inode lookup will be bothered by this change. But we do not have 
RCU inode lookup in VFS: inode lookup is done by rather a tranditional
way. 

  XFS gives me the impression that it implements its own inode cache.
There may be such thing there. I have little knowledge on XFS, but I
guess it's unlikely impacted by the change of code implementing VFS 
inode cache.

  As far as I can see, RCU inode free is for RCU dentry lookup, which
seems have nothing to do with 'detect a freed inode'. Taking i_lock in these
places looks like to me a result of following old lock scheme blindly when 
breaking the big global inode lock. Of course, maybe they are there for
something. Could you speak more about the race this change (patch 1,2?) brings 
up? Thank you.

Regards,
Guo Chao

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

