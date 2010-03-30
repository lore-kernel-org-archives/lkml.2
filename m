Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117Ab0C3BXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 21:23:44 -0400
Received: from vpn.pathscale.com ([198.186.3.75]:40038 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754976Ab0C3BXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 21:23:42 -0400
Date: Mon, 29 Mar 2010 18:23:41 -0700 (PDT)
From: Giridhar Malavali <giridhar.malavali@qlogic.com>
X-X-Sender: gmalavali@mvluser00.mv.qlogic.com
To: James.Bottomley@suse.de
cc: andrew.vasquez@qlogic.com, julia@diku.dk, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 9/12] drivers/scsi/qla2xxx: Add missing unlock
Message-ID: <alpine.LRH.2.00.1003291819330.28339@mvluser00.mv.qlogic.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Mar 2010, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
>
> This code represents error handling code.  Add an unlock as done in the
> normal exit path from the function.
>
> A simplified version of the semantic patch that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @r exists@
> expression E1;
> identifier f;
> @@
>
> f (...) { <+...
> * spin_lock_irqsave (E1,...);
> ... when != E1
> * return ...;
> ...+> }
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
>
> ---
> drivers/scsi/qla2xxx/qla_attr.c     |    1 +
> 1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> index 90d1e06..e8ace7a 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -2392,6 +2392,7 @@ done:
> 		kfree(sp->fcport);
> 	kfree(sp->ctx);
> 	mempool_free(sp, ha->srb_mempool);
> +	spin_unlock_irqrestore(&ha->hardware_lock, flags);
> 	return 0;
> }
>
>
James,

Can u please include this patch.
Here is the pointer for the similar patch submitted previously which I acked.
http://marc.info/?l=linux-scsi&m=126877099912968&w=2

With the new BSG patches submitted to scsi-misc at
http://marc.info/?l=linux-scsi&m=126904344832176&w=2, the BSG related code
is moved to new files bsg.[ch]. The patch below will fix the lock imbalance issue
with latest patches submitted to scsi-misc.

Giri
---
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 387d694..21e5bcd 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1199,6 +1199,7 @@ qla24xx_bsg_timeout(struct fc_bsg_job *bsg_job)
   	return 0;

   done:
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
   	if (bsg_job->request->msgcode == FC_BSG_HST_CT)
   		kfree(sp->fcport);
   	kfree(sp->ctx);
