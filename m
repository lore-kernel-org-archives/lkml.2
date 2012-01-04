Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab2ADPMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 10:12:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57145 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab2ADPMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 10:12:10 -0500
Message-ID: <4F046C42.30903@canonical.com>
Date: Wed, 04 Jan 2012 16:12:02 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: John Stultz <john.stultz@linaro.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sander Eikelenboom <linux@eikelenboom.it>, rjw@sisk.pl,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: Regression: ONE CPU fails bootup at Re: [3.2.0-RC7] BUG: unable
 to handle kernel NULL pointer dereference at 0000000000000598  1.478005]
 IP: [<ffffffff8107a6c4>] queue_work_on+0x4/0x30
References: <1599287628.20120103171351@eikelenboom.it> <20120103190754.GA27651@phenom.dumpdata.com> <1325632188.3037.59.camel@work-vm> <20120104113155.27bf6e46@notabene.brown> <1325638380.3037.69.camel@work-vm> <20120104122040.5a0fa6a3@notabene.brown>
In-Reply-To: <20120104122040.5a0fa6a3@notabene.brown>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/mixed;
 boundary="------------050202090103020909030507"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050202090103020909030507
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 04.01.2012 02:20, NeilBrown wrote:
> On Tue, 03 Jan 2012 16:53:00 -0800 John Stultz <john.stultz@linaro.org>
> wrote:
> 
>> On Wed, 2012-01-04 at 11:31 +1100, NeilBrown wrote:
>>> On Tue, 03 Jan 2012 15:09:48 -0800 John Stultz <john.stultz@linaro.org>
>>> wrote:
>>>>> From the stack trace, we've kicked off a rtc_timer_do_work,
>>>>> probably
>>>> from the rtc_initialize_alarm() schedule_work call added in Neil's 
>>>> patch.  From there, we call __rtc_set_alarm -> cmos_set_alarm -> 
>>>> cmos_rq_disable -> cmos_checkintr -> rtc_update_irq ->
>>>> schedule_work.
>>>> 
>>>> So, what it looks to me is that in cmos_checkintr, we grab the
>>>> cmos->rtc and pass that along. Unfortunately, since the cmos->rtc
>>>> value isn't set until after rtc_device_register() returns its null at
>>>> that point. So your patch isn't really fixing the issue, but just
>>>> reducing the race window for the second cpu to schedule the work.
>>>> 
>>>> Sigh. I'd guess dropping the schedule_work call from 
>>>> rtc_initialize_alarm() is the right approach (see below). When
>>>> reviewing Neil's patch it seemed like a good idea there, but it seems
>>>> off to me now.
>>>> 
>>>> Neil, any thoughts on the following? Can you expand on the condition
>>>> you were worried about in around that call?
>>> 
>>> If you set an alarm in the future, then shutdown and boot again after
>>> that time, then you will end up with a timer_queue node which is in the
>>> past.
>> 
>> Thanks for explaining this again.
>> 
>> Hrm. It seems the easy answer is to simply not add alarms that are in the
>> past.  Further, I'm a bit perplexed, as if they are in the past, the 
>> enabled flag shouldn't be set.   __rtc_read_alarm() does check the 
>> current time, so maybe we can make sure we don't return old values? I 
>> guess I assumed __rtc_read_alarm() avoided returning stale values, but 
>> apparently not.
> 
> That would probably be a more robust approach.  Also it might make sense
> to clean out old alarms whenever we are about to add a new one.
> 
>> 
>>> When this happens the queue gets stuck.  That entry-in-the-past won't
>>> get removed until and interrupt happens and an interrupt won't happen
>>> because the RTC only triggers an interrupt when the alarm is "now".
>>> 
>>> So you'll find that e.g. "hwclock" will always tell you that 'select'
>>> timed out.
>>> 
>>> So we force the interrupt work to happen at the start just in case.
>> 
>> Unfortunately its too early.
>> 
>>> Did you see my proposed patch which converted those calls to do the
>>> work in-process rather than passing it to a worker-thread?  I think
>>> that is a clean fix.
>> 
>> I don't think I saw it today. Was it from before the holidays?
> 
> About 4 hours ago: Subject: Re: Patch Upstream: rtc: Expire alarms after
> the time is set.
> 
>> 
>> Even so, at this point, I don't know if we have enough time for testing, 
>> so I'm thinking we either just drop the problematic sched_work call or 
>> revert the whole thing and try again for 3.3
> 
> I wouldn't object to that.  The bug only triggers in unusual circumstances 
> and is quite easy to work around so it is safer  to wait until we have a 
> really good fix.
> 
> Thanks, NeilBrown
> 
Neil, this variation would also keep the kernel from crashing in my test
environment. What do you think of that?

