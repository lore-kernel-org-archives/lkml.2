Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626Ab0EGSaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 14:30:06 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:45090 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757469Ab0EGSaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 14:30:04 -0400
Date: Fri, 7 May 2010 12:30:00 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-fsdevel@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: unified page and buffer cache?
Message-ID: <20100507183000.GD17259@parisc-linux.org>
References: <4BCC7C05.8000803@cfl.rr.com> <4BE417CB.7000806@cfl.rr.com> <20100507135329.GA17259@parisc-linux.org> <4BE4359E.9020400@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE4359E.9020400@cfl.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 11:45:34AM -0400, Phillip Susi wrote:
> On 5/7/2010 9:53 AM, Matthew Wilcox wrote:
> > The problem you're seeing is aliasing in the page cache, not a failed
> > unification of the buffer and page caches.  Pages are addressed by
> > (mapping, offset).  Each inode generally has its own mapping.  Depending
> > on the file system, directories may be addressed by their own inode's
> > mapping, or by the block device's mapping.
> 
> If there are two mappings that don't know about each other, then the
> caches don't seem very unified to me.  If I write to the file and that
> data sits in the mapping for the inode, then I read the corresponding
> blocks though the block device, and it has a different mapping, then I
> read the old data off the disk instead of the new data in the cache.  I
> thought that this exact problem had been fixed long ago.

A long time ago (was this 2.0?  1.2?) the buffer cache and the page cache
were actually separate caches.  Then the buffer cache was rewritten to
point into the page cache, and we were all grateful.

As I said, you're seeing something completely different.  The page cache
is virtually indexed, not physically indexed.  As generations of CPU
designers have found, that's a lot faster, but aliases can bite you.

> > Resolving aliasing would be horribly expensive, so it's unlikely to
> > happen.
> 
> Back to the drawing board I guess.  Maybe ext could be fixed to use an
> inode mapping for directories instead of relying on the block device
> mapping, then I could readahead() the directory instead of having to go
> to the block device at all.

That would be possible, but would waste memory space.  But we've all
got gigabytes of ram these days, maybe nobody cares.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
