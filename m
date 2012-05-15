Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966473Ab2EOTDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 15:03:05 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:48785 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966448Ab2EOTDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 15:03:02 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [RESEND PATCH 1/2] parisc/CPU hotplug: Add missing call to
 notify_cpu_starting()
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, mingo@kernel.org, a.p.zijlstra@chello.nl,
        mpatocka@redhat.com, stepanm@codeaurora.org, tglx@linutronix.de,
        James.Bottomley@hansenpartnership.com, deller@gmx.de,
        dhowells@redhat.com, yasutake.koichi@jp.panasonic.com,
        eike-kernel@sf-tec.de, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        linux-am33-list@redhat.com
Date: Wed, 16 May 2012 00:32:17 +0530
Message-ID: <20120515190157.22459.91924.stgit@srivatsabhat>
In-Reply-To: <20120515190115.22459.93544.stgit@srivatsabhat>
References: <20120515190115.22459.93544.stgit@srivatsabhat>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12051519-2000-0000-0000-000007826841
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scheduler depends on receiving the CPU_STARTING notification, without
which we end up into a lot of trouble. So add the missing call to
notify_cpu_starting() in the bringup code.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-and-Tested-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-and-Tested-by: Tobias Ulmer <tobiasu@tmux.org>
Tested-by: John David Anglin <dave.anglin@bell.net>
---

 arch/parisc/kernel/smp.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index 0bb1d63..4dc7b79 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -31,6 +31,7 @@
 #include <linux/delay.h>
 #include <linux/bitops.h>
 #include <linux/ftrace.h>
+#include <linux/cpu.h>
 
 #include <linux/atomic.h>
 #include <asm/current.h>
@@ -295,8 +296,13 @@ smp_cpu_init(int cpunum)
 
 		printk(KERN_CRIT "CPU#%d already initialized!\n", cpunum);
 		machine_halt();
-	}  
+	}
+
+	notify_cpu_starting(cpunum);
+
+	ipi_call_lock();
 	set_cpu_online(cpunum, true);
+	ipi_call_unlock();
 
 	/* Initialise the idle task for this CPU */
 	atomic_inc(&init_mm.mm_count);

