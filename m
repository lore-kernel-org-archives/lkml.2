Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab0FSWCo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 18:02:44 -0400
Received: from nikam-dmz.ms.mff.cuni.cz ([195.113.20.16]:57688 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752017Ab0FSWCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 18:02:43 -0400
X-Greylist: delayed 610 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Jun 2010 18:02:42 EDT
Date: Sat, 19 Jun 2010 23:52:30 +0200
From: Martin Mares <mj@ucw.cz>
To: linux-kernel@vger.kernel.org
Subject: Tracing of syscalls on x86
Message-ID: <mj+md-20100619.213111.21845.nikam@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, world!\n

I am playing with a simple ptrace-based sandbox for use in programming
contest (see git://git.ucw.cz/moe.git, box/box.c). It works pretty well
on the i386, but I got stuck when porting it to amd64.

The problem is that anytime ptrace reports a system call, I do not know how
to determine whether it is a 32-bit syscall or a 64-bit one -- both sets
of syscalls use different numbering, but they seem to be reported in exactly
the same way. For example, when a 64-bit process uses int 0x80 to issue
a 32-bit syscall, it cannot be distinguished from the same process using
the syscall instruction for a 64-bit syscall.

The same problem was present in auditing of syscalls, but it got fixed
in 2008 by Michael Davidson (see http://dunedin.lug.net.nz/forums/showthread.php?t=325963).
The auditing code path now checks the TS_COMPAT flag, which faithfully
represents the real syscall type. However, I do not see any possibility
of reading this flag from user space.

The strace utility currently checks the CS register to determine whether
the process runs in 32- or 64-bit mode, which is wrong (in case of int 0x80
issued in 64-bit mode). It also contains commented-out code which tries
to check the instruction code immediately preceding the current EIP,
which is ugly and potentially unreliable (as we do not have a pointer
to the start of the instruction, so that the detection might be fooled
by one instruction code being a suffix of another; it does not seem
to happen on current CPU's, but it could in the future).

Is there anything I have overlooked?

If not, would you welcome a patch allowing to read TS_COMPAT from user space?

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
Lisp Users: Due to the holiday, there will be no garbage collection on Monday.
