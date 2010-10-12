Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab0JLIN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 04:13:28 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:46689 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab0JLINZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 04:13:25 -0400
Subject: Re: PROBLEM: brcm80211 hangs on 2.6.36-0.34.rc6.git3.fc15.x86_64
 [FIXED]
From: Jon Masters <jonathan@jonmasters.org>
To: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>, Henry Ptasinski <henryp@broadcom.com>,
        Nohee Ko <noheek@broadcom.com>, Jon Masters <jcm@jonmasters.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1286870623.9228.2.camel@constitution.bos.jonmasters.org>
References: <20101008065810.GA1680@constitution.bos.jonmasters.org>
	 <1286538243.21485.298.camel@constitution.bos.jonmasters.org>
	 <1286869659.8574.10.camel@constitution.bos.jonmasters.org>
	 <1286870623.9228.2.camel@constitution.bos.jonmasters.org>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Tue, 12 Oct 2010 04:11:57 -0400
Message-ID: <1286871117.9228.8.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-12 at 04:03 -0400, Jon Masters wrote:
> On Tue, 2010-10-12 at 03:47 -0400, Jon Masters wrote:
> > On Fri, 2010-10-08 at 07:44 -0400, Jon Masters wrote:
> > > On Fri, 2010-10-08 at 02:58 -0400, Jon Masters wrote:
> > > 
> > > > I tried building the new brcm80211 driver from staging-next on Fedora rawhide
> > > > kernel 2.6.36-0.34.rc6.git3.fc15.x86_64. Now, of course, it's not the
> > > > staging-next kernel (I'll try that now this doesn't work) but perhaps this
> > > > report will still be of use to the Broadcom/other wireless folks.
> > > 
> > > I pulled the latest staging-next onto Linus' latest git tree and still
> > > experience problems with the driver. It seems that the first attempt to
> > > actually transmit results in the system locking hard. Once again, I am
> > > attaching the output from running a netconsole (due to the box I'm on,
> > > it's an attachment this time, sorry about that - don't trust evolution)
> > > where the trace is basically the same as the original trace I posted.
> > > 
> > > NOTE: in both cases, the driver is loaded with "msglevel=2
> > > phymsglevel=2" which (although not documented) suggests to enable
> > > tracing, and does certainly yield more debugging output.
> > 
> > The problem may be that the driver doesn't correctly handle its logic in
> > wl_up in the case that the call to wlc_up doesn't result in the value of
> > wl->pub->up being TRUE. This can happen, for example if radio_disabled
> > is true, but I'm sure there are other problems, too. This result is not
> > properly checked in wl_up, so we can get a situation where we will later
> > try to call the ops->tx function with wl down. You also don't check
> > wl_up return codes in general, for example in wlc_radio_enable.
> 
> You need to change the following lines in wlc_up:
> 
>         if (wlc->pub->radio_disabled) {
>                 wlc_radio_monitor_start(wlc);
>                 return 0;
>         }
> 
> This should be returning BCME_RADIOOFF. That's a start. Now the driver
> doesn't explode and does what you intended with the background worker
> looking to see if the radio gets turned on. At least no hard hang.
> 
> > This might all be related to the rfkill and other soft switch stuff I'm
> > not really super up to date on. This laptop doesn't have a hardware
> > switch that I'm aware of, but I assume the state is somehow recorded in
> > software (by the BIOS?) and perhaps this is how rfkill is supposed to
> > work (I'll go look this up). Anyway, if I can figure out how to get the
> > radio to work and hack up the driver to start with the device down,
> > perhaps it'll not try to transmit and not fall over :)
> 
> Looks like you don't do rfkill. I'm not sure what I'm supposed to do to
> turn the radio on on the ASUS EeePC 1015PEM but I will poke at a few
> things. If you have advice, it would be welcome.
> 
> Let me know if you need a patch for the above, and I'll send it along
> with anything else I think of - perhaps some more error handling :)

It was some "silly BIOS setting"(TM) keeping the radio off. Still, I'm
glad I'm having chance to poke at this driver. With the radio turned on
properly, and with my hack (which is harmless when there's no error),
then the wireless device comes up and I am able to get online. Yay :)

I'll followup with some more stuff, and a patch for the above+anything
else once I get chance. Thanks for the driver, guys. Please let me be a
guinea pig for testing stuff, etc. I can now use my netbook!

Jon.


