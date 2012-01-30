Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab2A3QSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:18:31 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55019 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2A3QS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:18:29 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com, corbet@lwn.net,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 0/4] PR_SET_NO_NEW_PRIVS, unshare, and chroot
Date: Mon, 30 Jan 2012 08:17:25 -0800
Message-Id: <cover.1327858005.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds PR_{GET,SET}_NO_NEW_PRIVS.  As an example of its use, it
allows some unshare operations and (sometimes) chroot when no_new_privs
is set.  Another example is the experimental pam module here:

http://web.mit.edu/luto/www/linux/

After some impressively long mailing list threads, I still think that
blocking setresuid, setuid, and capset in no_new_privs mode is
unnecessary and overcomplicated.  Additionally, blocking those calls
will make my pam module either fail or become a giant security hole
(depending on how carefully the core pam stuff is written -- I haven't
checked).

Changes from v2:
 - Rebased onto a very recent -linus tree.
 - Changed prctl numbering.  (Needed because prctl 35 is now taken.)
 - Fixed a typo or two.
 - Removed explicit propagation of no_new_privs.  dup_task_struct is enough.
 - Reworked the chroot patch.  It now uses hopefully much more sane logic
   to decide whether the user is chrooted.  It also checks that fs is not
   shared (which was a big security hole in the earlier version).

For the git-inclined, this series is here:
https://git.kernel.org/?p=linux/kernel/git/luto/linux.git;a=shortlog;h=refs/heads/security/no_new_privs/patch_v3

Test it like this:

---- begin test case

#include <sys/prctl.h>
#include <stdio.h>
#include <unistd.h>
#include <errno.h>

#define PR_SET_NO_NEW_PRIVS 36
#define PR_GET_NO_NEW_PRIVS 37

int main()
{
  int nnp = prctl(PR_GET_NO_NEW_PRIVS, 0, 0, 0, 0);
  if (nnp == -EINVAL) {
    printf("Failed!\n");
    return 1;
  }

  printf("nnp was %d\n", nnp);

  if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) != 0) {
    printf("Failed!\n");
    return 1;
  }

  nnp = prctl(PR_GET_NO_NEW_PRIVS, 0, 0, 0, 0);
  if (nnp == -EINVAL) {
    printf("Failed!\n");
    return 1;
  }

  printf("nnp is %d\n", nnp);

  printf("here goes...\n");
  execlp("bash", "bash", NULL);
  printf("Failed to exec bash\n");
  return 1;
}

---- end test case

Andy Lutomirski (3):
  Add PR_{GET,SET}_NO_NEW_PRIVS to prevent execve from granting privs
  Allow unprivileged CLONE_NEWUTS and CLONE_NEWIPC with no_new_privs
  Allow unprivileged chroot when safe

John Johansen (1):
  Fix apparmor for PR_{GET,SET}_NO_NEW_PRIVS

 fs/exec.c                  |   10 ++++++++-
 fs/open.c                  |   46 ++++++++++++++++++++++++++++++++++++++++++-
 include/linux/prctl.h      |   15 ++++++++++++++
 include/linux/sched.h      |    2 +
 include/linux/security.h   |    1 +
 kernel/nsproxy.c           |    8 ++++++-
 kernel/sys.c               |   10 +++++++++
 security/apparmor/domain.c |   35 +++++++++++++++++++++++++++++++++
 security/commoncap.c       |    7 ++++-
 security/selinux/hooks.c   |   10 ++++++++-
 10 files changed, 137 insertions(+), 7 deletions(-)

-- 
1.7.7.6

