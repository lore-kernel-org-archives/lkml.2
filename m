Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab0HGTP6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 15:15:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab0HGTP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 15:15:56 -0400
Subject: Re: [GIT PULL] notification tree - try 37!
From: Eric Paris <eparis@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Matt Helsley <matthltc@us.ibm.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org
In-Reply-To: <20100807000624.GA14819@infradead.org>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com>
	 <20100806233431.GW2927@count0.beaverton.ibm.com>
	 <20100807000624.GA14819@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Aug 2010 15:15:14 -0400
Message-ID: <1281208514.2609.25.camel@dhcp231-200.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-06 at 20:06 -0400, Christoph Hellwig wrote:
> On Fri, Aug 06, 2010 at 04:34:31PM -0700, Matt Helsley wrote:
> > On Fri, Aug 06, 2010 at 11:58:39AM -0400, Eric Paris wrote:
> > > Here it is again!  Another notification pull request!  There is still
> > > future work to be done on notification, but nothing that I believe
> > > others would call blocking or functional.  The work I plan to do
> > > includes:
> > > 
> > > 1) Al has discussed the addition of a file_clone() call in the VFS which
> > > would eliminate my use of __dentry_open() and would allow the removal of
> > > the rather hideous FMODE_/O_NONOTIFY.
> > 
> > I did a quick search and can't find a mailing list post on this. Was
> > it a private discussion or is there something I can read about what
> > file_clone() will do?

No, it was from a face to face meeting and a couple of irc conversations
talk about all of this stuff.  My understanding was that it was going to
be a lot like dentry_open() only it was going to require a valid struct
file and would return a new struct file.  One of the purposes of the new
interface being the ability to set f_mode at a better time to eliminate
the FMODE/O_ overlapping horror that fanotify requires to prevent
recursion and deadlock.

> I'm also totally missing on any re-post of these patches or discussion
> of the changes during the last development window.

I just searched lkml an fsdevel where I usually send everything don't
see then.  I totally failed.  I'm used to not hearing a peep about my
patches so I never noticed the lack of feedback.  I would have sworn the
last set of patches I sent to both Al and the list, but apparently I
only ever sent stuff to Al.  Looks like all changes between
f874e1ac21d770846 and 1968f5eed54ce47bde4 are the ones of interest.
They are all notification internal except for one:  

http://git.infradead.org/users/eparis/notify.git/commitdiff/c1e5c954020e123d30b4abf4038ce501861bcf9f

It screws with struct file refcnting.

Diffstat of when I don't see posted (well some of it is, but most isn't)
is below....

 fs/file_table.c                      |    9 +
 fs/notify/dnotify/dnotify.c          |   43 +-----
 fs/notify/fanotify/fanotify.c        |  221 +++++++++++++---------------------
 fs/notify/fanotify/fanotify_user.c   |   35 +----
 fs/notify/fsnotify.c                 |  226 ++++++++++++++++++++---------------
 fs/notify/fsnotify.h                 |   18 --
 fs/notify/group.c                    |  168 --------------------------
 fs/notify/inode_mark.c               |   48 +++++--
 fs/notify/inotify/inotify_fsnotify.c |   91 +++++---------
 fs/notify/inotify/inotify_user.c     |   34 +++--
 fs/notify/mark.c                     |   78 +++++++++---
 fs/notify/notification.c             |   88 +++++++++----
 fs/notify/vfsmount_mark.c            |   48 ++++---
 include/linux/fsnotify.h             |   37 ++---
 include/linux/fsnotify_backend.h     |   84 +++++--------
 kernel/audit_tree.c                  |   12 +
 kernel/audit_watch.c                 |   47 +------
 17 files changed, 578 insertions(+), 709 deletions(-)

