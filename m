Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab0FNXWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 19:22:18 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:42917 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753764Ab0FNXWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 19:22:17 -0400
Date: Tue, 15 Jun 2010 09:21:50 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, josef@redhat.com, jeffmerkey@gmail.com
Subject: Re: [PATCH 2/5] fsfreeze: emergency thaw will deadlock on s_umount
Message-ID: <20100614232150.GI6590@dastard>
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

Yeah, the idea of the first two patches is that they can be applied
to a current tree and backported and prevent the infinite loop or
deadlock. The problem of thaw_bdev/thaw_super is what the rest of
the patches are supposed to address.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
