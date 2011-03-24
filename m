Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933818Ab1CXTFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:05:47 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42297 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334Ab1CXTFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:05:45 -0400
Subject: Re: [Xen-devel] Re: 2.6.39 crashes BUG: unable to handle kernel
 NULL pointer dereference at 000000000000042 .. cmos_checkintr+0x4d/0x55
 under Xen as PV guest.
From: John Stultz <john.stultz@linaro.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: tglx@linutronix.de, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110324122755.GA31974@dumpdata.com>
References: <20110318203830.GA9262@dumpdata.com>
	 <1300485566.2731.46.camel@work-vm> <20110319025134.GA3298@dumpdata.com>
	 <1300736400.2731.66.camel@work-vm> <20110322143841.GA26952@dumpdata.com>
	 <20110324122755.GA31974@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Mar 2011 12:05:35 -0700
Message-ID: <1300993535.848.110.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-24 at 08:27 -0400, Konrad Rzeszutek Wilk wrote:
> The problem is this:
> 
> cmos_do_probe does:
> 
>  	cmos_rtc.dev = dev; 
>         dev_set_drvdata(dev, &cmos_rtc);
> 
> which means that dev->p->private_data contains cmos_rtc. And
> dev->p->private_data->rtc is a NULL pointer. The next function:
> 
>         cmos_rtc.rtc = rtc_device_register(driver_name, dev, 
>                                 &cmos_rtc_ops, THIS_MODULE);
> 
> 'rtc_device_register' creates an 'rtc' structure and sets 
> its parent to be:
> 	rtc->dev.parent = dev;

And rtc_device_register() also calls:
	INIT_WORK(&rtc->irqwork, rtc_timer_do_work);


> and later on it does:
>  if (!err && !rtc_valid_tm(&alrm.time))
>                 rtc_set_alarmtrtc, &alrm);
> 
> rtc_set_alarm calls rtc_timer_enqueue which calls __rtc_set_alarm.
> __rtc_set_alarms calls 'cmos_set_alarm' via:
>  err = rtc->ops->set_alarm(rtc->dev.parent, alarm);
> 
> which is basically passing in 'dev' to 'cmos_set_alarm', and
> 'cmos_set_alarm' uses the dev to:
>         struct cmos_rtc *cmos = dev_get_drvdata(dev);
> 
> (so get the from dev->p->private_data the cmos_rtc).
> get the 'cmos' (which is what 'cmos_rtc').


Ok. So this all seems like it is working as it should, although you
stated something to the effect that Xen doesn't support the cmos? And
here it seems like it is being probed and registered without issue.


>  Great... except
> then it ends up trying to dereference cmos->rtc.irqwork (via
> cmos_irq_disable(cmos, .. and somehere in its chain calls
> schedule_work(cmos->rtc) whcih ends up blowing up b/c
> cmos_rtc.rtc has not been set yet.
> 
> The cmos_rtc.rtc is set when the when 'rtc_device_register'
> finish, which it hadn't yet done.

Ok, so you're saying we've not completed rtc_device_register, when
something calls rtc_update_irq(), which then tries to schedule the work,
which hasn't been initialized.

> git gui blame tells me to look at 
>  f44f7f96a20af16f6f12e1c995576d6becf5f57b

Hmm. So this seems even more odd at first glance, as we're really just
adding an extra call in rtc_device_register(), which supposedly isn't
being run yet.

But... maybe the extra call in rtc_device_register is actually slowing
it down enough, and if an irq lands in the cmos code before the
device_register code is complete, that might cause trouble.

Or... more likely, the added rtc_set_alarm is enabling interrupts,
allowing an irq to land before the rtc_device_register completes.

Oof.. ok. so that is a little gross.


Let me see if I can't work something out here.

Thanks for the helpful clues here!
-john




