Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443Ab1CZHVN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 03:21:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61025 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab1CZHVL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 03:21:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JRc/ExAX+bPL3rU5dyQPUW5XOAn32UkgHi5pb3F3iDBSNrEW/i1k+olPCYXWEAhMsB
         2n9VY9Ch0iw6aHgJT815NsyR5LhA6s4105JUDG98Iusb8Mn8IwsqmGvNoZzPtY2P6R6h
         B3IwO9t25M7H/Da81w2C+CKzTyg5z8n7SX+44=
MIME-Version: 1.0
In-Reply-To: <4D8D87B0.3080107@fusionio.com>
References: <4D8B4A89.80608@fusionio.com>
	<AANLkTi=zJbUpcT+vbLARyxhA34F1se8pYq9No799Zqzh@mail.gmail.com>
	<4D8D87B0.3080107@fusionio.com>
Date: Sat, 26 Mar 2011 08:21:09 +0100
X-Google-Sender-Auth: B36x9ceeEZjUZphT-CGv7VmJX7c
Message-ID: <AANLkTimy1QZiHtQGUrXLPMRGEy3iXNOB=34tFjgezhEu@mail.gmail.com>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 26, 2011 at 07:29, Jens Axboe <jaxboe@fusionio.com> wrote:
> On 2011-03-25 22:35, Geert Uytterhoeven wrote:
>> On Thu, Mar 24, 2011 at 14:43, Jens Axboe <jaxboe@fusionio.com> wrote:
>>> Jens Axboe (20):
>>>      block: remove per-queue plugging
>>
>> This one (commit 7eaceaccab5f40bbfda044629a6298616aeaed50) breaks IDE
>> on Atari/m68k under ARAnyM. It hangs on:
>>
>> | ide: Falcon IDE controller
>> | Probing IDE interface ide0...
>> | hda: Sarge m68k, ATA DISK drive
>> | ide0 at 0xfff00000 on irq 15 (serialized)
>> | ide-gd driver 1.18
>> | hda: max request size: 128KiB
>> | hda: 2118816 sectors (1084 MB) w/256KiB Cache, CHS=2102/16/63
>>
>> The next expected line is the partition parsing:
>>
>> | hda: AHDI hda1 hda2
>
> Geert, does this work for you?

Yep.Thanks!

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

> diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
> index f407784..381017c 100644
> --- a/drivers/ide/ide-io.c
> +++ b/drivers/ide/ide-io.c
> @@ -549,6 +549,9 @@ plug_device_2:
>
>        if (rq)
>                blk_requeue_request(q, rq);
> +
> +       /* Use 3ms as that was the old plug delay */
> +       blk_delay_queue(q, msecs_to_jiffies(3));
>  }
>
>  void ide_requeue_and_plug(ide_drive_t *drive, struct request *rq)
> @@ -561,6 +564,8 @@ void ide_requeue_and_plug(ide_drive_t *drive, struct request *rq)
>        if (rq)
>                blk_requeue_request(q, rq);
>
> +       /* Use 3ms as that was the old plug delay */
> +       blk_delay_queue(q, msecs_to_jiffies(3));
>        spin_unlock_irqrestore(q->queue_lock, flags);
>  }
>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
