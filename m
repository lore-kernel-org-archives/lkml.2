Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab2GEUfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 16:35:37 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:44151 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab2GEUff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 16:35:35 -0400
Message-ID: <1341520528.3076.3.camel@lorien2>
Subject: Re: [PATCH 25/25] leds: convert One-shot LED trigger driver to
 devm_kzalloc() and cleanup error exit path
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: shuahkhan@gmail.com, Bryan Wu <bryan.wu@canonical.com>,
        linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Date: Thu, 05 Jul 2012 14:35:28 -0600
In-Reply-To: <20120705194828.GA1563@gmail.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
	 <1341378617-10386-26-git-send-email-bryan.wu@canonical.com>
	 <1341506839.2605.11.camel@lorien2> <20120705194828.GA1563@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-05 at 21:48 +0200, Fabio Baltieri wrote:

> > >  
> > Bryan,
> > 
> > I don't believe memory triggers allocate in their activate routine
> > should be converted to devm_kzalloc(). Based on my understanding, the
> > memory allocated using devm_kzalloc() us free'ed when driver is
> > detached. In the case of led triggers, driver stays registered while the
> > triggers it supports can be activated and deactivated many times. By
> > converting these allocations into devm_kzalloc()s could lead to memory
> > leaks. Please correct me if my understanding is incorrect.
> 
> Shuah,
> 
> I'm as the same opinion - as triggers are not really "driver", in the
> sense that they are not using the driver structures, using devm_
> functions doesn't seems to be really appropriate.
> 

Correct. Each driver could support multiple triggers and triggers are
not at the same level as the device.

> Specifically:
> 
> > > +	oneshot_data = devm_kzalloc(led_cdev->dev, sizeof(*oneshot_data),
> > > +				GFP_KERNEL);
> 
> this one is registering the data on the relative LED's resources, so
> that they are not freed until you unload the LED's driver itself.
> I also think that this leads to memory leak if you keep activating
> triggers, as the deactivate function is not actually freeing the
> resources, so in that case the correct procedure should be the usual
> kalloc/kfree.
> 
> Is this consistent with what your conclusions, Shuah?

Correct. Using devm_ in triggers is not the correct and there is no need
to change from using kalloc()/kfree().

-- Shuah
> 
> Fabio
> 
> > If what I am saying makes sense, please take this as comment that is
> > applicable to all led triggers, not just this one.
> > 
> > Thanks,
> > -- Shuah
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-leds" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


