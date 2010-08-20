Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab0HTAAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 20:00:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:60528 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777Ab0HTAAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 20:00:51 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Eric Paris <eparis@redhat.com>
Subject: Re: [GIT PULL] notification tree - try 37!
Date: Fri, 20 Aug 2010 02:00:27 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Matt Helsley <matthltc@us.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Michael Kerrisk <michael.kerrisk@gmail.com>,
        linux-fsdevel@vger.kernel.org
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com> <1282016387.21419.113.camel@acb20005.ipt.aol.com> <201008171009.51737.agruen@suse.de>
In-Reply-To: <201008171009.51737.agruen@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008200200.28582.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding linux-fsdevel here as well.]

On Tuesday 17 August 2010 10:09:50 Andreas Gruenbacher wrote:
> > > Q: What prevents the system from going out of memory when a listener
> > > decides to stop reading events or simply can't keep up?  There doesn't
> > > seem to be a limit on the queue depth.  Listeners currently need
> > > CAP_SYS_ADMIN, but somehow limiting the queue depth and throttling when
> > > things start to go bad still sounds like a reasonable thing to do,
> > > right?
> > 
> > It's an interesting question and obviously one that I've thought about.
> > You remember when we talked previously I said the hardest part left was
> > allowing non-root users to use the interface.  It gets especially
> > difficult when thinking about perm-events.  I was specifically told not
> > to timeout or drop those.  But when dealing with non-root users using
> > perm events?   As for pure notification we can do something like inotify
> > does quite easily.
> > 
> > I'm not certain exactly what the best semantics are for non trusted
> > users, so I didn't push any patches that way.  Suggestions welcome   :)
> 
> The system will happily go OOM for trusted users and non-perm events if the
> listener doesn't keep up, so some throttling, dropping, or both needs to
> happen for non-perm events.  This is the critical case.  Doing what inotify
> does (queue an overflow event and drop further events) seems to make sense
> here.
> 
> The situation with perm-events is less severe because the number of
> outstanding perm events is bounded by the number of running processes. 
> This may be enough of a limit.
> 
> I don't think we need to worry about perm-events for untrusted users.  We
> can start supporting some kinds of non-perm-events for untrusted users
> later; this won't change the existing interface.

Another case where fanotify fails to generate useful events is when a listener 
runs out of file descriptors; events will simply end up with fd == -EMFILE in 
that case.  I don't think this behavior is useful; instead, reading from the 
fanotify file descriptor (he one returned by fanotify_init()) should fail to 
give the listener a chance to react.

Andreas
