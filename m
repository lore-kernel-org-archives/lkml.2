Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab0IXSEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:04:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab0IXSEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:04:32 -0400
Date: Fri, 24 Sep 2010 20:04:17 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: jason.wessel@windriver.com, a.p.zijlstra@chello.nl
Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: kgdb segv in the latest tip due to perf ctx changes
Message-ID: <20100924180417.GC1818@jolsa.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

while starting kgdb early debug on latest tip tree,
I got SIGSEGV inside kernel in following location:

fetch_bp_busy_slots (bp=0xffff880075f69000) at
kernel/hw_breakpoint.c:137
137             struct task_struct *tsk = bp->ctx->task;


the segv is caused by the kgdb code assuming the event has
ctx field defined, which is not true at the the time
by the following backtrace:


(gdb) bt
#0  fetch_bp_busy_slots (bp=0xffff880075f69000) at kernel/hw_breakpoint.c:137
#1  __reserve_bp_slot (bp=0xffff880075f69000) at kernel/hw_breakpoint.c:314
#2  0xffffffff810ac0c5 in reserve_bp_slot (bp=0xffff880075f69000) at kernel/hw_breakpoint.c:336
#3  0xffffffff810ac0f6 in register_perf_hw_breakpoint (bp=0xffff880075f69000) at kernel/hw_breakpoint.c:412
#4  0xffffffff810ac165 in hw_breakpoint_event_init (bp=0xffff880075f69000) at kernel/hw_breakpoint.c:580
#5  0xffffffff810a3da6 in perf_init_event (event=0xffff880075f69000) at kernel/perf_event.c:5268
#6  0xffffffff810aa658 in perf_event_alloc (attr=0xffff88007899ddf0, cpu=0, group_leader=0xffff880075f69000, parent_event=0x0, 
    overflow_handler=0) at kernel/perf_event.c:5356
#7  0xffffffff810aae6c in perf_event_create_kernel_counter (attr=<value optimized out>, cpu=0, task=0x0, 
    overflow_handler=<value optimized out>) at kernel/perf_event.c:5752
#8  0xffffffff810ab8b5 in register_wide_hw_breakpoint (attr=0xffff88007899ddf0, triggered=0) at kernel/hw_breakpoint.c:518
#9  0xffffffff81025e2a in kgdb_arch_late () at arch/x86/kernel/kgdb.c:646
#10 0xffffffff8107be62 in kgdb_register_callbacks (new_dbg_io_ops=0xffffffff81a3de00) at kernel/debug/debug_core.c:802
#11 kgdb_register_io_module (new_dbg_io_ops=0xffffffff81a3de00) at kernel/debug/debug_core.c:906
#12 0xffffffff812662bc in configure_kgdboc () at drivers/serial/kgdboc.c:137
#13 0xffffffff81ae805b in init_kgdboc () at drivers/serial/kgdboc.c:159
#14 0xffffffff81abd61e in do_one_initcall (fn=0xffffffff81ae8047 <init_kgdboc>) at init/main.c:750
#15 0xffffffff81abd828 in do_initcalls (unused=<value optimized out>) at init/main.c:780
#16 do_basic_setup (unused=<value optimized out>) at init/main.c:801
#17 kernel_init (unused=<value optimized out>) at init/main.c:893
#18 0xffffffff810033d4 in ?? () at arch/x86/kernel/entry_64.S:1156
#19 0x0000000000000000 in ?? ()



I found out it's due to foolowing commit, that's causing the init code
to be called without the ctx field being defined...

commit c3f00c70276d8ae82578c8b773e2db657f69a478
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Wed Aug 18 14:37:15 2010 +0200


I'm not sure if kgdb is wrong assuming the filed exists or perf code
not defining the ctx field at that time..

I can reproduce easily, let me know if I can help

wbr,
jirka
