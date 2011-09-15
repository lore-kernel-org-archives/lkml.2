Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933492Ab1IOMXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 08:23:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59461 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933463Ab1IOMXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 08:23:48 -0400
Subject: Re: a question regarding sys_poll() on x86_64 via tha ia32 layer
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        viro@zeniv.linux.org.uk, mingo@redhat.com
In-Reply-To: <1316086860.6545.66.camel@localhost.localdomain>
References: <1316086860.6545.66.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Sep 2011 14:23:55 +0200
Message-ID: <1316089435.2893.6.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 15 septembre 2011 à 13:40 +0200, Thomas Meyer a écrit :
> cc'ed some people on this assumed bug.
> 
> Am Dienstag, den 13.09.2011, 14:04 +0200 schrieb Thomas Meyer:
> > Hello,
> > 
> > the ia32 poll system call is routed through the "standard" function
> > sys_poll().
> > 
> > This function is defined as:
> > 
> > SYSCALL_DEFINE3(poll, struct pollfd __user *, ufds, unsigned int, nfds,
> > 		long, timeout_msecs)
> > 
> > in fs/select.c
> > 
> > timeout_msecs is of type long which is AFAIK is 4 bytes on x86 and 8
> > bytes on x86_64.
> > 
> > the test for sign (i.e. < 0) in the objdump is done against the 64 bit
> > register (here %rbx):
> > 
> > ffffffff811313e0 <sys_poll>:
> > ffffffff811313e0:       55                      push   %rbp
> > ffffffff811313e1:       48 89 e5                mov    %rsp,%rbp
> > ffffffff811313e4:       48 83 ec 30             sub    $0x30,%rsp
> > ffffffff811313e8:       48 89 5d e8             mov    %rbx,-0x18(%rbp)
> > ffffffff811313ec:       48 89 d3                mov    %rdx,%rbx
> > ffffffff811313ef:       31 d2                   xor    %edx,%edx
> > ffffffff811313f1:       48 85 db                test   %rbx,%rbx
> > ffffffff811313f4:       4c 89 65 f0             mov    %r12,-0x10(%rbp)
> > ffffffff811313f8:       4c 89 6d f8             mov    %r13,-0x8(%rbp)
> > ffffffff811313fc:       41 89 f4                mov    %esi,%r12d
> > ffffffff811313ff:       49 89 fd                mov    %rdi,%r13
> > ffffffff81131402:       78 42                   js     ffffffff81131446 <sys_poll+0x66>
> > 
> > on an x86 kernel the test is done against %ebx
> > 
> > so when the system call is called with %rbx = 00000000ffffffff (i.e. -1
> > from %ebx) on an x86_64 kernel via the ia32 layer the test for sign will
> > fail and the timer will be set.
> > 
> > btw. <sys/poll.h> seems to define the function as
> > 
> > extern int poll (struct pollfd *__fds, nfds_t __nfds, int __timeout);
> > 
> > what am I overloking?
> > 
> > mfg
> > thomas
> 

Its a plain bug, please submit a formal patch.

Probably not noticed because timer is set to more than 24 days.

diff --git a/fs/select.c b/fs/select.c
index d33418f..e782258 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -912,7 +912,7 @@ static long do_restart_poll(struct restart_block *restart_block)
 }
 
 SYSCALL_DEFINE3(poll, struct pollfd __user *, ufds, unsigned int, nfds,
-		long, timeout_msecs)
+		int, timeout_msecs)
 {
 	struct timespec end_time, *to = NULL;
 	int ret;


