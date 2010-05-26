Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab0EZA0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 20:26:24 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55335 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282Ab0EZA0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 20:26:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=GJVhfNHW5kWfKHSdzeUGsPcNB5m94qiDOLTqmaGpq+wJM62h5ECL+Qe27W/VDVel9U
         1VzIkwWAwZ+bznbWNCoYCfkDZ7/ZKKs5LnDNgxKqvDlsB/4AP7kyCi5K2b+c+9Sw9cap
         fOI22n8+7IrTarEc9+fMrHUyDIGX+WSOtmXLM=
Date: Tue, 25 May 2010 17:26:13 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>, Ming Lei <tom.leiming@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
Message-ID: <20100526002612.GC5331@core.coreip.homeip.net>
References: <201005251124.58017.dmitry.torokhov@gmail.com>
 <Pine.LNX.4.44L0.1005251428090.1634-100000@iolanthe.rowland.org>
 <20100525184740.GA4248@core.coreip.homeip.net>
 <AANLkTik7eKNIqMFGVl6OzpqBnhvjet9puUQDCRkrabkg@mail.gmail.com>
 <20100525223220.GC4928@core.coreip.homeip.net>
 <AANLkTinnSH_egFYowkOQiYHL87QfIH332i1__OaTem-s@mail.gmail.com>
 <20100525225544.GA5331@core.coreip.homeip.net>
 <AANLkTikaoXH5T4FJ5sY9OnAyjhaY8wa7rH6S7_k9F_m8@mail.gmail.com>
 <20100525232625.GB5331@core.coreip.homeip.net>
 <AANLkTimdGWKbUTkgTZEUGNPrXVzZ6CYwbbKQ7C3X7Ek_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimdGWKbUTkgTZEUGNPrXVzZ6CYwbbKQ7C3X7Ek_@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 04:54:34PM -0700, Arve Hjønnevåg wrote:
> 2010/5/25 Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> > On Tue, May 25, 2010 at 04:13:35PM -0700, Arve Hjønnevåg wrote:
> >>
> >> You are missing the point. There are no event pending. The kernel
> >> reported the key down event, it was handled, but the keypad driver is
> >> still scanning to see if the user presses another key,
> >
> > Employ reasonable timeout.
> 
> Timeout for what? Stop trying to suspend altogether, stop scanning for
> key changes, or a more "reasonable" poll interval?

Stop trying to suspend for a fraction of a second to see if user wants
to press another key.

> 
> >
> >> or releases the
> >> currently held key.
> >>
> >
> > Userspace consumer should wait for the key release and retract "busy"
> > once event is received and handled.
> >
> 
> No it should not. User-space does not know if the key is coming from a
> keypad driver that needs to actively scan the matrix while keys are
> pressed.

OTOH nor does kernel driver know whether system suspend should be
blocked while it is scanning. What should happen in I press KEY_SUSPEND?
Do we always want to wait till user releases it?

> 
> >> >
> >> > 2. Wait a tiny bit after last application notified you that it finished
> >> > processing events.
> >> >
> >> > So basically the difference is that with in-kernel suspend blockers,
> >> > there is a tiny window where we haven't started the suspend yet but are
> >> > about to the driver has a chance to prevent entire system from starting
> >> > sleep.
> >>
> >> No, the difference is that if a driver needs to prevent suspend for an
> >> extended period of time, you don't have user space continuously
> >> polling to see if it can suspend.
> >
> > Why would a driver, on its own, prevent suspend for extended periods of
> > time? I think that the decision should originate from userspace, kernel
> > is here just to serve the requests.
> >
> 
> A driver prevents suspend if suspend would prevent it from working.
> For instance, the gpio keypad matrix code prevents suspend when a key
> is help down, since it has to activly scan the keypad for changes.
> Only no-keys-pressed versus one-or-more-keys-pressed can be detected
> with an interrupt.
> 
> >>
> >> >
> >> > Without the blocker we may start suspending and will stop midcycle. We
> >> > may be even better off in the end since we could leave some devices
> >> > still powered down after aborting system-wide suspend.
> >> >
> >>
> >> That does not sound right.
> >
> > Why doesn't it? If a device implements runtime PM it may chose remain in
> > powered-down mode even if system is awake.
> >
> 
> If the device implements runtime PM it should already be powered-down
> if it is not in use.

It could have been in use but userspace-initiated suspend accelerated it
entering low power state.

-- 
Dmitry
