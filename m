Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab2FZVEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 17:04:10 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:61538 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753179Ab2FZVEJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 17:04:09 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jun 2012 17:04:08 EDT
X-AuditID: 12074424-b7f2a6d0000008bf-ce-4fea229b996c
Date: Tue, 26 Jun 2012 16:59:04 -0400 (EDT)
From: Anders Kaseorg <andersk@MIT.EDU>
To: Jonathan Nieder <jrnieder@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dash@vger.kernel.org
Subject: [PATCH v2] fifo: Do not restart open() if it already found a
 partner
In-Reply-To: <20120626202009.GA382@burratino>
Message-ID: <alpine.DEB.2.00.1206261656000.3236@dr-wily.mit.edu>
References: <1340712298-4583-1-git-send-email-andersk@mit.edu> <20120626202009.GA382@burratino>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42IRYrdT152t9MrfoPeNhEVf/w5Gi7c3lzBa
	7Nl7ksXi8q45bBbn/x5ndWD12DnrLrvH501yHpuevGUKYI7isklJzcksSy3St0vgytjyYSZT
	wUyZio6X89kaGNeLdTFyckgImEjc+nCDBcIWk7hwbz1bFyMXh5DAPkaJuZ1bmCCcDYwS27Yt
	ZoFw9jBJ7Pu8GayFRUBb4s2DJ0wgNpuAmsTcDZPZQWwRgWiJE19vMoLYzAJxEv9WtoLZwgL+
	Eo1LephBbE4BXYll3RvB6nkFHCQWtXSCxYUE4iW6v08HmykKVLP30BmoGkGJkzOfsEDMVJc4
	8Oki1Hxtifs329gmMArOQlI2C0nZLCRlCxiZVzHKpuRW6eYmZuYUpybrFicn5uWlFuma6+Vm
	luilppRuYgQHuovKDsbmQ0qHGAU4GJV4eCNYXvkLsSaWFVfmHmKU5GBSEuWdowgU4kvKT6nM
	SCzOiC8qzUktPsQowcGsJMK7Uh4ox5uSWFmVWpQPk5LmYFES572ectNfSCA9sSQ1OzW1ILUI
	JivDwaEkwXsDZKhgUWp6akVaZk4JQpqJgxNkOA/Q8MkgNbzFBYm5xZnpEPlTjIpS4rzrQBIC
	IImM0jy4XlgiesUoDvSKMO8FkCoeYBKD634FNJgJaDDHphcgg0sSEVJSDYw8G/pMuPaUhamv
	OVNna3Bd70HcvgNz/K584Vov73WxtUHIbWUG8+rYyvbI8NT3PmyqlwTXyB3f03ScJym/gMuA
	M95Abkoso2Al6+rCGLXOqbNksjbFHPi1b+uzDLeao3fE+jdf2ZRqHXiny8rqz7121fjJhQ48
	oTt291S8k+0tia+aVLiwTomlOCPRUIu5qDgRAIVZxEIfAwAA
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
---
Changes from v1:
• Change wait_for_partner return from true/false to 0/-ERESTARTSYS.
• Mention that the demo program doesn’t always work for some.
• Remove some unneeded braces from the demo program’s CHECK() macro.

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

