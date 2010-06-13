Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab0FMPES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 11:04:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab0FMPEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 11:04:09 -0400
From: Avi Kivity <avi@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Really lazy fpu
Date: Sun, 13 Jun 2010 18:03:43 +0300
Message-Id: <1276441427-31514-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently fpu management is only lazy in one direction.  When we switch into
a task, we may avoid loading the fpu state in the hope that the task will
never use it.  If we guess right we save an fpu load/save cycle; if not,
a Device not Available exception will remind us to load the fpu.

However, in the other direction, fpu management is eager.  When we switch out
of an fpu-using task, we always save its fpu state.

This is wasteful if the task(s) that run until we switch back in all don't use
the fpu, since we could have kept the task's fpu on the cpu all this time
and saved an fpu save/load cycle.  This can be quite common with threaded
interrupts, but will also happen with normal kernel threads and even normal
user tasks.

This patch series converts task fpu management to be fully lazy.  When
switching out of a task, we keep its fpu state on the cpu, only flushing it
if some other task needs the fpu.

Open issues/TODO:

- patch 2 enables interrupts during #NM.  There's a comment that says
  it shouldn't be done, presumably because of old-style #FERR handling.
  Need to fix one way or the other (dropping #FERR support, eagerly saving
  state when #FERR is detected, or dropping the entire optimization on i386)
- flush fpu state on cpu offlining (trivial)
- make sure the AMD FXSAVE workaround still works correctly
- reduce IPIs by flushing fpu state when we know a task is being migrated
  (guidance from scheduler folk appreciated)
- preemptible kernel_fpu_begin() to improve latency on raid and crypto setups
  (will post patches)
- lazy host-side kvm fpu management (will post patches)
- accelerate signal delivery by allocating signal handlers their own fpu
  state, and letting them run with the normal task's fpu until they use
  an fp instruction (will generously leave to interested parties)

Avi Kivity (4):
  x86, fpu: merge __save_init_fpu() implementations
  x86, fpu: run device not available trap with interrupts enabled
  x86, fpu: Let the fpu remember which cpu it is active on
  x86, fpu: don't save fpu state when switching from a task

 arch/x86/include/asm/i387.h      |  126 +++++++++++++++++++++++++++++++++-----
 arch/x86/include/asm/processor.h |    4 +
 arch/x86/kernel/i387.c           |    3 +
 arch/x86/kernel/process.c        |    1 +
 arch/x86/kernel/process_32.c     |   12 +++-
 arch/x86/kernel/process_64.c     |   13 +++--
 arch/x86/kernel/traps.c          |   13 ++---
 7 files changed, 139 insertions(+), 33 deletions(-)

