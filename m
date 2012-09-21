Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157Ab2IUWtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 18:49:17 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:51933 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758330Ab2IUWtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 18:49:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqUNACruXFB5LFPK/2dsb2JhbABFhSK3eAIBgQOBCYIgAQEFOhwjEAgDDgouFCUDIROIBLk0FIsIcYE4gx1gA5VjkCOCeQ
Date: Sat, 22 Sep 2012 08:49:12 +1000
From: Dave Chinner <david@fromorbit.com>
To: Guo Chao <yan@linux.vnet.ibm.com>
Cc: viro@zeniv.linux.org.uk, dchinner@redhat.com, hch@infradead.org,
        jack@suse.cz, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v4 Patch 0/4] fs/inode.c: optimization for inode lock usage
Message-ID: <20120921224912.GA20960@dastard>
References: <1348219866-1799-1-git-send-email-yan@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348219866-1799-1-git-send-email-yan@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 05:31:02PM +0800, Guo Chao wrote:
> This patchset optimizes several places which take the per inode spin lock.
> They have not been fully tested yet, thus they are marked as RFC. 

Inodes are RCU freed. The i_lock spinlock on the i_state field forms
part of the memory barrier that allows the RCU read side to
correctly detect a freed inode during a RCU protected cache lookup
(hash list traversal for the VFS, or a radix tree traversal for XFS).
The i_lock usage around the hahs list operations ensures the hash
list operations are atomic with state changes so that such changes
are correctly detected during RCU-protected traversals...

IOWs, removing the i_lock from around the i_state transitions and
inode hash insert/remove/traversal operations will cause races in
the RCU lookups and result in incorrectly using freed inodes instead
of failing the lookup and creating a new one.

So I don't think this is a good idea at all...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
