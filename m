Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab1IMMFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 08:05:17 -0400
Received: from www17.your-server.de ([213.133.104.17]:40391 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab1IMMFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 08:05:15 -0400
Subject: a question regarding sys_poll() on x86_64 via tha ia32 layer
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 13 Sep 2011 14:04:02 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1315915448.6545.44.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

the ia32 poll system call is routed through the "standard" function
sys_poll().

This function is defined as:

SYSCALL_DEFINE3(poll, struct pollfd __user *, ufds, unsigned int, nfds,
		long, timeout_msecs)

in fs/select.c

timeout_msecs is of type long which is AFAIK is 4 bytes on x86 and 8
bytes on x86_64.

the test for sign (i.e. < 0) in the objdump is done against the 64 bit
register (here %rbx):

ffffffff811313e0 <sys_poll>:
ffffffff811313e0:       55                      push   %rbp
ffffffff811313e1:       48 89 e5                mov    %rsp,%rbp
ffffffff811313e4:       48 83 ec 30             sub    $0x30,%rsp
ffffffff811313e8:       48 89 5d e8             mov    %rbx,-0x18(%rbp)
ffffffff811313ec:       48 89 d3                mov    %rdx,%rbx
ffffffff811313ef:       31 d2                   xor    %edx,%edx
ffffffff811313f1:       48 85 db                test   %rbx,%rbx
ffffffff811313f4:       4c 89 65 f0             mov    %r12,-0x10(%rbp)
ffffffff811313f8:       4c 89 6d f8             mov    %r13,-0x8(%rbp)
ffffffff811313fc:       41 89 f4                mov    %esi,%r12d
ffffffff811313ff:       49 89 fd                mov    %rdi,%r13
ffffffff81131402:       78 42                   js     ffffffff81131446 <sys_poll+0x66>

on an x86 kernel the test is done against %ebx

so when the system call is called with %rbx = 00000000ffffffff (i.e. -1
from %ebx) on an x86_64 kernel via the ia32 layer the test for sign will
fail and the timer will be set.

btw. <sys/poll.h> seems to define the function as

extern int poll (struct pollfd *__fds, nfds_t __nfds, int __timeout);

what am I overloking?

mfg
thomas

