Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab0EVXZi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 19:25:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006Ab0EVXZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 19:25:36 -0400
Subject: Re: [2.6.34-git8][regression] massive polling problems with udevd
 and  other processes
From: Eric Paris <eparis@redhat.com>
To: Eric Paris <eparis@parisplace.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, walt <w41ter@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTimffWnIjHIEW54AoVxiALEoFkJZJJ7u57ZChDuy@mail.gmail.com>
References: <201005221535.38939.shawn.starr@rogers.com>
	 <4BF83CBF.8080300@gmail.com> <20100522204426.GO31073@ZenIV.linux.org.uk>
	 <AANLkTimffWnIjHIEW54AoVxiALEoFkJZJJ7u57ZChDuy@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 22 May 2010 19:25:31 -0400
Message-ID: <1274570731.2810.45.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-22 at 18:59 -0400, Eric Paris wrote:
> On Sat, May 22, 2010 at 4:44 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Sat, May 22, 2010 at 01:21:19PM -0700, walt wrote:
> >> On 05/22/2010 12:35 PM, Shawn Starr wrote:
> >> >Just built today's snapshot from linus's tree and have problems with udev
> >> >using 100% cpu and KDE processes also pegging cpus.
> >> >
> >> >This is with Fedora 13 + snapshot kernel from git.
> >> >
> >> >Anyone else noticing this?
> >>
> >> Yes, just bisected it to this:
> >>
> >> commit a7cf4145bb86aaf85d4d4d29a69b50b688e2e49d
> >> Author: Eric Paris <eparis@>
> >> Date:   Fri May 14 11:44:10 2010 -0400
> >>
> >>     anon_inode: set S_IFREG on the anon_inode
> >
> > Cute...  Frankly, I'd be fine with just reverting that one and teaching
> > selinux to STFU.  However, I wonder what specifically is getting polled.
> > Which anon_inode users?
> 
> On my system udev has both inotify and signalfd open.  He's asking for
> more of the strace.  If the ONLY thing that udev is doing is polling
> with no other syscalls at all it's a udev problem (although maybe one
> where we have to maintain bug for bug compatibility.
> 
> Can you show us a more lines of strace context and the output of ls -l
> /proc/$PID/fd ?  That should give us a better idea what udev is doing
> and which anon_inode we are dealing with.

I'm wondering if this isn't a udev bug brought on by the combination of:

commit c44dcc56d2b5c79ba3063d20f76e5347e2e418f6
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Feb 11 02:24:46 2010 -0500

    switch inotify_user to anon_inode
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk

and a7cf4145bb86aaf85d4d4d29a69b50b688e2e49d (the commit in question).
Before c44dcc56 the inotify inode would have been an S_IFDIR and maybe
for that reason wouldn't have made it into the udev polling set?  The
inotify inode would have been nothing after c44dcc56 (obviously) and now
that it is S_IFREG maybe udev is putting it in the polling set for some
reason....

I'm feeling like this is a udev bug, but the only fix is going to be to
revert and paper over anything else that has problems with
(mode & S_IFMNT) == 0

-Eric

