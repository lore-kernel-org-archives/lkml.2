Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761734Ab2J3BMz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 21:12:55 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38947 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761636Ab2J3BMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 21:12:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAOH1cHmYJmwJX8GsPthiKnF8T+dBi_ozBMD44HTWd0rTY4Nt7A@mail.gmail.com>
References: <20110917001215.GA961@zombie.hq.fstein.net>
	<20121009235446.GZ2616@ZenIV.linux.org.uk>
	<CAOH1cHkowcv6k0D2bkXFcjU3k4UtG2WX3nSwNa267qmODNfs_w@mail.gmail.com>
	<4547273.ji5OMfINXo@x2>
	<CAOH1cHm_+ujK6_WAk4Ec6Y9BhhzL6s9UwaJjUJ91CKRXg--Edw@mail.gmail.com>
	<CAOH1cHmYJmwJX8GsPthiKnF8T+dBi_ozBMD44HTWd0rTY4Nt7A@mail.gmail.com>
Date: Mon, 29 Oct 2012 18:12:53 -0700
Message-ID: <CAOH1cHnPpdJYUkM0090SeZKfXCE6sZnC6CBN_oapwocAki27fg@mail.gmail.com>
Subject: Re: linux-audit: reconstruct path names from syscall events?
From: Mark Moseley <moseleymark@gmail.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 10:27 AM, Mark Moseley <moseleymark@gmail.com> wrote:
> On Wed, Oct 10, 2012 at 4:07 PM, Mark Moseley <moseleymark@gmail.com> wrote:
>> On Wed, Oct 10, 2012 at 4:00 PM, Steve Grubb <sgrubb@redhat.com> wrote:
>>> On Wednesday, October 10, 2012 03:45:08 PM Mark Moseley wrote:
>>>> On Tue, Oct 9, 2012 at 4:54 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>>> > Again, relying on pathnames for forensics (or security in general) is
>>>> > a serious mistake (cue unprintable comments about apparmor and similar
>>>> > varieties of snake oil).  And using audit as poor man's ktrace analog
>>>> > is... misguided, to put it very mildly.
>>>>
>>>> Caveat: I'm just a sysadmin, so this stuff is as darn near "magic" as
>>>> I get to see on a regular basis, so it's safe to expect some naivety
>>>> and/or misguidedness on my part :)
>>>>
>>>> I'm just using it as a log of files that have been written/changed on
>>>> moderately- to heavily-used systems. If there's another in-kernel
>>>> mechanism that'd be better suited for that sort of thing (at least
>>>> without adding a lot of overhead), I'd be definitely eager to know
>>>> about it. It's a web hosting environment, with customer files all
>>>> solely on NFS, so writes to the same directory can come from an
>>>> arbitrary number of servers. When they get swamped with write
>>>> requests, the amount of per-client stats exposed by our Netapp and
>>>> Oracle NFS servers is often only enough to point us at a client server
>>>> with an abusive user on it (but not much more, without turning on
>>>> debugging). Having logs of who's doing writes would be quite useful,
>>>> esp when writes aren't happening at that exact moment and wouldn't
>>>> show up in tools like iotop. The audit subsystem seemed like the best
>>>> fit for this kind of thing, but I'm more than open to whatever works.
>>>
>>> The audit system is the best fit. But I think Al is saying there are some
>>> limitations. i know that Eric pushed some patches a while back that makes a
>>> stronger effort at collecting some of this information. What kernel are you
>>> using?

Would you happen to have a pointer to those patches? I've been surfing
the archives and not gotten lucky yet with finding the applicable
patchset.


>> Yup, understood. I've been playing with a variety of boxes, but mostly
>> within the 3.0.x and 3.2.x series. I'll drop 3.5.6 on some of these
>> boxes and see if my issues are already fixed (and proceed directly to
>> foot-in-mouth chagrined stage -- usually takes slightly longer to get
>> to that stage).
>
> Just gave 3.5.6 a shot and in these two particular cases, the result
> is the same: chroot'd actions are logged in the audit entry relative
> to the chroot, and the unlinkat/chmodat/chownat audit log entries only
> have one item with the bare filename and no indication of directory.

renameat seems to be the toughest of all of them (where
unlinkat/chmodat/chownat give you a hint in another audit entry). This
is doing a renameat(), from /home/moseley/tmp/tmp/renameat/1/a1 to
/home/moseley/tmp/tmp/renameat/2/a2

type=SYSCALL msg=audit(1351557710.520:74211): arch=c000003e
syscall=264 success=yes exit=0 a0=3 a1=40075c a2=4 a3=400759 items=4
ppid=22742 pid=15181 auid=0 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0
sgid=0 fsgid=0 tty=pts17 ses=1727 comm="rename" exe="/tmp/rename"
key=(null)
type=CWD msg=audit(1351557710.520:74211):  cwd="/tmp"
type=PATH msg=audit(1351557710.520:74211): item=0 name="/tmp"
inode=2367550 dev=08:02 mode=040775 ouid=1000 ogid=1000 rdev=00:00
type=PATH msg=audit(1351557710.520:74211): item=1 name="/tmp"
inode=2367551 dev=08:02 mode=040775 ouid=1000 ogid=1000 rdev=00:00
type=PATH msg=audit(1351557710.520:74211): item=2 name="a1"
inode=2367552 dev=08:02 mode=0100664 ouid=1000 ogid=1000 rdev=00:00
type=PATH msg=audit(1351557710.520:74211): item=3 name="a2"
inode=2367552 dev=08:02 mode=0100664 ouid=1000 ogid=1000 rdev=00:00

Anything else I could/should be trying? I'm more than willing to
experiment. I just always assume I'm missing some key flag or
something.

Here's the simple example code ... and, yes, I *do* know how to use
variables, just didn't bother here ;)

#include <fcntl.h>
#include <stdio.h>
#include <sys/types.h>
#include <dirent.h>

int main() {
	DIR *a;
	DIR *b;

	char* dir1 = "/home/moseley/tmp/tmp/renameat/1";
	char* dir2 = "/home/moseley/tmp/tmp/renameat/2";

	a = opendir( dir1 );
	b = opendir( dir2 );

	int afd = dirfd( a );
	int bfd = dirfd( b );

	renameat( afd, "a1", bfd, "a2" );
}
