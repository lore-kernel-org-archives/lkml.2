Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab1FNHws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 03:52:48 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40180 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968Ab1FNHwq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 03:52:46 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Tejun Heo <tj@kernel.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, "Girdwood, Liam" <lrg@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>
Subject: Re: Re: Re: Re: [PATCH v4 11/18] input: Add initial support for TWL6040 vibrator
Date: Tue, 14 Jun 2011 10:51:35 +0300
Message-ID: <4476185.bf2jyafmHt@barack>
User-Agent: KMail/4.6.0 (Linux/2.6.39-gentoo; KDE/4.6.4; x86_64; ; )
In-Reply-To: <20110614073130.GF8141@htj.dyndns.org>
References: <1307706876-4768-1-git-send-email-peter.ujfalusi@ti.com> <8556714.NHVg2d8yTv@barack> <20110614073130.GF8141@htj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 June 2011 09:31:30 Tejun Heo wrote:
> Thanks for the explanation.  I have a couple more questions.
> 
> * While transferring data from I2C, I suppose the work item is fully
>   occupying the CPU?

Not exactly on OMAP platforms at least. We do not have busy looping in low 
level driver (we wait with wait_for_completion_timeout for the transfer to be 
done), so scheduling on the same CPU can be possible.

>   If so, how long delay are we talking about?
>   Millisecs?

It is hard to predict, but it can be few tens of ms for one device, if we have 
several devices on the same bus (which we tend to have), and they want to 
read/write something at the same time we can see hundred(s) ms in total - it 
is rare to happen, and hard to reproduce, but it does happen for sure.
 
> * You said that the if one task is accessing I2C bus, the other would
>   wait even if scheduled on a different CPU.  Is access to I2C bus
>   protected with a spinlock?

At the bottom it is using rt_mutex_lock/unlick to protect the bus.
And yes, the others need to wait till the ongoing transfer has been finished.
 
> Also, as it's currently implemented, single threaded wq's effectively
> bypass concurrency level control.  This is an implementation detail
> which may change in the future, so even if you're seeing lower latency
> by using a separate single threaded wq, it's an accident and if you
> require lower latency you should be expressing the requirement
> explicitly.

I see, do you have suggestion to which would be best for this kind of 
scenarios.
In most cases global wq would be OK for this, but time-to-time we face with 
sudden latency spikes, which makes the user experience really bad.
Currently with singlethreaded wq we can avoid these spikes.

Thank you, 
Péter
