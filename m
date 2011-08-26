Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab1HZXA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 19:00:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56523 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab1HZXA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 19:00:27 -0400
Message-ID: <4E582577.2060805@zytor.com>
Date: Fri, 26 Aug 2011 16:00:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H.J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: RFD: x32 ABI system call numbers
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

As most of you know I and H.J. Lu have been working on a native 32-bit
ABI for x86-64 Linux.  H.J. has had a prototype git tree for a while; I
am currently in the process of cleaning up the kernel patches to post.

Before posting, Ingo suggested that I discuss the handling of system
calls, as this affects some of the machinery that needs to go into the
patchset.

x32 uses mostly the compat system calls already available for the i386
ABI (which means it also uses i386 ABI numbers and data structure
layouts).  There are only seven, mostly signal-related, entirely new
system calls, and most of them are trivial wrappers.

x32 uses the same SYSCALL64 instruction as native x86-64.  Currently, on
x86, the choice of system call ABI is a purely local property -- a
64-bit process can call int $0x80 and get the i386 ABI.  I have wanted
to keep this property and avoid testing global state for the meaning of
a system call.  As such, the only thing that is available to distinguish
an x32 system call from an x86-64 system call is the system call number
itself.

In the current patchset, rather than having two separate system call
tables (which would add several instructions to the system call entry
path, including for native 64-bit binaries) we have added the x32 system
calls to the 64-bit system call table with a small gap (starting at 512)
to avoid adding to the cache footprint of native 64-bit processes.

However, this leads to an annoying problem for the system calls which do
*not* need to be duplicated between x86-64 and x32, which is actually
most system calls -- 218 of 310 in the current kernel.  Unfortunately, a
single subsystem -- input -- uses is_compat() on a bunch of the I/O
paths, even changing things like the text format of sysfs entries
depending on the ABI of the user space process.

Rather than duplicating the system call table, we are proposing to deal
with that by setting bit 30 in the system call number across the board
when called from x32, so we end up with:

# Shared system call, sys_read (0)

x86-64:		%eax = 0x00000000
x32:		%eax = 0x40000000

# Unshared system call, sys_stat (4/513)

x86-64:		%eax = 0x00000004
x32:		%eax = 0x40000201

The extra bit would be masked off and only affect device drivers like
input which relies on is_compat().

The question here is if anyone has a reason to believe this would be
unacceptable.

	-hpa
