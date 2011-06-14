Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab1FNHbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 03:31:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56170 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab1FNHbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 03:31:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=v/AD2yFpLD/6NwY4onUtAgt/oTnJfoepNWipA3StPV7dYU/OinfHc9Tzs9DR9dvY+y
         HSYB/QUbUpzzbpEH+Za3DSk3ASqbZSM0/WGQvJbPCs3GI5PZo8fce1eTnDWS2pE/h9m8
         Qx7IhwFMC9hRuDGw7vMco0+NJ3jF9U33DOqOg=
Date: Tue, 14 Jun 2011 09:31:30 +0200
From: Tejun Heo <tj@kernel.org>
To: =?iso-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, "Girdwood, Liam" <lrg@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>
Subject: Re: Re: Re: [PATCH v4 11/18] input: Add initial support for TWL6040
 vibrator
Message-ID: <20110614073130.GF8141@htj.dyndns.org>
References: <1307706876-4768-1-git-send-email-peter.ujfalusi@ti.com>
 <20110613212028.GA13138@core.coreip.homeip.net>
 <20110614063400.GB8141@htj.dyndns.org>
 <8556714.NHVg2d8yTv@barack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8556714.NHVg2d8yTv@barack>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jun 14, 2011 at 10:17:10AM +0300, Péter Ujfalusi wrote:
> The latency in most cases comes from the fact, that we are running an embedded 
> system. Number of peripherals are connected via I2C, these drivers are using 
> workqueues to communicate with the IC.
> Since only one device can communicate through I2C at the time. This is 
> basically the source of the latency. It does not really matter, if the devices 
> are on the same I2C bus or not, it is enough if two work belonging to device, 
> which happens to be on the same I2C bus, and the first work in the queue takes 
> long time to complete (reading back bigger chunk of info, configuring, etc).
> Even if we could schedule the second work on the other CPU, it will be put 
> waiting till the I2C bus is free, so both CPU core has work assigned, the 
> first is keeping the I2C bus, the other waits for the I2C bus, and the third 
> is waiting to be scheduled (which will be happening, when the first work 
> finished).
> IMHO the tactile feedback (vibra) should have an excuse to have separate WQ to 
> avoid latency spikes.
> I agree, that most cases we can use the global wq.

Thanks for the explanation.  I have a couple more questions.

* While transferring data from I2C, I suppose the work item is fully
  occupying the CPU?  If so, how long delay are we talking about?
  Millisecs?

* You said that the if one task is accessing I2C bus, the other would
  wait even if scheduled on a different CPU.  Is access to I2C bus
  protected with a spinlock?

Also, as it's currently implemented, single threaded wq's effectively
bypass concurrency level control.  This is an implementation detail
which may change in the future, so even if you're seeing lower latency
by using a separate single threaded wq, it's an accident and if you
require lower latency you should be expressing the requirement
explicitly.

Thank you.

-- 
tejun
