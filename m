Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab2JIOH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 10:07:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38505 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab2JIOHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 10:07:22 -0400
MIME-Version: 1.0
In-Reply-To: <20121008220532.GD15039@rhmail.home.annexia.org>
References: <20121008171517.GA15039@rhmail.home.annexia.org>
	<20121008172103.GB15039@rhmail.home.annexia.org>
	<87a9vwrgtl.fsf@rho.meyering.net>
	<20121008215030.GI24071@rhmail.home.annexia.org>
	<20121008215325.GC15039@rhmail.home.annexia.org>
	<20121008220532.GD15039@rhmail.home.annexia.org>
Date: Tue, 9 Oct 2012 22:07:22 +0800
Message-ID: <CAM_iQpV+4QfUBec7ixA6Yk43dafsYtX=KpSkmOjOKzkvtyAywg@mail.gmail.com>
Subject: Re: F_DUPFD_CLOEXEC broken in 3.7.0
From: Cong Wang <xiyou.wangcong@gmail.com>
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: Jim Meyering <jim@meyering.net>, eblake@redhat.com,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 6:05 AM, Richard W.M. Jones <rjones@redhat.com> wrote:
> Let's move this to LKML ...
>
> On Mon, Oct 08, 2012 at 10:53:25PM +0100, Richard W.M. Jones wrote:
>> On Mon, Oct 08, 2012 at 10:50:30PM +0100, Richard W.M. Jones wrote:
>> [.. discussion on gnulib test-cloexec test snipped ..]
>> > I'm suspicious this is a kernel bug:
>> >
>> > creat("test-cloexec.tmp", 0600)         = 3
>> > fcntl(3, F_GETFD)                       = 0
>> > fcntl(3, F_GETFD)                       = 0
>> > fcntl(3, F_SETFD, FD_CLOEXEC)           = 0
>> > fcntl(3, F_GETFD)                       = 0x1 (flags FD_CLOEXEC)
>> > fcntl(3, F_GETFD)                       = 0x1 (flags FD_CLOEXEC)
>> > fcntl(3, F_SETFD, 0)                    = 0
>> > fcntl(3, F_GETFD)                       = 0
>> > fcntl(3, F_DUPFD_CLOEXEC, 0)            = 4
>> > fcntl(4, F_GETFD)                       = 0
>> > write(2, "test-cloexec.c:97: assertion failed\n", 36) = 36
>> >
>> > It seems to me from the description in the man page that
>> > F_DUPFD_CLOEXEC ought to be setting the FD_CLOEXEC flag on file
>> > descriptor 4, so either it's not or else F_GETFD isn't reading the
>> > flag for some reason.
>>
>> Al Viro (CC'd) made some changes in this area recently ..
>
> Attached is a self-contained test program that demonstrates the bug.
>

Seems we passed a wrong flag to f_dupfd()...
Does the following patch help?

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 8f70429..71a600a 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -258,7 +258,7 @@ static long do_fcntl(int fd, unsigned int cmd,
unsigned long arg,
                err = f_dupfd(arg, filp, 0);
                break;
        case F_DUPFD_CLOEXEC:
-               err = f_dupfd(arg, filp, FD_CLOEXEC);
+               err = f_dupfd(arg, filp, O_CLOEXEC);
                break;
        case F_GETFD:
                err = get_close_on_exec(fd) ? FD_CLOEXEC : 0;
