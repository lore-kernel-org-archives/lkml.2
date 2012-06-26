Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab2FZMKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 08:10:32 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:62710 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756054Ab2FZMKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 08:10:30 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Jun 2012 08:10:29 EDT
X-AuditID: 1209190e-b7fb56d0000008b2-26-4fe9a5887e2f
From: Anders Kaseorg <andersk@MIT.EDU>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Nieder <jrnieder@gmail.com>, dash@vger.kernel.org,
        Anders Kaseorg <andersk@MIT.EDU>
Subject: [PATCH] fifo: Do not restart open() if it already found a partner
Date: Tue, 26 Jun 2012 08:04:58 -0400
Message-Id: <1340712298-4583-1-git-send-email-andersk@mit.edu>
X-Mailer: git-send-email 1.7.11.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsUixCmqrdux9KW/wYpLghZ9/TsYLd7eXMJo
	sWfvSRaLy7vmsFmc/3uc1YHVY+esu+wenzfJeWx68pYpgDmKyyYlNSezLLVI3y6BK+PltIMs
	BevFK/pm/2JuYLwk2MXIySEhYCLxa84HNghbTOLCvfVANheHkMA+Rol9d/4wQTgbGCXW7D3P
	DuFcZpL4e66HGaSFTUBNYu6GyewgtoiAjsTvhrMsIEXMAusZJbZvmQmWEBbwknh4awETiM0i
	oCqxeO0xoGYODl4BO4mbi5wgVitKHPm3A6yEV0BQ4uTMJywgJcwC6hLr5wmBhJkF5CWat85m
	nsDIPwtJ1SyEqllIqhYwMq9ilE3JrdLNTczMKU5N1i1OTszLSy3SNdbLzSzRS00p3cQIDlpJ
	vh2MXw8qHWIU4GBU4uH1qH/hL8SaWFZcmXuIUZKDSUmUd+Wil/5CfEn5KZUZicUZ8UWlOanF
	hxglOJiVRHi3tAHleFMSK6tSi/JhUtIcLErivFdSbvoLCaQnlqRmp6YWpBbBZGU4OJQkeLuX
	ADUKFqWmp1akZeaUIKSZODhBhvMADe8DqeEtLkjMLc5Mh8ifYlSUEuctAUkIgCQySvPgemFJ
	5RWjONArwrxTQap4gAkJrvsV0GAmoMEcm16ADC5JREhJNTBOfprk0lr3k/+f1EnnpjN/owJ2
	/ohXk81ePWFysf1/2wL9omlGQWKaxSvXn0mv1T4bdydBTmPHxA6Rk4eWLFrx56ZR+cWbh2Of
	TrZcaL3Jtym+apPX6tUeNcvML97c0cR/onbO8q06egccKk98Kfq8+UVmyC8bmVVm2lvvhRh2
	tWQtX7fk0wdHJZbijERDLeai4kQArzOqHQUDAAA=
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
second reader that will never come.

  #include <sys/stat.h>
  #include <sys/types.h>
  #include <sys/wait.h>
  #include <fcntl.h>
  #include <signal.h>
  #include <stdio.h>
  #include <stdlib.h>
  #include <unistd.h>

  #define CHECK(x) do {if ((x) == -1) {perror(#x); abort();}} while(0)

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
 fs/fifo.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/fifo.c b/fs/fifo.c
index b1a524d..0d2b53e 100644
--- a/fs/fifo.c
+++ b/fs/fifo.c
@@ -14,7 +14,7 @@
 #include <linux/sched.h>
 #include <linux/pipe_fs_i.h>
 
-static void wait_for_partner(struct inode* inode, unsigned int *cnt)
+static bool wait_for_partner(struct inode* inode, unsigned int *cnt)
 {
 	int cur = *cnt;	
 
@@ -23,6 +23,7 @@ static void wait_for_partner(struct inode* inode, unsigned int *cnt)
 		if (signal_pending(current))
 			break;
 	}
+	return cur != *cnt;
 }
 
 static void wake_up_partner(struct inode* inode)
@@ -67,8 +68,7 @@ static int fifo_open(struct inode *inode, struct file *filp)
 				 * seen a writer */
 				filp->f_version = pipe->w_counter;
 			} else {
-				wait_for_partner(inode, &pipe->w_counter);
-				if(signal_pending(current))
+				if (!wait_for_partner(inode, &pipe->w_counter))
 					goto err_rd;
 			}
 		}
@@ -90,8 +90,7 @@ static int fifo_open(struct inode *inode, struct file *filp)
 			wake_up_partner(inode);
 
 		if (!pipe->readers) {
-			wait_for_partner(inode, &pipe->r_counter);
-			if (signal_pending(current))
+			if (!wait_for_partner(inode, &pipe->r_counter))
 				goto err_wr;
 		}
 		break;
-- 
1.7.11.1

