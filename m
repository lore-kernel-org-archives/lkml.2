Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab0I2H7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 03:59:35 -0400
Received: from nm7.bullet.mail.sp2.yahoo.com ([98.139.91.77]:24577 "HELO
	nm7.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752540Ab0I2H7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 03:59:33 -0400
X-Yahoo-Newman-Id: 812176.42713.bm@omp1038.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: xxjLMKUVM1np8A3JzstXH4pJWIvLA0igsrb1oWzOtaMKuln
 rDyxLUv4L9ILgY76nhvfHfKk1kRTG7e8QD.vFT5wwa456x1yY2.RErnpFNev
 l58qKfADBGqGG6uaUUugAPY6g.yhwaEP0W9eUnkG5qUcXKFD_u.gU3l5G3gn
 D6Wq5oBMwBvH0cmVFHKEh6gF_zv6KyPqj7R9GlY0gHBQpt92V_5xI4x3zZhY
 Hhs80iAnyGTPbnmXGuap.8NC2bdIvUIMZrl5Z.mJQqexNaGOhzGvcPJFu4OW
 r0JiHeA238K6c_A.zoz5K_4YGNxEhIAK00bDIByfgGF4-
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [RFC v4 14/19] buslogic: Remove host_lock unlock() + lock()
	from BusLogic_QueueCommand()
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>,
        James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>,
        MPTFusionLinux <DL-MPTFusionLinux@lsi.com>,
        "eata.c maintainer" <dario.ballabio@inwind.it>,
        Luben Tuikov <ltuikov@yahoo.com>, mvsas maintainer <kewei@marvell.com>,
        pm8001 maintainer Jack Wang <jack_wang@usish.com>
In-Reply-To: <1285639651-7485-1-git-send-email-nab@linux-iscsi.org>
References: <1285639651-7485-1-git-send-email-nab@linux-iscsi.org>
Content-Type: text/plain
Date: Wed, 29 Sep 2010 00:55:12 -0700
Message-Id: <1285746912.18417.38.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-27 at 19:07 -0700, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch removes the now legacy host_lock unlock() + lock() optimization
> from buslogic.c:BusLogic_QueueCommand()
> 

FYI Guys, I have gone ahead and dropped this patch for RFCv5 as the
BusLogic LLD was the only patch in the v4 series who did not set
SHT->unlocked_qcmds=1, so we will still need the BusLogic_QueueCommand()
unlock -> lock before calling BusLogic_Delay() for the two cases below.

Thanks,

--nab

> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/scsi/BusLogic.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index fc0b4b8..f39b4fc 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -2837,9 +2837,7 @@ static int BusLogic_QueueCommand(struct scsi_cmnd *Command, void (*CompletionRou
>  	 */
>  	CCB = BusLogic_AllocateCCB(HostAdapter);
>  	if (CCB == NULL) {
> -		spin_unlock_irq(HostAdapter->SCSI_Host->host_lock);
>  		BusLogic_Delay(1);
> -		spin_lock_irq(HostAdapter->SCSI_Host->host_lock);
>  		CCB = BusLogic_AllocateCCB(HostAdapter);
>  		if (CCB == NULL) {
>  			Command->result = DID_ERROR << 16;
> @@ -2965,10 +2963,8 @@ static int BusLogic_QueueCommand(struct scsi_cmnd *Command, void (*CompletionRou
>  		   error as a Host Adapter Hard Reset should be initiated soon.
>  		 */
>  		if (!BusLogic_WriteOutgoingMailbox(HostAdapter, BusLogic_MailboxStartCommand, CCB)) {
> -			spin_unlock_irq(HostAdapter->SCSI_Host->host_lock);
>  			BusLogic_Warning("Unable to write Outgoing Mailbox - " "Pausing for 1 second\n", HostAdapter);
>  			BusLogic_Delay(1);
> -			spin_lock_irq(HostAdapter->SCSI_Host->host_lock);
>  			if (!BusLogic_WriteOutgoingMailbox(HostAdapter, BusLogic_MailboxStartCommand, CCB)) {
>  				BusLogic_Warning("Still unable to write Outgoing Mailbox - " "Host Adapter Dead?\n", HostAdapter);
>  				BusLogic_DeallocateCCB(CCB);

