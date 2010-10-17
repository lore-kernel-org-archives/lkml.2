Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab0JQAnG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 20:43:06 -0400
Received: from canuck.infradead.org ([134.117.69.58]:60970 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab0JQAnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 20:43:05 -0400
Date: Sat, 16 Oct 2010 20:42:57 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/17] fs: icache lock s_inodes list
Message-ID: <20101017004257.GA1614@infradead.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-3-git-send-email-david@fromorbit.com>
 <20101001054909.GB32349@infradead.org>
 <20101016075411.GA19147@amd>
 <20101016161210.GA16861@infradead.org>
 <20101016170911.GA3240@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016170911.GA3240@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 04:09:11AM +1100, Nick Piggin wrote:
> If you want it to be scalable within a single sb, it needs to be
> per cpu. If it is per-cpu it does not need to be per-sb as well
> which just adds bloat.

Right now the patches split up the inode lock and do not add
per-cpu magic.  It's not any more work to move from per-sb lists
to per-cpu locking if we eventually do it than moving from global
to per-cpu.

I'm not entirely convinced moving s_inodes to a per-cpu list is a good
idea.  For now per-sb is just fine for disk filesystems as they have
much more fs-wide cachelines they touch for inode creatation/deletion
anyway, and for sockets/pipes a variant of your patch to not ever
add them to s_inodes sounds like the better approach.

If we eventually hit the limit for disk filesystems I have some better
ideas to solve this.  One is to abuse whatever data sturcture we use
for the inode hash also for iterating over all inodes - we only
iterate over them in very few places, and none of them is a fast path.

