Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab0LOR5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 12:57:47 -0500
Received: from dovecot.org ([62.236.108.70]:34168 "EHLO dovecot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111Ab0LOR5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 12:57:45 -0500
X-Greylist: delayed 1998 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Dec 2010 12:57:45 EST
Subject: poll()ing a shared pipe triggers unnecessary context switches
From: Timo Sirainen <tss@iki.fi>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 17:24:24 +0000
Message-ID: <1292433864.5569.105.camel@kurkku.sapo.corppt.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have one master process reading status updates from a pipe shared by
multiple child processes. The child processes also poll() the pipe's
write fd to see when the master process dies. This works fine, except
each time a child process writes to the pipe, all the child processes
wake up in poll()/epoll_wait() and go back to sleep without returning
anything, triggering unnecessary context switches.

I worked around this by creating yet another pipe just for listening the
master's death, but this still seems like a Linux bug to me. Solaris and
BSDs don't behave like this.

Test program:

/*
   gcc poller.c -o poller -Wall

   Usage: ./poller
   Wait for a while if it prints any "volcs for poll() = .." messages.
   It shouldn't.
   Program stops by hitting enter.
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <poll.h>
#include <sys/time.h>
#include <sys/resource.h>

void child(int fd)
{
	struct pollfd pfd;
	struct rusage ru1, ru2;
	int diff;

	memset(&pfd, 0, sizeof(pfd));
	pfd.fd = fd;
	pfd.events = 0;
	while (write(fd, "foo\n", 4) == 4) {
		getrusage(RUSAGE_SELF, &ru1);
		if (poll(&pfd, 1, 100) != 0)
			break;
		getrusage(RUSAGE_SELF, &ru2);

		diff = ru2.ru_nvcsw - ru1.ru_nvcsw;
		if (diff > 2)
			printf("volcs for poll() = %d\n", diff);

	}
	printf("%d exited\n", (int)getpid());
	exit(0);
}

int main(void)
{
	struct pollfd pfds[2];
	int i, fd[2];
	char buf[1024];

	pipe(fd);
	for (i = 0; i < 10; i++) {
		if (fork() == 0) {
			close(fd[0]);
			child(fd[1]);
		}
	}

	memset(pfds, 0, sizeof(pfds));
	pfds[0].fd = 0;
	pfds[0].events = POLLIN;
	pfds[1].fd = fd[0];
	pfds[1].events = POLLIN;
	while (poll(pfds, 2, -1) > 0) {
		if (pfds[0].revents != 0)
			break;
		if (pfds[1].revents != 0)
			read(fd[0], buf, sizeof(buf));
	}

	close(fd[0]);
	close(fd[1]);
	printf("done\n");
	return 1;
}


