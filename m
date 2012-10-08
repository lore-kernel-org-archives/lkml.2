Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab2JHHYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 03:24:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab2JHHYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 03:24:08 -0400
Date: Mon, 8 Oct 2012 09:23:54 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-driver@qlogic.com,
        Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] [RESEND] qla2xxx: fix potential deadlock on
 ha->hardware_lock
In-Reply-To: <alpine.LNX.2.00.1210041500010.9942@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1210080922250.28357@pobox.suse.cz>
References: <506D80C2.5040405@linux.vnet.ibm.com> <alpine.LNX.2.00.1210041500010.9942@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lockdep reports:

=== [ cut here ] ===
 =========================================================
 [ INFO: possible irq lock inversion dependency detected ]
 3.6.0-0.0.0.28.36b5ec9-default #1 Not tainted
 ---------------------------------------------------------
 qla2xxx_1_dpc/368 just changed the state of lock:
  (&(&ha->vport_slock)->rlock){+.....}, at: [<ffffffffa009b377>] qla2x00_configure_hba+0x197/0x3c0 [qla2xxx]
 but this lock was taken by another, HARDIRQ-safe lock in the past:
  (&(&ha->hardware_lock)->rlock){-.....}

and interrupts could create inverse lock ordering between them.

other info that might help us debug this:
 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&(&ha->vport_slock)->rlock);
                               local_irq_disable();
                               lock(&(&ha->hardware_lock)->rlock);
                               lock(&(&ha->vport_slock)->rlock);
  <Interrupt>
    lock(&(&ha->hardware_lock)->rlock);
=== [ cut here ] ===

Fix the potential deadlock by disabling IRQs while holding ha->vport_slock.

Reported-and-tested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/scsi/qla2xxx/qla_init.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 799a58b..48fca47 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2080,6 +2080,7 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 	uint8_t       domain;
 	char		connect_type[22];
 	struct qla_hw_data *ha = vha->hw;
+	unsigned long flags;
 
 	/* Get host addresses. */
 	rval = qla2x00_get_adapter_id(vha,
@@ -2154,9 +2155,9 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
 	vha->d_id.b.area = area;
 	vha->d_id.b.al_pa = al_pa;
 
-	spin_lock(&ha->vport_slock);
+	spin_lock_irqsave(&ha->vport_slock, flags);
 	qlt_update_vp_map(vha, SET_AL_PA);
-	spin_unlock(&ha->vport_slock);
+	spin_unlock_irqrestore(&ha->vport_slock, flags);
 
 	if (!vha->flags.init_done)
 		ql_log(ql_log_info, vha, 0x2010,

-- 
Jiri Kosina
SUSE Labs
