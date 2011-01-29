Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab1A2W4c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 17:56:32 -0500
Received: from nm22-vm0.bullet.mail.ac4.yahoo.com ([98.139.53.218]:26953 "HELO
	nm22-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751989Ab1A2W4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 17:56:32 -0500
X-Yahoo-Newman-Id: 75099.67098.bm@omp1049.mail.ac4.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: cm45MAEVM1kuU1ykSZd0Q7dq_eDh3JDbtO3O3twUjM9PHeX
 qmWyGZ.J6zMrNMFLC3KtZQivNBG_egJTPunocsd9pnAlNm_NxJOgUFx8Df7k
 2u1Wog9bM4Ir.wYfyYIdBaQV6RclryG2N_uBFlBAInvKpwPcucS14Tug6.eh
 01HBiZJqfw8_NDxaZCbQGbQXjc._ZWElnJ5hccsqZPMMYZE2Fr3QIn41ED8M
 lburEvdsTqn..7ehEga_XC_gqwvIeU6yjcT9w37mkbeSWe8cP2scgti0v4Rr
 QJOEWsE7o
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH] SCSI, target: Don't leak memory in error path in
	pscsi_alloc_task()
From: "Nicholas A. Bellinger" <nab@kernel.org>
Reply-To: nab@kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>
In-Reply-To: <alpine.LNX.2.00.1101292326510.19392@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101292326510.19392@swampdragon.chaosbits.net>
Content-Type: text/plain
Date: Sat, 29 Jan 2011 14:56:27 -0800
Message-Id: <1296341787.14831.237.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-01-29 at 23:29 +0100, Jesper Juhl wrote:
> We'll leak the memory allocated via kzalloc() to 'pt' if the allocation of 
> memory for 'pt->pscsi_cdb' fails in pscsi_alloc_task().
> This patch fixes the leak by kfree()'ing the previously allocated memory 
> in the error path.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  target_core_pscsi.c |    1 +
>  1 file changed, 1 insertion(+)
> 
>   Compile tested only since I lack the hardware.
> 
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index 742d246..84561a0 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -815,6 +815,7 @@ pscsi_alloc_task(struct se_cmd *cmd)
>  
>  		pt->pscsi_cdb = kzalloc(scsi_command_size(cdb), GFP_KERNEL);
>  		if (!(pt->pscsi_cdb)) {
> +			kfree(pt);
>  			printk(KERN_ERR "pSCSI: Unable to allocate extended"
>  					" pt->pscsi_cdb\n");
>  			return NULL;
> 
> 

Thanks, but this one was already fixed recently by Roland in
lio-core-2.6.git/linus-38-rc2, and included in the series to mainline as
[PATCH 04/24]:

commit 85133a962707b0e550c3f5f151557bed3e056869
Author: Roland Dreier <rolandd@cisco.com>
Date:   Sun Jan 16 06:59:51 2011 +0000

    target: Fix memory leak on error path

Best Regards,

--nab




