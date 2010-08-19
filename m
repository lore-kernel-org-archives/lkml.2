Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab0HSPAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:00:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663Ab0HSPAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:00:33 -0400
Subject: Re: [GIT PULL] notification tree: directory events
From: Eric Paris <eparis@redhat.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Matt Helsley <matthltc@us.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Michael Kerrisk <michael.kerrisk@gmail.com>
In-Reply-To: <201008191444.08966.agruen@suse.de>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com>
	 <201008181747.15461.agruen@suse.de>
	 <1282147146.21419.165.camel@acb20005.ipt.aol.com>
	 <201008191444.08966.agruen@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 11:00:12 -0400
Message-ID: <1282230012.21419.1566.camel@acb20005.ipt.aol.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 14:44 +0200, Andreas Gruenbacher wrote:
> On Wednesday 18 August 2010 17:59:06 Eric Paris wrote:

> The half-thought-out directory events are not part of this subset though.  
> They are not useful in their own right and only generate overheads, and much 
> worse, they could even get in the way when proper directory event support is 
> eventually added.  So that part should really be removed ASAP.

They aren't something I specifically added so you can call them
zero-thought-out.  fanotify is just a userspace interface on top of the
notification infrastructure in the kernel.  The events the
infrastructure delivers are the events it sends.

> > Nothing hard about it.  It's as easy as defining a flag and adding a
> > conditional in the code but it's not high on my list.
> 
> We are not talking about Eric's own private syscalls here.  Things we screw up 
> now may be very hard or impossible to fix later; syscalls don't just change 
> from release to release.

Which is why there was so much discussion and reworking of the
interface.  It went through many iterations to end up here.  What all
did we have in those discussions?  2 magic proc files, ioctls on a char
dev, netlink, a socket with get/setsockopt and eventually we landed on 2
syscalls that noone found fault with.  For this particular feature
request the syscall in question looks like so:

SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)

Your changes could be as simple as defining a new flag and then add an
if (flag && S_IFDIR(i_mode)) to the fanotify_should_send_event handler.
I'd love to hear objections, failings, short comings, or suggestions if
you think the interface is inadequate to address these or other needs.

> This also applies to the error reporting mess I have commented on.  At least 
> the interface should be changed so that it can report a valid file descriptor 
> and an error condition at the same time; otherwise, we will end up with a 
> weakness in the interface that we won't be able to fix.

Can you describe your problem for me again.  I'm not sure I understand
your request.  I don't understand how we have an error and a valid fd at
the same time.  Are you really intending to restating the complaint that
when the system is unable to deliver notification there is not a lot of
information about what notification it failed to deliver?  You suggested
possibly adding st_ino and st_dev to the notification in that situation.
The notification messages are easy extensible assuming userspace
properly used the provided macros FAN_EVENT_NEXT and FAN_EVENT_OK to do
its processing.  Nothing prevents us from expanding what information is
provided in the message.  (idea stolen from netlink for just that
purpose)

I understand you want new features but I'm not seeing failures of the
interface to be forward looking or failures in the feature set that is
provided.

-Eric

