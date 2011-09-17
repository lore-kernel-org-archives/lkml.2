Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab1IQASM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 20:18:12 -0400
Received: from mx1.pyrox.eu ([188.40.139.189]:51561 "EHLO mx1.pyrox.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab1IQASL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 20:18:11 -0400
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Sep 2011 20:18:11 EDT
Date: Sat, 17 Sep 2011 02:12:15 +0200
From: John Feuerstein <john@feurix.com>
To: linux-kernel@vger.kernel.org
Cc: linux-audit@redhat.com
Subject: linux-audit: reconstruct path names from syscall events?
Message-ID: <20110917001215.GA961@zombie.hq.fstein.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to audit all changes to a directory tree using the linux
auditing system[1].

# auditctl -a exit,always -F dir=/etc/ -F perm=wa

It seems like the GNU coreutils are enough to break the audit trail.

The resulting SYSCALL events provide CWD and multiple PATH records,
depending on the syscall. If one of the PATH records is relative, I can
reconstruct the absolute path using the CWD record.

However, that does not work for the whole *at syscall family
(unlinkat(2), renameat(2), linkat(2), ...); accepting paths relative to
a given directory file descriptor. GNU coreutils are prominent users,
for example "rm -r" making use of unlinkat(2) to prevent races.

Things like dup(2) and fd passing via unix domain sockets come to mind.
It's the same old story again: mapping fds to path names is ambiguous at
best, if not impossible.

I wonder why such incomplete file system auditing rules are considered
sufficient in the CAPP/LSPP/NISPOM/STIG rulesets?

Here's a simplified example:

$ cd /tmp
$ mkdir dir
$ touch dir/file
$ ls -ldi /tmp /tmp/dir /tmp/dir/file
 2057 drwxrwxrwt 9 root root 380 Sep 17 00:02 /tmp
58781 drwxr-xr-x 2 john john  40 Sep 17 00:02 /tmp/dir
56228 -rw-r--r-- 1 john john   0 Sep 17 00:02 /tmp/dir/file
$ cat > unlinkat.c
#include <unistd.h>
#include <fcntl.h>

int main(int argc, char **argv)
{
    int dirfd = open("dir", O_RDONLY);
    unlinkat(dirfd, "file", 0);
    return 0;
}
^D
$ make unlinkat
cc     unlinkat.c   -o unlinkat
$ sudo autrace ./unlinkat
Waiting to execute: ./unlinkat
Cleaning up...
Trace complete. You can locate the records with 'ausearch -i -p 32121'
$ ls -li dir
total 0

Now, looking at the resulting raw SYSCALL event for unlinkat(2):

type=SYSCALL msg=audit(1316210542.899:779): arch=c000003e syscall=263 success=yes exit=0 a0=3 a1=400690 a2=0 a3=0 items=2 ppid=32106 pid=32121 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts12 ses=36 comm="unlinkat" exe="/tmp/unlinkat" key=(null)
type=CWD msg=audit(1316210542.899:779):  cwd="/tmp"
type=PATH msg=audit(1316210542.899:779): item=0 name="/tmp" inode=58781 dev=00:0e mode=040755 ouid=1000 ogid=1000 rdev=00:00
type=PATH msg=audit(1316210542.899:779): item=1 name="file" inode=56228 dev=00:0e mode=0100644 ouid=1000 ogid=1000 rdev=00:00
type=EOE msg=audit(1316210542.899:779): 

- From this event alone, there's no way to answer "Who unlinked
  /tmp/dir/file?". For what it's worth, the provided path names would be
  exactly the same if we had unlinked "/tmp/dir/dir/dir/dir/dir/file".

- PATH item 0 reports the inode of "/tmp/dir" (58781, see ls output
  above), however, the reported path name is "/tmp" (bug?).

In this example I've used autrace, which traces everything, so I could
possibly search for a previous open(2) of inode 58781. And indeed, there
it is:

type=SYSCALL msg=audit(1316210542.899:778): arch=c000003e syscall=2 success=yes exit=3 a0=40068c a1=0 a2=7fff22724fc8 a3=0 items=1 ppid=32106 pid=32121 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts12 ses=36 comm="unlinkat" exe="/tmp/unlinkat" key=(null)
type=CWD msg=audit(1316210542.899:778):  cwd="/tmp"
type=PATH msg=audit(1316210542.899:778): item=0 name="dir" inode=58781 dev=00:0e mode=040755 ouid=1000 ogid=1000 rdev=00:00
type=EOE msg=audit(1316210542.899:778): 

Great, so inode 58781 was opened using "/tmp/dir", and therefore, the relative
path "file" given to unlinkat(2) above could possibly translate to
"/tmp/dir/path"... not really feeling confident here.

- All file system auditing rules in various rulesets and the examples in
  the documentation add the "-F perm=wa" (or similar) filter, so the
  open(2) wouldn't even make it into the audit trail.

- If you can handle the volume and log all open(2), what happens if the
  open(2) was done hours, days, weeks, ... ago?

- What if the open(2) was done by another process which passed the fd
  on a unix domain socket?

It looks like the kernel auditing code should provide

    ... item=0 name="/tmp/dir" inode=58781 ...

in the unlinkat(2) syscall event above. Looking up the unlinkat(2)
documentation:

    int unlinkat(int dirfd, const char *pathname, int flags);

    If the pathname given in pathname is relative, then it is
    interpreted relative to the directory referred to by the file
    descriptor dirfd (rather than relative to the current working
    directory of the calling process, as is done by unlink(2) and
    rmdir(2) for a relative pathname).

    If the pathname given in pathname is relative and dirfd is the
    special value AT_FDCWD,  then  pathname  is  interpreted relative
    to the current working directory of the calling process (like
    unlink(2) and rmdir(2)).

As you might see, there's not only the fd->pathname problem, but
also the special case for AT_FDCWD. In this case the kernel side should
probably just duplicate CWD's path name into item 0's path name. But
that's just unlinkat(2), there are a lot more.

What am I missing here? Is there no way to audit a directory tree?
I've looked at alternatives: Inotify watches won't scale to big trees
and events lack so much detail that they can't be used for auditing.
Fanotify, while providing the pid, still lacks a lot of events and
passes fds; the example code relies on readlink("/proc/self/fd/...").

Thanks,
John

[1] http://people.redhat.com/sgrubb/audit/

-- 
John Feuerstein <john@feurix.com>
