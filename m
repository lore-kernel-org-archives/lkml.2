Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167Ab2BJLZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 06:25:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136Ab2BJLZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 06:25:42 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 0/5] kernel: backtrace unwind support
Date: Fri, 10 Feb 2012 12:25:14 +0100
Message-Id: <1328873119-21553-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
I was recently dealing with libunwind and wanted to try out
the dwarf backtrace unwind in kernel space.

The attached patchset implements dwarf backtrace unwind
based on the exception header frames (.eh_frame_hdr and 
.eh_frame ELF sections). The code is mostly stolen from
libunwind (git://git.sv.gnu.org/libunwind.git).

I'm not sure how much of usage this can be given that we
already have quite reliable stack backtrace, and given
the complexity of the dwarf unwind. But I might be
overlooking something and this could be of use for someone
else.

Also it needs to be said, that the state of this patchset
is far from being done. It's in state 'working for me' on
x86_64 and seems to provide reliable backtrace.

attached patches:
 - 1/5 unwind, kconfig: Adding UNWIND* options
 - 2/5 unwind, x86: Generate exception frames data for UNWIND_EH_FRAME option
 - 3/5 unwind, dwarf: Add dwarf unwind support
 - 4/5 unwind, api: Add unwind interface and implementation for x86_64
 - 5/5 unwind, test: Add backtrace unwind test code

The test code could be triggered via unwind_test debugfs file
with following output:

 # echo > ./unwind_test
 Testing unwind from process context.
 unwind backtrace:
     [0xffffffff810ef759] unw_backtrace+0x29/0x80
     [0xffffffff810ef7d4] test_write+0x24/0x90
     [0xffffffff81138940] vfs_write+0xd0/0x1a0
     [0xffffffff81138b14] sys_write+0x54/0xa0
     [0xffffffff814d7352] system_call_fastpath+0x16/0x1b
 Testing a unwind from irq context.
 unwind backtrace:
     [0xffffffff810ef759] unw_backtrace+0x29/0x80
     [0xffffffff810ef84e] unwind_test_irq_callback+0xe/0x20
     [0xffffffff8103d1c3] tasklet_action+0x143/0x150
     [0xffffffff8103d9bd] __do_softirq+0xdd/0x250
     [0xffffffff8103dc18] run_ksoftirqd+0xe8/0x200
     [0xffffffff8105a1b6] kthread+0xc6/0xd0
     [0xffffffff814d8564] kernel_thread_helper+0x4/0x10


thanks for comments,
jirka
---
 arch/x86/Kconfig.debug            |    2 +
 arch/x86/Makefile                 |    8 +-
 arch/x86/include/asm/dwarf.h      |   89 +++++
 arch/x86/include/asm/unwind.h     |   14 +
 arch/x86/kernel/Makefile          |    2 +
 arch/x86/kernel/dwarf.c           |  101 ++++++
 arch/x86/kernel/unwind_init_64.S  |   31 ++
 arch/x86/kernel/vmlinux.lds.S     |    5 +
 include/asm-generic/vmlinux.lds.h |   12 +
 include/linux/dwarf.h             |  161 +++++++++
 include/linux/unwind.h            |   23 ++
 kernel/Kconfig.unwind             |   26 ++
 kernel/Makefile                   |    6 +
 kernel/dwarf-cfi.c                |  337 ++++++++++++++++++
 kernel/dwarf-expression.c         |  694 +++++++++++++++++++++++++++++++++++++
 kernel/dwarf-fde.c                |  349 +++++++++++++++++++
 kernel/dwarf-read.c               |  227 ++++++++++++
 kernel/dwarf.c                    |    7 +
 kernel/unwind.c                   |  224 ++++++++++++
 19 files changed, 2317 insertions(+), 1 deletions(-)
