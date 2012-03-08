Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337Ab2CHQum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 11:50:42 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43793 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757850Ab2CHQuk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 11:50:40 -0500
MIME-Version: 1.0
In-Reply-To: <528D7E8A-B2F6-4EDB-A7C0-E0BF494038D0@xyratex.com>
References: <1330263210-25134-1-git-send-email-santoshprasadnayak@gmail.com>
	<528D7E8A-B2F6-4EDB-A7C0-E0BF494038D0@xyratex.com>
Date: Thu, 8 Mar 2012 22:20:39 +0530
Message-ID: <CAOD=uF4+F7MYO0cqd7ogmc=K9jtE5DX3wDoMv1eTxFq48JCX2g@mail.gmail.com>
Subject: Re: [PATCH 1/2] [SCSI] pm8001: Fix bogus interrupt state flag issue.
From: santosh prasad nayak <santoshprasadnayak@gmail.com>
To: Mark Salyzyn <mark_salyzyn@xyratex.com>
Cc: Jack Wang <jack_wang@usish.com>, lindar_liu <lindar_liu@usish.com>,
        James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Thanks for your review.

Few queries:

1. Similar changes have been made in mpi_sata_completion() surrounding
spin_*lock_irq*(&t->task->state_lock)
    Should those changes also need to revert back ?

>
>  The change you did was not inert, and result in the IRQ being disabled upon exit should a
>  SAS_TASK_STATE_ABORTED task state condition occur then following block will enable IRQ.

2.  I could not get this point.
     If "SAS_TASK_STATE_ABORTED" task state condition occurs then following
     block will enable IRQ.

          if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
                spin_unlock_irq(&t->task_state_lock);
           //   HERE IRQ will be enabled.
                  .......
                pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
          }

3.  How bad  will be "spin_lock_irq / spin_unlock_irq" in this case compared to
     "spin_lock_irqsave / spin_unlock_irqrestore "



Regards
Santosh

>
> I propose (annotated below) you leave the flags automatic variable, but uninitialized. The changes surrounding spin_*lock_irq*(&pm8001_ha->lock, flags) are OK, but revert back the changes surrounding the spin_*lock_irq*(&t->task->state_lock,flags) so that lock would be properly nested.
>
> To be pedantic, and to be more correct, this code should have spawned a work queue task to perform the t->task_done(t) operation in a separate thread rather than inline and precariously unlocked; but that would be beyond the scope of these changes and should be left for future work to decide if it is even necessary. Not sure how such a change would affect performance (using the work queue) ... so I am 'afraid' of pushing such a change in any case given the relatively reliable operation of this driver (and the dynamic nature of the changes Dan is making to the SATA side of things for instance ;-} ).
>
> I am sorry for taking so long to get to the task of reviewing this (and the previous) code. I look forward to your comments.
>
> Sincerely -- Mark Salyzyn
>
> On Feb 26, 2012, at 8:33 AM, santosh nayak wrote:
>
>> @@ -2207,7 +2206,6 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
>> static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
>> {
>>       struct sas_task *t;
>> -     unsigned long flags = 0;
> MGS>    unsigned long flags;
>>       struct task_status_struct *ts;
>>       struct pm8001_ccb_info *ccb;
>>       struct pm8001_device *pm8001_dev;
>> @@ -2287,9 +2285,9 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
>>                       ts->stat = SAS_QUEUE_FULL;
>>                       pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>>                       mb();/*ditto*/
>> -                     spin_unlock_irqrestore(&pm8001_ha->lock, flags);
>> +                     spin_unlock_irq(&pm8001_ha->lock);
>>                       t->task_done(t);
>> -                     spin_lock_irqsave(&pm8001_ha->lock, flags);
>> +                     spin_lock_irq(&pm8001_ha->lock);
>>                       return;
>>               }
>>               break;
>> @@ -2387,31 +2385,31 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
>>               ts->stat = SAS_OPEN_TO;
>>               break;
>>       }
>> -     spin_lock_irqsave(&t->task_state_lock, flags);
>> +     spin_lock_irq(&t->task_state_lock);
> MGS>    spin_lock_irqsave(&t->task_state_lock, flags);
>>       t->task_state_flags &= ~SAS_TASK_STATE_PENDING;
>>       t->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
>>       t->task_state_flags |= SAS_TASK_STATE_DONE;
>>       if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
>> -             spin_unlock_irqrestore(&t->task_state_lock, flags);
>> +             spin_unlock_irq(&t->task_state_lock);
> MGS>            spin_unlock_irqrestore(&t->task_state_lock, flags);
>>               PM8001_FAIL_DBG(pm8001_ha,
>>                       pm8001_printk("task 0x%p done with io_status 0x%x"
>>                       " resp 0x%x stat 0x%x but aborted by upper layer!\n",
>>                       t, event, ts->resp, ts->stat));
>>               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>>       } else if (t->uldd_task) {
>> -             spin_unlock_irqrestore(&t->task_state_lock, flags);
>> +             spin_unlock_irq(&t->task_state_lock);
>>               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>>               mb();/* ditto */
>> -             spin_unlock_irqrestore(&pm8001_ha->lock, flags);
>> +             spin_unlock_irq(&pm8001_ha->lock);
>>               t->task_done(t);
>> -             spin_lock_irqsave(&pm8001_ha->lock, flags);
>> +             spin_lock_irq(&pm8001_ha->lock);
>>       } else if (!t->uldd_task) {
>> -             spin_unlock_irqrestore(&t->task_state_lock, flags);
>> +             spin_unlock_irq(&t->task_state_lock);
>>               pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
>>               mb();/*ditto*/
>> -             spin_unlock_irqrestore(&pm8001_ha->lock, flags);
>> +             spin_unlock_irq(&pm8001_ha->lock);
>>               t->task_done(t);
>> -             spin_lock_irqsave(&pm8001_ha->lock, flags);
>> +             spin_lock_irq(&pm8001_ha->lock);
>>       }
>> }
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
