Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab1HLNu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:50:58 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:48850 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab1HLNtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:49:22 -0400
Message-Id: <20110812134907.816664005@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 12 Aug 2011 15:48:55 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: vgoyal@redhat.com
Cc: ebiederm@xmission.com, mahesh@linux.vnet.ibm.com, hbabu@us.ibm.com,
        oomichi@mxs.nes.nec.co.jp, horms@verge.net.au, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [patch v3 6/8] s390: Do first kdump checksum test before really starting kdump
References: <20110812134849.748973593@linux.vnet.ibm.com>
Content-Disposition: inline; filename=s390-kdump-arch-backend-entry.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

With this patch first the kdump checksums in purgatory are verified (with
start_kdump(0)) before kdump is started. This allows us to do the shutdown
actions defined under /sys/firmware as recovery action in case kdump is
overwritten. The main use case is to define stand-alone dump as recovery
action.

We have to split the purgatory function into "checksum test" and "real
execution", because we have to switch to the IPL CPU when we execute kdump.
After the switch it is not possible to return from the called function.

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 arch/s390/kernel/machine_kexec.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/arch/s390/kernel/machine_kexec.c
+++ b/arch/s390/kernel/machine_kexec.c
@@ -325,8 +325,16 @@ void machine_kexec(struct kimage *image)
 {
 	tracer_disable();
 #ifdef CONFIG_CRASH_DUMP
-	if (image->type == KEXEC_TYPE_CRASH)
+	if (image->type == KEXEC_TYPE_CRASH) {
+		int (*start_kdump)(int) = (void *)image->start;
+		int rc;
+		__arch_local_irq_stnsm(0xfb); /* disable DAT */
+		rc = start_kdump(0);
+		__arch_local_irq_stosm(0x04); /* enable DAT */
+		if (rc)
+			return;
 		smp_switch_to_ipl_cpu(__machine_kdump, image);
+	}
 #endif
 	smp_send_stop();
 	smp_switch_to_ipl_cpu(__machine_kexec, image);

