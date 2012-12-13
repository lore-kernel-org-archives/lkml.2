Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab2LMTYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 14:24:10 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40823 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab2LMTYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 14:24:08 -0500
Message-ID: <50CA2B55.5070402@amacapital.net>
Date: Thu, 13 Dec 2012 11:24:05 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] user namespace and namespace infrastructure changes
 for 3.8
References: <87ip88uw4n.fsf@xmission.com>
In-Reply-To: <87ip88uw4n.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 01:17 PM, Eric W. Biederman wrote:
> 
> Linus,
> 
> Please pull the for-linus git tree from:
> 
>    git://git.kernel.org:/pub/scm/linux/kernel/git/ebiederm/user-namespace.git for-linus
> 
>    HEAD: 98f842e675f96ffac96e6c50315790912b2812be proc: Usable inode numbers for the namespace file descriptors.
> 
>    This tree is against v3.7-rc3

You've just allowed unprivileged users to create new pid namespaces,
etc, by creating a new userns, then creating a new pid namespace inside
that userns, then setns-ing from outside the userns into the pid ns.  Is
this intentional?  (The mount ns is okay -- it checks for CAP_CHROOT on
setns.)


In user_namespace.c:

        /* Threaded many not enter a different user namespace */
        if (atomic_read(&current->mm->mm_users) > 1)
                return -EINVAL;

The comment has a typo.  Also, you're checking the wrong condition:
that's whether the vm is shared, not whether the thread group has more
than one member.

In any case, why are threads special here?



I think, although I haven't verified it, that these changes allow
CAP_SYS_ADMIN to bypass the bounding set (and, in particular, to gain
CAP_MODULE): unshare the user namespace and then setfd yourself back.  I
think that setns should only grant caps when changing to a descendent
namespace.

Also in userns_install:

796         /* Don't allow gaining capabilities by reentering
797          * the same user namespace.
798          */
799         if (user_ns == current_user_ns())
800                 return -EINVAL;

Why?  You can trivially bypass this by creating a temporary user ns.
(If you're the owner of your own ns, then you can create a subsidiary
ns, map yourself into it, then setns back -- you'll still be the owner.)


unshare has a bug.  This code:

#define _GNU_SOURCE

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <signal.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/prctl.h>
#include <sys/mman.h>
#include <sched.h>
#include <fcntl.h>

static void fail(const char *msg)
{
  perror(msg);
  exit(1);
}

int main()
{
  if (unshare(CLONE_NEWUSER) != 0)
    fail("CLONE_NEWUSER");

  if (open("/proc/self/uid_map", O_RDWR) == -1)
    perror("/proc/self/uid_map O_RDWR");

  int fd = open("/proc/self/uid_map", O_RDONLY);
  if (fd == -1) {
    perror("/proc/self/uid_map O_RDONLY");
  } else {
    char buf[4096];
    ssize_t len = read(fd, buf, sizeof(buf));
    if (len > 0)
      write(1, buf, len);
    else
      printf("read uid_map returned %d\n", (int)len);
  }
}

produces this output:

/proc/self/uid_map O_RDWR: Permission denied
read uid_map returned 0

With clone instead of unshare, it works.  I'm not quite sure what's
going on.



Also, I'm entirely unconvinced that the owner of a userns should
automatically have all caps (in the cap_capable sense) on a userns if
the task is inside that ns.  What's wrong with just using normal caps?
(Of course, the fact that caps don't usefully inherit is an issue --
there's a loooong thread going on right now about that.)  But doing this
enshrines root-has-caps even farther into ABI.  At least please make
this depend on !SECURE_NOROOT.


> 
> While small this set of changes is very significant with respect to
> containers in general and user namespaces in particular.  The user space
> interface is now complete.
> 
> This set of changes adds support for unprivileged users to create user
> namespaces and as a user namespace root to create other namespaces.  The
> tyrrany of supporting suid root preventing unprivileged users from using
> cool new kernel features is broken.
> 

no_new_privs already (kind of) did that :)

--Andy
