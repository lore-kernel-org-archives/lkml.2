Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab2GOVOi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 17:14:38 -0400
Received: from DMZ-MAILSEC-SCANNER-4.MIT.EDU ([18.9.25.15]:54489 "EHLO
	dmz-mailsec-scanner-4.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865Ab2GOVO3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 17:14:29 -0400
X-AuditID: 1209190f-b7f306d0000008b4-05-500332b42b31
Date: Sun, 15 Jul 2012 17:14:25 -0400 (EDT)
From: Anders Kaseorg <andersk@MIT.EDU>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jonathan Nieder <jrnieder@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dash@vger.kernel.org
Subject: [PATCH v2] fifo: Do not restart open() if it already found a
 partner
In-Reply-To: <alpine.DEB.2.00.1206261656000.3236@dr-wily.mit.edu>
Message-ID: <alpine.DEB.2.00.1207151710190.3236@dr-wily.mit.edu>
References: <1340712298-4583-1-git-send-email-andersk@mit.edu> <20120626202009.GA382@burratino> <alpine.DEB.2.00.1206261656000.3236@dr-wily.mit.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsUixCmqrbvFiDnA4PxSTYu+/h2MFm9vLmG0
	2LP3JIvF5V1z2Cwe9b1ltzj/9zirA5vHzll32T1OzPjN4vF5k5zHpidvmQJYorhsUlJzMstS
	i/TtErgy2la9ZSt4K1Ux/chl1gbG+aJdjJwcEgImEosOHmaEsMUkLtxbz9bFyMUhJLCPUeLs
	pAUsEM4GRon5DbOhnD1MEiu3/WEDaWER0Ja4+vYDE4jNJqAmMXfDZHYQW0TASOLziyusIA3M
	AgcYJU7PX8YKkhAW8JdoXNLD3MXIwcEp4Chx5kkeSJhXwEHi6dJtjBALpjBKHNgxEewmUQFd
	ib2HzrBDFAlKnJz5hAXEZhZQlzjw6SIjhK0tcf9mG9sERsFZSMpmISmbhaRsASPzKkbZlNwq
	3dzEzJzi1GTd4uTEvLzUIl0TvdzMEr3UlNJNjODwl+TfwfjtoNIhRgEORiUeXiExpgAh1sSy
	4srcQ4ySHExKoryPVZgDhPiS8lMqMxKLM+KLSnNSiw8xSnAwK4nwuhsA5XhTEiurUovyYVLS
	HCxK4rxXU276CwmkJ5akZqemFqQWwWRlODiUJHh5gHEuJFiUmp5akZaZU4KQZuLgBBnOAzS8
	xRBkeHFBYm5xZjpE/hSjopQ472+QhABIIqM0D64Xlp5eMYoDvSLM+wOkigeY2uC6XwENZgIa
	bFnCBDK4JBEhJdXAmLPgwxxt8edVlYpGec9cdhXwBiTrn5dMqHa0YfnlXfcm7FOeyT6zC+lx
	uy2mzttVH31RW9ln4Ws/LXX3MwzbT71asmjpY45Q8W+q/h9zayfGPN/K5auo8G1B3Oue+q9J
	pn+fRZ9ODQ59kqlz2rQo+e7C8gnlTftMrx1Y57S04MDqU+HyTfwTlViKMxINtZiLihMBCM5x
	dCoDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
(Re-sending v2 to Linus with no changes.)

 fs/fifo.c | 9 ++++-----
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
-- 
1.7.11.1

