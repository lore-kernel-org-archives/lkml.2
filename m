Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab2DQXC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 19:02:57 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45619 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab2DQXC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 19:02:56 -0400
Message-ID: <4F8DF673.8050605@linaro.org>
Date: Tue, 17 Apr 2012 16:02:11 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        Greg Kroah-Hartman <greg@kroah.com>, stable@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [REGRESSION] rtc/interface.c: kills suspend-to-ram
References: <4F8BA1C1.4030804@teksavvy.com> <4F8C24E5.4020703@teksavvy.com> <CAFLxGvzkcYw-iUA1X8jK+Q8A2HFEG1SSXvfZ3Uj+OwKWgi+zAA@mail.gmail.com> <4F8C3DDF.8030103@teksavvy.com> <CAFLxGvy=3SHKFYoSfUcQrJKsCYWq5Fxpi4q_DTQjjFNDSSnJOw@mail.gmail.com> <4F8C415C.80806@teksavvy.com> <4F8C76EB.20709@linaro.org> <4F8C926D.2040503@linaro.org> <4F8CD5D3.8060006@teksavvy.com> <4F8CFC12.6050700@linaro.org> <4F8DCE74.2020906@teksavvy.com>
In-Reply-To: <4F8DCE74.2020906@teksavvy.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041723-5112-0000-0000-00000727BDDD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2012 01:11 PM, Mark Lord wrote:
> On 12-04-17 01:13 AM, John Stultz wrote:
> ..
>> -    rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
>> +    //rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
>> +    dump_stack();
> ..
>
> Okay, the call into here is coming from a "hwclock -w -u" line
> in the system suspend script.
>
> Since that command isn't touching the hardware Alarm,
> then neither should the Linux kernel.  Yet it is touching it.
> Pid: 4353, comm: hwclock Tainted: P           O 3.3.2 #5
> Call Trace:
>   [<ffffffff8123cfcd>] ? rtc_timer_remove+0x66/0xb2
>   [<ffffffff8103d2ff>] ? should_resched+0x5/0x23
>   [<ffffffff8123d21b>] ? rtc_update_irq_enable+0xd0/0x108
>   [<ffffffff812dd582>] ? __mutex_lock_common.isra.5+0x3b/0x166
>   [<ffffffff8123e058>] ? rtc_dev_ioctl+0x36d/0x468
>   [<ffffffff8101b78a>] ? do_page_fault+0x264/0x2ce
>   [<ffffffff81027650>] ? timespec_add_safe+0x33/0x63
>   [<ffffffff810077a8>] ? read_tsc+0x5/0x14
>   [<ffffffff810483fa>] ? timekeeping_get_ns+0xd/0x2a
>   [<ffffffff810ab492>] ? do_vfs_ioctl+0x45a/0x49c
>   [<ffffffff810abb8e>] ? poll_select_copy_remaining+0xdb/0xfb
>   [<ffffffff810ab511>] ? sys_ioctl+0x3d/0x60
>   [<ffffffff812df222>] ? system_call_fastpath+0x16/0x1b
>

Thanks again for testing and sending the backtrace in the other mail 
(pasted above).
Unfortunately,  I'm not sure the assessment above is correct.  If you 
strace hwclock -w -u you'll see:
...
ioctl(3, PHN_SET_REGS or RTC_UIE_ON, 0) = 0
...
ioctl(3, PHN_NOT_OH or RTC_UIE_OFF, 0)  = 0
...
Which is the UIE alarm being turned on and then back off.  The UIE mode 
has been emulated using the AIE alarm since ~2.6.38. So technically the 
kernel is touching the hardware alarm, and has been for a bit. The 
recent difference is that previously we'd drop the soft-timer and then 
it would be possible we'd get one final hardware alarm which we'd 
(ideally) ignore. But that could cause problems with systems waking up 
immediately after suspend/poweroff.  So now when we drop the soft-timer, 
if there's no other soft-timers pending, we also turn off the hardware 
alarm. Thus,  why we see rtc_timer_remove() being called from the ioctl.

