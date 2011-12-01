Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab1LAO1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 09:27:09 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:52188 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab1LAO1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 09:27:07 -0500
Date: Thu, 1 Dec 2011 07:27:05 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fs: Make write(2) interruptible by a fatal signal
Message-ID: <20111201142704.GT4387@parisc-linux.org>
References: <1322735278-17420-1-git-send-email-jack@suse.cz> <20111201122425.GA16274@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201122425.GA16274@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 08:24:25PM +0800, Wu Fengguang wrote:
> > This patch makes write interruptible by SIGKILL.
> 
> Let me try to summarize the objective impacts of (not) merging this
> patch, and would like to hear more opinions from experienced users.
> 
> - w/o patch
> 
> BEHAVIOR:
> write(2) insists to complete even when the user really wants to stop it.
> 
> IMPACT:
> It could be annoying to experience slow responses to "kill -9" when
> it's a large write to a slow device, for example,
> 
>         dd if=/dev/zero of=/mnt/nokia/zero bs=100M

Another problem scenario is an NFS mounted file going away while the
user is writing to it.  The user should be able to kill the stuck process
without rebooting their machine.

> - w/ patch
> 
> BEHAVIOR:
> write(2) aborts quickly with possible partial write on SIGKILL
> 
> IMPACT:
> The partial write might lead to data corruption somewhere, sometime
> (the possibility is low but real) and bring trouble to some users.

Let's examine these cases.  We've already written at least some of the
data into the page cache (and updated i_size for extending writes in the
call to ->write_end).  It's just not hit the backing store yet.  That means
that this state of affairs is already *visible* to another process on the
same machine, it's just not *durable* (eg in the event of power failure).

I think in the worst case, we've simply extended the window of opportunity
for another process to see the partial write.

So, please add

Acked-by: Matthew Wilcox <matthew.r.wilcox@intel.com>

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
