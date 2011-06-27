Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab1F0H4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 03:56:10 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:58160 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911Ab1F0Hy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 03:54:59 -0400
Date: Mon, 27 Jun 2011 09:54:42 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.40-rc4
Message-ID: <20110627095442.10a70204@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

Christian Borntraeger (3):
      [S390] kvm-s390: fix kconfig dependencies
      [S390] s390: enforce HW limits for the initial sampling rate
      [S390] hwsampler: Set a sane default sampling rate

Jan Glauber (1):
      [S390] allow setting of upper 32 bit in smp_ctl_set_bit

 arch/s390/Kconfig         |    1 +
 arch/s390/kernel/smp.c    |    4 ++--
 arch/s390/oprofile/init.c |    8 +++++++-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 90d77bd..c03fef7 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -579,6 +579,7 @@ config S390_GUEST
 	def_bool y
 	prompt "s390 guest support for KVM (EXPERIMENTAL)"
 	depends on 64BIT && EXPERIMENTAL
+	select VIRTUALIZATION
 	select VIRTIO
 	select VIRTIO_RING
 	select VIRTIO_CONSOLE
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 52420d2..1d55c95 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -262,7 +262,7 @@ void smp_ctl_set_bit(int cr, int bit)
 
 	memset(&parms.orvals, 0, sizeof(parms.orvals));
 	memset(&parms.andvals, 0xff, sizeof(parms.andvals));
-	parms.orvals[cr] = 1 << bit;
+	parms.orvals[cr] = 1UL << bit;
 	on_each_cpu(smp_ctl_bit_callback, &parms, 1);
 }
 EXPORT_SYMBOL(smp_ctl_set_bit);
@@ -276,7 +276,7 @@ void smp_ctl_clear_bit(int cr, int bit)
 
 	memset(&parms.orvals, 0, sizeof(parms.orvals));
 	memset(&parms.andvals, 0xff, sizeof(parms.andvals));
-	parms.andvals[cr] = ~(1L << bit);
+	parms.andvals[cr] = ~(1UL << bit);
 	on_each_cpu(smp_ctl_bit_callback, &parms, 1);
 }
 EXPORT_SYMBOL(smp_ctl_clear_bit);
diff --git a/arch/s390/oprofile/init.c b/arch/s390/oprofile/init.c
index 5995e9b..0e358c2 100644
--- a/arch/s390/oprofile/init.c
+++ b/arch/s390/oprofile/init.c
@@ -25,7 +25,7 @@ extern void s390_backtrace(struct pt_regs * const regs, unsigned int depth);
 
 #include "hwsampler.h"
 
-#define DEFAULT_INTERVAL	4096
+#define DEFAULT_INTERVAL	4127518
 
 #define DEFAULT_SDBT_BLOCKS	1
 #define DEFAULT_SDB_BLOCKS	511
@@ -151,6 +151,12 @@ static int oprofile_hwsampler_init(struct oprofile_operations *ops)
 	if (oprofile_max_interval == 0)
 		return -ENODEV;
 
+	/* The initial value should be sane */
+	if (oprofile_hw_interval < oprofile_min_interval)
+		oprofile_hw_interval = oprofile_min_interval;
+	if (oprofile_hw_interval > oprofile_max_interval)
+		oprofile_hw_interval = oprofile_max_interval;
+
 	if (oprofile_timer_init(ops))
 		return -ENODEV;
 
