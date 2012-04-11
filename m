Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286Ab2DKU7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:59:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:17766 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704Ab2DKU7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:59:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="127924525"
Subject: Re: [PATCH] clockevents: Leave broadcast device shtudown only if
 the current device is always running.
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Feng Tang <feng.tang@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, santosh.shilimkar@ti.com,
        linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Date: Wed, 11 Apr 2012 14:01:12 -0700
In-Reply-To: <20120411160402.GA27044@feng-i7>
References: <1333951423-27621-1-git-send-email-santosh.shilimkar@ti.com>
	 <1334011304.12400.81.camel@sbsiddha-desk.sc.intel.com>
	 <CA++bM2th5XW1gxrHbcHwDK=qBBaNc3ut0ydbNNStfNa-Xa-9tA@mail.gmail.com>
	 <20120411063452.GA25399@feng-i7> <alpine.LFD.2.02.1204111208070.2542@ionos>
	 <20120411160402.GA27044@feng-i7>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1334178072.27381.21.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-12 at 00:04 +0800, Feng Tang wrote:
> Thanks for the explaination, I understand the root cause now.
> 
> And regarding the original commit 77b0d60c5
>     clockevents: Leave the broadcast device in shutdown mode when not needed
> 
> @@ -575,11 +575,15 @@ void tick_broadcast_switch_to_oneshot(void)
>  	unsigned long flags;
>  
>  	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
> +	if (cpumask_empty(tick_get_broadcast_mask()))
> +		goto end;
> 
>   	tick_broadcast_device.mode = TICKDEV_MODE_ONESHOT;
>  	bc = tick_broadcast_device.evtdev;
>  	if (bc)
>  		tick_broadcast_setup_oneshot(bc);
> +
> +end:
>  	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
>  }
>  
> The tick_broadcast_switch_to_oneshot() get called mostly at boot time or
> during cpu hotplug. And when it is called at boot time, the tick_broadcast_mask
> is alwasys 0 at the point,

On the correctly working platforms, that is the case. But there are
cases where APIC timer calibration fails, in which case APIC is marked
as CLOCK_EVT_FEAT_DUMMY and in this scenario, broadcast mask will be
non-zero.

>  thus this check is always true and skip the
> following oneshot setting up for broadcast device, 

On most platforms yes, but there are some buggy exceptions which the
code is trying to handle.

thanks,
suresh

