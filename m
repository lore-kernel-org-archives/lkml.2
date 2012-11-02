Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762722Ab2KBDmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 23:42:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:19811 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762674Ab2KBDmH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 23:42:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,696,1344236400"; 
   d="scan'208";a="236083983"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] alarmtimer: Using the alarmtimer_get_rtcdev for all
 posix clock interface
Thread-Topic: [PATCH 2/3] alarmtimer: Using the alarmtimer_get_rtcdev for
 all posix clock interface
Thread-Index: AQHNuIQC5CVh2ojgZ0i28n1otBAKtpfV5KWQ
Date: Fri, 2 Nov 2012 03:41:14 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A1BAAD8@SHSMSX101.ccr.corp.intel.com>
References: <1351700455.15558.1571.camel@cliu38-desktop-build>
 <1351700583.15558.1573.camel@cliu38-desktop-build>
 <alpine.LFD.2.02.1211012343120.2756@ionos>
In-Reply-To: <alpine.LFD.2.02.1211012343120.2756@ionos>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Friday, November 02, 2012 6:56 AM
> To: Liu, Chuansheng
> Cc: john.stultz@linaro.org; gregkh@linuxfoundation.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 2/3] alarmtimer: Using the alarmtimer_get_rtcdev for all
> posix clock interface
> 
> On Thu, 1 Nov 2012, Chuansheng Liu wrote:
> >
> > Some posix clock interface directly use the variable rtcdev,
> > cleanup it here by alarmtimer_get_rtcdev().
> >
> > Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> > ---
> >  kernel/time/alarmtimer.c |   13 ++++++-------
> >  1 files changed, 6 insertions(+), 7 deletions(-)
> >
> > diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
> > index 4fc17cb..5490fa8 100644
> > --- a/kernel/time/alarmtimer.c
> > +++ b/kernel/time/alarmtimer.c
> > @@ -86,11 +86,10 @@ static int alarmtimer_rtc_add_device(struct device
> *dev,
> >  		return -1;
> >
> >  	mutex_lock(&rtcdev_mutex);
> > -	if (!rtcdev) {
> > -		rtcdev = rtc;
> > -		/* hold a reference so it doesn't go away */
> > -		get_device(dev);
> > -	}
> > +	rtcdev = rtc;
> > +	/* hold a reference so it doesn't go away */
> > +	get_device(dev);
> > +
> 
> Brilliant.
> 
> rtcdev = NULL
> 
> CPU0				CPU 1
> 
> alarmtimer_rtc_add_device(A)
> 	if (rtcdev)		alarmtimer_rtc_add_device(B)
> 	     return -EBUSY;		if (rtcdev)
> 	mutex_lock();				return -EBUSY;
> 	rtcdev = A;			mutex_lock();
> 	mutex_unlock;
> 
> bla = alarmtimer_rtc_get_device()
> 
> So bla = A
>       				  	mutex_lock() returns
>       				  	rtcdev = B;
> 					mutex_unlock();
> 
> The next call to alarmtimer_rtc_get_device() will return B. Not what
> you want. Maybe you want that, but then your patch is missing an
> explanation why you want that and why this would be a desired
> behaviour.
Thanks your pointing out, I am wrong.
> 
> Thanks,
> 
> 	tglx
