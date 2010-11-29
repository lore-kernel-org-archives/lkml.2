Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab0K2PNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:13:34 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62587 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab0K2PNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:13:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=e2jEah48qS12A5fgzabqa0OeqcvmECDBQIQvyGZ/+7tQmsilG71O9wmCO/o/h9GBgA
         lx+aPbtoX2BstVykX1sIDgyPxgYRyYgURBWaknIHe4784sNuGpV3q5iIHOOOC7R+kp1H
         Z1Sw2ihwAhUHKpl+y40jaRSCtxA172liwBAJ0=
Subject: [PATCH v2 0/4] kthread: NUMA aware kthread_create_on_cpu()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
In-Reply-To: <1291023532.3435.29.camel@edumazet-laptop>
References: <1290972833.29196.90.camel@edumazet-laptop>
	 <20101128224024.GA12300@basil.fritz.box>
	 <1290984712.29196.100.camel@edumazet-laptop>
	 <20101128230146.GB12300@basil.fritz.box>
	 <1290987424.29196.128.camel@edumazet-laptop>
	 <20101129090510.GA15763@basil.fritz.box>
	 <1291023532.3435.29.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 16:13:23 +0100
Message-ID: <1291043604.3435.969.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note : compiled and tested on x86_32 and x86_64 only, but these patches
take care of other arches as well.

Cc: linux-arch@vger.kernel.org 

Thanks for your feedback Andi !


[PATCH v2 0/4] kthread: NUMA aware kthread_create_on_cpu()

All kthreads being created from a single helper task, they all use
memory from a single node for their kernel stack and task struct.

This patch suite creates kthread_create_on_cpu(), adding a 'cpu'
parameter to parameters already used by kthread_create().

This parameter serves in allocating memory for the new kthread on its
memory node if available.

Users of this new function are : ksoftirqd, kworker, migration,
pktgend...


Patch 1/4 mm: NUMA aware alloc_task_struct_node()

alloc_task_struct(void) becomes alloc_task_struct_node(int node)

Patch 2/4 mm: NUMA aware alloc_thread_info_node()

alloc_thread_info(struct task_struct *tsk) becomes
alloc_thread_info_node(struct task_struct *tsk, int node)

Patch 3/4 kthread: NUMA aware kthread_create_on_cpu()

Patch 4/4 kthread: use kthread_create_on_cpu() 

ksoftirqd, kworker, migration, and pktgend kthreads can be created with
NUMA aware kthread_create_on_cpu()

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-arch@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/cris/include/asm/thread_info.h     |    2 -
 arch/frv/include/asm/processor.h        |    2 -
 arch/frv/include/asm/thread_info.h      |   13 ++------
 arch/frv/kernel/process.c               |    5 ++-
 arch/ia64/include/asm/thread_info.h     |   14 +++++++--
 arch/m32r/include/asm/thread_info.h     |   13 ++------
 arch/mips/include/asm/thread_info.h     |    6 ++--
 arch/mn10300/include/asm/thread_info.h  |    6 ++--
 arch/powerpc/include/asm/thread_info.h  |    2 -
 arch/powerpc/kernel/process.c           |    4 +-
 arch/score/include/asm/thread_info.h    |    2 -
 arch/sh/include/asm/thread_info.h       |    2 -
 arch/sh/kernel/process.c                |   16 ++++++-----
 arch/sparc/include/asm/thread_info_32.h |    6 ++--
 arch/sparc/include/asm/thread_info_64.h |   24 ++++++++--------
 arch/sparc/mm/srmmu.c                   |    4 +-
 arch/sparc/mm/sun4c.c                   |    4 +-
 arch/tile/include/asm/thread_info.h     |    2 -
 arch/tile/kernel/process.c              |    4 +-
 arch/um/include/asm/processor-generic.h |    2 -
 arch/x86/include/asm/thread_info.h      |   10 +++++-
 include/linux/kthread.h                 |   14 ++++++---
 include/linux/sched.h                   |    1 
 kernel/fork.c                           |   20 ++++++++-----
 kernel/kthread.c                        |   32 +++++++++++++++++-----
 kernel/softirq.c                        |    3 +-
 kernel/stop_machine.c                   |    4 +-
 kernel/workqueue.c                      |    4 +-
 net/core/pktgen.c                       |    3 +-
 29 files changed, 135 insertions(+), 89 deletions(-)



