Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab1DOLGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 07:06:19 -0400
Received: from imr3.ericy.com ([198.24.6.13]:33062 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755794Ab1DOLGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 07:06:18 -0400
Date: Fri, 15 Apr 2011 04:05:29 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Natarajan Gurumoorthy <natg@google.com>
CC: Jean Delvare <khali@linux-fr.org>, Wim Van Sebroeck <wim@iguana.be>,
        Mike Waychison <mikew@google.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH v6 1/2] Use "request_muxed_region" in it87 watchdog
 drivers
Message-ID: <20110415110529.GA23594@ericsson.com>
References: <1302816996-6345-1-git-send-email-natg@google.com>
 <1302817069-6389-1-git-send-email-natg@google.com>
 <1302821370.26780.585.camel@groeck-laptop>
 <BANLkTin6M0R4d+HMovbRwqthSHowUEKFow@mail.gmail.com>
 <20110415024005.GA21642@ericsson.com>
 <BANLkTi=t+AgRU47DhKoGOJ2mTa6AVfaPVw@mail.gmail.com>
 <20110415055852.GA21905@ericsson.com>
 <BANLkTi=464Q8z7GzDZw9Mb-j-L4O0bPRjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BANLkTi=464Q8z7GzDZw9Mb-j-L4O0bPRjg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 04:46:04AM -0400, Natarajan Gurumoorthy wrote:
> On Thu, Apr 14, 2011 at 10:58 PM, Guenter Roeck
> <guenter.roeck@ericsson.com> wrote:
> > I have seen the list. I don't think you should fix everything in one go.
> > First step might be to get the w83697hf and it87 to work together, then
> > go from there.
> >
> > Is there a reason for loading (or trying to load) both the it87 and
> > the w83697hf driver at the same time ? Those drivers are usually only
> > loaded if the respective chip is known to exist. If there is no reason
> > to try loading both drivers, a simple workaround would be to not do it.
> >
> Guenter,
>       I agree the above should never happen. The only way the 2
> drivers will be loaded at the same time is a misconfigured kernel
> where these 2 drivers get built and the rc scripts end up loading them
> too. If we are agreed that I suggest we make the superio_enter routine
> be the following:
> 
> static inline void
> superio_enter(void)
> {
> 	/*
> 	 * Reserve REG and REG + 1 for exclusive access.
> 	 */
> 	while (!request_muxed_region(REG, 2, WATCHDOG_NAME))
> 		continue;
> 
At least for my part, I would not agree to that. If another driver misbehaves
and does not release the region, one of your CPU cores will be stuck
in an endless loop.

> 	outb(0x87, REG);
> 	outb(0x01, REG);
> 	outb(0x55, REG);
> 	outb(0x55, REG);
> }
> 
> What I am suggesting is not returning an error and instead keep
> calling "request_muxed_region" till it succeeds. If superio_enter
> returns an error then we will have to rewrite a large chunk of
> it8712f_wdt to deal with it. There are 8-9 calls to superio_enter. We
> will have supreio_enter returning errors at awkward places in the
> driver where the current logic has no code to deal with errors.
> 
Can't help it. I browsed through it earlier and didn't think it was that bad.
Just pass the error on to the next level until you can return it.

Guenter

> In case of properly written drivers the while loop will eventually
> exit. I agree this is ugly as sin but it limits the perturbation of
> the driver. Feedback please.
> 
> Regards
> Nat
> 
> 
> > Thanks,
> > Guenter
> >
> >
> 
> 
> 
> -- 
> Regards
> Nat Gurumoorthy AB6SJ
