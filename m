Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030619Ab2COO7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:59:35 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51320 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965388Ab2COO71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:59:27 -0400
Message-ID: <4F6203C9.3010608@monstr.eu>
Date: Thu, 15 Mar 2012 15:59:21 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: John Williams <john.williams@petalogix.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        John Linn <John.Linn@xilinx.com>
Subject: microblaze: clone syscall: Potentially ABI breaking by passing parent/child_tidptr
 - old glibc 2.3.6.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

We have updated our toolchain to the latest & greatest based on an eglibc with ntpl for microblaze.
And I would like to check one thing with you to be sure that we don't break ABI compatibility.

In current kernel code (without ntpl), kernel sys_clone wrapper(in entry.S) clears 2 arguments (or setup them to NULL)
which is parent_tidptr and child_tidptr.
Obviously we have to use these two parameters to get things to work on eglibc that's why I have to remove
that clearing.

I have looked at the kernel code(fork.c and core.c files) and I haven't found any reason why
passing parent_tidptr and child_tidptr from glibc and not to clearing them in the kernel should break
old glibc toolchain and break ABI.

For old glibc if clone_flags is setup to (CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID | CLONE_CHILD_SETTID)
to get parent/child_tidptr use in the kernel (but both are NULL).
 From code I have seen it always ends with unsuccessful attempt to return value back to user space
because kernel ignores return values from put_user macros (It also means that put_user fails
because pointer is NULL).
For new case(with passing parent/child_tidptr) from old glibc, kernel will just do what it is expected
to do which is setup/clear proper values to provided pointers.

Also from man page if I compare both cases (with setup pointers to NULL and passing them from glibc)
kernel will setup/clear thread ID to proper location prepared by glibc.

My point is if there is any option if we start to pass parent/child_tidptr for old glibc that it will
break anything.

Can you correct my understanding?

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
