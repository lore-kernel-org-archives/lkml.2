Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab1CXM2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 08:28:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46006 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681Ab1CXM2I (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 24 Mar 2011 08:28:08 -0400
Date: Thu, 24 Mar 2011 08:27:55 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: John Stultz <john.stultz@linaro.org>
Cc: tglx@linutronix.de, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: 2.6.39 crashes BUG: unable to handle kernel
 NULL pointer dereference at 000000000000042 .. cmos_checkintr+0x4d/0x55
 under Xen as PV guest.
Message-ID: <20110324122755.GA31974@dumpdata.com>
References: <20110318203830.GA9262@dumpdata.com>
 <1300485566.2731.46.camel@work-vm>
 <20110319025134.GA3298@dumpdata.com>
 <1300736400.2731.66.camel@work-vm>
 <20110322143841.GA26952@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110322143841.GA26952@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D8B38CC.0158,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 10:38:41AM -0400, Konrad Rzeszutek Wilk wrote:
> > > No. 2.6.38 vaniall works great.
> > 
> > Ok. Hrm. 
> > 
> > > > Any insight there?
> > > 
> > > I hoped you might have :-)
> > 
> > Could you help me understand where in the probe logic xen bombs out of
> > the cmos code?
> 
> Sure. The issue is that rtc_update_irq calls schedule_work with rtc->irqwork
> which has not been initialized. The reason for that is that rtc_device_register
> has never been called.. uh wait, that does not make sense, it is called in
> cmos_do_probe. Hmm, let get find out exactly on which variable queue_work_on
> bombs out on.

The problem is this:

cmos_do_probe does:

 	cmos_rtc.dev = dev; 
        dev_set_drvdata(dev, &cmos_rtc);

which means that dev->p->private_data contains cmos_rtc. And
dev->p->private_data->rtc is a NULL pointer. The next function:

        cmos_rtc.rtc = rtc_device_register(driver_name, dev, 
                                &cmos_rtc_ops, THIS_MODULE);

'rtc_device_register' creates an 'rtc' structure and sets 
its parent to be:
	rtc->dev.parent = dev;

and later on it does:
 if (!err && !rtc_valid_tm(&alrm.time))
                rtc_set_alarmtrtc, &alrm);

rtc_set_alarm calls rtc_timer_enqueue which calls __rtc_set_alarm.
__rtc_set_alarms calls 'cmos_set_alarm' via:
 err = rtc->ops->set_alarm(rtc->dev.parent, alarm);

which is basically passing in 'dev' to 'cmos_set_alarm', and
'cmos_set_alarm' uses the dev to:
        struct cmos_rtc *cmos = dev_get_drvdata(dev);

(so get the from dev->p->private_data the cmos_rtc).
get the 'cmos' (which is what 'cmos_rtc'). Great... except
then it ends up trying to dereference cmos->rtc.irqwork (via
cmos_irq_disable(cmos, .. and somehere in its chain calls
schedule_work(cmos->rtc) whcih ends up blowing up b/c
cmos_rtc.rtc has not been set yet.

The cmos_rtc.rtc is set when the when 'rtc_device_register'
finish, which it hadn't yet done.

git gui blame tells me to look at 
 f44f7f96a20af16f6f12e1c995576d6becf5f57b
