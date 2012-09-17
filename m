Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab2IQUjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 16:39:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34314 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154Ab2IQUjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 16:39:51 -0400
Date: Mon, 17 Sep 2012 21:39:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org,
        Trond.Myklebust@netapp.com
Subject: Re: [PATCH 1/2] vfs: dcache: fix deadlock in tree traversal
Message-ID: <20120917203946.GV13973@ZenIV.linux.org.uk>
References: <871ui01jr1.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871ui01jr1.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 10:23:30PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> IBM reported a deadlock in select_parent().  This was found to be caused by
> taking rename_lock when already locked when restarting the tree traversal.
> 
> There are two cases when the traversal needs to be restarted:
> 
>  1) concurrent d_move(); this can only happen when not already locked,
>  since taking rename_lock protects against concurrent d_move().
> 
>  2) racing with final d_put() on child just at the moment of ascending
>  to parent; rename_lock doesn't protect against this rare race, so it
>  can happen when already locked.
> 
> Because of case 2. we need to be able to handle restarting the traversal
> when rename_lock is already held.  This patch fixes all three callers of
> try_to_ascend().
> 
> IBM reported that the deadlock is gone with this patch.  However, there's still
> a soft lockup which is addressed by the next patch.

Egads...  The problem is real and analysis, AFAICS, is correct, but result
is extremely ugly ;-/  Let me try to come up with something saner; I'll
push that one to Linus if nothing better comes to mind, but I'd really
prefer to avoid adding to ugliness in fs/dcache.c - we already have too
much of that...
