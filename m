Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab0HTLZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 07:25:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42135 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab0HTLZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 07:25:22 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Eric Paris <eparis@redhat.com>
Subject: Re: [GIT PULL] notification tree: directory events
Date: Fri, 20 Aug 2010 13:25:03 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Matt Helsley <matthltc@us.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Michael Kerrisk <michael.kerrisk@gmail.com>,
        linux-fsdevel@vger.kernel.org
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com> <201008200141.10068.agruen@suse.de> <1282275497.21419.2073.camel@acb20005.ipt.aol.com>
In-Reply-To: <1282275497.21419.2073.camel@acb20005.ipt.aol.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008201325.04218.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 August 2010 05:38:17 Eric Paris wrote:
> So the actual bugs you have reported, I see two.
> 
> The (nearly) unbounded number of potential outstanding notifications
> events is a known situation, pointed out in previous discussions well
> before this commit and is one of the (numerous) reasons why fanotify is
> at this time CAP_SYS_ADMIN only.  It is something that is difficult to
> address while still making fanotify useful for permissions gating.  But
> the issue is clearly noted.

Clearly noting and blissfully ignoring the problem is not enough
unfortunately; this needs to be addressed now.  I have already pointed out 
(quoted below) that permission gating is not the worst problem here; the worst 
problem are listeners whose fanotify event queue just grows and grows.  There 
is no throttling, and no guarantee that even a listener which simply reads and 
completely ignores all events will manage to keep up.  The system will run out 
of memory eventually.

Here is a quote from a previous message about this problem that only went to 
linux-kernel:

On Tuesday 17 August 2010 05:39:47 Eric Paris wrote:
> On Mon, 2010-08-16 at 22:32 +0200, Andreas Gruenbacher wrote:
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

Andreas
