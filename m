Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab1CYMVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 08:21:55 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55158 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1CYMVy (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 25 Mar 2011 08:21:54 -0400
Date: Fri, 25 Mar 2011 08:21:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: John Stultz <john.stultz@linaro.org>
Cc: tglx@linutronix.de, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: 2.6.39 crashes BUG: unable to handle kernel
 NULL pointer dereference at 000000000000042 .. cmos_checkintr+0x4d/0x55
 under Xen as PV guest.
Message-ID: <20110325122139.GA27651@dumpdata.com>
References: <20110318203830.GA9262@dumpdata.com>
 <1300485566.2731.46.camel@work-vm>
 <20110319025134.GA3298@dumpdata.com>
 <1300736400.2731.66.camel@work-vm>
 <20110322143841.GA26952@dumpdata.com>
 <20110324122755.GA31974@dumpdata.com>
 <1300993535.848.110.camel@work-vm>
 <1300999174.848.122.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300999174.848.122.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D8C88D5.006E,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 01:39:34PM -0700, John Stultz wrote:
> On Thu, 2011-03-24 at 12:05 -0700, John Stultz wrote:
> > Or... more likely, the added rtc_set_alarm is enabling interrupts,
> > allowing an irq to land before the rtc_device_register completes.
> > 
> > Oof.. ok. so that is a little gross.
> > 
> > 
> > Let me see if I can't work something out here.
> 
> Konrad: Can you give this patch a shot to see if it changes the
> behavior?

Yup. It fixes it. Tested on PV i386 and x86_64 case. And also
as the initial domain as 32-bit and 64-bit.

Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Thank you for fixing it!
> 
> Basically we still initialize the alarm timer from whatever the hardware
> is set to at boot time, but don't use the standard rtc_set_alarm, and
> instead initialize the aie_timer and enqueue it by hand.
> 
> That should avoid having rtc_set_alarm enabling irqs possibly too early.
> 
> thanks
> -john
> 
> 
> 
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> 
> diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
> index 09b4437..3901386 100644
> --- a/drivers/rtc/class.c
> +++ b/drivers/rtc/class.c
> @@ -171,7 +171,7 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
>  	err = __rtc_read_alarm(rtc, &alrm);
>  
>  	if (!err && !rtc_valid_tm(&alrm.time))
> -		rtc_set_alarm(rtc, &alrm);
> +		rtc_initialize_alarm(rtc, &alrm);
>  
>  	strlcpy(rtc->name, name, RTC_DEVICE_NAME_SIZE);
>  	dev_set_name(&rtc->dev, "rtc%d", id);
> diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
> index 8ec6b06..b2fea80 100644
> --- a/drivers/rtc/interface.c
> +++ b/drivers/rtc/interface.c
> @@ -375,6 +375,32 @@ int rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
>  }
>  EXPORT_SYMBOL_GPL(rtc_set_alarm);
>  
> +/* Called once per device from rtc_device_register */
> +int rtc_initialize_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
> +{
> +	int err;
> +
> +	err = rtc_valid_tm(&alarm->time);
> +	if (err != 0)
> +		return err;
> +
> +	err = mutex_lock_interruptible(&rtc->ops_lock);
> +	if (err)
> +		return err;
> +
> +	rtc->aie_timer.node.expires = rtc_tm_to_ktime(alarm->time);
> +	rtc->aie_timer.period = ktime_set(0, 0);
> +	if (alarm->enabled) {
> +		rtc->aie_timer.enabled = 1;
> +		timerqueue_add(&rtc->timerqueue, &rtc->aie_timer.node);
> +	}
> +	mutex_unlock(&rtc->ops_lock);
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(rtc_initialize_alarm);
> +
> +
> +
>  int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled)
>  {
>  	int err = mutex_lock_interruptible(&rtc->ops_lock);
> diff --git a/include/linux/rtc.h b/include/linux/rtc.h
> index 2ca7e8a..877ece4 100644
> --- a/include/linux/rtc.h
> +++ b/include/linux/rtc.h
> @@ -228,6 +228,8 @@ extern int rtc_read_alarm(struct rtc_device *rtc,
>  			struct rtc_wkalrm *alrm);
>  extern int rtc_set_alarm(struct rtc_device *rtc,
>  				struct rtc_wkalrm *alrm);
> +extern int rtc_initialize_alarm(struct rtc_device *rtc,
> +				struct rtc_wkalrm *alrm);
>  extern void rtc_update_irq(struct rtc_device *rtc,
>  			unsigned long num, unsigned long events);
>  
> 
