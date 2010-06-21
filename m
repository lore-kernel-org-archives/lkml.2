Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab0FUHr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 03:47:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37825 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab0FUHr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 03:47:57 -0400
Date: Mon, 21 Jun 2010 03:47:56 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk, josef@redhat.com,
       jeffmerkey@gmail.com
Subject: Re: [PATCH 2/5] fsfreeze: emergency thaw will deadlock on s_umount
Message-ID: <20100621074756.GA2201@infradead.org>
References: <1276154395-24766-1-git-send-email-david@fromorbit.com>
 <1276154395-24766-3-git-send-email-david@fromorbit.com>
 <20100614152011.GB32354@infradead.org>
 <20100621015731.GJ6590@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100621015731.GJ6590@dastard>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 11:57:31AM +1000, Dave Chinner wrote:
> This patch doesn't try to deal with the bdev/super mismatches; all
> it does is prevent an obvious deadlock. Calling freeze/thaw_super
> directly will serialise on the s_umount lock, calling
> freeze/thaw_bdev() will serialise on the bdev freeze mutex, and if
> we mix the two they'll serialise on the s_umount lock. So I think
> with this patch serialisation will still occur correctly but avoid
> the current deadlock.
> 
> I'll change the commit message to explain this better.

I don;t think the explanation alone is enough.

Right now thaw_super itself is only serialized by exclusive shared
s_umount.   thaw_bdev it also serialized by bd_fsfreeze_mutex, but
there are callers of thaw_super that do not go through thaw_bdev, so
our locking is not enough here.

