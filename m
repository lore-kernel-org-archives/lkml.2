Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551Ab2FAMNv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 08:13:51 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:46992 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437Ab2FAMNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 08:13:49 -0400
Message-ID: <4FC8B1C6.4050503@linux.vnet.ibm.com>
Date: Fri, 01 Jun 2012 17:42:54 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Tony Luck <tony.luck@intel.com>, Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>, Chris Metcalf <cmetcalf@tilera.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Richard Kuo <rkuo@codeaurora.org>, David Howells <dhowells@redhat.com>,
        Bob Liu <lliubbo@gmail.com>, "David S. Miller" <davem@davemloft.net>,
        Richard Weinberger <richard@nod.at>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Matt Turner <mattst88@gmail.com>, nikunj@linux.vnet.ibm.com
Subject: Re: [PATCH 02/27] smpboot: Add provisions for arch-specific locking
 around cpu_online_mask
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com> <20120601091024.31979.23253.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120601091024.31979.23253.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12060112-8878-0000-0000-000002BE5FE5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding arch maintainers to Cc, which I had missed earlier. No changes to the 
patch.

======

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 02/27] smpboot: Add provisions for arch-specific locking around cpu_online_mask

We want to make smp booting as generic as possible and remove code
duplication in arch/ directories.

While manipulating the cpu_online_mask, x86 uses an additional lock, i.e.,
'vector_lock'. So provide a generic way to implement such arch-specific
extra locking, by providing weakly defined functions arch_vector_lock()
and arch_vector_unlock() which can be overriden by different architectures
suitably.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Bob Liu <lliubbo@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Richard Weinberger <richard@nod.at>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 kernel/smpboot.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index 6c26133..5ae1805 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -107,6 +107,13 @@ void __weak __cpu_pre_online(void *arg) {}
 void __weak __cpu_post_online(void *arg) {}
 #endif
 
+/*
+ * Optional arch-specific locking for manipulating cpu_online_mask while
+ * bringing up secondary CPUs.
+ */
+void __weak arch_vector_lock(void) {}
+void __weak arch_vector_unlock(void) {}
+
 
 /**
  * smpboot_start_secondary - Generic way to boot secondary processors
@@ -129,8 +136,10 @@ void __cpuinit smpboot_start_secondary(void *arg)
 
 	__cpu_pre_online(arg);
 
-	/* Set the CPU in the cpu_online_mask */
+	/* Set the CPU in the cpu_online_mask with required locks held */
+	arch_vector_lock();
 	set_cpu_online(cpu, true);
+	arch_vector_unlock();
 
 	__cpu_post_online(arg);
 


