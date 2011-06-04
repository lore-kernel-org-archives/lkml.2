Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab1FDOYw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 10:24:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39462 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab1FDOYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 10:24:51 -0400
Date: Sat, 4 Jun 2011 15:24:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, xfs@oss.sgi.com
Subject: Re: [PATCH 08/12] superblock: introduce per-sb cache shrinker
 infrastructure
Message-ID: <20110604142448.GX11521@ZenIV.linux.org.uk>
References: <1306998067-27659-1-git-send-email-david@fromorbit.com>
 <1306998067-27659-9-git-send-email-david@fromorbit.com>
 <20110604004231.GV11521@ZenIV.linux.org.uk>
 <20110604015212.GD561@dastard>
 <20110604140848.GA20404@infradead.org>
 <20110604141940.GW11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110604141940.GW11521@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 04, 2011 at 03:19:40PM +0100, Al Viro wrote:
> > The iprune_sem removal is fine as soon as you have a per-sb shrinker
> > for the inodes which keeps an active reference on the superblock until
> > all the inodes are evicted.
> 
> I really don't like that.  Stuff keeping active refs, worse yet doing that
> asynchronously...  Shrinkers should *not* do that.  Just grab a passive
> ref (i.e. bump s_count), try grab s_umount (shared) and if that thing still
> has ->s_root while we hold s_umount, go ahead.  Unregister either at the
> end of generic_shutdown_super() or from deactivate_locked_super(), between
> the calls of ->kill_sb() and put_filesystem().

PS: shrinkers should not acquire active refs; more specifically, they should
not _drop_ active refs, lest they end up dropping the last active one and
trigger unregistering a shrinker for superblock in question.  From inside of
->shrink(), with shrinker_rwsem held by caller.  Deadlock...
