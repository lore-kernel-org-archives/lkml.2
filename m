Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992602Ab2KAWnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 18:43:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:35578 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762306Ab2KAWnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 18:43:12 -0400
Date: Thu, 1 Nov 2012 23:43:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
cc: Oliver Neukum <oneukum@suse.de>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] alarmtimer: Replace the spinlock rtcdev_lock with
 mutex
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A1B9C8A@SHSMSX101.ccr.corp.intel.com>
Message-ID: <alpine.LFD.2.02.1211012306240.2756@ionos>
References: <1351700455.15558.1571.camel@cliu38-desktop-build> <2035297.QqCM5sVoD5@linux-lqwf.site> <27240C0AC20F114CBF8149A2696CBE4A1B9C8A@SHSMSX101.ccr.corp.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2012, Liu, Chuansheng wrote:
> > From: Oliver Neukum [mailto:oneukum@suse.de]
> > On Thursday 01 November 2012 00:20:55 Chuansheng Liu wrote:
> > > When do code reviewing, found no special requirement to
> > > use spin_lock_irqsave/spin_unlock_irqrestore, because
> > > alarmtimer_get_rtcdev() is called by posix clock interface.
> > > So would like to use mutex to replace it.
> > 
> > What is gained thereby?
> spin_lock_irqsave will disable the preempt and local irq, it is expensive than
> mutex. Thanks.

Let's have a look at how expensive that is. The function which is
relevant is alarmtimer_get_rtcdev(), which does:

        spin_lock_irqsave(&rtcdev_lock, flags);
        ret = rtcdev;
        spin_unlock_irqrestore(&rtcdev_lock, flags);
        return ret;

So now you make rtcdev_lock a mutex, which means that for a single
protected instruction i.e "ret = rtcdev" you want to use a
serialization mechanism which is way more expensive when it actually
comes to a contention.

Now we could debate this back and forth, but this is pointless as your
code review missed the real issue:

 "Protecting" the dereferencing of rtcdev with any kind of lock does
 not provide any useful protection at all.

Lets look at the code which manipulates rtcdev.

The only function which does that is alarmtimer_rtc_add_device(). This
function only can set the pointer ONCE. Now that function needs a
serialization and again we can debate whether this needs to be a
spinlock or a mutex. So now that we know that a device which has been
registered with that function can never go away and is never going to
change, it's completely pointless to have a lock in
alarmtimer_get_rtcdev() at all.

It's safe to do in any code path which wants to use rtcdev:

     if (!rtcdev)
     	return -ENODEV:
     do_something(rtcdev);

Thanks,

	tglx
