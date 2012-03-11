Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393Ab2CKHJs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 03:09:48 -0400
Received: from sr-smtp.usish.com ([210.5.144.203]:44348 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab2CKHJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 03:09:43 -0400
Date: Sun, 11 Mar 2012 15:09:41 +0800
From: jack_wang <jack_wang@usish.com>
To: "santosh nayak" <santoshprasadnayak@gmail.com>
Cc: "Mark Salyzyn" <mark_salyzyn@xyratex.com>,
        lindar_liu <lindar_liu@usish.com>,
        "James Bottomley" <JBottomley@parallels.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Reply-To: jack_wang <jack_wang@usish.com>
Subject: Re: Re: [PATCH] [SCSI] pm8001: Use spin_lock_irqsave() for task_state.
References: <1331280818-14042-1-git-send-email-santoshprasadnayak@gmail.com>, 
	<3AC0015A-DFF5-4D08-A535-1FC6F2094B31@xyratex.com>
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.87[cn]
Mime-Version: 1.0
Message-ID: <201203111509407962111@usish.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2B7Aith006005

Looks OK to me.
Thanks.
Acked-by: Jack Wang <jack_wang@usish.com>


--------------
jack_wang
>ACK
>
>On Mar 9, 2012, at 3:13 AM, santosh nayak wrote:
>
>> From: Santosh Nayak <santoshprasadnayak@gmail.com>
>> 
>> Use spin_lock_irqsave() for task_state.
>> 
>> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
>> ---
>> drivers/scsi/pm8001/pm8001_hwi.c |   18 ++++++++++--------
>> 1 files changed, 10 insertions(+), 8 deletions(-)
>> 
>> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
>> index 3619f6e..9d82ee5 100644
>> --- a/drivers/scsi/pm8001/pm8001_hwi.c
>> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
>> @@ -2093,6 +2093,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>> 	struct ata_task_resp *resp ;
>> 	u32 *sata_resp;
>> 	struct pm8001_device *pm8001_dev;
>> +	unsigned long flags;
>> 
>> 	psataPayload = (struct sata_completion_resp *)(piomb + 4);
>> 	status = le32_to_cpu(psataPayload->status);
>> @@ -2382,26 +2383,26 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>> 		ts->stat = SAS_DEV_NO_RESPONSE;
>> 		break;
>> 	}
>> -	spin_lock_irq(&t->task_state_lock);
>> +	spin_lock_irqsave(&t->task_state_lock, flags);
>> 	t->task_state_flags &= ~SAS_TASK_STATE_PENDING;
>> 	t->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
>> 	t->task_state_flags |= SAS_TASK_STATE_DONE;
>> 	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
>> -		spin_unlock_irq(&t->task_state_lock);
>> +		spin_unlock_irqrestore(&t->task_state_lock, flags);
>> 		PM8001_FAIL_DBG(pm8001_ha,
>> 			pm8001_printk("task 0x%p done with io_status 0x%x"
>> 			" resp 0x%x stat 0x%x but aborted by upper layer!\n",
>> 			t, status, ts->resp, ts->stat));
>> 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>> 	} else if (t->uldd_task) {
>> -		spin_unlock_irq(&t->task_state_lock);
>> +		spin_unlock_irqrestore(&t->task_state_lock, flags);
>> 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>> 		mb();/* ditto */
>> 		spin_unlock_irq(&pm8001_ha->lock);
>> 		t->task_done(t);
>> 		spin_lock_irq(&pm8001_ha->lock);
>> 	} else if (!t->uldd_task) {
>> -		spin_unlock_irq(&t->task_state_lock);
>> +		spin_unlock_irqrestore(&t->task_state_lock, flags);
>> 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>> 		mb();/*ditto*/
>> 		spin_unlock_irq(&pm8001_ha->lock);
>> @@ -2423,6 +2424,7 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
>> 	u32 tag = le32_to_cpu(psataPayload->tag);
>> 	u32 port_id = le32_to_cpu(psataPayload->port_id);
>> 	u32 dev_id = le32_to_cpu(psataPayload->device_id);
>> +	unsigned long flags;
>> 
>> 	ccb = &pm8001_ha->ccb_info[tag];
>> 	t = ccb->task;
>> @@ -2593,26 +2595,26 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
>> 		ts->stat = SAS_OPEN_TO;
>> 		break;
>> 	}
>> -	spin_lock_irq(&t->task_state_lock);
>> +	spin_lock_irqsave(&t->task_state_lock, flags);
>> 	t->task_state_flags &= ~SAS_TASK_STATE_PENDING;
>> 	t->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
>> 	t->task_state_flags |= SAS_TASK_STATE_DONE;
>> 	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
>> -		spin_unlock_irq(&t->task_state_lock);
>> +		spin_unlock_irqrestore(&t->task_state_lock, flags);
>> 		PM8001_FAIL_DBG(pm8001_ha,
>> 			pm8001_printk("task 0x%p done with io_status 0x%x"
>> 			" resp 0x%x stat 0x%x but aborted by upper layer!\n",
>> 			t, event, ts->resp, ts->stat));
>> 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>> 	} else if (t->uldd_task) {
>> -		spin_unlock_irq(&t->task_state_lock);
>> +		spin_unlock_irqrestore(&t->task_state_lock, flags);
>> 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>> 		mb();/* ditto */
>> 		spin_unlock_irq(&pm8001_ha->lock);
>> 		t->task_done(t);
>> 		spin_lock_irq(&pm8001_ha->lock);
>> 	} else if (!t->uldd_task) {
>> -		spin_unlock_irq(&t->task_state_lock);
>> +		spin_unlock_irqrestore(&t->task_state_lock, flags);
>> 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>> 		mb();/*ditto*/
>> 		spin_unlock_irq(&pm8001_ha->lock);
>
>______________________________________________________________________
>This email may contain privileged or confidential information, which should only be used for the purpose for which it was sent by Xyratex. No further rights or licenses are granted to use such information. If you are not the intended recipient of this message, please notify the sender by return and delete it. You may not use, copy, disclose or rely on the information contained in it.
> 
>Internet email is susceptible to data corruption, interception and unauthorised amendment for which Xyratex does not accept liability. While we have taken reasonable precautions to ensure that this email is free of viruses, Xyratex does not accept liability for the presence of any computer viruses in this email, nor for any losses caused as a result of viruses.
> 
>Xyratex Technology Limited (03134912), Registered in England & Wales, Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
> 
>The Xyratex group of companies also includes, Xyratex Ltd, registered in Bermuda, Xyratex International Inc, registered in California, Xyratex (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd registered in The People's Republic of China and Xyratex Japan Limited registered in Japan.
>______________________________________________________________________
> 
>
>
>__________ Information from ESET NOD32 Antivirus, version of virus signature database 5659 (20101129) __________
>
>The message was checked by ESET NOD32 Antivirus.
>
>http://www.eset.com
>
>
>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
