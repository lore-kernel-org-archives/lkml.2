Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab1FNKXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 06:23:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49115 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605Ab1FNKXv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 06:23:51 -0400
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
Subject: Re: Re: Re: Re: Re: [PATCH v4 11/18] input: Add initial support for TWL6040 vibrator
Date: Tue, 14 Jun 2011 13:22:45 +0300
Message-ID: <100646074.zaKeYdXKr4@barack>
User-Agent: KMail/4.6.0 (Linux/2.6.39-gentoo; KDE/4.6.4; x86_64; ; )
In-Reply-To: <20110614081836.GG8141@htj.dyndns.org>
References: <1307706876-4768-1-git-send-email-peter.ujfalusi@ti.com> <4476185.bf2jyafmHt@barack> <20110614081836.GG8141@htj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 June 2011 10:18:36 Tejun Heo wrote:
> I see, so IIUC,
> 
> * If it's using mutex and not holding CPU for the whole duration, you
>   shouldn't need to do anything special for latency for other work
>   items.  Workqueue code will start executing other work items as soon
>   as the I2C work item goes to sleep.

I see.
 
> * If I2C work item is burning CPU cycles for the whole duration which
>   may stretch to tens / few hundreds millsecs, 1. it's doing something
>   quite wrong, 2. should be marked WQ_CPU_INTENSIVE.
> 
> So, if something needs to be modified, it's the I2C stuff, not the
> vibrator driver.  If I2C stuff isn't doing something wonky, there
> shouldn't be a latency problem to begin with.

In case of OMAP the former is the case regarding to I2C.

However I did run a short experiments regarding to latencies:
With create_singlethread_workqueue :
Jun 14 12:54:30 omap-gentoo kernel: [  211.269531] vibra scheduling time: 30 usec
Jun 14 12:54:30 omap-gentoo kernel: [  211.300811] vibra scheduling time: 30 usec
Jun 14 12:54:33 omap-gentoo kernel: [  214.419006] vibra scheduling time: 31 usec
Jun 14 12:54:34 omap-gentoo kernel: [  214.980987] vibra scheduling time: 30 usec
Jun 14 12:54:35 omap-gentoo kernel: [  215.762115] vibra scheduling time: 30 usec
Jun 14 12:54:35 omap-gentoo kernel: [  215.816650] vibra scheduling time: 30 usec
Jun 14 12:54:35 omap-gentoo kernel: [  215.871337] vibra scheduling time: 61 usec
Jun 14 12:54:35 omap-gentoo kernel: [  215.926025] vibra scheduling time: 61 usec
Jun 14 12:54:35 omap-gentoo kernel: [  215.980743] vibra scheduling time: 61 usec
Jun 14 12:54:35 omap-gentoo kernel: [  216.035430] vibra scheduling time: 61 usec
Jun 14 12:54:38 omap-gentoo kernel: [  219.425659] vibra scheduling time: 31 usec
Jun 14 12:54:40 omap-gentoo kernel: [  220.981658] vibra scheduling time: 31 usec
Jun 14 12:54:44 omap-gentoo kernel: [  224.692504] vibra scheduling time: 30 usec
Jun 14 12:54:44 omap-gentoo kernel: [  225.067138] vibra scheduling time: 30 usec

With create_workqueue :
Jun 14 12:05:00 omap-gentoo kernel: [  304.965393] vibra scheduling time: 183 usec
Jun 14 12:05:01 omap-gentoo kernel: [  305.964996] vibra scheduling time: 61 usec
Jun 14 12:05:03 omap-gentoo kernel: [  307.684082] vibra scheduling time: 152 usec
Jun 14 12:05:06 omap-gentoo kernel: [  310.972778] vibra scheduling time: 30 usec
Jun 14 12:05:08 omap-gentoo kernel: [  312.683715] vibra scheduling time: 61 usec
Jun 14 12:05:10 omap-gentoo kernel: [  314.785675] vibra scheduling time: 183 usec
Jun 14 12:05:15 omap-gentoo kernel: [  319.800903] vibra scheduling time: 61 usec
Jun 14 12:05:16 omap-gentoo kernel: [  320.738403] vibra scheduling time: 30 usec
Jun 14 12:05:16 omap-gentoo kernel: [  320.793090] vibra scheduling time: 61 usec
Jun 14 12:05:16 omap-gentoo kernel: [  320.847778] vibra scheduling time: 61 usec
Jun 14 12:05:16 omap-gentoo kernel: [  320.902465] vibra scheduling time: 61 usec
Jun 14 12:05:16 omap-gentoo kernel: [  320.957153] vibra scheduling time: 61 usec
Jun 14 12:05:16 omap-gentoo kernel: [  320.996185] vibra scheduling time: 31 usec

This is in a system, where I do not have any other drivers on I2C bus, and I have
generated some load with this command:
grep -r generate_load /*

So, I have some CPU, and IO load as well.

At the end the differences are not that big, but with create_singlethread_workqueue
I can see less spikes.

This is with 3.0-rc2 kernel

I still think, that there is a place for the create_singlethread_workqueue, and the
tactile feedback needs such a thing.

As I recall correctly this was the reason to use create_singlethread_workqueue
in the twl4030-vibra driver as well (there were latency issues without it).

-- 
Péter
