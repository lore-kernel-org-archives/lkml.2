Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab1EYHhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 03:37:51 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:33703 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755463Ab1EYHhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 03:37:50 -0400
X-ASG-Debug-ID: 1306309067-01de28096b65c30001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DDCB1C8.7040708@fusionio.com>
Date: Wed, 25 May 2011 09:37:44 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Parag Warudkar <parag.lkml@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        <akpm@linux-foundation.org>, <torvalds@linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] SCSI IOCTL: Check for device deletion [was Re: __elv_add_request
  OOPS]
References: <alpine.DEB.2.02.1105232329040.1910@natty-nar> <4DDB8BF6.2000304@fusionio.com> <alpine.DEB.2.02.1105242127340.3472@ubuntu-natty>
X-ASG-Orig-Subj: Re: [PATCH] SCSI IOCTL: Check for device deletion [was Re: __elv_add_request
  OOPS]
In-Reply-To: <alpine.DEB.2.02.1105242127340.3472@ubuntu-natty>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306309067
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64662
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-25 03:41, Parag Warudkar wrote:
> 
> 
> On Tue, 24 May 2011, Jens Axboe wrote:
> 
>> On 2011-05-24 06:29, Parag Warudkar wrote:
>>>
>>> External DVD drive - connected when suspended, removed before resume.
>>> Results in NULL pointer dereference in __blk_add_request on resume.
>>>
>>> *ffffffff811d6503:      48 89 58 08             mov    %rbx,0x8(%rax) |
>>> %ebx = ffff880131559020 <--- faulting instruction
>>>
>>> 48 89 58 08 appears only in list_add :
>>>
>>> static inline void list_add(struct list_head *new, struct list_head *head)
>>> {
>>>         __list_add(new, head, head->next);
>>> ffffffff81ac012c:       49 8b 04 24             mov    (%r12),%rax
>>> #ifndef CONFIG_DEBUG_LIST
>>> static inline void __list_add(struct list_head *new,
>>>                               struct list_head *prev,
>>>                               struct list_head *next)
>>> {
>>>         next->prev = new;
>>> ffffffff81ac0130:       48 89 58 08             mov    %rbx,0x8(%rax)
>>>
>>> AFAICS list_add is only called from one place in __elv_add_request :
>>>
>>>        switch (where) {
>>>         case ELEVATOR_INSERT_REQUEUE:
>>>         case ELEVATOR_INSERT_FRONT:
>>>                 rq->cmd_flags |= REQ_SOFTBARRIER;
>>>               **  list_add(&rq->queuelist, &q->queue_head);
>>>                 break;
>>>
>>> Now, where is the patch? :)
>>
>> You forgot to attach it?
>>
>> This is clearly q == NULL [snip]
> 
> OK, I think this patch should do the trick.
> 
> Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>
> Reported-and-tested-by: Parag Warudkar <parag.lkml@gmail.com>
>  
> Check for device deletion before sending it a scsi command. This fixes an 
> OOPS I was seeing during resume when the external dvd drive was removed 
> while suspended.
> 
> diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
> index d9564fb..cc4edbf 100644
> --- a/drivers/scsi/scsi_ioctl.c
> +++ b/drivers/scsi/scsi_ioctl.c
> @@ -136,7 +136,7 @@ int scsi_set_medium_removal(struct scsi_device *sdev, char state)
>  	char scsi_cmd[MAX_COMMAND_SIZE];
>  	int ret;
>  
> -	if (!sdev->removable || !sdev->lockable)
> +	if (!sdev->removable || !sdev->lockable || sdev->sdev_state == SDEV_DEL)
>  	       return 0;
>  
>  	scsi_cmd[0] = ALLOW_MEDIUM_REMOVAL;

While this will fix your particular oops, I don't think it's quite
right. It's fixing one particular piece of fall out from attempting to
talk to a removed device, it's not necessarily fixing the full class of
them. The other checks in scsi_set_medium_removal() aren't related to a
changing state of the device, they are capability checks.

-- 
Jens Axboe

