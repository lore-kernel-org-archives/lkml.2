Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905Ab0FJM2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 08:28:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:51024 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689Ab0FJM2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 08:28:36 -0400
Date: Thu, 10 Jun 2010 22:28:33 +1000
From: Nick Piggin <npiggin@suse.de>
To: Tao Ma <tao.ma@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joel Becker <joel.becker@oracle.com>,
       mfasheh@suse.com
Subject: Re: [PATCH v3] ocfs2: Let ocfs2_setattr use new truncate sequence.
Message-ID: <20100610122833.GF26335@laptop>
References: <20100610044234.GD26335@laptop>
 <1276146485-9346-1-git-send-email-tao.ma@oracle.com>
 <20100610082711.GA2173@lst.de>
 <20100610084707.GG30672@mail.oracle.com>
 <4C10D600.60209@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C10D600.60209@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 08:09:36PM +0800, Tao Ma wrote:
> Joel Becker wrote:
> >On Thu, Jun 10, 2010 at 10:27:11AM +0200, Christoph Hellwig wrote:
> >>You just leave the duplicate inode_newsize_ok in, but still have
> >>one as part of inode_change_ok.  See the previous thread - we'll
> >>need to move inode_change_ok to under the cluster locks, both
> >>for the truncate and non-truncate case.
> >
> >	Is your concern that the u/gid checks may be against stale ids?
> So I think we should have one inode_change_ok before the cluster
> lock and another after the cluster lock.
> The first one will save us a lot of cluster lock effort if the user
> pass us the wrong arguments while the later
> one will test again with the refreshed inode info.

If attributes cannot be stale, then do the checks before the cluster
lock and not again. If they can be stale, then the check outside the
cluster lock might give incorrect results so it is not harmless to do
it twice.

If you have a mix of some attributes may be stale, then why not do the
inode_change_ok check inside the lock, and then do some open code checks
for optimization before taking the lock.

