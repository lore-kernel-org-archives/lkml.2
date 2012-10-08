Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab2JHWFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 18:05:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977Ab2JHWFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:05:38 -0400
Date: Mon, 8 Oct 2012 23:05:32 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Jim Meyering <jim@meyering.net>, eblake@redhat.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: F_DUPFD_CLOEXEC broken in 3.7.0
Message-ID: <20121008220532.GD15039@rhmail.home.annexia.org>
References: <20121008171517.GA15039@rhmail.home.annexia.org>
 <20121008172103.GB15039@rhmail.home.annexia.org>
 <87a9vwrgtl.fsf@rho.meyering.net>
 <20121008215030.GI24071@rhmail.home.annexia.org>
 <20121008215325.GC15039@rhmail.home.annexia.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <20121008215325.GC15039@rhmail.home.annexia.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Let's move this to LKML ...

On Mon, Oct 08, 2012 at 10:53:25PM +0100, Richard W.M. Jones wrote:
> On Mon, Oct 08, 2012 at 10:50:30PM +0100, Richard W.M. Jones wrote:
> [.. discussion on gnulib test-cloexec test snipped ..]
> > I'm suspicious this is a kernel bug:
> > 
> > creat("test-cloexec.tmp", 0600)         = 3
> > fcntl(3, F_GETFD)                       = 0
> > fcntl(3, F_GETFD)                       = 0
> > fcntl(3, F_SETFD, FD_CLOEXEC)           = 0
> > fcntl(3, F_GETFD)                       = 0x1 (flags FD_CLOEXEC)
> > fcntl(3, F_GETFD)                       = 0x1 (flags FD_CLOEXEC)
> > fcntl(3, F_SETFD, 0)                    = 0
> > fcntl(3, F_GETFD)                       = 0
> > fcntl(3, F_DUPFD_CLOEXEC, 0)            = 4
> > fcntl(4, F_GETFD)                       = 0
> > write(2, "test-cloexec.c:97: assertion failed\n", 36) = 36
> > 
> > It seems to me from the description in the man page that
> > F_DUPFD_CLOEXEC ought to be setting the FD_CLOEXEC flag on file
> > descriptor 4, so either it's not or else F_GETFD isn't reading the
> > flag for some reason.
> 
> Al Viro (CC'd) made some changes in this area recently ..

Attached is a self-contained test program that demonstrates the bug.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
libguestfs lets you edit virtual machines.  Supports shell scripting,
bindings from many languages.  http://libguestfs.org

--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="cloexec.c"

/* Test if F_DUPFD_CLOEXEC works right.
 * by Richard W.M. Jones.
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <assert.h>

int
main ()
{
  char *file = "/tmp/cloexec.tmp";
  int fd = creat (file, 0600);
  int fd2;
  int flags;

  assert (fd >= 0);

  fd2 = fcntl (fd, F_DUPFD_CLOEXEC, 0);
  assert (fd2 >= 0);

  flags = fcntl (fd2, F_GETFD);
  assert (flags >= 0);

  if ((flags & FD_CLOEXEC) == 0) {
    fprintf (stderr, "F_DUPFD_CLOEXEC failed to set FD_CLOEXEC flag!\n");
    exit (EXIT_FAILURE);
  }

  exit (EXIT_SUCCESS);
}

--d6Gm4EdcadzBjdND--
