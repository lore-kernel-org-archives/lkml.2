Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab2JIOLC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 10:11:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247Ab2JIOK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 10:10:59 -0400
Date: Tue, 9 Oct 2012 15:10:53 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jim Meyering <jim@meyering.net>, eblake@redhat.com,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: F_DUPFD_CLOEXEC broken in 3.7.0
Message-ID: <20121009141053.GO24071@rhmail.home.annexia.org>
References: <20121008171517.GA15039@rhmail.home.annexia.org>
 <20121008172103.GB15039@rhmail.home.annexia.org>
 <87a9vwrgtl.fsf@rho.meyering.net>
 <20121008215030.GI24071@rhmail.home.annexia.org>
 <20121008215325.GC15039@rhmail.home.annexia.org>
 <20121008220532.GD15039@rhmail.home.annexia.org>
 <CAM_iQpV+4QfUBec7ixA6Yk43dafsYtX=KpSkmOjOKzkvtyAywg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpV+4QfUBec7ixA6Yk43dafsYtX=KpSkmOjOKzkvtyAywg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 10:07:22PM +0800, Cong Wang wrote:
> On Tue, Oct 9, 2012 at 6:05 AM, Richard W.M. Jones <rjones@redhat.com> wrote:
> > Let's move this to LKML ...
> >
> > On Mon, Oct 08, 2012 at 10:53:25PM +0100, Richard W.M. Jones wrote:
> >> On Mon, Oct 08, 2012 at 10:50:30PM +0100, Richard W.M. Jones wrote:
> >> [.. discussion on gnulib test-cloexec test snipped ..]
> >> > I'm suspicious this is a kernel bug:
> >> >
> >> > creat("test-cloexec.tmp", 0600)         = 3
> >> > fcntl(3, F_GETFD)                       = 0
> >> > fcntl(3, F_GETFD)                       = 0
> >> > fcntl(3, F_SETFD, FD_CLOEXEC)           = 0
> >> > fcntl(3, F_GETFD)                       = 0x1 (flags FD_CLOEXEC)
> >> > fcntl(3, F_GETFD)                       = 0x1 (flags FD_CLOEXEC)
> >> > fcntl(3, F_SETFD, 0)                    = 0
> >> > fcntl(3, F_GETFD)                       = 0
> >> > fcntl(3, F_DUPFD_CLOEXEC, 0)            = 4
> >> > fcntl(4, F_GETFD)                       = 0
> >> > write(2, "test-cloexec.c:97: assertion failed\n", 36) = 36
> >> >
> >> > It seems to me from the description in the man page that
> >> > F_DUPFD_CLOEXEC ought to be setting the FD_CLOEXEC flag on file
> >> > descriptor 4, so either it's not or else F_GETFD isn't reading the
> >> > flag for some reason.
> >>
> >> Al Viro (CC'd) made some changes in this area recently ..
> >
> > Attached is a self-contained test program that demonstrates the bug.
> >
> 
> Seems we passed a wrong flag to f_dupfd()...
> Does the following patch help?
> 
> diff --git a/fs/fcntl.c b/fs/fcntl.c
> index 8f70429..71a600a 100644
> --- a/fs/fcntl.c
> +++ b/fs/fcntl.c
> @@ -258,7 +258,7 @@ static long do_fcntl(int fd, unsigned int cmd,
> unsigned long arg,
>                 err = f_dupfd(arg, filp, 0);
>                 break;
>         case F_DUPFD_CLOEXEC:
> -               err = f_dupfd(arg, filp, FD_CLOEXEC);
> +               err = f_dupfd(arg, filp, O_CLOEXEC);
>                 break;
>         case F_GETFD:
>                 err = get_close_on_exec(fd) ? FD_CLOEXEC : 0;

Yes ..  the same patch has already been sent upstream.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
New in Fedora 11: Fedora Windows cross-compiler. Compile Windows
programs, test, and build Windows installers. Over 70 libraries supprt'd
http://fedoraproject.org/wiki/MinGW http://www.annexia.org/fedora_mingw
