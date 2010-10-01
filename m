Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab0JAGDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 02:03:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752443Ab0JAGDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 02:03:17 -0400
Date: Thu, 30 Sep 2010 23:04:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/17] fs: icache lock i_count
Message-Id: <20100930230416.868e6468.akpm@linux-foundation.org>
In-Reply-To: <20101001055536.GD32349@infradead.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	<1285762729-17928-6-git-send-email-david@fromorbit.com>
	<20100929215229.160c7bce.akpm@linux-foundation.org>
	<20101001055536.GD32349@infradead.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Oct 2010 01:55:36 -0400 Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, Sep 29, 2010 at 09:52:29PM -0700, Andrew Morton wrote:
> > On Wed, 29 Sep 2010 22:18:37 +1000 Dave Chinner <david@fromorbit.com> wrote:
> > 
> > > -	if (atomic_read(&inode->i_count) != 1)
> > > +	if (inode->i_count != 1)
> > 
> > This really should have been renamed to catch unconverted code.
> > 
> > Such code usually wouldn't compile anyway, but it will if it takes the
> > address of i_count only (for example).
> 
> If people do whacky things they'll lose - there is a reason why C has a
> fairly strict type system after all.  We've changed types of variables
> all the time and we didn't run into problems.

No, we've run into problems *frequently*.  A common case is where we
convert a mutex to a spinlock or vice versa.  If you don't rename the
lock, the code still compiles (with warnings) and crashes horridly at
runtime.

> > And maybe we should access this guy via accessor functions, dunno.
> 
> Seems like complete overkill.

Still wrong.  We do this frequently and we do it in areas where we
believe that the implementation might change in the future.

Had we done it with i_count from day one then this part of the patchset
would be far simpler.


