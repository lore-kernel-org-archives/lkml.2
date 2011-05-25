Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab1EYBl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 21:41:27 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54299 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab1EYBl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 21:41:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=g7E4Rx7eqhutvN+x4B8zt7eyMwBXYxR3rX2ZgYm7qNxnuAGei0ttfFRNyrhKeYEMFL
         Wsqu109nAi4wGpG8H5gwR2BiEweQx23xoeqid6wJT2T6BkXcVLh8KrzWPR9GzSryPnIr
         KZhBmc+D9M4AYKvMVVrsld223XgZG/cXUFlII=
Date: Tue, 24 May 2011 21:41:17 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@ubuntu-natty
To: Jens Axboe <jaxboe@fusionio.com>
cc: Parag Warudkar <parag.lkml@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        Linux SCSI List <linux-scsi@vger.kernel.org>
Subject: [PATCH] SCSI IOCTL: Check for device deletion [was Re: __elv_add_request
 OOPS]
In-Reply-To: <4DDB8BF6.2000304@fusionio.com>
Message-ID: <alpine.DEB.2.02.1105242127340.3472@ubuntu-natty>
References: <alpine.DEB.2.02.1105232329040.1910@natty-nar> <4DDB8BF6.2000304@fusionio.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 May 2011, Jens Axboe wrote:

> On 2011-05-24 06:29, Parag Warudkar wrote:
> > 
> > External DVD drive - connected when suspended, removed before resume.
> > Results in NULL pointer dereference in __blk_add_request on resume.
> > 
> > *ffffffff811d6503:      48 89 58 08             mov    %rbx,0x8(%rax) |
> > %ebx = ffff880131559020 <--- faulting instruction
> > 
> > 48 89 58 08 appears only in list_add :
> > 
> > static inline void list_add(struct list_head *new, struct list_head *head)
> > {
> >         __list_add(new, head, head->next);
> > ffffffff81ac012c:       49 8b 04 24             mov    (%r12),%rax
> > #ifndef CONFIG_DEBUG_LIST
> > static inline void __list_add(struct list_head *new,
> >                               struct list_head *prev,
> >                               struct list_head *next)
> > {
> >         next->prev = new;
> > ffffffff81ac0130:       48 89 58 08             mov    %rbx,0x8(%rax)
> > 
> > AFAICS list_add is only called from one place in __elv_add_request :
> > 
> >        switch (where) {
> >         case ELEVATOR_INSERT_REQUEUE:
> >         case ELEVATOR_INSERT_FRONT:
> >                 rq->cmd_flags |= REQ_SOFTBARRIER;
> >               **  list_add(&rq->queuelist, &q->queue_head);
> >                 break;
> > 
> > Now, where is the patch? :)
> 
> You forgot to attach it?
> 
> This is clearly q == NULL [snip]

OK, I think this patch should do the trick.

Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>
Reported-and-tested-by: Parag Warudkar <parag.lkml@gmail.com>
 
Check for device deletion before sending it a scsi command. This fixes an 
OOPS I was seeing during resume when the external dvd drive was removed 
while suspended.

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index d9564fb..cc4edbf 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -136,7 +136,7 @@ int scsi_set_medium_removal(struct scsi_device *sdev, char state)
 	char scsi_cmd[MAX_COMMAND_SIZE];
 	int ret;
 
-	if (!sdev->removable || !sdev->lockable)
+	if (!sdev->removable || !sdev->lockable || sdev->sdev_state == SDEV_DEL)
 	       return 0;
 
 	scsi_cmd[0] = ALLOW_MEDIUM_REMOVAL;
