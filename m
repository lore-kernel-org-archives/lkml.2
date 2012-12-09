Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934523Ab2LIUrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 15:47:22 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59135 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934486Ab2LIUrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 15:47:21 -0500
Date: Sun, 9 Dec 2012 20:47:19 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Chris Adams <cmadams@hiwaay.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: New system call wanted: fdreopen
Message-ID: <20121209204719.GG4939@ZenIV.linux.org.uk>
References: <ka2982$ra3$1@ger.gmane.org>
 <20121209193733.GA15378@hiwaay.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121209193733.GA15378@hiwaay.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 09, 2012 at 01:37:33PM -0600, Chris Adams wrote:
> Once upon a time, Tristan Wibberley  <tristan.wibberley@gmail.com> said:
> >A common idiom on Linux is to open a file and keep the fd open so that 
> >the underlying file can be unlinked from its directory. But if the file 
> >needs to be read from several different parts of the codebase then due to 
> >the file descriptor having exactly one read pointer those different parts 
> >must be synchronised which is a relatively difficult task.
> 
> I think you can get similar behavior entirely in user space and in a
> fashion portable to at least BSD systems.  You could fork() (which would
> create a separate FD in the child), pass the FD back to the parent over
> a socket, and then have the child exit.

... and here's your well-earned F for UNIX101.  fork() will *NOT* do anything
of that sort.  Not on anything starting at v1 - the bug you want to rely upon
had been killed very early, possibly even before the migration from PDP-8 to
PDP-11.

Think how would something like (ls;ls) >/tmp/a work if you didn't have
current file offset shared across fork(2).  Parent doesn't do any IO
here; both children inherit stdout from it when they are forked and
write to said stdout.  We want the output of the second not at the
offset 0, obviously.

That's *the* reason why we (every Unix out there) have a distinction between
file descriptors and opened files.  open() yields a new IO channel (aka
opened file).  It also creates a new descriptor and associates that channel
with it.  fork() does *not* create new opened files.  It creates new
descriptor table, populating it with additional references to opened files
the parent had descriptors for.

It's the same difference as between doing open() of the same file twice and
doing open() + dup().  In fact, what you've described is a very obfuscated
way to do dup(2) - SCM_RIGHTS descriptor passing will take a descriptor in
sender, acquire an extra reference to opened file corresponding to it and
store that reference in datagram.  Recepient will allocate a new descriptor
and associate it with the reference to opened file it has found in datagram.

Seriously, this is as basic as it gets - understanding how redirects work
and what file descriptors are really ought to be covered by any introductory
course on Unix, let alone anything that touches descriptor-passing.  Current
IO offset is a property of opened file, not of a descriptor.  What the original
poster has described is clearly a new opened file instance associated with
the same filesystem object.  dup() or fork() will do nothing of that sort;
not on Linux, not on *BSD, not on any Unix.

open() on /proc/<pid>/fd/<n> will, but it's Linux-specific.  Whether it's
a good idea or not, depends on the program in question, obviously.  In any
case, you don't need a new syscall for that.
