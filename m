Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab0HHT0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 15:26:16 -0400
Received: from smtpauth03.csee.onr.siteprotect.com ([64.26.60.137]:53043 "EHLO
	smtpauth03.csee.onr.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754622Ab0HHT0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 15:26:15 -0400
From: "Rob Donovan" <rob@proivrc.com>
To: <linux-kernel@vger.kernel.org>
Subject: FCNTL Performance problem
Date: Sun, 8 Aug 2010 20:26:13 +0100
Message-ID: <013501cb372f$912ce420$b386ac60$@proivrc.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Acs3L0J5OcgNaXT5TJGm1/zRz94GXQ==
Content-Language: en-gb
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020208.4C5F04D6.0061,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We use CISAM files  a lot in our application, which uses the FCNTL system
call for record locking.

I've noticed a possible problem in though with FCNTL, after a lot of work
using the systemtap tracing program.

The problem is, when you have lots of F_RDLCK locks being created and
released, then it slows down any F_WRLCK with F_SETLKW locks massively.

It's because the F_RDLCK seems to 'drown out' the write locks. Because our
system (it's a large system with 700-800 users, so lots of activity) does
lots more reads than writes, it causes the writes to be very slow. 

This is because (I think), if I have say 15 processes doing read locks, and
1 process doing write wait locks, then when the write tries to get a lock.
It can't, because process 1 has a read lock, so it. Then I think how it
works is that when the read lock gets released it then wakes up any other
locks waiting (i.e. the write), so that it can then try to lock. The problem
is that, if process 1 creates a read lock, then the write process tries to
get its lock and cant, so it sleeps, then process 2 gets a read lock (which
it can at this point) and then process 1 releases its lock, wakes up the
write process, but because process 2 got its read lock, the write process
still can't get its lock, so its sleeps again. This goes on for quite some
time, until eventually, the write process gets lucky and actually grabs a
lock.

(I think the write lock actually sits in the 'for' loop in
do_lock_file_wait() in fs/locks.c,  waiting for the lock to be freed)

Obviously, this slows down the write locks a lot.

I can show this by running some code (not the actual application code, just
a test example to show it happening a lot).

If you touch a file 'control.dat' in your current dir, and run test_read
(code example below) in the background with 15 sessions, and then run
test_write once. test_write will hardly ever gets a write lock (seen by
systemtap or strace) and will just wait. It's not that bad in our
application, but the writes slow down massively (to .03ms compared to .00003
normally, and sometimes 3-6 seconds for just 1 write lock).

Is there anything that can possibly be done in the kernel to help this, as I
would have thought this could cause problems with other people?

One possible solution would be that when the write lock tries to get a lock
and cant, its actually puts its lock in a queue of some kind, so that the
other reads that are about to start can see that, and they 'queue' and wait
for the write lock first.. I'm obviously not a kernel coder, so I have no
idea of the effects of something like that, hence this post. 

I've tried this on various versions, and it seems to be the same on, Fedora
2.6.33.6-147.2.4.fc13.i686, RHEL5 & RHEL6 Beta.

Thanks for any input or help,

Rob.

test_read.c:

#include <fcntl.h>

main()
{
  int myfd;
  char buffer[5000];
  struct flock myflock;

  myfd = open("control.dat",O_RDWR);

  while (1)
  {
    myflock.l_type = F_RDLCK;
    myflock.l_whence = SEEK_SET;
    myflock.l_start = 0;
    myflock.l_len = 1073741823;
    myflock.l_pid = getpid();

    fcntl(myfd, F_SETLKW, &myflock);

    lseek(myfd, 0, SEEK_SET);
    read(myfd, buffer, 200);

    myflock.l_type = F_UNLCK;
    fcntl(myfd, F_SETLKW, &myflock);
  }
}

test_write.c:

#include <fcntl.h>
#include <time.h>

main()
{
  struct timespec mytime;
  struct flock myflock;
  int myfd;
  char buffer[5000];

  myfd = open("control.dat",O_RDWR);

  while (1)
  {
    myflock.l_type = F_WRLCK;
    myflock.l_whence = SEEK_SET;
    myflock.l_start = 0;
    myflock.l_len = 1;
    myflock.l_pid = getpid();

    fcntl(myfd, F_SETLKW, &myflock);

    lseek(myfd, 0, SEEK_SET);
    read(myfd, buffer, 200);

    myflock.l_type = F_UNLCK;
    fcntl(myfd, F_SETLKW, &myflock);

    mytime.tv_sec = 0;
    mytime.tv_nsec = 10000;

    nanosleep(&mytime,NULL);
  }
}





