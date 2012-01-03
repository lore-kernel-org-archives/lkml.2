Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab2ACXL2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 18:11:28 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36092 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab2ACXLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 18:11:23 -0500
Message-ID: <1325632188.3037.59.camel@work-vm>
Subject: Re: Regression: ONE CPU fails bootup at Re: [3.2.0-RC7] BUG: unable
 to handle kernel NULL pointer dereference at 0000000000000598 [   
 1.478005] IP: [<ffffffff8107a6c4>] queue_work_on+0x4/0x30
From: John Stultz <john.stultz@linaro.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Sander Eikelenboom <linux@eikelenboom.it>, neilb@suse.de,
        stefan.bader@canonical.com, rjw@sisk.pl,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Date: Tue, 03 Jan 2012 15:09:48 -0800
In-Reply-To: <20120103190754.GA27651@phenom.dumpdata.com>
References: <1599287628.20120103171351@eikelenboom.it>
	 <20120103190754.GA27651@phenom.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12010323-8974-0000-0000-000004D98C9A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-03 at 14:07 -0500, Konrad Rzeszutek Wilk wrote:
> On Tue, Jan 03, 2012 at 05:13:51PM +0100, Sander Eikelenboom wrote:
> > Hi all,
> > 
> > While trying a vanilla 3.2.0-rc7+ kernel (commit 115e8e705e4be071b9e06ff72578e3b603f2ba65) as host and guest kernels under Xen:
> > 
> > The kernels only boot when a guest has MORE than 1 cpu, with ONE CPU it gives this stacktrace:
> 
[snip]
> Is this by any chance related to "rtc: Expire alarms after the time is set."
> (93b2ec0128c431148b216b8f7337c1a52131ef03) which breaks Amazon EC2 instances?
> 
[snip]
> > 
> > [    1.074218] i8042: No controller found
> > [    1.074510] mousedev: PS/2 mouse device common for all mice
> > [    1.233365] BUG: unable to handle kernel NULL pointer dereference at 0000000000000598
> > [    1.233382] IP: [<ffffffff8107a6c4>] queue_work_on+0x4/0x30
> > [    1.233394] PGD 0
> > [    1.233399] Oops: 0002 [#1] SMP
> > [    1.233406] CPU 0
> > [    1.233409] Modules linked in:
> > [    1.233415]
> > [    1.233419] Pid: 586, comm: kworker/0:1 Not tainted 3.2.0-rc7+ #1
> > [    1.233427] RIP: e030:[<ffffffff8107a6c4>]  [<ffffffff8107a6c4>] queue_work_on+0x4/0x30
> > [    1.233436] RSP: e02b:ffff88000ee07b20  EFLAGS: 00010002
> > [    1.233441] RAX: ffff88000ecea000 RBX: ffffffff82729c80 RCX: 00005684b0256000
> > [    1.233447] RDX: 0000000000000598 RSI: ffff88000ecea000 RDI: 0000000000000000
> > [    1.233452] RBP: ffff88000ee07b20 R08: 0000000000000000 R09: 0000000000000001
> > [    1.233458] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000ffffffd0
> > [    1.233464] R13: 00000000000000ff R14: 0000000000000023 R15: 0000000000000014
> > [    1.233472] FS:  0000000000000000(0000) GS:ffff88000ffd5000(0000) knlGS:0000000000000000
> > [    1.233479] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [    1.233484] CR2: 0000000000000598 CR3: 0000000001e05000 CR4: 0000000000000660
> > [    1.233490] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [    1.233496] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > [    1.233502] Process kworker/0:1 (pid: 586, threadinfo ffff88000ee06000, task ffff88000edbbe80)
> > [    1.233508] Stack:
> > [    1.233511]  ffff88000ee07b30 ffffffff8107a72a ffff88000ee07b40 ffffffff8107a743
> > [    1.233522]  ffff88000ee07b50 ffffffff81575250 ffff88000ee07b80 ffffffff815779c7
> > [    1.233533]  ffffffff81e10500 00000000000000df 0000000000000020 ffffffff82729c80
> > [    1.233545] Call Trace:
> > [    1.233550]  [<ffffffff8107a72a>] queue_work+0x1a/0x20
> > [    1.233556]  [<ffffffff8107a743>] schedule_work+0x13/0x20
> > [    1.233564]  [<ffffffff81575250>] rtc_update_irq+0x10/0x20
> > [    1.233571]  [<ffffffff815779c7>] cmos_checkintr+0x67/0x70
> > [    1.233577]  [<ffffffff81577a1d>] cmos_irq_disable+0x4d/0x60
> > [    1.233583]  [<ffffffff81578ad1>] ? cmos_set_alarm+0xc1/0x220
> > [    1.234342]  [<ffffffff81578ade>] cmos_set_alarm+0xce/0x220
> > [    1.234342]  [<ffffffff81574c43>] ? rtc_time_to_tm+0xe3/0x1b0
> > [    1.234342]  [<ffffffff8157541b>] __rtc_set_alarm+0x9b/0xa0
> > [    1.234342]  [<ffffffff81575899>] rtc_timer_do_work+0x1c9/0x1e0
> > [    1.234342]  [<ffffffff81096127>] ? lock_acquire+0x97/0xb0
> > [    1.234342]  [<ffffffff81079d20>] process_one_work+0x190/0x450
> > [    1.234342]  [<ffffffff81079cbf>] ? process_one_work+0x12f/0x450
> > [    1.234342]  [<ffffffff815756d0>] ? rtc_timer_start+0x80/0x80
> > [    1.234342]  [<ffffffff8107cb21>] worker_thread+0x171/0x3a0
> > [    1.234342]  [<ffffffff8107c9b0>] ? manage_workers+0x210/0x210
> > [    1.234342]  [<ffffffff81081526>] kthread+0x96/0xa0
> > [    1.234342]  [<ffffffff818ed774>] kernel_thread_helper+0x4/0x10
> > [    1.234342]  [<ffffffff818eb7f8>] ? int_ret_from_sys_call+0x7/0x1b
> > [    1.234342]  [<ffffffff818e4e45>] ? retint_restore_args+0x5/0x6
> > [    1.234342]  [<ffffffff818ed770>] ? gs_change+0x13/0x13

Hey Konrad,
	So I'm looking at the patch, and its not obviously sticking out to me
why the patch you posted should resolve the issue.

Specifically, what is being done in the following that it fails before
and not after?

	strlcpy(rtc->name, name, RTC_DEVICE_NAME_SIZE);
	dev_set_name(&rtc->dev, "rtc%d", id);

	rtc_dev_prepare(rtc);

	err = device_register(&rtc->dev);
	if (err) {
		put_device(&rtc->dev);
		goto exit_kfree;
	}

	rtc_dev_add_device(rtc);
	rtc_sysfs_add_device(rtc);
	rtc_proc_add_device(rtc);


>From the stack trace, we've kicked off a rtc_timer_do_work, probably
from the rtc_initialize_alarm() schedule_work call added in Neil's
patch.  From there, we call __rtc_set_alarm -> cmos_set_alarm ->
cmos_rq_disable -> cmos_checkintr -> rtc_update_irq -> schedule_work.

So, what it looks to me is that in cmos_checkintr, we grab the cmos->rtc
and pass that along. Unfortunately, since the cmos->rtc value isn't set
until after rtc_device_register() returns its null at that point. So
your patch isn't really fixing the issue, but just reducing the race
window for the second cpu to schedule the work.

Sigh. I'd guess dropping the schedule_work call from
rtc_initialize_alarm() is the right approach (see below). When reviewing
Neil's patch it seemed like a good idea there, but it seems off to me
now.

Neil, any thoughts on the following? Can you expand on the condition you
were worried about in around that call?

thanks
-john

Drop schedule_work() call in rtc_initialize_alarm, as we're not finished
setting things up and can't handle triggering the alarm yet.

Signed-off-by: John Stultz <john.stultz@linaro.org>

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 3bcc7cf..084a137 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -407,8 +407,6 @@ int rtc_initialize_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 		timerqueue_add(&rtc->timerqueue, &rtc->aie_timer.node);
 	}
 	mutex_unlock(&rtc->ops_lock);
-	/* maybe that was in the past.*/
-	schedule_work(&rtc->irqwork);
 	return err;
 }
 EXPORT_SYMBOL_GPL(rtc_initialize_alarm);




