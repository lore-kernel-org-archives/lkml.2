Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab0HQIKK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 04:10:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:56218 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab0HQIKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 04:10:08 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Eric Paris <eparis@redhat.com>
Subject: Re: [GIT PULL] notification tree - try 37!
Date: Tue, 17 Aug 2010 10:09:50 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Matt Helsley <matthltc@us.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Michael Kerrisk <michael.kerrisk@gmail.com>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com> <201008162232.36873.agruen@suse.de> <1282016387.21419.113.camel@acb20005.ipt.aol.com>
In-Reply-To: <1282016387.21419.113.camel@acb20005.ipt.aol.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008171009.51737.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 August 2010 05:39:47 Eric Paris wrote:
> On Mon, 2010-08-16 at 22:32 +0200, Andreas Gruenbacher wrote:
> > Q: What happens when a process watching for FAN_OPEN_PERM or
> > FAN_ACCESS_PERM events exits or dies while events are in flight?  I
> > can't see anything in the code that would wake sleeping processes up
> > when the fsnotify_group of the listener is torn down.
> 
> We can get stuck.  There was code which cleaned that up, but it got
> accidentally removed long ago when, upon review on list, I was told to
> remove all timeout code.  It's easy enough to fix up.  I'll post a patch
> this week.

This needs to be fixed then.  Not such a big deal, but it shows that the tree 
wasn't ready for being merged yet and needs further review.

> > Q: What prevents the system from going out of memory when a listener
> > decides to stop reading events or simply can't keep up?  There doesn't
> > seem to be a limit on the queue depth.  Listeners currently need
> > CAP_SYS_ADMIN, but somehow limiting the queue depth and throttling when
> > things start to go bad still sounds like a reasonable thing to do,
> > right?
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

The system will happily go OOM for trusted users and non-perm events if the 
listener doesn't keep up, so some throttling, dropping, or both needs to 
happen for non-perm events.  This is the critical case.  Doing what inotify 
does (queue an overflow event and drop further events) seems to make sense 
here.

The situation with perm-events is less severe because the number of 
outstanding perm events is bounded by the number of running processes.  This 
may be enough of a limit.

I don't think we need to worry about perm-events for untrusted users.  We can 
start supporting some kinds of non-perm-events for untrusted users later; this 
won't change the existing interface.

Thanks,
Andreas
