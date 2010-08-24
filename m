Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934156Ab0HXX0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:26:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:55995 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934135Ab0HXX0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:26:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,265,1280732400"; 
   d="scan'208";a="316569510"
Date: Wed, 25 Aug 2010 07:26:09 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Jan Kara <jack@suse.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shi, Alex" <alex.shi@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH]dquot: do full inode dirty in allocating space
Message-ID: <20100824232609.GA18338@sli10-desk.sh.intel.com>
References: <20100820084943.GA1131@sli10-desk.sh.intel.com>
 <20100824142359.GE3713@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100824142359.GE3713@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 10:23:59PM +0800, Jan Kara wrote:
>   Hi,
> 
> On Fri 20-08-10 16:49:43, Shaohua Li wrote:
> > Alex Shi found a regression when doing ffsb test. The test has several threads,
> > and each thread creates a small file, write to it and then delete it. ffsb
> > reports about 20% regression and Alex bisected it to 43d2932d88e4. The test
> > will call __mark_inode_dirty 3 times. without this commit, we only take
> > inode_lock one time, while with it, we take the lock 3 times with flags (
> > I_DIRTY_SYNC,I_DIRTY_PAGES,I_DIRTY). Perf shows the lock contention increased
> > too much. Below proposed patch fixes it.
>   Thanks for the analysis and the patch!  With which filesystem have you
> measured the results? And what kind of machine it was?
it's ext3 and 24 CPU system with two sockets.
 
> > fs is allocating blocks, which usually means file writes and the inode
> > will be dirtied soon. We fully dirty the inode to reduce some inode_lock
> > contention in several calls of __mark_inode_dirty.
>   Well, this is rather a workaround for a poor handling of inode dirty
> bits. BTW, I think Nick's VFS scalability patches address inode_lock
> contention as well so with them the contention you see should be reduced.
yep, the VFS scalability patch might reduce this.

>   Anyway, I will take this patch for the time before inode_lock
> contention improves and add a proper comment about this before
> mark_inode_dirty.
Thanks.
