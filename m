Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab2DQUMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 16:12:23 -0400
Received: from ironport-out.teksavvy.com ([206.248.143.162]:43286 "EHLO
	ironport-out.teksavvy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab2DQUMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 16:12:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuEBACxOgk8Y9geI/2dsb2JhbAANNoVzsCSGLAEBAQECASMEUQEFCwsYAgIFFgsCAgkDAgECAUUGDQEHAQGIBawfihiBL44TgRgEqSWBOBY
X-IronPort-AV: E=Sophos;i="4.75,391,1330923600"; 
   d="scan'208";a="174927313"
Message-ID: <4F8DCEA4.9010605@teksavvy.com>
Date: Tue, 17 Apr 2012 16:12:20 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        Greg Kroah-Hartman <greg@kroah.com>, stable@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [REGRESSION] rtc/interface.c: kills suspend-to-ram
References: <4F8BA1C1.4030804@teksavvy.com> <4F8C24E5.4020703@teksavvy.com> <CAFLxGvzkcYw-iUA1X8jK+Q8A2HFEG1SSXvfZ3Uj+OwKWgi+zAA@mail.gmail.com> <4F8C3DDF.8030103@teksavvy.com> <CAFLxGvy=3SHKFYoSfUcQrJKsCYWq5Fxpi4q_DTQjjFNDSSnJOw@mail.gmail.com> <4F8C415C.80806@teksavvy.com> <4F8C76EB.20709@linaro.org> <4F8C926D.2040503@linaro.org> <4F8CD5D3.8060006@teksavvy.com> <4F8CFC12.6050700@linaro.org> <4F8DCE74.2020906@teksavvy.com>
In-Reply-To: <4F8DCE74.2020906@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-04-17 04:11 PM, Mark Lord wrote:
> On 12-04-17 01:13 AM, John Stultz wrote:
> ..
>> -    rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
>> +    //rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
>> +    dump_stack();
> ..
> 
> Okay, the call into here is coming from a "hwclock -w -u" line
> in the system suspend script.

Forgot the stack dump:

Pid: 4353, comm: hwclock Tainted: P           O 3.3.2 #5
Call Trace:
 [<ffffffff8123cfcd>] ? rtc_timer_remove+0x66/0xb2
 [<ffffffff8103d2ff>] ? should_resched+0x5/0x23
 [<ffffffff8123d21b>] ? rtc_update_irq_enable+0xd0/0x108
 [<ffffffff812dd582>] ? __mutex_lock_common.isra.5+0x3b/0x166
 [<ffffffff8123e058>] ? rtc_dev_ioctl+0x36d/0x468
 [<ffffffff8101b78a>] ? do_page_fault+0x264/0x2ce
 [<ffffffff81027650>] ? timespec_add_safe+0x33/0x63
 [<ffffffff810077a8>] ? read_tsc+0x5/0x14
 [<ffffffff810483fa>] ? timekeeping_get_ns+0xd/0x2a
 [<ffffffff810ab492>] ? do_vfs_ioctl+0x45a/0x49c
 [<ffffffff810abb8e>] ? poll_select_copy_remaining+0xdb/0xfb
 [<ffffffff810ab511>] ? sys_ioctl+0x3d/0x60
 [<ffffffff812df222>] ? system_call_fastpath+0x16/0x1b

> Since that command isn't touching the hardware Alarm,
> then neither should the Linux kernel.  Yet it is touching it.
> 
>>      CMOS_WRITE(rtc_control, RTC_CONTROL);
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
> 
> I think all that should be done here, is to change the kernel
> to NOT enable/disable the Alarm unless told to do so by
> an explicit userspace action.  Eg. writing to /sys/../wakealarm
> and/or /proc/acpi/alarm.
> 
> If userspace leaves the alarm alone, then so should the kernel when possible.
> That's the old behaviour before the new alarm_irq_enable() stuff.
> 
> Cheers

