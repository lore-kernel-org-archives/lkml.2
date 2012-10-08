Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab2JHQpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 12:45:04 -0400
Received: from [65.55.88.15] ([65.55.88.15]:26406 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751823Ab2JHQo7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 12:44:59 -0400
X-Forefront-Antispam-Report: CIP:198.70.193.61;KIP:(null);UIP:(null);IPV:NLI;H:avexcashub1.qlogic.com;RD:avexcashub1.qlogic.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz1432I4015Izz1202h1d1ah1d2ahzz17326ah8275bh8275dhz2fh2a8h668h839h944he5bhf0ah107ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1155h)
From: Saurav Kashyap <saurav.kashyap@qlogic.com>
To: Jiri Kosina <jkosina@suse.cz>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Dept-Eng Linux Driver <Linux-Driver@qlogic.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Mon, 8 Oct 2012 11:43:42 -0500
Subject: Re: [PATCH] [RESEND] qla2xxx: fix potential deadlock on
 ha->hardware_lock
Thread-Topic: [PATCH] [RESEND] qla2xxx: fix potential deadlock on
 ha->hardware_lock
Thread-Index: Ac2ldBN8tnjqPjPzSlqXvRznbp/8yQ==
Message-ID: <CC98FFD9.ECEC%saurav.kashyap@qlogic.com>
In-Reply-To: <alpine.LNX.2.00.1210080922250.28357@pobox.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.10.0.110310
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: qlogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Saurav Kashyap <saurav.kashyap@qlogic.com>

Thanks,
~Saurav


>Lockdep reports:
>
>=== [ cut here ] ===
> =========================================================
> [ INFO: possible irq lock inversion dependency detected ]
> 3.6.0-0.0.0.28.36b5ec9-default #1 Not tainted
> ---------------------------------------------------------
> qla2xxx_1_dpc/368 just changed the state of lock:
>  (&(&ha->vport_slock)->rlock){+.....}, at: [<ffffffffa009b377>]
>qla2x00_configure_hba+0x197/0x3c0 [qla2xxx]
> but this lock was taken by another, HARDIRQ-safe lock in the past:
>  (&(&ha->hardware_lock)->rlock){-.....}
>
>and interrupts could create inverse lock ordering between them.
>
>other info that might help us debug this:
> Possible interrupt unsafe locking scenario:
>
>       CPU0                    CPU1
>       ----                    ----
>  lock(&(&ha->vport_slock)->rlock);
>                               local_irq_disable();
>                               lock(&(&ha->hardware_lock)->rlock);
>                               lock(&(&ha->vport_slock)->rlock);
>  <Interrupt>
>    lock(&(&ha->hardware_lock)->rlock);
>=== [ cut here ] ===
>
>Fix the potential deadlock by disabling IRQs while holding
>ha->vport_slock.
>
>Reported-and-tested-by: Srivatsa S. Bhat
><srivatsa.bhat@linux.vnet.ibm.com>
>Signed-off-by: Jiri Kosina <jkosina@suse.cz>
>---
> drivers/scsi/qla2xxx/qla_init.c |    5 +++--
> 1 files changed, 3 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/scsi/qla2xxx/qla_init.c
>b/drivers/scsi/qla2xxx/qla_init.c
>index 799a58b..48fca47 100644
>--- a/drivers/scsi/qla2xxx/qla_init.c
>+++ b/drivers/scsi/qla2xxx/qla_init.c
>@@ -2080,6 +2080,7 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
>       uint8_t       domain;
>       char            connect_type[22];
>       struct qla_hw_data *ha = vha->hw;
>+      unsigned long flags;
>
>       /* Get host addresses. */
>       rval = qla2x00_get_adapter_id(vha,
>@@ -2154,9 +2155,9 @@ qla2x00_configure_hba(scsi_qla_host_t *vha)
>       vha->d_id.b.area = area;
>       vha->d_id.b.al_pa = al_pa;
>
>-      spin_lock(&ha->vport_slock);
>+      spin_lock_irqsave(&ha->vport_slock, flags);
>       qlt_update_vp_map(vha, SET_AL_PA);
>-      spin_unlock(&ha->vport_slock);
>+      spin_unlock_irqrestore(&ha->vport_slock, flags);
>
>       if (!vha->flags.init_done)
>               ql_log(ql_log_info, vha, 0x2010,
>
>--
>Jiri Kosina
>SUSE Labs
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