- -Stefan

> 
>> 
>> thanks -john
>> 
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCgAGBQJPBGw4AAoJEOhnXe7L7s6jg5YQAJ1PrNGhuXJSAevurIorc+l5
Xbyj96MRk2Z7y7c0f/OQCCKzmReNMOQ91pgok2FIamHBh55JtbgdldyTWG80Jr0M
N1jwkus1SJTIcLAeIrzoXSLU5uTvmcCcW0GBUuK98m0LDwMMJr0P1a5ilsyorRFY
ekdFIL732Cs6hn3BAlg6zVucG/kMOi3OEOtHlbKdw83VdxJ1OmjIkW9tlj/6268j
ZImuXh1XZmCJiTuCwdvdi3RVU3qZvQJi1AW0G0zsQcc2r13OQkSSoi/Wo5+6dNit
7WxSbYqeZ4hPmk67yDKjOK67kDU094end++ePtQNke0d9IePB3fRvDIi+eEkrjc5
0rJi2gLkpSyE8MJ3pBO9Bt8JCVjpY1QZnQsDT68fIHUApMnrwRK2N371JzbSim52
8VYgTfubRRdwiLlMAL7ACilFV2FKc9PcTf7FrrR2j+GZfhKTD5iy+bNvqpWaJVVT
jUrfCS79z+Z9v9/bjZ55n23gIJQn3jLk3B79plnFlwmxp9CDaAITmfzKsSB0EoZB
RF0ndDkd1Oii/XuFdqaVaMeZojPCT2rVHas2H26mH+Ihb0n9EvSBgx2L64DbRrAt
duLngf+IAO6T9ngaqnhmHwJXdwKiKGxUhWVdo92YTd16jdANd/711/B0kzHHWw4H
FT46+Os2UQJR+HsedKZg
=Kgpc
-----END PGP SIGNATURE-----

--------------050202090103020909030507
Content-Type: text/x-diff;
 name="0001-rtc-Do-not-schedule-work-in-rtc_initialize_alarm.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-rtc-Do-not-schedule-work-in-rtc_initialize_alarm.patch"

>From 0c91dc5c02c828b6b57066f99d9d2b853ced5c97 Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Wed, 4 Jan 2012 15:41:16 +0100
Subject: [PATCH] rtc: Do not schedule work in rtc_initialize_alarm

commit 93b2ec0128c431148b216b8f7337c1a52131ef03
  rtc: Expire alarms after the time is set.

added a schedule_work to rtc_initialize_alarm in order to
get alarm processing running, even in case of an alarm that
had been in the past.

However, this is called from rtc_device_register that in turn
is called from cmos_do_probe while rtc_cmos.rtc is still NULL.
If the worker fires off and tries to rtc_update_irq it will
dereference that potentially NULL pointer (this only was
observer running a Xen paravirt guest, but I think if the
timing is right could happen anywhere). So it seems better to
tickle the interrupt worker just in any case when the probe
really is complete. Worst case it should just confirm the
fact that there is no alarm.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/rtc/interface.c |    2 --
 drivers/rtc/rtc-cmos.c  |    7 +++++++
 2 files changed, 7 insertions(+), 2 deletions(-)

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
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 05beb6c..21fcb31 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -731,6 +731,13 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 		goto cleanup2;
 	}
 
+	/* I hope it will not matter much if there was not actually
+	 * some interrupt work that needed to be done. The worker
+	 * thread just should do nothing (beside of disabling the
+	 * alarm again. At least by now all other setup is done.
+	 */
+	schedule_work(&cmos_rtc.rtc->irqwork);
+
 	pr_info("%s: %s%s, %zd bytes nvram%s\n",
 		dev_name(&cmos_rtc.rtc->dev),
 		!is_valid_irq(rtc_irq) ? "no alarms" :
-- 
1.7.5.4


--------------050202090103020909030507--
