Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab0HTDvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 23:51:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab0HTDu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 23:50:57 -0400
Subject: Re: [GIT PULL] notification tree - try 37!
From: Eric Paris <eparis@redhat.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, Matt Helsley <matthltc@us.ibm.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        Michael Kerrisk <michael.kerrisk@gmail.com>
In-Reply-To: <201008192307.32526.agruen@suse.de>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com>
	 <201008192224.12309.agruen@suse.de>
	 <1282250565.21419.1821.camel@acb20005.ipt.aol.com>
	 <201008192307.32526.agruen@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 23:50:36 -0400
Message-ID: <1282276236.21419.2101.camel@acb20005.ipt.aol.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 23:07 +0200, Andreas Gruenbacher wrote:
> On Thursday 19 August 2010 22:42:45 Eric Paris wrote:

[necessary context to the conversation reinserted]

>>> Watching the same directory with fanotify results in:
>>> 
>>>       .../d: pid=... open_perm
>>>       .../d: pid=... open
>>>       .../d: pid=... access_perm
>>>       .../d: pid=... access_perm
>>>       .../d: pid=... close
>>> 
>>> Five events seem a bit excessive; I can't explain why so many are generated.  
>>> The real issue is when watching the same directory both with inotify and 
>>> fanotify, though: the fanotify result stays the same, but

> > The extra events are plainly the new events that inotify doesn't
> > support: namely permissions events.  You ask for and received extra
> > events....
> 
> How can it make sense that inotify suddenly starts seeing events it does not
> support?

I inline commented in the wrong place to make it clear what I was
responding to.  The question I was was answering was: "Five events seem
a bit excessive; I can't explain why so many are generated."  I answered
it.

Now onto the the question of extra inotify events:

> > I can't reproduce it. You must have some other testing methodology.....
> 
> Apparently.  Here is a trace if what I'm getting through inotify (the inotify
> events were dumped with gdb, the rest is from strace):
> 
> inotify_init()                          = 3
> inotify_add_watch(3, "d", IN_ACCESS|IN_MODIFY|IN_ATTRIB|IN_CLOSE_WRITE|IN_CLOSE_NOWRITE|IN_OPEN|IN_MOVED_FROM|IN_MOVED_TO|IN_CREATE|
> IN_DELETE|IN_DELETE_SELF|IN_MOVE_SELF) = 1
> read(3, "\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\1\0\0\0 \0\0@\0\0\0\0\0\0\0\0", 4210688) = 32
> 
> 	=> {wd = 1, mask = 0, cookie = 0, len = 0, name = ...}
> 	=> {wd = 1, mask = 1073741856, cookie = 0, len = 0, name = ...}
> 
> read(3, "\1\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\1\0\0\0\20\0\0@\0\0\0\0\0\0\0\0", 4210688) = 32
> 
> 	=> {wd = 1, mask = 0, cookie = 0, len = 0, name = ...}
> 	=> {wd = 1, mask = 1073741840, cookie = 0, len = 0, name = ...}
> 
> read(3, 0x7fff56db15e0, 4210688)        = -1 EINTR (Interrupted system call)

inotify_add_watch(3, "/mnt/tmp/", IN_ACCESS|IN_MODIFY|IN_ATTRIB|IN_CLOSE_WRITE|IN_CLOSE_NOWRITE|IN_OPEN|IN_MOVED_FROM|IN_MOVED_TO|IN_CREATE|IN_DELETE|IN_DELETE_SELF|IN_MOVE_SELF) = 1
lstat("/mnt/tmp/", {st_mode=S_IFDIR|0755, st_size=1024, ...}) = 0
write(2, "Watches established.\n", 21)  = 21
select(4, [3], NULL, NULL, NULL)        = 1 (in [3])
ioctl(3, FIONREAD, [16])                = 0
read(3, "\1\0\0\0 \0\0@\0\0\0\0\0\0\0\0", 65536) = 16
fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f8fef0d3000
write(1, "/mnt/tmp/ OPEN,ISDIR \n", 22) = 22
select(4, [3], NULL, NULL, NULL)        = 1 (in [3])
ioctl(3, FIONREAD, [16])                = 0
read(3, "\1\0\0\0\20\0\0@\0\0\0\0\0\0\0\0", 65536) = 16
write(1, "/mnt/tmp/ CLOSE_NOWRITE,CLOSE,IS"..., 37) = 37
select(4, [3], NULL, NULL, NULL)        = ? ERESTARTNOHAND (To be restarted)
--- SIGINT (Interrupt) @ 0 (0) ---
+++ killed by SIGINT +++

We must be doing something different...  What kernel?  what kconfig?
What exact FS setup?  What exact steps are you taking?  What programs
are you using to test east side?  If you want to spam me with something
I added a whole lot of pr_debug statements throughout notification code
just in case it wasn't perfect (haha) so if you built with dynamic debug
you could run my debug script:

#!/bin/bash

echo "file fs/notify/inode_mark.c +p" > /sys/kernel/debug/dynamic_debug/control
echo "file fs/notify/mark.c +p" > /sys/kernel/debug/dynamic_debug/control
echo "file fs/notify/notification.c +p" > /sys/kernel/debug/dynamic_debug/control
echo "file fs/notify/fanotify/fanotify_user.c +p" > /sys/kernel/debug/dynamic_debug/control
echo "file fs/notify/fanotify/fanotify.c +p" > /sys/kernel/debug/dynamic_debug/control
echo "file fs/notify/vfsmount_mark.c +p" > /sys/kernel/debug/dynamic_debug/control
echo "file fs/notify/group.c +p" > /sys/kernel/debug/dynamic_debug/control
echo "file fs/notify/inotify/inotify_fsnotify.c +p" > /sys/kernel/debug/dynamic_debug/control
echo "file fs/notify/inotify/inotify_user.c +p" > /sys/kernel/debug/dynamic_debug/control
echo "file fs/notify/dnotify/dnotify.c +p" > /sys/kernel/debug/dynamic_debug/control
echo "file fs/notify/fsnotify.c +p" > /sys/kernel/debug/dynamic_debug/control

reproduce and send me the dmesg results.  Maybe I can glean something
out of it....

-Eric

