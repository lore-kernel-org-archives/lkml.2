Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab1IHAWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 20:22:16 -0400
Received: from gretna.indigovision.com ([62.7.85.227]:39320 "EHLO
	gretna.indigovision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab1IHAWN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 20:22:13 -0400
From: Bruce Stenning <b.stenning@indigovision.com>
To: Tejun Heo <htejun@gmail.com>
CC: Mark Lord <kernel@teksavvy.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Date: Wed, 7 Sep 2011 13:09:10 +0100
Subject: RE: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Topic: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Index: Acxst728k3UUYXA1TRyldt4Qu/pBogAnmOzg
Message-ID: <C1438B59050E1B4C9482FF3266AD6BA32D8DA54C99@gretna.indigovision.com>
References: <4DF25526.9010800@teksavvy.com>
 <20110611121957.GA7980@mtj.dyndns.org> <4DF4F30B.70702@teksavvy.com>
 <20110613104856.GC16021@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32D8D984D03@gretna.indigovision.com>
 <20110902011305.GE2752@htj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32D8D9854F7@gretna.indigovision.com>
 <20110906034544.GB18425@mtj.dyndns.org>
 <C1438B59050E1B4C9482FF3266AD6BA32D8DA54B00@gretna.indigovision.com>
 <20110906163355.GG18425@mtj.dyndns.org>
 <20110906164221.GH18425@mtj.dyndns.org>
In-Reply-To: <20110906164221.GH18425@mtj.dyndns.org>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Sorry for sending so many emails yesterday; I blame the dental anaesthetic
I received in the morning for being so jumpy on the send button ;-)

> Can you please instrument the followings?
>
> * print the caller of scsi_eh_wakeup().  "%pF" w/ (void *)_RET_IP_
>   should do it.
>
> * print why scsi_eh is going back to sleep immediately.
>   ie. shost->host_failed, host_eh_scheduled, host_busy in
>   scsi_error_handler().  It would also be nice to add some printks
>   around schedule() and enable PRINTK_TIME.

I can certainly try this.  Could you confirm whether my thoughts about a race
between the scsi_eh thread and the wake-up are plausible?  I backtracked
yesterday because I thought the scsi_eh thread would get rescheduled naturally,
not realising that when the task state is TASK_INTERRUPTIBLE schedule() takes
the task off the run queue (so it needs to be explicitly woken.)

Here is my thinking again:

shost->host_eh_scheduled is read here in scsi_error_handler:

        set_current_state(TASK_INTERRUPTIBLE);
        while (!kthread_should_stop()) {
                if ((shost->host_failed == 0 && shost->host_eh_scheduled == 0) ||

There's no locking in scsi_error_handler (though functions it calls probably
claim locks.)

When scheduling an EH, scsi_schedule_eh takes the shost->host_lock, increments
shost->host_eh_scheduled, and then wakes the EH thread.  If this happens
between the scsi_eh thread reading host_eh_scheduled and sending itself back
to sleep (when the scsi_eh thread's state is TASK_INTERRUPTIBLE) nothing will
wake up the thread again and host_eh_scheduled will not get inspected.
host_eh_scheduled is stuck at 1 with the scsi_eh thread asleep, and it won't
get woken again because the ata port has been frozen and irqs are masked off.

Bruce.


Latest News at: http://www.indigovision.com/index.php/en/news.html
