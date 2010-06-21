Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab0FUB6M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 21:58:12 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:49806 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757356Ab0FUB6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 21:58:09 -0400
Date: Mon, 21 Jun 2010 11:57:31 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, josef@redhat.com, jeffmerkey@gmail.com
Subject: Re: [PATCH 2/5] fsfreeze: emergency thaw will deadlock on s_umount
Message-ID: <20100621015731.GJ6590@dastard>
References: <1276154395-24766-1-git-send-email-david@fromorbit.com>
 <1276154395-24766-3-git-send-email-david@fromorbit.com>
 <20100614152011.GB32354@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100614152011.GB32354@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 11:20:11AM -0400, Christoph Hellwig wrote:
> On Thu, Jun 10, 2010 at 05:19:51PM +1000, Dave Chinner wrote:
> > The emergency thaw process uses iterate_super() which holds the
> > sb->s_umount lock in read mode. The current thaw_super() code takes
> > the sb->s_umount lock in write mode, hence leading to an instant
> > deadlock.
> > 
> > Pass the emergency state into the thaw_bdev/thaw_super code to avoid
> > taking the s_umount lock in this case. We are running under the bdev
> > freeze mutex, so this is still serialised against freeze despite
> > only having a read lock on the sb->s_umount. Hence it should be safe
> > to execute in this manner, especially given that emergency thaw is a
> > rarely executed "get-out-of-jail" feature.
> 
> This is correct as long as no one calls thaw_super directly, which
> is not the case currently.

This patch doesn't try to deal with the bdev/super mismatches; all
it does is prevent an obvious deadlock. Calling freeze/thaw_super
directly will serialise on the s_umount lock, calling
freeze/thaw_bdev() will serialise on the bdev freeze mutex, and if
we mix the two they'll serialise on the s_umount lock. So I think
with this patch serialisation will still occur correctly but avoid
the current deadlock.

I'll change the commit message to explain this better.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
