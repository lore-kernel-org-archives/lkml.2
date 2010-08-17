Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab0HQDkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 23:40:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab0HQDkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 23:40:09 -0400
Subject: Re: [GIT PULL] notification tree - try 37!
From: Eric Paris <eparis@redhat.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Matt Helsley <matthltc@us.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Michael Kerrisk <michael.kerrisk@gmail.com>
In-Reply-To: <201008162232.36873.agruen@suse.de>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com>
	 <20100807000624.GA14819@infradead.org>
	 <1281208514.2609.25.camel@dhcp231-200.rdu.redhat.com>
	 <201008162232.36873.agruen@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 23:39:47 -0400
Message-ID: <1282016387.21419.113.camel@acb20005.ipt.aol.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 22:32 +0200, Andreas Gruenbacher wrote:
> On Saturday 07 August 2010 21:15:14 Eric Paris wrote:
> > On Fri, 2010-08-06 at 20:06 -0400, Christoph Hellwig wrote:
> > > I'm also totally missing on any re-post of these patches or discussion
> > > of the changes during the last development window.
> > 
> > I just searched lkml an fsdevel where I usually send everything don't
> > see then.  I totally failed.
> 
> Oh yes.
> 
> This introduces two new syscalls which will be impossible to fix up after the 
> fact, and those system calls are poorly documented: commits 2a3edf86 and 
> 52c923dd document the initial versions (in the commit message!), but 
> subsequent commits then extend that interface.  The interface for replying to 
> events is not documented at all beyond the example code [1].  There is no 
> documentation in Documentation/filesystems/, either.
> 
> 	[1] http://people.redhat.com/~eparis/fanotify/

I'll work on documentation.  Although it should be pointed out that the
interface was sent to list many times with lots of discussion and
feedback.  The only patches that didn't make the list were the last
couple which changed internal notification semantics (and fscked with
fput() but that patch, which caused problems, was specifically pointed
out in this thread and reverted).

> Q: What happens when a process watching for FAN_OPEN_PERM or FAN_ACCESS_PERM 
> events exits or dies while events are in flight?  I can't see anything in the 
> code that would wake sleeping processes up when the fsnotify_group of the 
> listener is torn down.

We can get stuck.  There was code which cleaned that up, but it got
accidentally removed long ago when, upon review on list, I was told to
remove all timeout code.  It's easy enough to fix up.  I'll post a patch
this week.

> Q: What prevents the system from going out of memory when a listener decides 
> to stop reading events or simply can't keep up?  There doesn't seem to be a 
> limit on the queue depth.  Listeners currently need CAP_SYS_ADMIN, but somehow 
> limiting the queue depth and throttling when things start to go bad still 
> sounds like a reasonable thing to do, right?)

It's an interesting question and obviously one that I've thought about.
You remember when we talked previously I said the hardest part left was
allowing non-root users to use the interface.  It gets especially
difficult when thinking about perm-events.  I was specifically told not
to timeout or drop those.  But when dealing with non-root users using
perm events?   As for pure notification we can do something like inotify
does quite easily.

I'm not certain exactly what the best semantics are for non trusted
users, so I didn't push any patches that way.  Suggestions welcome   :)

-Eric

