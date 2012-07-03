Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab2GCCq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 22:46:59 -0400
Received: from tundra.namei.org ([65.99.196.166]:45195 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab2GCCq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 22:46:58 -0400
Date: Tue, 3 Jul 2012 12:46:54 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [GIT][v3.5] Document no_new_privs
Message-ID: <alpine.LRH.2.02.1207031244210.28166@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull -- this documents a new 3.5 feature.

The following changes since commit ca24a145573124732152daff105ba68cc9a2b545:
  Linus Torvalds (1):
        Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Andy Lutomirski (1):
      security: document no_new_privs

 Documentation/prctl/no_new_privs.txt |   50 ++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 Documentation/prctl/no_new_privs.txt


commit 09b243577be319ef55310b45c65737008f3ebf12
Author: Andy Lutomirski <luto@amacapital.net>
Date:   Mon Jul 2 14:03:58 2012 -0700

    security: document no_new_privs
    
    Document no_new_privs.
    
    Signed-off-by: Andy Lutomirski <luto@amacapital.net>
    Acked-by: Kees Cook <keescook@chromium.org>
    Signed-off-by: James Morris <james.l.morris@oracle.com>

diff --git a/Documentation/prctl/no_new_privs.txt b/Documentation/prctl/no_new_privs.txt
new file mode 100644
index 0000000..cb705ec
--- /dev/null
+++ b/Documentation/prctl/no_new_privs.txt
@@ -0,0 +1,50 @@
+The execve system call can grant a newly-started program privileges that
+its parent did not have.  The most obvious examples are setuid/setgid
+programs and file capabilities.  To prevent the parent program from
+gaining these privileges as well, the kernel and user code must be
+careful to prevent the parent from doing anything that could subvert the
+child.  For example:
+
+ - The dynamic loader handles LD_* environment variables differently if
+   a program is setuid.
+
+ - chroot is disallowed to unprivileged processes, since it would allow
+   /etc/passwd to be replaced from the point of view of a process that
+   inherited chroot.
+
+ - The exec code has special handling for ptrace.
+
+These are all ad-hoc fixes.  The no_new_privs bit (since Linux 3.5) is a
+new, generic mechanism to make it safe for a process to modify its
+execution environment in a manner that persists across execve.  Any task
+can set no_new_privs.  Once the bit is set, it is inherited across fork,
+clone, and execve and cannot be unset.  With no_new_privs set, execve
+promises not to grant the privilege to do anything that could not have
+been done without the execve call.  For example, the setuid and setgid
+bits will no longer change the uid or gid; file capabilities will not
+add to the permitted set, and LSMs will not relax constraints after
+execve.
+
+Note that no_new_privs does not prevent privilege changes that do not
+involve execve.  An appropriately privileged task can still call
+setuid(2) and receive SCM_RIGHTS datagrams.
+
+There are two main use cases for no_new_privs so far:
+
+ - Filters installed for the seccomp mode 2 sandbox persist across
+   execve and can change the behavior of newly-executed programs.
+   Unprivileged users are therefore only allowed to install such filters
+   if no_new_privs is set.
+
+ - By itself, no_new_privs can be used to reduce the attack surface
+   available to an unprivileged user.  If everything running with a
+   given uid has no_new_privs set, then that uid will be unable to
+   escalate its privileges by directly attacking setuid, setgid, and
+   fcap-using binaries; it will need to compromise something without the
+   no_new_privs bit set first.
+
+In the future, other potentially dangerous kernel features could become
+available to unprivileged tasks if no_new_privs is set.  In principle,
+several options to unshare(2) and clone(2) would be safe when
+no_new_privs is set, and no_new_privs + chroot is considerable less
+dangerous than chroot by itself.
