Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab1KBOz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 10:55:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369Ab1KBOz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 10:55:27 -0400
Date: Wed, 2 Nov 2011 15:51:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: hank <pyu@redhat.com>
Cc: tj@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] set wo_stat to an init value in do_wait function
Message-ID: <20111102145105.GA27394@redhat.com>
References: <4EB0FF81.90808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB0FF81.90808@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02, hank wrote:
>
> When all of the below conditions become true:
> 1 parent fork a child
> 2 parent ignore SIGCHLD signal
> 3 parent call waitpid function
> do_wait function won't touch the wo->stat variable.

Of course it doesn't, do_wait() fails and does nothing.

The parent ignores SIGCHLD. In this case waitpid(&status) acts as
if there are no children. Except it sleeps.

IOW,

> int main(int argc, char *argv[])
> {
>         int pid, child;
>         int status;
>         int *p;
> 
>         signal(SIGCHLD, SIG_IGN);
> 
>         child = fork();
>         if (child == 0) {
>                 sleep(1);
>                 exit(0);
>         } else if (child < 0) {
>                 perror("fork");
>                 exit(1);
>         } else {
>                 status = 0xa5a5;
>                 p = &status;
>                 printf("status addr: %p\n", p);
>                 pid = waitpid(-1, &status, WUNTRACED);
>                 printf("pid=%d status=0x%x\n", pid, status);
>                 exit(0);
>         }
>         return 0;
> }
> ========================================================
>
> After run this program, we can see the value of status is still
> 0xa5a5,so kernel do not touch this value.

Sure, this is correct.

> It may be dangerous. Because lots of programs such as 'su' don't set
> an init value for the variable 'status' when it call waitpid function,
> and after the waitpid function return, the program may check the value
> of 'status' to see the state of child.

Then this program is buggy. Once again, waitpid() fails. The program
shouldn't look at status at all.

Oleg.

