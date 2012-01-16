Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab2APAhg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 19:37:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48333 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2APAhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 19:37:34 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jamie Lokier <jamie@shareable.org>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
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
        alan@lxorguk.ukuu.org.uk, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 0/4] PR_SET_NO_NEW_PRIVS, unshare, and chroot
Date: Sun, 15 Jan 2012 16:37:17 -0800
Message-Id: <cover.1326673414.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make the no_new_privs discussion more concrete, here is an updated
series that is actually useful.  It adds PR_SET_NO_NEW_PRIVS with the
same semantics as before (plus John Johansen's AppArmor fix and with
improved bisectability).  It then allows some unshare flags and chroot
(sometimes) when no_new_privs is set.

The unprivileged chroot could be quite useful, even though it's rather
constrained for now.

I think that blocking setresuid, setuid, and capset in no_new_privs mode
will make this a little less useful.  Comments are welcome.

For the git-inclined, this series is here:
https://git.kernel.org/?p=linux/kernel/git/luto/linux.git;a=shortlog;h=refs/heads/security/no_new_privs/patch_v2

Test it like this:

---- begin test case

#include <sys/prctl.h>
#include <stdio.h>
#include <unistd.h>
#include <errno.h>

#define PR_SET_NO_NEW_PRIVS 35
#define PR_GET_NO_NEW_PRIVS 36

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

 fs/exec.c                  |   10 +++++++++-
 fs/open.c                  |   16 ++++++++++++++--
 include/linux/prctl.h      |   15 +++++++++++++++
 include/linux/sched.h      |    2 ++
 include/linux/security.h   |    1 +
 kernel/fork.c              |    2 ++
 kernel/nsproxy.c           |    8 +++++++-
 kernel/sys.c               |   10 ++++++++++
 security/apparmor/domain.c |   35 +++++++++++++++++++++++++++++++++++
 security/commoncap.c       |    7 +++++--
 security/selinux/hooks.c   |   10 +++++++++-
 11 files changed, 109 insertions(+), 7 deletions(-)

-- 
1.7.7.5

