Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab1FNHSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 03:18:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57870 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579Ab1FNHSf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 03:18:35 -0400
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
Subject: Re: Re: Re: [PATCH v4 11/18] input: Add initial support for TWL6040 vibrator
Date: Tue, 14 Jun 2011 10:17:10 +0300
Message-ID: <8556714.NHVg2d8yTv@barack>
User-Agent: KMail/4.6.0 (Linux/2.6.39-gentoo; KDE/4.6.4; x86_64; ; )
In-Reply-To: <20110614063400.GB8141@htj.dyndns.org>
References: <1307706876-4768-1-git-send-email-peter.ujfalusi@ti.com> <20110613212028.GA13138@core.coreip.homeip.net> <20110614063400.GB8141@htj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 June 2011 08:34:00 Tejun Heo wrote:
> Yeap, using a separate workqueue doesn't do anything for latency
> unless WQ_HIGHPRI and/or WQ_CPU_INTENSIVE is used; however, _please_
> stay away from it unless absolutely sure it's necessary (ie. unless
> you can pin point to where latency is coming from - even in that case,
> the thing which induces the latency probably is the one which should
> be fixed).

The latency in most cases comes from the fact, that we are running an embedded 
system. Number of peripherals are connected via I2C, these drivers are using 
workqueues to communicate with the IC.
Since only one device can communicate through I2C at the time. This is 
basically the source of the latency. It does not really matter, if the devices 
are on the same I2C bus or not, it is enough if two work belonging to device, 
which happens to be on the same I2C bus, and the first work in the queue takes 
long time to complete (reading back bigger chunk of info, configuring, etc).
Even if we could schedule the second work on the other CPU, it will be put 
waiting till the I2C bus is free, so both CPU core has work assigned, the 
first is keeping the I2C bus, the other waits for the I2C bus, and the third 
is waiting to be scheduled (which will be happening, when the first work 
finished).
IMHO the tactile feedback (vibra) should have an excuse to have separate WQ to 
avoid latency spikes.
I agree, that most cases we can use the global wq.

> CMWQ is pretty good at keeping latency low unless something is
> consuming large amount of CPU cycles and those work items are marked
> WQ_CPU_INTENSIVE, not the other way around and WQ_HIGHPRI is for
> things like MCE error reporting.

So this is not really about CPU utilization, it is due to the wide variety of 
peripherals connected to an embedded system.

-- 
Péter
