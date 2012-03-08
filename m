Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab2CHOPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 09:15:13 -0500
Received: from sr-smtp.usish.com ([210.5.144.203]:49847 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab2CHOPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 09:15:11 -0500
Date: Thu, 8 Mar 2012 22:15:03 +0800
From: jack_wang <jack_wang@usish.com>
To: "Mark Salyzyn" <mark_salyzyn@xyratex.com>,
        "santosh nayak" <santoshprasadnayak@gmail.com>
Cc: "Mark Salyzyn" <mark_salyzyn@xyratex.com>,
        lindar_liu <lindar_liu@usish.com>,
        "James Bottomley" <JBottomley@parallels.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        "Dan Carpenter" <dan.carpenter@oracle.com>
Reply-To: jack_wang <jack_wang@usish.com>
Subject: Re: Re: [PATCH 1/2] [SCSI] pm8001: Fix bogus interrupt state flag issue.
References: <1330263210-25134-1-git-send-email-santoshprasadnayak@gmail.com>, 
	<528D7E8A-B2F6-4EDB-A7C0-E0BF494038D0@xyratex.com>
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.87[cn]
Mime-Version: 1.0
Message-ID: <201203082215017182231@usish.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q28EG3SU023456

Thanks Mark for look into this.You're right. The change for task_state_lock is not right.
Sorry for not look carefully about the change.



--------------
jack_wang
>NAK
>
>In the fragment below, the 'spin_lock_irqsave(&t->task_state_lock, flags);' is 100% legitimate. The change you did was not inert, and result in the IRQ being disabled upon exit should a SAS_TASK_STATE_ABORTED task state condition occur.
>
>I propose (annotated below) you leave the flags automatic variable, but uninitialized. The changes surrounding spin_*lock_irq*(&pm8001_ha->lock, flags) are OK, but revert back the changes surrounding the spin_*lock_irq*(&t->task->state_lock,flags) so that lock would be properly nested.
>
>To be pedantic, and to be more correct, this code should have spawned a work queue task to perform the t->task_done(t) operation in a separate thread rather than inline and precariously unlocked; but that would be beyond the scope of these changes and should be left for future work to decide if it is even necessary. Not sure how such a change would affect performance (using the work queue) ... so I am 'afraid' of pushing such a change in any case given the relatively reliable operation of this driver (and the dynamic nature of the changes Dan is making to the SATA side of things for instance ;-} ).
>
>I am sorry for taking so long to get to the task of reviewing this (and the previous) code. I look forward to your comments.
>
>Sincerely -- Mark Salyzyn
>
>On Feb 26, 2012, at 8:33 AM, santosh nayak wrote:
>
>> @@ -2207,7 +2206,6 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>> static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
>> {
>> 	struct sas_task *t;
>> -	unsigned long flags = 0;
>MGS>	unsigned long flags;
>> 	struct task_status_struct *ts;
>> 	struct pm8001_ccb_info *ccb;
>> 	struct pm8001_device *pm8001_dev;
>> @@ -2287,9 +2285,9 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
>> 			ts->stat = SAS_QUEUE_FULL;
>> 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>> 			mb();/*ditto*/
>> -			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
>> +			spin_unlock_irq(&pm8001_ha->lock);
>> 			t->task_done(t);
>> -			spin_lock_irqsave(&pm8001_ha->lock, flags);
>> +			spin_lock_irq(&pm8001_ha->lock);
>> 			return;
>> 		}
>> 		break;
>> @@ -2387,31 +2385,31 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
>> 		ts->stat = SAS_OPEN_TO;
>> 		break;
>> 	}
>> -	spin_lock_irqsave(&t->task_state_lock, flags);
>> +	spin_lock_irq(&t->task_state_lock);
>MGS>	spin_lock_irqsave(&t->task_state_lock, flags);
>> 	t->task_state_flags &= ~SAS_TASK_STATE_PENDING;
>> 	t->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
>> 	t->task_state_flags |= SAS_TASK_STATE_DONE;
>> 	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
>> -		spin_unlock_irqrestore(&t->task_state_lock, flags);
>> +		spin_unlock_irq(&t->task_state_lock);
>MGS>		spin_unlock_irqrestore(&t->task_state_lock, flags);
>> 		PM8001_FAIL_DBG(pm8001_ha,
>> 			pm8001_printk("task 0x%p done with io_status 0x%x"
>> 			" resp 0x%x stat 0x%x but aborted by upper layer!\n",
>> 			t, event, ts->resp, ts->stat));
>> 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>> 	} else if (t->uldd_task) {
>> -		spin_unlock_irqrestore(&t->task_state_lock, flags);
>> +		spin_unlock_irq(&t->task_state_lock);
>> 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>> 		mb();/* ditto */
>> -		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
>> +		spin_unlock_irq(&pm8001_ha->lock);
>> 		t->task_done(t);
>> -		spin_lock_irqsave(&pm8001_ha->lock, flags);
>> +		spin_lock_irq(&pm8001_ha->lock);
>> 	} else if (!t->uldd_task) {
>> -		spin_unlock_irqrestore(&t->task_state_lock, flags);
>> +		spin_unlock_irq(&t->task_state_lock);
>> 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>> 		mb();/*ditto*/
>> -		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
>> +		spin_unlock_irq(&pm8001_ha->lock);
>> 		t->task_done(t);
>> -		spin_lock_irqsave(&pm8001_ha->lock, flags);
>> +		spin_lock_irq(&pm8001_ha->lock);
>> 	}
>> }
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>__________ Information from ESET NOD32 Antivirus, version of virus signature database 5659 (20101129) __________
>
>The message was checked by ESET NOD32 Antivirus.
>
>http://www.eset.com
>
>
>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
