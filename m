Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab0LPE6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 23:58:23 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:33804 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab0LPE6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 23:58:22 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 15 Dec 2010 20:55:01 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@davide-lnx1
To: Timo Sirainen <tss@iki.fi>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: poll()ing a shared pipe triggers unnecessary context switches
In-Reply-To: <1292433864.5569.105.camel@kurkku.sapo.corppt.com>
Message-ID: <alpine.DEB.2.00.1012152052350.9145@davide-lnx1>
References: <1292433864.5569.105.camel@kurkku.sapo.corppt.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010, Timo Sirainen wrote:

> I have one master process reading status updates from a pipe shared by
> multiple child processes. The child processes also poll() the pipe's
> write fd to see when the master process dies. This works fine, except
> each time a child process writes to the pipe, all the child processes
> wake up in poll()/epoll_wait() and go back to sleep without returning
> anything, triggering unnecessary context switches.
> 
> I worked around this by creating yet another pipe just for listening the
> master's death, but this still seems like a Linux bug to me. Solaris and
> BSDs don't behave like this.

Hmm, I *thought* I had already posted this.
The code is in place, in fs/select.c, to filter wakeups based on keys, we 
just need to wire up the event-based wakeups to pipes.
See patch below, which should take care of both poll and epoll (and select).




> Test program:
> 
> /*
>    gcc poller.c -o poller -Wall
> 
>    Usage: ./poller
>    Wait for a while if it prints any "volcs for poll() = .." messages.
>    It shouldn't.
>    Program stops by hitting enter.
> */
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <unistd.h>
> #include <poll.h>
> #include <sys/time.h>
> #include <sys/resource.h>
> 
> void child(int fd)
> {
> 	struct pollfd pfd;
> 	struct rusage ru1, ru2;
> 	int diff;
> 
> 	memset(&pfd, 0, sizeof(pfd));
> 	pfd.fd = fd;
> 	pfd.events = 0;
> 	while (write(fd, "foo\n", 4) == 4) {
> 		getrusage(RUSAGE_SELF, &ru1);
> 		if (poll(&pfd, 1, 100) != 0)
> 			break;
> 		getrusage(RUSAGE_SELF, &ru2);
> 
> 		diff = ru2.ru_nvcsw - ru1.ru_nvcsw;
> 		if (diff > 2)
> 			printf("volcs for poll() = %d\n", diff);
> 
> 	}
> 	printf("%d exited\n", (int)getpid());
> 	exit(0);
> }
> 
> int main(void)
> {
> 	struct pollfd pfds[2];
> 	int i, fd[2];
> 	char buf[1024];
> 
> 	pipe(fd);
> 	for (i = 0; i < 10; i++) {
> 		if (fork() == 0) {
> 			close(fd[0]);
> 			child(fd[1]);
> 		}
> 	}
> 
> 	memset(pfds, 0, sizeof(pfds));
> 	pfds[0].fd = 0;
> 	pfds[0].events = POLLIN;
> 	pfds[1].fd = fd[0];
> 	pfds[1].events = POLLIN;
> 	while (poll(pfds, 2, -1) > 0) {
> 		if (pfds[0].revents != 0)
> 			break;
> 		if (pfds[1].revents != 0)
> 			read(fd[0], buf, sizeof(buf));
> 	}
> 
> 	close(fd[0]);
> 	close(fd[1]);
> 	printf("done\n");
> 	return 1;
> }



---
 fs/pipe.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6.mod/fs/pipe.c
===================================================================
--- linux-2.6.mod.orig/fs/pipe.c	2010-12-15 20:49:48.000000000 -0800
+++ linux-2.6.mod/fs/pipe.c	2010-12-15 20:51:42.000000000 -0800
@@ -441,7 +441,7 @@
 			break;
 		}
 		if (do_wakeup) {
-			wake_up_interruptible_sync(&pipe->wait);
+			wake_up_interruptible_sync_poll(&pipe->wait, POLLOUT);
  			kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 		}
 		pipe_wait(pipe);
@@ -450,7 +450,7 @@
 
 	/* Signal writers asynchronously that there is more room. */
 	if (do_wakeup) {
-		wake_up_interruptible_sync(&pipe->wait);
+		wake_up_interruptible_sync_poll(&pipe->wait, POLLOUT);
 		kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 	}
 	if (ret > 0)
@@ -612,7 +612,7 @@
 			break;
 		}
 		if (do_wakeup) {
-			wake_up_interruptible_sync(&pipe->wait);
+			wake_up_interruptible_sync_poll(&pipe->wait, POLLIN);
 			kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 			do_wakeup = 0;
 		}
@@ -623,7 +623,7 @@
 out:
 	mutex_unlock(&inode->i_mutex);
 	if (do_wakeup) {
-		wake_up_interruptible_sync(&pipe->wait);
+		wake_up_interruptible_sync_poll(&pipe->wait, POLLIN);
 		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 	}
 	if (ret > 0)
@@ -715,7 +715,7 @@
 	if (!pipe->readers && !pipe->writers) {
 		free_pipe_info(inode);
 	} else {
-		wake_up_interruptible_sync(&pipe->wait);
+		wake_up_interruptible_sync_poll(&pipe->wait, POLLIN | POLLOUT);
 		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 		kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 	}

