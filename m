Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab0HTDij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 23:38:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab0HTDig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 23:38:36 -0400
Subject: Re: [GIT PULL] notification tree: directory events
From: Eric Paris <eparis@redhat.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Matt Helsley <matthltc@us.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Michael Kerrisk <michael.kerrisk@gmail.com>,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <201008200141.10068.agruen@suse.de>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com>
	 <201008191444.08966.agruen@suse.de>
	 <1282230012.21419.1566.camel@acb20005.ipt.aol.com>
	 <201008200141.10068.agruen@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 23:38:17 -0400
Message-ID: <1282275497.21419.2073.camel@acb20005.ipt.aol.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-20 at 01:41 +0200, Andreas Gruenbacher wrote:
> [Adding linux-fsdevel to the list as this really is a filesystem discussion.]

> Yes.  Right now, struct fanotify_event_metadata contains a file descriptor 
> which is the only information we have about the object the event refers to, or 
> a negative error code if a file descriptor could not be opened with 
> dentry_open() or some other error occurred.
> 
> Being able to identify the object that an event refers to is important.  There 
> are two ways to do that:
> 
> 	(1) Include fields like st_dev and st_ino in struct
> 	    fanotify_event_metadata.  This is not ideal because the listener
> 	    won't be able to find out any additional information about the file
> 	    (like an idea about its name, for example).
> 
> 		 For example, if inode->i_generation is ever exposed to user-space
> 	    through stat(), that information would still be missing in struct
> 	    fanotify_event_metadata.
> 
> 	(2) Construct a file descriptor that refers to the file that could not be
> 	    dentry_open()ed, but which cannot be used for any I/O, and pass the
> 	    error condition in a separate field.  The kernel has all the
> 	    information needed for doing that, and it shouldn't be hard to
> 	    implement.
> 
> 	    That way, the listener always has a file descriptor to poke around
> 	    with.
> 
> Failing to do (2) right now, I think it still makes sense to separate the file 
> descriptor from the error code in struct fanotify_event_metadata; this would 
> enable us to do (2) later if we decide to.

In reference to (2), I don't even understand what an fd is that can't be
used for anything.  I'll let Al or Christoph respond if they feel like
it, but it sounds crazy to me.  You want to just magic up some struct
file and attach a struct path to it even though dentry_open() failed?
So you can do what with it?

On a more realistic note, I'm not opposed to (1), however, your
arguments would lead one to reject inotify as the IN_OVERFLOW or oom
conditions will result in silently lost events or events which provide
no useful information since the notification system has broken down.
When the appropriate use of notification is impossible I'm certainly not
opposed to patches which add best effort information, but you are
already outside the bounds of a reasonably functional system and there
is no good solution.

> bugs that 
> would have been shaken out in a proper review (OOMing the system when a 
> listener stops listening or blocking access to files when a listener dies; I 
> have reported that).

So the actual bugs you have reported, I see two.

The (nearly) unbounded number of potential outstanding notifications
events is a known situation, pointed out in previous discussions well
before this commit and is one of the (numerous) reasons why fanotify is
at this time CAP_SYS_ADMIN only.  It is something that is difficult to
address while still making fanotify useful for permissions gating.  But
the issue is clearly noted.

As to when a listener dies:  You have to define 'dies'.  If the process
just stops respond it is supposed to lock forever.  I was explicitly ask
to remove timeouts (even though I've already been ask off list to put
them back)  In Linus' tree there is a race in which both processes (the
listener and the process doing an action waiting on the listener) can
deadlock and hang forever.  A (much less racy but not right) patch to
fix this has already been posted.  Do you have comments on that patch?
I have a better version which has worked well for me today which I will
likely post tomorrow morning after I look over it again.  I'd love your
feedback.

-Eric

