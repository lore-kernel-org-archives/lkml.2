Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731Ab1IHBQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 21:16:53 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65105 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757688Ab1IHBQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 21:16:50 -0400
Date: Thu, 8 Sep 2011 10:16:40 +0900
From: Tejun Heo <htejun@gmail.com>
To: Bruce Stenning <b.stenning@indigovision.com>
Cc: Mark Lord <kernel@teksavvy.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Message-ID: <20110908011640.GA5381@mtj.dyndns.org>
References: <4DF4F30B.70702@teksavvy.com>
 <20110613104856.GC16021@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32D8D984D03@gretna.indigovision.com>
 <20110902011305.GE2752@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32D8D9854F7@gretna.indigovision.com>
 <20110906034544.GB18425@mtj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32D8DA54B00@gretna.indigovision.com>
 <20110906163355.GG18425@mtj.dyndns.org>
 <20110906164221.GH18425@mtj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32D8DA54C99@gretna.indigovision.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C1438B59050E1B4C9482FF3266AD6BA32D8DA54C99@gretna.indigovision.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Sep 07, 2011 at 01:09:10PM +0100, Bruce Stenning wrote:
> Sorry for sending so many emails yesterday; I blame the dental anaesthetic
> I received in the morning for being so jumpy on the send button ;-)

Oh the fun. :)

> I can certainly try this.  Could you confirm whether my thoughts about a race
> between the scsi_eh thread and the wake-up are plausible?  I backtracked
> yesterday because I thought the scsi_eh thread would get rescheduled naturally,
> not realising that when the task state is TASK_INTERRUPTIBLE schedule() takes
> the task off the run queue (so it needs to be explicitly woken.)
> 
> Here is my thinking again:
> 
> shost->host_eh_scheduled is read here in scsi_error_handler:
> 
>         set_current_state(TASK_INTERRUPTIBLE);
>         while (!kthread_should_stop()) {
>                 if ((shost->host_failed == 0 && shost->host_eh_scheduled == 0) ||
> 
> There's no locking in scsi_error_handler (though functions it calls probably
> claim locks.)
> 
> When scheduling an EH, scsi_schedule_eh takes the shost->host_lock, increments
> shost->host_eh_scheduled, and then wakes the EH thread.  If this happens
> between the scsi_eh thread reading host_eh_scheduled and sending itself back
> to sleep (when the scsi_eh thread's state is TASK_INTERRUPTIBLE) nothing will
> wake up the thread again and host_eh_scheduled will not get inspected.
> host_eh_scheduled is stuck at 1 with the scsi_eh thread asleep, and it won't
> get woken again because the ata port has been frozen and irqs are masked off.

I don't think there's a race condition there.  set_current_state()
implies memory barrier and wake_up_process() implies wmb().  host_eh
either sees the inrecremented eh_scheduled count or TASK_RUNNING set
by wake_up_process(), so it can't miss an event.

Thanks.

-- 
tejun
