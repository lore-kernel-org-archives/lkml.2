Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab0JHNs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 09:48:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51542 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab0JHNs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 09:48:26 -0400
Date: Fri, 8 Oct 2010 09:48:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/18] fs: introduce a per-cpu last_ino allocator
Message-ID: <20101008134821.GA15157@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-16-git-send-email-david@fromorbit.com>
 <20101008095658.GA19804@ZenIV.linux.org.uk>
 <20101008100346.GA27737@infradead.org>
 <1286533219.2959.128.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286533219.2959.128.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 12:20:19PM +0200, Eric Dumazet wrote:
> If iunique() was scalable, sockets could use it, so that we can have
> hard guarantee two sockets on machine dont have same inum.
> 
> A reasonable compromise here is to use a simple and scalable allocator,
> and take the risk two sockets have same inum.
> 
> While it might break some applications playing fstats() games, on
> sockets, current schem is vastly faster.
> 
> I worked with machines with millions of opened socket concurrently,
> iunique() was not an option, and application didnt care of possible inum
> clash.

The current version of iuniqueue is indeed rather suboptimal.  As is
the pure counter approach.  I think the right way to deal with it
is to use an idr allocator.  This means the filesystem needs to
explicitly free the inode number when the inode is gone, but that
just makes the usage more clear.  Together with the lazy assignment
scheme for synthetic filesystems that should give us both speed and
correctness.

