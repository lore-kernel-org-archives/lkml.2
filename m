Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab2AKH6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 02:58:47 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:39014 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab2AKH6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 02:58:46 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH] sched/s390: fix compile error in sched/core.c
Date: Wed, 11 Jan 2012 08:58:16 +0100
Message-Id: <1326268696-30904-1-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.7.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
x-cbid: 12011107-4966-0000-0000-000001201885
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit 029632fbb7b7c9d85063cc9eb470de6c54873df3
    sched: Make separate sched*.c translation units

removed the include of asm/mutex.h from sched.c. This breaks the combination of

CONFIG_MUTEX_SPIN_ON_OWNER=yes
CONFIG_HAVE_ARCH_MUTEX_CPU_RELAX=yes
like s390 without mutex debugging:

  CC      kernel/sched/core.o
kernel/sched/core.c: In function ‘mutex_spin_on_owner’:
kernel/sched/core.c:3287: error: implicit declaration of function ‘arch_mutex_cpu_relax’
make[2]: *** [kernel/sched/core.o] Error 1

Lets re-add the include to kernel/sched/core.c

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 kernel/sched/core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index cecbb64..f82efdc 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -74,6 +74,9 @@
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
+#ifdef CONFIG_HAVE_ARCH_MUTEX_CPU_RELAX
+#include <asm/mutex.h>
+#endif
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #endif
-- 
1.7.8.2

