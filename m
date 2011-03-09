Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab1CIAc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 19:32:58 -0500
Received: from mout.perfora.net ([74.208.4.195]:57525 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463Ab1CIAc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 19:32:57 -0500
From: Stephen Wilson <wilsons@start.ca>
To: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        Paul Mundt <lethal@linux-sh.org>, Andi Kleen <ak@linux.intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] make *_gate_vma accept mm_struct instead of task_struct
Date: Tue,  8 Mar 2011 19:31:56 -0500
Message-Id: <1299630721-4337-1-git-send-email-wilsons@start.ca>
X-Mailer: git-send-email 1.7.3.5
X-Provags-ID: V02:K0:Ex8LDGV3RwBYZvCCTUIHxIWFiQwkdJp8+GHI712whJ7
 rQRJXaK4TNGyF/wCMTPogHqhtyHu0diCJ+Hz7mxOLvQHpr9dAj
 I5L35Yo96NB336IC4y5aJ+6CHYgVBGbtNAM8Q+Tz6pKXJTIES/
 bPYGIzMuqyyFMRuDVhFTUJFgYEDCCxAxfKnbQWoRSrlG97+PX9
 zZ7Y9jAZoYy/SGgbOZQI/SRQucJf8M6qR/1fuFakiw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Morally, the question of whether an address lies in a gate vma should be asked
with respect to an mm, not a particular task.

Practically, dropping the dependency on task_struct will help make current and
future operations on mm's more flexible and convenient.  In particular, it
allows some code paths to avoid the need to hold task_lock.

The only architecture this change impacts in any significant way is x86_64.
The principle change on that architecture is to mirror TIF_IA32 via
a new flag in mm_context_t. 

This is the first of a two part series that implements safe writes to
/proc/pid/mem.  I will be posting the second series to lkml shortly.  These
patches are based on v2.6.38-rc8.  The general approach used here was suggested
to me by Alexander Viro, but any mistakes present in these patches are entirely
my own.


--
steve


Stephen Wilson (5):
      x86: add context tag to mark mm when running a task in 32-bit compatibility mode
      x86: mark associated mm when running a task in 32 bit compatibility mode
      mm: arch: make get_gate_vma take an mm_struct instead of a task_struct
      mm: arch: make in_gate_area take an mm_struct instead of a task_struct
      mm: arch: rename in_gate_area_no_task to in_gate_area_no_mm


 arch/powerpc/kernel/vdso.c         |    6 +++---
 arch/s390/kernel/vdso.c            |    6 +++---
 arch/sh/kernel/vsyscall/vsyscall.c |    6 +++---
 arch/x86/ia32/ia32_aout.c          |    1 +
 arch/x86/include/asm/mmu.h         |    6 ++++++
 arch/x86/kernel/process_64.c       |    8 ++++++++
 arch/x86/mm/init_64.c              |   16 ++++++++--------
 arch/x86/vdso/vdso32-setup.c       |   15 ++++++++-------
 fs/binfmt_elf.c                    |    2 +-
 fs/proc/task_mmu.c                 |    8 +++++---
 include/linux/mm.h                 |   10 +++++-----
 kernel/kallsyms.c                  |    4 ++--
 mm/memory.c                        |    8 ++++----
 mm/mlock.c                         |    4 ++--
 mm/nommu.c                         |    2 +-
 15 files changed, 61 insertions(+), 42 deletions(-)



