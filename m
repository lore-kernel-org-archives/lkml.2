Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751057Ab0HQEEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 00:04:07 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:50482 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702Ab0HQEEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 00:04:04 -0400
Date: Mon, 16 Aug 2010 21:03:53 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: Andreas Gruenbacher <agruen@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        Matt Helsley <matthltc@us.ibm.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, Michael Kerrisk <michael.kerrisk@gmail.com>,
        Serge Hallyn <serge@hallyn.com>,
        Biederman Eric Biederman <ebiederm@xmission.com>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [GIT PULL] notification tree - try 37!
Message-ID: <20100817040353.GD3648@count0.beaverton.ibm.com>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com>
 <20100807000624.GA14819@infradead.org>
 <1281208514.2609.25.camel@dhcp231-200.rdu.redhat.com>
 <201008162232.36873.agruen@suse.de>
 <1282016387.21419.113.camel@acb20005.ipt.aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282016387.21419.113.camel@acb20005.ipt.aol.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 11:39:47PM -0400, Eric Paris wrote:
> On Mon, 2010-08-16 at 22:32 +0200, Andreas Gruenbacher wrote:
> > On Saturday 07 August 2010 21:15:14 Eric Paris wrote:
> > > On Fri, 2010-08-06 at 20:06 -0400, Christoph Hellwig wrote:
> > > > I'm also totally missing on any re-post of these patches or discussion
> > > > of the changes during the last development window.
> > > 
> > > I just searched lkml an fsdevel where I usually send everything don't
> > > see then.  I totally failed.
> > 
> > Oh yes.
> > 
> > This introduces two new syscalls which will be impossible to fix up after the 
> > fact, and those system calls are poorly documented: commits 2a3edf86 and 
> > 52c923dd document the initial versions (in the commit message!), but 
> > subsequent commits then extend that interface.  The interface for replying to 
> > events is not documented at all beyond the example code [1].  There is no 
> > documentation in Documentation/filesystems/, either.
> > 
> > 	[1] http://people.redhat.com/~eparis/fanotify/
> 
> I'll work on documentation.  Although it should be pointed out that the
> interface was sent to list many times with lots of discussion and
> feedback.  The only patches that didn't make the list were the last
> couple which changed internal notification semantics (and fscked with
> fput() but that patch, which caused problems, was specifically pointed
> out in this thread and reverted).
> 
> > Q: What happens when a process watching for FAN_OPEN_PERM or FAN_ACCESS_PERM 
> > events exits or dies while events are in flight?  I can't see anything in the 
> > code that would wake sleeping processes up when the fsnotify_group of the 
> > listener is torn down.
> 
> We can get stuck.  There was code which cleaned that up, but it got
> accidentally removed long ago when, upon review on list, I was told to
> remove all timeout code.  It's easy enough to fix up.  I'll post a patch
> this week.
> 
> > Q: What prevents the system from going out of memory when a listener decides 
> > to stop reading events or simply can't keep up?  There doesn't seem to be a 
> > limit on the queue depth.  Listeners currently need CAP_SYS_ADMIN, but somehow 
> > limiting the queue depth and throttling when things start to go bad still 
> > sounds like a reasonable thing to do, right?)
> 
> It's an interesting question and obviously one that I've thought about.
> You remember when we talked previously I said the hardest part left was
> allowing non-root users to use the interface.  It gets especially
> difficult when thinking about perm-events.  I was specifically told not
> to timeout or drop those.  But when dealing with non-root users using
> perm events?   As for pure notification we can do something like inotify
> does quite easily.
> 
> I'm not certain exactly what the best semantics are for non trusted
> users, so I didn't push any patches that way.  Suggestions welcome   :)

Hi Eric,

Sorry I haven't had a chance to look at the perm events. I think
user namespace and containers folks might be interested in them for
non-root users though.

[Adding userns/containers folks to Cc]

I'm guessing non-trusted users can be restricted to only get perm events
on stuff they already own. Plus make perm events by non-trusted users
unreliable yet failsafe -- return EACESS/EPERM when we have to timeout or
drop the events if I understand the issues correctly. Those rules plus user
namespaces would still be quite useful I think. Do they seem reasonable to
implement? Am I forgetting anything important?

Cheers,
	-Matt Helsley
