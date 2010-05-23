Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab0EWXtJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 19:49:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306Ab0EWXtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 19:49:07 -0400
Subject: Re: [2.6.34-git8][regression] massive polling problems with udevd
 and  other processes
From: Eric Paris <eparis@redhat.com>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Cc: Eric Paris <eparis@parisplace.org>, Al Viro <viro@zeniv.linux.org.uk>,
       walt <w41ter@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTimnJ2FJtvVJxRHHEr99td7aNCpdpQT9F461Z3IU@mail.gmail.com>
References: <201005221535.38939.shawn.starr@rogers.com>
	 <4BF83CBF.8080300@gmail.com> <20100522204426.GO31073@ZenIV.linux.org.uk>
	 <AANLkTimffWnIjHIEW54AoVxiALEoFkJZJJ7u57ZChDuy@mail.gmail.com>
	 <1274570731.2810.45.camel@localhost>
	 <AANLkTimnJ2FJtvVJxRHHEr99td7aNCpdpQT9F461Z3IU@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 May 2010 19:49:01 -0400
Message-ID: <1274658541.2810.58.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-05-23 at 22:20 +0200, Alessandro Suardi wrote:
> On Sun, May 23, 2010 at 1:25 AM, Eric Paris <eparis@redhat.com> wrote:

> > I'm feeling like this is a udev bug, but the only fix is going to be to
> > revert and paper over anything else that has problems with
> > (mode & S_IFMNT) == 0
> >
> > -Eric

> [root@duff ~]# cat udevd.proc.pid.fd.out
> lr-x------. 1 root root 64 2010-05-23 22:15 6 -> anon_inode:inotify
> lrwx------. 1 root root 64 2010-05-23 22:15 7 -> anon_inode:[signalfd]

> [root@duff ~]# head -30 udevd.strace.log
> Process 1734 attached - interrupt to quit
> poll([{fd=4, events=POLLIN}, {fd=5, events=POLLIN}, {fd=6, events=POLLIN}, {fd=7, events=POLLIN}, {fd=8, events=POLLIN}], 5, 3000) = 1 ([{fd=6, revents=POLLIN}])
> ioctl(6, FIONREAD, [0])                 = 0

Well at least I see what is wrong.  Before the change ioctl(FIONREAD)
would go down this code path:

sys_ioctl()
  do_vfs_ioctl()
    vfs_ioctl()
      filp->f_ops->ioctl()
        inotify_ioctl()
          returns the answer.

After the change we instead get:

sys_ioctl()
  do_vfs_ioctl()
    file_ioctl()
      which would return put_user(i_size_read(inode) - filp->f_pos, p)

If there is no rule that all inodes must be of a known S_IFMNT then I
guess the best fix is to just revert and I'll fix up the symptoms.  If
there is such an unwritten rule (which seems perfectly reasonable) we
can either special case the anon_inode to push FIONREAD down to
vfs_ioctl or move FIONREAD down to vfs_ioctl and force everyone else to
implement it.

Al?  Maybe you have better ideas?

-Eric

