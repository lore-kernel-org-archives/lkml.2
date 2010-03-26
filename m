Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab0CZVkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 17:40:23 -0400
Received: from legolas.restena.lu ([158.64.1.34]:48023 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab0CZVkU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 17:40:20 -0400
Date: Fri, 26 Mar 2010 22:39:32 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: Re: [PATCH v3 1/6] hid: new driver for PicoLCD device
Message-ID: <20100326223932.01305c17@neptune.home>
In-Reply-To: <201003261416.25387.dmitry.torokhov@gmail.com>
References: <20100324233707.7243b04d@neptune.home>
	<20100326102951.3b9ecda1@neptune.home>
	<alpine.LNX.2.00.1003262156280.24576@pobox.suse.cz>
	<201003261416.25387.dmitry.torokhov@gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 March 2010 Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> On Friday 26 March 2010 01:59:19 pm Jiri Kosina wrote:
> > On Fri, 26 Mar 2010, Bruno Prémont wrote:
> > > > > +	for (i = 0; i < PICOLCD_KEYS; i++) {
> > > > > +		int key = ((int *)idev->keycode)[i];
> > > > 
> > > > Keycodes are now short, not int. Also, just do:
> > > > 		input_set_capability(idev, EV_KEY, data->keycode[i]);
> > > > 		
> > > > > +		if (key < KEY_MAX && key >= 0)
> > > > > +			input_set_capability(idev, EV_KEY, key);
> > > 
> > > Oops, I was not careful enough when switching over...
> > 
> > Dmitry, thanks a lot for rapid review the driver.
> > 
> > Bruno, could you please fix this and submit a followup 1/6 patch, so that
> > I could queue the driver in my tree?
> > 
> > I have almost finished going over the driver and haven't encountered any
> > other issues that would require immediate fixing.
> > 
> > Still, it would be nice to have the framebuffer/LCD/backlight bits
> > reviewed by respective subsystem maintainers. But I'll probably queue the
> > driver nevertheless and add potential ACKs later.
> 
> FWIW I am not entrely happy with the whole send-and_wait implementation -
> it looks like it is not being called concurrently so we don't need mutex
> there... I'd do something like:

It can be called concurrently, not within patch 1/6 but it definitely
can once patch 6/6 is applied (concurrent access to debugfs files for
EEPROM and/or FLASH).
Even later on when FLASH (and EEPROM) access get moved to a better home
concurrent access will still exist.


> send_nand_wait() {
> 
> 	set_bit(WAITING_RESPONSE, data->state);
> 	prepare message
> 	send message
> 	wait_for_event_interruptible_timeout(&data->wait,
> 					!test_bit(WAITING_RESPONSE, data->state));
> 	if (!test_bit()) {
> 		process
> 		return 0;
> 	}
> 
> 	return -ETIME;
> }
> 
> irq(...) {
> 
> 	else if (test_bit(WAITING_RESPONSE, data->state)) {
> 		copy response...
> 		clear_bit(WAITING_RESPONSE, data->state);	
> 		wake_up(&data->wait);
> 	}
> }
> 
> and not bother with kmallocing pending structure, but it should not
> stop from merging driver.

It might be an option to not allocate the pending structure but as
the whole "pending" access is definitely not a hot path (flashing
firmware or splash and changing EEPROM values will most probably
not be done very often). The only more common use is version check
on probe.

So what is more expensive, the used memory or the CPU usage to
allocate/release the struct? That probably depends on reader's taste.

Bruno
