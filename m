Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab0FDHOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 03:14:55 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52616 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab0FDHOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 03:14:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=H2TKm8UUggFUv320Kf/yfPs0TdtGzs8o5IBXvuXe3dxZOSUW/oM9H88GUnWN5jBzCF
         LUj/bf8XniWi4E6KQEZOyGWL62E2UiZTya5GpYmf0TJ3RxmmYeF7b9+CywLY8XVXCoWH
         qLHRxizjdDVQGMasNgf9zbRTU3m4a4inUWcLg=
Date: Fri, 4 Jun 2010 00:14:45 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: Florian Mickler <florian@mickler.org>, Neil Brown <neilb@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] - race-free suspend. Was: Re: [linux-pm] [PATCH 0/8]
 Suspend block api (version 8)
Message-ID: <20100604071445.GG21239@core.coreip.homeip.net>
References: <20100601122012.1edeaf48@notabene.brown>
 <alpine.LFD.2.00.1006011243350.2933@localhost.localdomain>
 <20100602153235.340a7852@notabene.brown>
 <AANLkTikVjAf5nHdMx2bcHRAUSkq99s-b5YZCECXIJJLy@mail.gmail.com>
 <20100602180614.729246ea@notabene.brown>
 <AANLkTimISbs4X2YR_Pal9A80mpkNyCy8laWBcOgR2Cl7@mail.gmail.com>
 <20100602210224.6ae2333f@notabene.brown>
 <20100602210521.54b9cd9b@schatten.dmk.lab>
 <20100602233243.GA27666@core.coreip.homeip.net>
 <AANLkTim3WQ6qgBH5Cx5tkf-LPtYZ7L6BN6OZIJpQbET1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim3WQ6qgBH5Cx5tkf-LPtYZ7L6BN6OZIJpQbET1@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 07:44:59PM -0700, Arve Hjønnevåg wrote:
> On Wed, Jun 2, 2010 at 4:32 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Wed, Jun 02, 2010 at 09:05:21PM +0200, Florian Mickler wrote:
> >> On Wed, 2 Jun 2010 21:02:24 +1000
> >> Neil Brown <neilb@suse.de> wrote:
> >> >
> >> > And this decision (to block suspend) really needs to be made in the driver,
> >> > not in userspace?
> >>
> >> Well, it fits. The requirement is a direct consequence of the intimate
> >> knowledge the driver has about the driven devices.
> >
> > That is not really true. A driver does have intimate knowledge of the
> > device, however it does not necessarily have an idea about the data read
> > from the device. Consider the gpio_matrix driver: Arve says that it has
> > to continue scanning matrix once first interrupt arrvies. But it really
> > depends on what key has been pressed - if user pressed KEY_SUSPEND or
> > KEY_POWER it cmight be better if we did not wait for key release but
> > initiated the action right away. The decision on how system reacts to a
> > key press does not belong to the driver but really to userspace.
> 
> If we just suspend while the keypad scan is active, a second press of
> KEY_POWER would not be able wake the device up. The gpio keypad matrix
> driver has two operating modes. No keys are pressed: all the outputs
> are active so a key press will generate an interrupt in one of the
> inputs. Keys are pressed: Activate a single output at a time so we can
> determine which keys are pressed. The second mode is entered when the
> driver gets an interrupt in the first mode. The first mode is entered
> if the scan detected that no keys are pressed. The driver could be
> modified to stop the scan on suspend and forcibly put the device back
> in no-keys-pressed state, but pressing additional keys connected to
> the same input can no longer generate any events (the input does not
> change).

Would that be still the case if you reprogram the device as wakeup
source while suspending?

Anyway, it does not really matter. Your case (current suspend blockers)
would delay putting device to sleep till you release all the keys,
including KEY_POWER. If you delegate the decision to userspace it would
have an _option_ of putting the device to sleep earlier, however in both
cases user has to release all keys before the device can be resumed.

-- 
Dmitry
