Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab1DHUwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 16:52:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63814 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401Ab1DHUwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 16:52:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=u9BVisorGu9SgU1o3VYT9pdnqer0iY+DMDn7FsxLOUhvKOoBk/EYC5gPPzui2hT7Vj
         /6XOigRiu6J0PZXrEfH29dneOcfeTFHGfAaBL0OTqOa1cNH2CobTqsoRH+kBLbY/bAjQ
         UkqoWuJne1FHaaLM/DR4qc6z+JZ66u/uYIttE=
MIME-Version: 1.0
In-Reply-To: <4D9F6F6E.6040107@aknet.ru>
References: <4D6510A3.90905@aknet.ru> <BANLkTinfOKf+aSKy+Rj+2+v42JeGuzzrNg@mail.gmail.com>
 <4D9F6F6E.6040107@aknet.ru>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Fri, 8 Apr 2011 16:52:05 -0400
Message-ID: <BANLkTimbB4rhbdTy07DuneSf=SydGYvbBA@mail.gmail.com>
Subject: Re: [path][rfc] add PR_DETACH prctl command
To: Stas Sergeev <stsp@aknet.ru>
Cc: Linux kernel <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=KOI8-R
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/8 Stas Sergeev <stsp@aknet.ru>:
> 08.04.2011 22:13, Bryan Donlan wrote:
>>
>> I can't comment on the patch itself, but, if your application knows it
>> might have to daemonize after spinning up threads, why not simply
>> fork() immediately on startup, and have the parent simply wait forever
>> for either the child to die or for a daemonize signal from the child?
>> If done early enough it shouldn't tie up too much memory, and it
>> wouldn't require any of these invasive kernel changes. As an added
>> bonus, it's portable to all unixen :)
>
> Yes, thats almost always true. Except when you deal with
> the vendor-provided poorly-coded drivers and libs, where
> you get the drivers initialized only via the lib. And the
> initialization process must be finished before the boot-up
> can continue, but that's not the whole story: only the
> process that initialized that lib, can then work with it.
> And of course that lib creates a dozen of threads...
> OK, you've got the idea. :)

Still, you can workaround this by either:
a) Load the vendor library via dlopen()
b) Use a separate launcher executable to handle the fork-and-wait

Either of these approaches are far simpler than patching the kernel,
more portable, and much, much easier to get right. In fact, here's a
quick and dirty implementation of the latter:

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

void sigusr1_handler(int unused)
{
        (void)unused;

        _exit(0);
}

int main(int argc, char **argv)
{
        int waitstatus;
        pid_t child, parent = getpid();

        (void)argc;

        signal(SIGUSR1, sigusr1_handler);

        child = fork();
        if (child < 0) {
                perror("Fork failed");
                return EXIT_FAILURE;
        }
        if (child == 0) {
                char envbuf[20];
                sprintf(envbuf, "%d", (int)parent);
                setenv("LAUNCHER_PID", envbuf, 1);

                execvp(argv[1], &argv[1]);
                perror("Launching child failed");
                _exit(EXIT_FAILURE);
        }

        wait(&waitstatus);

        if (WIFEXITED(waitstatus))
                _exit(WEXITSTATUS(waitstatus));

        _exit(256);
}

Just kill(atoi(getenv("LAUNCHER_PID")), SIGUSR1) to detach. Much
easier than doing some very racy things in the kernel, no? It's
certainly more obvious that this ought to be correct in the face of
races with its parent :)
