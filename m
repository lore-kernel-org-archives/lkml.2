Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab2ERQgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:36:21 -0400
Received: from netrider.rowland.org ([192.131.102.5]:41903 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932365Ab2ERQfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:35:46 -0400
Date: Fri, 18 May 2012 12:35:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Grant Likely <grant.likely@secretlab.ca>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@suse.de>, Kevin Hilman <khilman@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] gpiolib: Defer failed gpio requests by default
In-Reply-To: <20120518043219.740113E062C@localhost>
Message-ID: <Pine.LNX.4.44L0.1205181227350.8126-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2012, Grant Likely wrote:

> /anyway/ the reason I'm saying this is that devices are *supposed* to
> be in the correct order for suspend/resume.  With the implicit
> dependencies expected by deferred probe, it becomes really important
> that devices are correctly ordered in the list.  The only way this can
> be done is to move the device to the end of the list.  The agreement
> when this was last discussed on the ML was to make the drivers do an
> explicit move immediately after it has validated all its dependencies.
> That is why it doesn't work to return -EPROBE_DEFER by default from
> helpers; because it becomes really hard to audit if the drivers are
> doing the right thing.
> 
> I see two solutions to this though;
> 1) add a new .preprobe hook to device drivers that will respect
>    -EPROBE_DEFER and ignore -EPROBE_DEFER on the regular .probe.
>    Probing a driver will call both, but if the .preprobe hook is
>    populated, then it will also reorder dpm_list between the two
>    calls.
>    - This still requires modifying drivers, but at least it is
>      auditable by mere-mortal reviewers.
>    - It also means all bus_type code has to add a new hook.  Blech.
> 2) simply force devices to the end of dpm_list before each probe
>    attempt (provided that it doesn't have any children).
>    - I've avoided this because it adds a claim of the dpm_list_mtx
>      mutex on every single probe call and adds a lot more manipulation
>      of the list....
>    - However, it should make your patch here actually safe.  If a
>      device gets deferred, it will be guaranteed to be at the end of
>      the list because it gets moved there on every probe attempt.
>    - also after reading through the code (see my notes below; I'm a
>      bit frustrated with the whole thing) I think it is probably the
>      right thing to do.

2) seems like the best approach.  A little extra list manipulation 
shouldn't hurt anything (the bits don't wear out...).

> As for /using/ dpm_list, I see 2 locations:
> dpm_complete()
>  - entries in dpm_prepared_list are spliced into dpm_list.
> dpm_prepare()
>  - moves entries into dpm_prepared_list
>    - Hmmm... So what happens when a device is moved but it is already
>      in dpm_prepared_list?  Will it accidentally put /back/ onto the
>      dpm_list when it shouldn't be?  I don't see any protections
>      against this.

It should never happen.  A device gets put on the dpm_prepared_list 
after its .prepare method is called, and one of the things that method 
is supposed to do is guarantee that no more children will be registered 
beneath the device.  No registrations means no probes -- or at least, 
it did until the deferred probing mechanism was created.

It may turn out to be necessary to make the deferred probing threads 
freezable, so they will not run while the dpm lists are being used.

>      - It *looks* like dev->power.is_{prepared,suspended} is intended
>        to protect that list, but I don't see it being used by the
>        core.

IIRC, those flags is used mainly for error detection and reporting 
(also for error recovery, when a suspend is aborted in the middle).  
They don't protect anything.

> There are other lists too that devices can be on instead of dpm_list:
>  - dpm_suspended_list
>  - dpm_late_early_list
>  - dpm_noirq_list
> 
> Blech!  None of this is ******* documented.  How is this all supposed to
> work and stay consistent?!?

That's not entirely fair.  The overall process is documented in
Documentation/power/devices.txt.  The list headers themselves are
supposed to be private to drivers/base/power/main.c, although they
currently aren't declared static for some reason -- an oversight?

Alan Stern

