Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab0CVLj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 07:39:28 -0400
Received: from legolas.restena.lu ([158.64.1.34]:60596 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561Ab0CVLj0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 07:39:26 -0400
Date: Mon, 22 Mar 2010 12:38:40 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: Re: [PATCH v2 1/6] hid: new driver for PicoLCD device
Message-ID: <20100322123840.7351cc82@neptune.home>
In-Reply-To: <20100322043508.GC31621@core.coreip.homeip.net>
References: <20100320170014.440959a8@neptune.home>
	<20100320170241.55258b0d@neptune.home>
	<20100321034600.GE29360@core.coreip.homeip.net>
	<20100321173737.5fcf3580@neptune.home>
	<20100322043508.GC31621@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 March 2010 Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> On Sun, Mar 21, 2010 at 05:37:37PM +0100, Bruno Prémont wrote:
> > On Sat, 20 March 2010 Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > > > +	usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
> > > > +	complete_all(&data->ready);
> > > > +	INIT_COMPLETION(data->ready);
> > > 
> > > Umm, what does this do, exactly?
> > 
> > It wakes up anyone waiting on the completion and then resets the completion
> > as otherwise any future attempt to wait on it would succeed immediately.
> > 
> 
> You realize that if you re-initialize the completion right after
> signalling it there is a big chance the waiters will miss it (they do
> check completion->done flags that you reset right away.
> 
> In general completions are suited for something that happens once (a
> single request - allocated - processed - signalled) but not for
> repeating use.

Would below approach be more correct?

- move the completion to struct picolcd_pending
  so it meets the "happens once" requirement

- protect data->pending with a mutex
  (though also use spinlock to prevent race between event which
   signals the completion and picolcd_send_and_wait() around timeout)

- use the data->lock spinlock to protect multi-report requests from
  interleaving

In speudo-code this would be something like:

picolcd_send_and_wait(...)
{
	struct picolcd_pending pending;
	...
	init_completion(&pending->ready);
	aquire_mutex(data->mutex);
	spin_lock_irqsave(&data->lock, flags);
	... // prepare report
	data->pending = &pending;
	usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
	spin_unlock_irqrestore(&data->lock, flags);
	wait_for_completion_interruptible_timeout(&pending->ready, HZ*2);
	spin_lock_irqsave(&data->lock, flags);
	if (data->pending == &pending)
		data->pending = NULL;
	spin_unlock_irqrestore(&data->lock, flags);
	release_mutext(data->mutex);
	...
}

picolcd_raw_event(...)
{
	...
	spin_lock_irqsave(&data->lock, flags);
	if (data->pending) {
		// copy event data to pending
		...
		complete(&pending->ready);
	}
	spin_unlock_irqrestore(&data->lock, flags);
	...
}

In picolcd_remove() and picolcd_reset() I could then do something
similar to picolcd_raw_event() to trigger completion with no
data/error in order to skip timeout on the requester side.

Though how should I prevent races on hot-unplug?

Thanks,
Bruno
