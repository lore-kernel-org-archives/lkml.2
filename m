Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab0DNVER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 17:04:17 -0400
Received: from fieldses.org ([174.143.236.118]:45239 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756765Ab0DNVEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 17:04:16 -0400
Date: Wed, 14 Apr 2010 17:04:03 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Arnd Bergmann <arnd@arndb.de>, Matthew Wilcox <willy@linux.intel.com>,
       Christoph Hellwig <hch@lst.de>, Miklos Szeredi <mszeredi@suse.cz>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] [RFC] Remove BKL from fs/locks.c
Message-ID: <20100414210403.GA29133@fieldses.org>
References: <1271277384-7627-1-git-send-email-arnd@arndb.de> <1271277384-7627-2-git-send-email-arnd@arndb.de> <1271278334.3159.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271278334.3159.19.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 04:52:14PM -0400, Trond Myklebust wrote:
> On Wed, 2010-04-14 at 22:36 +0200, Arnd Bergmann wrote: 
> > From: Matthew Wilcox <willy@linux.intel.com>
> > 
> > I've taken a patch originally written by Matthew Wilcox and
> > ported it to the current version. It seems that there were
> > originally concerns that this breaks NFS, but since Trond
> > has recently removed the BKL from NFS, my naive assumption
> > would be that it's all good now, despite not having tried to
> > understand what it does.
> 
> Hi Arnd,
> 
> We still need to fix up the bits in NFS that dereference inode->i_flock.
> On the client side, those are mainly the bits that deal with lock
> recovery when the NFS server has rebooted or restarted.
> 
> AFAICS, there are two places in the NFSv4 client that need to be changed
> to call lock_flocks(): nfs_delegation_claim_locks(), and
> nfs4_reclaim_locks(). In both cases, the replacement is trivial.
> 
> For NFSv3, I think we are already safe, since AFAICS the host->h_rwsem
> already provides exclusion between file locking and lock recovery
> attempts. I think we should therefore be able to immediately remove the
> BKL in fs/lockd/clntlock.c:reclaimer().
> 
> I'm not as sure about how sensitive the NFS server is to the switch from
> BKL -> lock_flocks(). Perhaps Bruce can comment...

There's a callback from the lease code, the implementation of which
sleeps in the NFSv4 server case.  I've got patches for the next merge
window which remove that sleep (by just deferring work to a workqueue).

release_lockowner() traverses the lock list.  I need to fix that.

The lockd thread is entirely under the BKL--it takes it at the top of
fs/lockd/svc.c:lockd(), and drops it at the bottom.  It's possible
there may be code that lockd runs that assumes mutual exclusion with
code in locks.c, but I don't know.

--b.
