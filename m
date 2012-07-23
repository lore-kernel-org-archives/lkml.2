Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab2GWBxD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:53:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54340 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753437Ab2GWBnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:18 -0400
Message-Id: <20120723010700.272854370@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:49 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anders Kaseorg <andersk@MIT.EDU>,
        Anders Kaseorg <andersk@MIT.EDU>, Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 058/108] fifo: Do not restart open() if it already found a partner
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anders Kaseorg <andersk@MIT.EDU>

commit 05d290d66be6ef77a0b962ebecf01911bd984a78 upstream.

If a parent and child process open the two ends of a fifo, and the
child immediately exits, the parent may receive a SIGCHLD before its
open() returns.  In that case, we need to make sure that open() will
return successfully after the SIGCHLD handler returns, instead of
throwing EINTR or being restarted.  Otherwise, the restarted open()
would incorrectly wait for a second partner on the other end.

The following test demonstrates the EINTR that was wrongly thrown from
the parent’s open().  Change .sa_flags = 0 to .sa_flags = SA_RESTART
to see a deadlock instead, in which the restarted open() waits for a
second reader that will never come.  (On my systems, this happens
pretty reliably within about 5 to 500 iterations.  Others report that
it manages to loop ~forever sometimes; YMMV.)

  #include <sys/stat.h>
  #include <sys/types.h>
  #include <sys/wait.h>
  #include <fcntl.h>
  #include <signal.h>
  #include <stdio.h>
  #include <stdlib.h>
  #include <unistd.h>

  #define CHECK(x) do if ((x) == -1) {perror(#x); abort();} while(0)

  void handler(int signum) {}

  int main()
  {
      struct sigaction act = {.sa_handler = handler, .sa_flags = 0};
      CHECK(sigaction(SIGCHLD, &act, NULL));
      CHECK(mknod("fifo", S_IFIFO | S_IRWXU, 0));
      for (;;) {
          int fd;
          pid_t pid;
          putc('.', stderr);
          CHECK(pid = fork());
          if (pid == 0) {
              CHECK(fd = open("fifo", O_RDONLY));
              _exit(0);
          }
          CHECK(fd = open("fifo", O_WRONLY));
          CHECK(close(fd));
          CHECK(waitpid(pid, NULL, 0));
      }
  }

This is what I suspect was causing the Git test suite to fail in
t9010-svn-fe.sh:

	http://bugs.debian.org/678852

Signed-off-by: Anders Kaseorg <andersk@mit.edu>
Reviewed-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/fifo.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/fifo.c b/fs/fifo.c
index b1a524d..cf6f434 100644
--- a/fs/fifo.c
+++ b/fs/fifo.c
@@ -14,7 +14,7 @@
 #include <linux/sched.h>
 #include <linux/pipe_fs_i.h>
 
-static void wait_for_partner(struct inode* inode, unsigned int *cnt)
+static int wait_for_partner(struct inode* inode, unsigned int *cnt)
 {
 	int cur = *cnt;	
 
@@ -23,6 +23,7 @@ static void wait_for_partner(struct inode* inode, unsigned int *cnt)
 		if (signal_pending(current))
 			break;
 	}
+	return cur == *cnt ? -ERESTARTSYS : 0;
 }
 
 static void wake_up_partner(struct inode* inode)
@@ -67,8 +68,7 @@ static int fifo_open(struct inode *inode, struct file *filp)
 				 * seen a writer */
 				filp->f_version = pipe->w_counter;
 			} else {
-				wait_for_partner(inode, &pipe->w_counter);
-				if(signal_pending(current))
+				if (wait_for_partner(inode, &pipe->w_counter))
 					goto err_rd;
 			}
 		}
@@ -90,8 +90,7 @@ static int fifo_open(struct inode *inode, struct file *filp)
 			wake_up_partner(inode);
 
 		if (!pipe->readers) {
-			wait_for_partner(inode, &pipe->r_counter);
-			if (signal_pending(current))
+			if (wait_for_partner(inode, &pipe->r_counter))
 				goto err_wr;
 		}
 		break;


