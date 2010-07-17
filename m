Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759658Ab0GQBSt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 21:18:49 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38953 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab0GQBSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 21:18:48 -0400
MIME-Version: 1.0
From: Kyle Moffett <kyle@moffetthome.net>
Date: Fri, 16 Jul 2010 21:18:26 -0400
Message-ID: <AANLkTiksHBuT9OmniKpZRRaPOnEYHCAINbPC7nH9NXnF@mail.gmail.com>
Subject: apr testsuite: Spinning forever in sys_futex() [SIGSTOP does not 
	work]
To: linux-kernel@vger.kernel.org, Kumar Gala <galak@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kyle D Moffett <Kyle.D.Moffett@boeing.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

In the "apr" testsuite, the "testatomic" test seems to get 4 processes
completely stuck in sys_futex.  If I "kill -STOP" the process it
continues to run, chewing CPU.  It seems that "kill -KILL" works,
though...

Because of the "kill -STOP" problem, I can't attach to it with GDB to
see where it's stuck, but I can dump /proc/$PID/stack repeatedly to
see where it seems to be spinning in the kernel.  My kernel version is
2.6.32.15 plus arch/powerpc board-support patches.

In particular, I seem to have the following callchains (starting at sys_futex):

do_futex
  futex_lock_pi
    __switch_to
    futex_lock_pi_atomic
      cmpxchg_futex_value_locked
        handle_page_fault
          do_page_fault
    fault_in_user_writeable
      get_user_pages
        __get_user_pages
          __cond_resched
            __switch_to
    get_futex_key
      __lock_page
        sync_page
          __switch_to
    drop_futex_key_refs
      iput
        0x48026000
          resume_kernel
            __switch_to
      resume_kernel
        __switch_to


I noticed this particular problem while working on a Debian
"PowerPCSPE" port [0], so it's entirely possible that my EGLIBC build
is slightly broken, but even that should not make it completely
impossible to "kill -STOP" a process. My particular boards use the
"P2020" chipset (mpc85xx/e500v2 family).

Any advice on how to further debug this would be much appreciated!

Cheers,
Kyle Moffett

[0] http://wiki.debian.org/PowerPCSPEPort
