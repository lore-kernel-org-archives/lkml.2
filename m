Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab1EBIDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 04:03:49 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:60911 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab1EBIDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 04:03:46 -0400
Date: Mon, 2 May 2011 10:03:47 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.39-rc5
Message-ID: <20110502100347.52553105@mschwide.boeblingen.de.ibm.com>
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

Heiko Carstens (1):
      [S390] irqstats: fix counting of pfault, dasd diag and virtio irqs

Martin Schwidefsky (1):
      [S390] prng: fix pointer arithmetic

 arch/s390/crypto/prng.c        |    2 +-
 arch/s390/mm/fault.c           |    2 +-
 drivers/s390/block/dasd_diag.c |    2 +-
 drivers/s390/kvm/kvm_virtio.c  |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/s390/crypto/prng.c b/arch/s390/crypto/prng.c
index 44bca3f..8b16c47 100644
--- a/arch/s390/crypto/prng.c
+++ b/arch/s390/crypto/prng.c
@@ -76,7 +76,7 @@ static void prng_seed(int nbytes)
 
 	/* Add the entropy */
 	while (nbytes >= 8) {
-		*((__u64 *)parm_block) ^= *((__u64 *)buf+i);
+		*((__u64 *)parm_block) ^= *((__u64 *)(buf+i));
 		prng_add_entropy();
 		i += 8;
 		nbytes -= 8;
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 4cf85fe..ab98813 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -543,7 +543,6 @@ static void pfault_interrupt(unsigned int ext_int_code,
 	struct task_struct *tsk;
 	__u16 subcode;
 
-	kstat_cpu(smp_processor_id()).irqs[EXTINT_PFL]++;
 	/*
 	 * Get the external interruption subcode & pfault
 	 * initial/completion signal bit. VM stores this 
@@ -553,6 +552,7 @@ static void pfault_interrupt(unsigned int ext_int_code,
 	subcode = ext_int_code >> 16;
 	if ((subcode & 0xff00) != __SUBCODE_MASK)
 		return;
+	kstat_cpu(smp_processor_id()).irqs[EXTINT_PFL]++;
 
 	/*
 	 * Get the token (= address of the task structure of the affected task).
diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
index 29143ed..85dddb1 100644
--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -239,7 +239,6 @@ static void dasd_ext_handler(unsigned int ext_int_code,
 	addr_t ip;
 	int rc;
 
-	kstat_cpu(smp_processor_id()).irqs[EXTINT_DSD]++;
 	switch (ext_int_code >> 24) {
 	case DASD_DIAG_CODE_31BIT:
 		ip = (addr_t) param32;
@@ -250,6 +249,7 @@ static void dasd_ext_handler(unsigned int ext_int_code,
 	default:
 		return;
 	}
+	kstat_cpu(smp_processor_id()).irqs[EXTINT_DSD]++;
 	if (!ip) {		/* no intparm: unsolicited interrupt */
 		DBF_EVENT(DBF_NOTICE, "%s", "caught unsolicited "
 			      "interrupt");
diff --git a/drivers/s390/kvm/kvm_virtio.c b/drivers/s390/kvm/kvm_virtio.c
index 414427d..607998f 100644
--- a/drivers/s390/kvm/kvm_virtio.c
+++ b/drivers/s390/kvm/kvm_virtio.c
@@ -381,10 +381,10 @@ static void kvm_extint_handler(unsigned int ext_int_code,
 	u16 subcode;
 	u32 param;
 
-	kstat_cpu(smp_processor_id()).irqs[EXTINT_VRT]++;
 	subcode = ext_int_code >> 16;
 	if ((subcode & 0xff00) != VIRTIO_SUBCODE_64)
 		return;
+	kstat_cpu(smp_processor_id()).irqs[EXTINT_VRT]++;
 
 	/* The LSB might be overloaded, we have to mask it */
 	vq = (struct virtqueue *)(param64 & ~1UL);
