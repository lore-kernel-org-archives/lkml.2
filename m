Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab0LSVWi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 16:22:38 -0500
Received: from nm3-vm0.bullet.mail.ac4.yahoo.com ([98.139.53.204]:41174 "HELO
	nm3-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757055Ab0LSVWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 16:22:36 -0500
X-Yahoo-Newman-Id: 932949.65065.bm@omp1064.mail.ac4.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 6dzs.FgVM1mxfO6qdlgZUQsyJ_64aAD9Ozj3xhTEo0F1PjQ
 spaCS7rLul6zOR5JBi9gSml49IsHuvEtI10LSAiLkiSv9R4jdR_rZ.QCCVbA
 K8fAzyfsHMQmYMMNlHfYIJsV9JHR_eIr1AuVUpZvgtZQl3Ga_0ZJrD548QNJ
 JLKvw4rm3hbh1oc5s1XaXvhf0LFDWELFW3k3FIXmwz3T5DiGTPvDGQiR34wi
 FadXfaVE27dT8IWKxpUjNDPkubmlpq_pWDe8ttAo4UdJwsDnH8THCjxTLGPO
 lCX0U5jcIi7S83LdcxNsrZ3UAMt4IXY.Sin1R.xMWXk2xvuDs4wlNw12.34J
 adiJdkwqvqT3bR5CEQwSCUb_0CZI6oM854N3GRHVtutJGldStA1cIRMy5Bbn
 1OLArQGP5dgq0jdvywokrPIlB_htVDPhtIo2bqOhxA_mgXS9KmCG_UUwzblG
 MJfAdzP3SGrqy8PtDtzIXgq8Fs17GUpveHkiQ4lu7hjjza6qIwRYhHnrn0L1
 f04fxHiv.hSOHCsvsFF8-
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
Subject: [PATCH 04/12] message: Convert to host_lock less w/ interrupts disabled externally
Date: Sun, 19 Dec 2010 13:21:59 -0800
Message-Id: <1292793727-31957-5-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the message/fusion mptsas, mptscsih and mptspi
to run in host_lock less mode with the new IRQ_DISABLE_SCSI_QCMD()
that disables interrupts while calling ->queuecommand() dispatch.

Note that mptfc.c is left out as it checks libfc rport state, which
for the moment still needs the host lock.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/message/fusion/mptfc.c    |    2 +-
 drivers/message/fusion/mptsas.c   |    6 +++---
 drivers/message/fusion/mptscsih.c |    8 +++++---
 drivers/message/fusion/mptscsih.h |    2 +-
 drivers/message/fusion/mptspi.c   |    6 +++---
 5 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index d784c36..349b3c7 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -677,7 +677,7 @@ mptfc_qcmd_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 		return 0;
 	}
 
-	return mptscsih_qcmd(SCpnt,done);
+	return mptscsih_qcmd(SCpnt->device->host, SCpnt);
 }
 
 static DEF_SCSI_QCMD(mptfc_qcmd)
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index d48c2c6..f0d205e 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1889,7 +1889,7 @@ mptsas_slave_alloc(struct scsi_device *sdev)
 }
 
 static int
-mptsas_qcmd_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
+mptsas_qcmd_irq_disable(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
 	MPT_SCSI_HOST	*hd;
 	MPT_ADAPTER	*ioc;
@@ -1910,10 +1910,10 @@ mptsas_qcmd_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	if (ioc->debug_level & MPT_DEBUG_SCSI)
 		scsi_print_command(SCpnt);
 
-	return mptscsih_qcmd(SCpnt,done);
+	return mptscsih_qcmd(SCpnt->device->host, SCpnt);
 }
 
-static DEF_SCSI_QCMD(mptsas_qcmd)
+static IRQ_DISABLE_SCSI_QCMD(mptsas_qcmd)
 
 /**
  *	mptsas_mptsas_eh_timed_out - resets the scsi_cmnd timeout
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 59b8f53..4ff996e 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1383,7 +1383,7 @@ mptscsih_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t off
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mptscsih_qcmd - Primary Fusion MPT SCSI initiator IO start routine.
+ *	mptscsih_qcmd_irq_disable - Primary Fusion MPT SCSI initiator IO start routine.
  *	@SCpnt: Pointer to scsi_cmnd structure
  *	@done: Pointer SCSI mid-layer IO completion function
  *
@@ -1393,8 +1393,8 @@ mptscsih_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t off
  *
  *	Returns 0. (rtn value discarded by linux scsi mid-layer)
  */
-int
-mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
+static int
+mptscsih_qcmd_irq_disable(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
 	MPT_SCSI_HOST		*hd;
 	MPT_FRAME_HDR		*mf;
@@ -1529,6 +1529,8 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
+IRQ_DISABLE_SCSI_QCMD(mptscsih_qcmd);
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
  *	mptscsih_freeChainBuffers - Function to free chain buffers associated
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index 45a5ff3..1815aef 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -113,7 +113,7 @@ extern int mptscsih_resume(struct pci_dev *pdev);
 #endif
 extern int mptscsih_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset, int length, int func);
 extern const char * mptscsih_info(struct Scsi_Host *SChost);
-extern int mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *));
+extern int mptscsih_qcmd(struct Scsi_Host *sh, struct scsi_cmnd *SCpnt);
 extern int mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel,
 	u8 id, int lun, int ctx2abort, ulong timeout);
 extern void mptscsih_slave_destroy(struct scsi_device *device);
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 6d9568d..53eec57 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -780,7 +780,7 @@ static int mptspi_slave_configure(struct scsi_device *sdev)
 }
 
 static int
-mptspi_qcmd_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
+mptspi_qcmd_irq_disable(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 {
 	struct _MPT_SCSI_HOST *hd = shost_priv(SCpnt->device->host);
 	VirtDevice	*vdevice = SCpnt->device->hostdata;
@@ -802,10 +802,10 @@ mptspi_qcmd_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	if (spi_dv_pending(scsi_target(SCpnt->device)))
 		ddvprintk(ioc, scsi_print_command(SCpnt));
 
-	return mptscsih_qcmd(SCpnt,done);
+	return mptscsih_qcmd(SCpnt->device->host, SCpnt);
 }
 
-static DEF_SCSI_QCMD(mptspi_qcmd)
+static IRQ_DISABLE_SCSI_QCMD(mptspi_qcmd)
 
 static void mptspi_slave_destroy(struct scsi_device *sdev)
 {
-- 
1.7.3.4

