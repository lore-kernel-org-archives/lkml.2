Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab1F2Rzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 13:55:45 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:50553
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752313Ab1F2Rzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 13:55:43 -0400
Date: Wed, 29 Jun 2011 13:55:34 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Curt Wohlgemuth <curtw@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: [PATCH] writeback: Don't wait for completion in
 writeback_inodes_sb_nr
Message-ID: <20110629175534.GA32236@infradead.org>
References: <1309304616-8657-1-git-send-email-curtw@google.com>
 <20110629005422.GQ32466@dastard>
 <BANLkTimKtwVZo3D+w9AB2-C83d08YROcMw@mail.gmail.com>
 <20110629081155.GA5558@infradead.org>
 <20110629165714.GF17590@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629165714.GF17590@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 06:57:14PM +0200, Jan Kara wrote:
> > For sys_sync I'm pretty sure we could simply remove the
> > writeback_inodes_sb call and get just as good if not better performance,
>   Actually, it won't with current code. Because WB_SYNC_ALL writeback
> currently has the peculiarity that it looks like:
>   for all inodes {
>     write all inode data
>     wait for inode data
>   }
> while to achieve good performance we actually need something like
>   for all inodes
>     write all inode data
>   for all inodes
>     wait for inode data
> It makes a difference in an order of magnitude when there are lots of
> smallish files - SLES had a bug like this so I know from user reports ;)

I don't think that's true.  The WB_SYNC_ALL writeback is done using
sync_inodes_sb, which operates as:

  for all dirty inodes in bdi:
     if inode belongs to sb
        write all inode data

  for all inodes in sb:
     wait for inode data

we still do that in a big for each sb loop, though.

>   You mean that sync(1) would actually write the data itself? It would
> certainly make some things simpler but it has its problems as well - for
> example sync racing with flusher thread writing back inodes can create
> rather bad IO pattern...

Only the second pass.  The idea is that we first try to use the flusher
threads for good I/O patterns, but if we can't get that to work only
block the caller and not everyone.  But that's just an idea so far,
it would need serious benchmark.  And despite what I claimed before
we actually do the wait in the caller context already anyway, which
already gives you the easy part of the above effect.

