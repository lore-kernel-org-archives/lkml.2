Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596Ab2DKQGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:06:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:12419 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759744Ab2DKQGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:06:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="131243450"
Date: Thu, 12 Apr 2012 00:04:02 +0800
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: suresh.b.siddha@intel.com, santosh.shilimkar@ti.com,
        linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: Re: [PATCH] clockevents: Leave broadcast device shtudown only if
 the current device is always running.
Message-ID: <20120411160402.GA27044@feng-i7>
References: <1333951423-27621-1-git-send-email-santosh.shilimkar@ti.com>
 <1334011304.12400.81.camel@sbsiddha-desk.sc.intel.com>
 <CA++bM2th5XW1gxrHbcHwDK=qBBaNc3ut0ydbNNStfNa-Xa-9tA@mail.gmail.com>
 <20120411063452.GA25399@feng-i7>
 <alpine.LFD.2.02.1204111208070.2542@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1204111208070.2542@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Wed, Apr 11, 2012 at 12:10:59PM +0200, Thomas Gleixner wrote:
> On Wed, 11 Apr 2012, Feng Tang wrote:
> > > Problem you encountered is not related to leaving the broadcast device
> > > in shutdown mode. Problem is that we didn't track the mode change to
> > > oneshot and later during idle entry/exit, when we request the broadcast
> > > device services using CLOCK_EVT_NOTIFY_BROADCAST_ENTER etc,
> > > tick_broadcast_oneshot_control() returns with out doing much as it
> > > thinks broadcast device is in periodic mode.
> > 
> > Just curious, IIUC, the tick_broadcast_switch_to_oneshot() is only called
> > during CPU init process in boot time or bring a offlined cpu back on. Why
> > is it related to the deep idle?
> 
> Because a deep idle state might require the broadcast device and w/o
> Suresh's patch it can't use it because it's in the wrong state.
>

Thanks for the explaination, I understand the root cause now.

And regarding the original commit 77b0d60c5
    clockevents: Leave the broadcast device in shutdown mode when not needed

@@ -575,11 +575,15 @@ void tick_broadcast_switch_to_oneshot(void)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
+	if (cpumask_empty(tick_get_broadcast_mask()))
+		goto end;

  	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
 	bc = tick_broadcast_device.evtdev;
 	if (bc)
 		tick_broadcast_setup_oneshot(bc);
+
+end:
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
 
The tick_broadcast_switch_to_oneshot() get called mostly at boot time or
during cpu hotplug. And when it is called at boot time, the tick_broadcast_mask
is alwasys 0 at the point, thus this check is always true and skip the
following oneshot setting up for broadcast device, which sounds a little
buggy.

Thanks,
Feng

> 
> Thanks,
> 
> 	tglx
