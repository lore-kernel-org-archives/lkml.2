Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab0EGNxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 09:53:32 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:60025 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab0EGNxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 09:53:31 -0400
Date: Fri, 7 May 2010 07:53:30 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-fsdevel@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: unified page and buffer cache? (was: readahead on directories)
Message-ID: <20100507135329.GA17259@parisc-linux.org>
References: <4BCC7C05.8000803@cfl.rr.com> <4BE417CB.7000806@cfl.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE417CB.7000806@cfl.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 09:38:19AM -0400, Phillip Susi wrote:
> I thought that the buffer and page caches were unified long ago, but
> last night I modified ureadahead to call readahead() directly on the
> block device for all physical extents involved rather than open() each
> file and readahead() on that.  It read all of the related blocks into
> the buffer cache nice and fast, which was then ignored and the data was
> read again when accessed normally during boot.
> 
> So it seems that the buffer cache and page cache are still separate, and
> normal files only use the page cache, and directories only use the
> buffer cache, which is why readahead() fails when called on a directory.
> 
> Can anyone confirm that my disappointed understanding is correct?  I
> started experimenting with a workaround where I readahead directories
> via the block device, and normal files the normal way.  This seems to do
> the trick, but is sub optimal since you have to read in two passes,
> picking up the directories on the first pass, then going back for the files.

The problem you're seeing is aliasing in the page cache, not a failed
unification of the buffer and page caches.  Pages are addressed by
(mapping, offset).  Each inode generally has its own mapping.  Depending
on the file system, directories may be addressed by their own inode's
mapping, or by the block device's mapping.

Resolving aliasing would be horribly expensive, so it's unlikely to
happen.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
