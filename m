Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab2GRARn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:17:43 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59612 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757820Ab2GRAMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:12:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anders Kaseorg <andersk@mit.edu>, Jonathan Nieder <jrnieder@gmail.com>
Subject: =?UTF-8?q?=5B=2007/23=5D=20fifo=3A=20Do=20not=20restart=20open=28=29=20if=20it=20already=20found=20a=20partner?=
Date: Tue, 17 Jul 2012 17:12:00 -0700
Message-Id: <20120717232329.807736291@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232329.276003806@linuxfoundation.org>
References: <20120717232455.GA5994@kroah.com>
 <20120717232329.276003806@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fifo.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/fifo.c
+++ b/fs/fifo.c
@@ -14,7 +14,7 @@
 #include <linux/sched.h>
 #include <linux/pipe_fs_i.h>
 
-static void wait_for_partner(struct inode* inode, unsigned int *cnt)
+static int wait_for_partner(struct inode* inode, unsigned int *cnt)
 {
 	int cur = *cnt;	
 
@@ -23,6 +23,7 @@ static void wait_for_partner(struct inod
 		if (signal_pending(current))
 			break;
 	}
+	return cur == *cnt ? -ERESTARTSYS : 0;
 }
 
 static void wake_up_partner(struct inode* inode)
@@ -67,8 +68,7 @@ static int fifo_open(struct inode *inode
 				 * seen a writer */
 				filp->f_version = pipe->w_counter;
 			} else {
-				wait_for_partner(inode, &pipe->w_counter);
-				if(signal_pending(current))
+				if (wait_for_partner(inode, &pipe->w_counter))
 					goto err_rd;
 			}
 		}
@@ -90,8 +90,7 @@ static int fifo_open(struct inode *inode
 			wake_up_partner(inode);
 
 		if (!pipe->readers) {
-			wait_for_partner(inode, &pipe->r_counter);
-			if (signal_pending(current))
+			if (wait_for_partner(inode, &pipe->r_counter))
 				goto err_wr;
 		}
 		break;


