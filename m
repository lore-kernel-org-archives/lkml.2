Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab2BWF0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 00:26:47 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:52983 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab2BWF0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 00:26:46 -0500
X-Nat-Received: from [202.181.97.72]:51538 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1329974800.16913
Message-Id: <201202230526.q1N5QdUc035041@www262.sakura.ne.jp>
Subject: [ptrace] Problem with ptrace cleanup logic.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: oleg@redhat.com, tj@kernel.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 23 Feb 2012 14:26:39 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 23022012 #7063985, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that ptrace(PTRACE_ATTACH, 1) makes the global init process remain
killable even after a process that called ptrace(PTRACE_ATTACH, 1) exits.

Steps to reproduce:

(1) Compile ptrace-init.c as ./a.out .

----- ptrace-init.c -----
#include <sys/ptrace.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
        printf("PTRACE_ATTACH=%ld\n", ptrace(PTRACE_ATTACH, 1));
        return 0;
}
----- ptrace-init.c -----

(2) Run below commands as root user.

    # ./a.out
    # kill -KILL 1




Result on 2.6.26.8 to 2.6.29.6 is

    # head -n 2 /proc/1/status
    Name:   init
    State:  S (sleeping)
    # ./a.out
    PTRACE_ATTACH=0
    # head -n 2 /proc/1/status
    Name:   init
    State:  S (sleeping)
    # kill -KILL 1

Result on 2.6.30.10 to 3.3-rc4 is

    # head -n 2 /proc/1/status
    Name:   init
    State:  S (sleeping)
    # ./a.out
    PTRACE_ATTACH=0
    # head -n 2 /proc/1/status
    Name:   init
    State:  T (stopped)
    # kill -KILL 1
    Kernel panic - not syncing: Attempted to kill init!

As you can see, the global init process remains "T (stopped)" state. I think
this is a regression because it always triggers kernel panic upon sysvinit's
shutdown sequence.

  Sending all processes the TERM signal...done.
  Sending all processes the KILL signal...
  Kernel panic - not syncing: Attempted to kill init!
  Pid: 1, comm: init Not tainted 3.2.7 #1
  Call Trace:
   [<c10354c3>] panic+0x63/0x170
   [<c1038123>] find_new_reaper+0xa3/0xb0
   [<c103824c>] forget_original_parent+0x2c/0x180
   [<c11c7f24>] ? get_current_tty+0x54/0x70

If ptrace-init.c were expected to do some cleanup logic before exit, we can't
force ptrace-init.c to do it, for ptrace-init.c can be terminated unexpectedly.
