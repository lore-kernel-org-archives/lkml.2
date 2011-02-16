Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab1BPBMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:12:18 -0500
Received: from kroah.org ([198.145.64.141]:45620 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933012Ab1BPAtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:49:11 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:06 2011
Message-Id: <20110216002106.256715532@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:20:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kashyap Desai <kashyap.desai@lsi.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [patch 071/176] [SCSI] mpt2sas: Kernel Panic during Large Topology discovery
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kashyap, Desai <kashyap.desai@lsi.com>

commit 4224489f45b503f0a1f1cf310f76dc108f45689a upstream.

There was a configuration page timing out during the initial port
enable at driver load time. The port enable would fail, and this would
result in the driver unloading itself, meanwhile the driver was accessing
freed memory in another context resulting in the panic.  The fix is to
prevent access to freed memory once the driver had issued the diag reset
which woke up the sleeping port enable process.  The routine
_base_reset_handler was reorganized so the last sleeping process woken up was
the port_enable.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/mpt2sas/mpt2sas_base.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3786,6 +3786,8 @@ mpt2sas_base_detach(struct MPT2SAS_ADAPT
 static void
 _base_reset_handler(struct MPT2SAS_ADAPTER *ioc, int reset_phase)
 {
+	mpt2sas_scsih_reset_handler(ioc, reset_phase);
+	mpt2sas_ctl_reset_handler(ioc, reset_phase);
 	switch (reset_phase) {
 	case MPT2_IOC_PRE_RESET:
 		dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: "
@@ -3816,8 +3818,6 @@ _base_reset_handler(struct MPT2SAS_ADAPT
 		    "MPT2_IOC_DONE_RESET\n", ioc->name, __func__));
 		break;
 	}
-	mpt2sas_scsih_reset_handler(ioc, reset_phase);
-	mpt2sas_ctl_reset_handler(ioc, reset_phase);
 }
 
 /**
@@ -3871,6 +3871,7 @@ mpt2sas_base_hard_reset_handler(struct M
 {
 	int r;
 	unsigned long flags;
+	u8 pe_complete = ioc->wait_for_port_enable_to_complete;
 
 	dtmprintk(ioc, printk(MPT2SAS_INFO_FMT "%s: enter\n", ioc->name,
 	    __func__));
@@ -3913,6 +3914,14 @@ mpt2sas_base_hard_reset_handler(struct M
 	if (r)
 		goto out;
 	_base_reset_handler(ioc, MPT2_IOC_AFTER_RESET);
+
+	/* If this hard reset is called while port enable is active, then
+	 * there is no reason to call make_ioc_operational
+	 */
+	if (pe_complete) {
+		r = -EFAULT;
+		goto out;
+	}
 	r = _base_make_ioc_operational(ioc, sleep_flag);
 	if (!r)
 		_base_reset_handler(ioc, MPT2_IOC_DONE_RESET);


