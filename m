Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab0JXQVf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 12:21:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41394 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab0JXQVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 12:21:34 -0400
Date: Sun, 24 Oct 2010 12:21:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/21] fs: Protect inode->i_state with the inode->i_lock
Message-ID: <20101024162131.GA23677@infradead.org>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <1287622186-1935-17-git-send-email-david@fromorbit.com>
 <20101022015622.GE19804@ZenIV.linux.org.uk>
 <20101022031431.GK12506@dastard>
 <20101022103705.GK19804@ZenIV.linux.org.uk>
 <20101023213752.GR19804@ZenIV.linux.org.uk>
 <20101024141310.GA21513@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101024141310.GA21513@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 24, 2010 at 10:13:10AM -0400, Christoph Hellwig wrote:
> On Sat, Oct 23, 2010 at 10:37:52PM +0100, Al Viro wrote:
> > 	* invalidate_inodes() - collect I_FREEING/I_WILL_FREE on a separate
> > list, then (after we'd evicted the stuff we'd decided to evict) wait until
> > they get freed by whatever's freeing them already.
> 
> Note that we would only have to do this for the umount case.  For others
> it's pretty pointless.

Now that I've looked into it I think we basically fine right now.

If we're in umount there should be no other I_FREEING inodes.

 - concurrent prune_icache is prevented by iprune_sem.
 - concurrent other invalidate_inodes should not happen because we're
   in unmount and the filesystem should not be reachable any more,
   and even if it did iprune_sem would protect us.
 - how could a concurrent iput_final happen?  filesystem is not
   accessible anymore, and iput of fs internal inodes is single-threaded
   with the rest of the actual umount process.

So just skipping over I_FREEING inodes here should be fine for
non-umount callers, and for umount we could even do a WARN_ON.
