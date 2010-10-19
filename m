Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab0JSQVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:21:10 -0400
Received: from avexcashub1.qlogic.com ([198.70.193.61]:21954 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab0JSQVJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:21:09 -0400
From: Madhu Iyengar <madhu.iyengar@qlogic.com>
To: Julia Lawall <julia@diku.dk>, Andrew Vasquez <andrew.vasquez@qlogic.com>,
        Madhu Iyengar <madhu.iyengar@qlogic.com>,
        Giridhar Malavali <giridhar.malavali@qlogic.com>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Linux Driver <Linux-Driver@qlogic.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Date: Tue, 19 Oct 2010 09:21:05 -0700
Subject: RE: [PATCH 1/4] drivers/scsi/qla2xxx/qla_init.c: convert nested
 spin_lock_irqsave to spin_lock
Thread-Topic: [PATCH 1/4] drivers/scsi/qla2xxx/qla_init.c: convert nested
 spin_lock_irqsave to spin_lock
Thread-Index: ActvcXjjd6m9dMAwT2mjgf8dO3aPgwAN3IHg
Message-ID: <5E4F49720D0BAD499EE1F01232234BA871294F61E8@AVEXMB1.qlogic.org>
References: <1287481436-26656-1-git-send-email-julia@diku.dk>
In-Reply-To: <1287481436-26656-1-git-send-email-julia@diku.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia,

We've submitted this patch upstream to scsi-misc already on Oct 15th (Dan Carpenter had flagged this). Here's the submission info (patch (01/12) or item #12 in the link below:

http://marc.info/?l=linux-scsi&w=2&r=1&s=qla2xxx&q=b

Thanks,
Madhu

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Julia Lawall
Sent: Tuesday, October 19, 2010 2:44 AM
To: Andrew Vasquez
Cc: kernel-janitors@vger.kernel.org; Linux Driver; James E.J. Bottomley; Grant Likely; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 1/4] drivers/scsi/qla2xxx/qla_init.c: convert nested spin_lock_irqsave to spin_lock

From: Julia Lawall <julia@diku.dk>

If spin_lock_irqsave is called twice in a row with the same second
argument, the interrupt state at the point of the second call overwrites
the value saved by the first call.  Indeed, the second call does not need
to save the interrupt state, so it is changed to a simple spin_lock.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression lock1,lock2;
expression flags;
@@

*spin_lock_irqsave(lock1,flags)
... when != flags
*spin_lock_irqsave(lock2,flags)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/qla2xxx/qla_init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3cafbef..c8d0b12 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1818,14 +1818,14 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 		qla2x00_init_response_q_entries(rsp);
 	}
 
-	spin_lock_irqsave(&ha->vport_slock, flags);
+	spin_lock(&ha->vport_slock);
 	/* Clear RSCN queue. */
 	list_for_each_entry(vp, &ha->vp_list, list) {
 		vp->rscn_in_ptr = 0;
 		vp->rscn_out_ptr = 0;
 	}
 
-	spin_unlock_irqrestore(&ha->vport_slock, flags);
+	spin_unlock(&ha->vport_slock);
 
 	ha->isp_ops->config_rings(vha);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