>
>>       CMOS_WRITE(rtc_control, RTC_CONTROL);
>> -    hpet_mask_rtc_irq_bit(mask);
>> +    //hpet_mask_rtc_irq_bit(mask);
>>
>> -    cmos_checkintr(cmos, rtc_control);
>> +    //cmos_checkintr(cmos, rtc_control);
> ...
>
> The problem still occurs (lockup on suspend)
> with both lines above commented out.
>
> Note that it's not 100% in any case, more like 8/10,
> indicating a possible strong race condition somewhere.
Thanks again for the testing!   I'm still a little bit baffled what 
would be going on. As you said in your other mail, it seems to only 
affect certain versions of the same hardware, so its likely a bios 
issue. Even so, it could be the rtc-cmos code is just missing something.

> I think all that should be done here, is to change the kernel
> to NOT enable/disable the Alarm unless told to do so by
> an explicit userspace action.  Eg. writing to /sys/../wakealarm
> and/or /proc/acpi/alarm.
>
> If userspace leaves the alarm alone, then so should the kernel when possible.
> That's the old behaviour before the new alarm_irq_enable() stuff.
>
Well, I'd really like to better understand what is going wrong in this 
case.  Disabling the alarm shouldn't cause suspend problems, even if it 
was redundant.  So if we can better understand the mechanics of the 
issue, we can better work around it.

If you could, would you mind booting a unmodified kernel w/ "nohpet" to 
see if this is hpet related?

Then, please run with the debug patch below on an otherwise unmodified 
kernel, then send me the complete dmesg.

Finally, I don't think you sent me your .config, would you mind sending 
that as well?

Thanks so much again!
-john

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 7d5f56e..44740b8 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -303,9 +303,12 @@ static void cmos_irq_enable(struct cmos_rtc *cmos, unsigned char mask)
  	 */
  	rtc_control = CMOS_READ(RTC_CONTROL);
  	cmos_checkintr(cmos, rtc_control);
+	printk("cmos_irq_enable:  Read: 0x%02x Mask: 0x%02x ", (int)rtc_control, (int)mask);

  	rtc_control |= mask;
  	CMOS_WRITE(rtc_control, RTC_CONTROL);
+	printk("wrote: 0x%02x\n", (int)rtc_control);
+
  	hpet_set_rtc_irq_bit(mask);

  	cmos_checkintr(cmos, rtc_control);
@@ -316,8 +319,10 @@ static void cmos_irq_disable(struct cmos_rtc *cmos, unsigned char mask)
  	unsigned char	rtc_control;

  	rtc_control = CMOS_READ(RTC_CONTROL);
+	printk("cmos_irq_disable: Read: 0x%02x Mask: 0x%02x ", (int)rtc_control, (int)mask);
  	rtc_control&= ~mask;
  	CMOS_WRITE(rtc_control, RTC_CONTROL);
+	printk("wrote: 0x%02x\n", (int)rtc_control);
  	hpet_mask_rtc_irq_bit(mask);

  	cmos_checkintr(cmos, rtc_control);
@@ -554,6 +559,9 @@ static irqreturn_t cmos_interrupt(int irq, void *p)
  	 */
  	irqstat = CMOS_READ(RTC_INTR_FLAGS);
  	rtc_control = CMOS_READ(RTC_CONTROL);
+
+	printk("cmos_interrupt: irqstat: 0x%02x control: 0x%02x\n", irqstat, rtc_control);
+
  	if (is_hpet_enabled())
  		irqstat = (unsigned long)irq&  0xF0;
  	irqstat&= (rtc_control&  RTC_IRQMASK) | RTC_IRQF;
@@ -671,6 +679,13 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)

  	spin_lock_irq(&rtc_lock);

+
+
+	printk("cmos_do_probe: irqstat: 0x%02x control: 0x%02x valid: 0x%02x\n",
+			(int)CMOS_READ(RTC_INTR_FLAGS),
+			(int)CMOS_READ(RTC_CONTROL),
+			(int)CMOS_READ(RTC_VALID));
+
  	/* force periodic irq to CMOS reset default of 1024Hz;
  	 *
  	 * REVISIT it's been reported that at least one x86_64 ALI mobo



