Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab0LSVW3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 16:22:29 -0500
Received: from nm5.bullet.mail.ac4.yahoo.com ([98.139.52.202]:25844 "HELO
	nm5.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757231Ab0LSVW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 16:22:26 -0500
X-Yahoo-Newman-Id: 39590.86672.bm@omp1033.mail.ac4.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: zF0Zr4kVM1njsTutqL0bXeZBkOjjKcV2lsUOn5pPn7bZoy6
 t2.GMLM7I0d0ctJWfhfxOpcUvfmxOvtywLkmPvxG6thWMxG1jp8vhjKJYtR8
 FueP6dRpy2gxAxH4qipPk84pPYSMg63UO1232LYROzUoXO5tRuQhWxeI5rHy
 t9unN2oyRaDO.luOGOO0TegdOBxG_pV2oO7Kbw6mlVuwbyLEYqmSKHfTc1Rh
 w9l8UYPsGSwKaTdj3b8_G13EZl1unXu_KA3KBjgtfb16nVmnDMK.TLmBN6fi
 ZFFsR_lcU8J.rbsVMSUONj4CVLHs5KgzBVLJY36uT4kquepSvaoplC0HqP_i
 kUUNDthK1GW8d48_AoezZZAcc71pY
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Ravi Anand <ravi.anand@qlogic.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        adam radford <aradford@gmail.com>,
        Kashyap Desai <Kashyap.Desai@lsi.com>,
        MPTFusionLinux <DL-MPTFusionLinux@lsi.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 02/12] scsi: Add IRQ_DISABLE_SCSI_QCMD wrapper
Date: Sun, 19 Dec 2010 13:21:57 -0800
Message-Id: <1292793727-31957-3-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a IRQ_DISABLE_SCSI_QCMD() wrapper macro used by LLDs
that can now run in host_lock less mode, but still need interrupts disabled
using local_irq_save() before calling their lld_queuecommand() dispatcher.

jgarzik says this method is in fact slower than doing a spin_lock_irqsave() on
internal lib_lld_queuecommand() callers (as is done in libiscsi and libata)
but is still needed by the majority of lock_less LLDs.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 include/scsi/scsi_host.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index e7e3858..321b114 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -521,6 +521,20 @@ struct scsi_host_template {
 		return rc;						\
 	}
 
+/*
+ * Used for LLDs running in lock-less mode, but that still require having
+ * interrupts disable during their lld_queuecommand() dispatch.
+ */
+#define IRQ_DISABLE_SCSI_QCMD(func_name)				\
+	int func_name(struct Scsi_Host *shost, struct scsi_cmnd *cmd)	\
+	{								\
+		unsigned long irq_flags;				\
+		int rc;							\
+		local_irq_save(irq_flags);				\
+		rc = func_name##_irq_disable(cmd, cmd->scsi_done);	\
+		local_irq_restore(irq_flags);				\
+		return rc;						\
+	}
 
 /*
  * shost state: If you alter this, you also need to alter scsi_sysfs.c
-- 
1.7.3.4

