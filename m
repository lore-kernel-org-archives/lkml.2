Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab0HSXlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 19:41:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52225 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab0HSXl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 19:41:28 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Eric Paris <eparis@redhat.com>
Subject: Re: [GIT PULL] notification tree: directory events
Date: Fri, 20 Aug 2010 01:41:09 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Matt Helsley <matthltc@us.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Michael Kerrisk <michael.kerrisk@gmail.com>,
        linux-fsdevel@vger.kernel.org
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com> <201008191444.08966.agruen@suse.de> <1282230012.21419.1566.camel@acb20005.ipt.aol.com>
In-Reply-To: <1282230012.21419.1566.camel@acb20005.ipt.aol.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008200141.10068.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding linux-fsdevel to the list as this really is a filesystem discussion.]

On Thursday 19 August 2010 17:00:12 Eric Paris wrote:
> On Thu, 2010-08-19 at 14:44 +0200, Andreas Gruenbacher wrote:
> > On Wednesday 18 August 2010 17:59:06 Eric Paris wrote:
> > 
> > The half-thought-out directory events are not part of this subset though.
> > They are not useful in their own right and only generate overheads, and
> > much worse, they could even get in the way when proper directory event
> > support is eventually added.  So that part should really be removed
> > ASAP.
> 
> They aren't something I specifically added so you can call them
> zero-thought-out.  fanotify is just a userspace interface on top of the
> notification infrastructure in the kernel.  The events the
> infrastructure delivers are the events it sends.

Apparently the infrastructure delivers a number of directory events like file 
creation, deletion, and renames through inotify that are not delivered through 
fanotify, and fanotify only sees a subset of all directory events.  The result 
is that directory events for inotify are useful because they allow to watch a 
directory for changes, and the directory events in fanotify are not useful for 
that right now.

>[...]
>> Your changes could be as simple as defining a new flag and then add an
> if (flag && S_IFDIR(i_mode)) to the fanotify_should_send_event handler.
> I'd love to hear objections, failings, short comings, or suggestions if
> you think the interface is inadequate to address these or other needs.

I don't think the events that fanotify delivers for directories (open_perm, 
open, access_perm, close) are useful at all, or that we should allow perm 
events for directories.

So let's please get rid of those directory events unconditionally now, and add 
them back in their proper, final form later, after 2.6.36.

> > We are not talking about Eric's own private syscalls here.  Things we
> > screw up now may be very hard or impossible to fix later; syscalls don't
> > just change from release to release.
> 
> Which is why there was so much discussion and reworking of the
> interface.  It went through many iterations to end up here.  What all
> did we have in those discussions?  2 magic proc files, ioctls on a char
> dev, netlink, a socket with get/setsockopt and eventually we landed on 2
> syscalls that noone found fault with.

Unfortunately there wasn't a lot of discussion about which events should be 
generated when.  Fanotify was merged before turning into a superset of 
inotify, and there was even less discussion about how fanotify should look if 
it isn't a superset of inotify.

> > This also applies to the error reporting mess I have commented on.  At
> > least the interface should be changed so that it can report a valid file
> > descriptor and an error condition at the same time; otherwise, we will
> > end up with a weakness in the interface that we won't be able to fix.
> 
> Can you describe your problem for me again.  I'm not sure I understand
> your request.  I don't understand how we have an error and a valid fd at
> the same time.

Yes.  Right now, struct fanotify_event_metadata contains a file descriptor 
which is the only information we have about the object the event refers to, or 
a negative error code if a file descriptor could not be opened with 
dentry_open() or some other error occurred.

Being able to identify the object that an event refers to is important.  There 
are two ways to do that:

	(1) Include fields like st_dev and st_ino in struct
	    fanotify_event_metadata.  This is not ideal because the listener
	    won't be able to find out any additional information about the file
	    (like an idea about its name, for example).

		 For example, if inode->i_generation is ever exposed to user-space
	    through stat(), that information would still be missing in struct
	    fanotify_event_metadata.

	(2) Construct a file descriptor that refers to the file that could not be
	    dentry_open()ed, but which cannot be used for any I/O, and pass the
	    error condition in a separate field.  The kernel has all the
	    information needed for doing that, and it shouldn't be hard to
	    implement.

	    That way, the listener always has a file descriptor to poke around
	    with.

Failing to do (2) right now, I think it still makes sense to separate the file 
descriptor from the error code in struct fanotify_event_metadata; this would 
enable us to do (2) later if we decide to.

> I understand you want new features but I'm not seeing failures of the
> interface to be forward looking or failures in the feature set that is
> provided.

I do see failures of being forward looking, inconsistencies in the feature set 
which might lead to trouble as we extend fanotify in the future, and bugs that 
would have been shaken out in a proper review (OOMing the system when a 
listener stops listening or blocking access to files when a listener dies; I 
have reported that).

Sorry to say, but this code really should not have been merged yet.  (And mind 
I'm not saying this because I want to block fanotify from making progress -- 
quite the contrary.)

Andreas
