Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab2ATXrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 18:47:14 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:34868 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754262Ab2ATXrM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 18:47:12 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1201201033260.1509-100000@iolanthe.rowland.org>
References: <1327016262-17957-1-git-send-email-sjg@chromium.org>
	<Pine.LNX.4.44L0.1201201033260.1509-100000@iolanthe.rowland.org>
Date: Fri, 20 Jan 2012 15:47:11 -0800
X-Google-Sender-Auth: RN4Zbl2ZviOTMtS_Q6qkSLhNCXk
Message-ID: <CAPnjgZ0-VdAzudGFopBd+5j4HhOp10C=x0kPuJEZyaYSzwjBAA@mail.gmail.com>
Subject: Re: [PATCH] usb: Use a workqueue in usb_add_hcd() to reduce boot time
From: Simon Glass <sjg@chromium.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Fri, Jan 20, 2012 at 7:46 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Thu, 19 Jan 2012, Simon Glass wrote:
>
>> This allows the boot to progress while USB is being probed - which
>> otherwise takes about 70ms per controller on my Tegra2 system.
>>
>> It was mentioned some years ago in an email from Linus Torvalds:
>>
>> https://lkml.org/lkml/2008/10/10/411
>>
>> >  - they call usb_add_hcd, and usb_add_hcd is a horrible and slow
>> > piece of crap that doesn't just add the host controller, but does all
>> > the probing too.
>> >
>> > In other words, what should be fixed is not the initcall sequence,
>> > and certainly not make PCI device probing (or other random buses) be
>> > partly asynchronous, but simply make that USB host controller startup
>> > function be asynchronous.
>

Thanks for the comments.

> Too bad Linus didn't send this message to the linux-usb mailing list;
> it might have received more attention.  Also, it's not clear what he
> meant by "does all the probing too" -- since usb_add_hcd() is called
> from within various drivers' probe routines, it seems only reasonable
> that it _should_ do probing.

Well the problem is that we are trying to boot the kernel, so
time-consuming things should be done later or in parallel where
possible.

>
>> It might be better to delay the work until much later unless USB is needed
>> for the root disk, but that might have to be a command line option.
>
> This may be a worthy goal, but your implementation is not good.  In
> particular, if asynchronous usb_add_hcd fails then the driver should
> not remain bound to the controller device.  Did you test what happens
> when the delayed routine fails and you then try to unload the host
> controller driver?

First, backing up a bit, there are at least two ways to solve this.
One is to have the drivers only call usb_add_hcd() from a work queue
or similar - i.e. not as part of their initcall execution. The other
is what I have done here.

Before I go much further I would like to know which is
best/preferable. Because in answer to your questions I'm not sure
drivers have a way of dealing with failure of delayed init. It would
need notification back to the driver at least.

>
> Also, you added at least one new field to the usb_hcd structure that is
> pretty much just a copy of a field that already exists.  And you added

The irq member is normally only assigned when valid, but I'm sure I
could reuse it for init.

> a delayed_work structure that is only going to be used once -- why not
> allocate and free it separately instead?  And you created an entire new

I originally did it that way, but it's more complicated. I can change
it back easily enough.

> workqueue just for registering new USB controllers; what's wrong with
> using the system workqueue?

Nothing - perhaps I could use system_long_wq without anyone
complaining about delays.

>
> Finally, what justification is there for delaying everything by one
> second?  If a USB controller is critical then you don't want to delay
> it at all, if the controller was hotplugged some time after booting
> then a delay doesn't matter, and if the action takes place during
> booting then a 1-second delay isn't going to be long enough to make any
> difference.

My purpose was to get feedback on what is acceptable. Re your last
point it does seem to make a difference since other things can init in
that time.

As I said above my real uncertainty is where to consider that the
'pure init' is be done, and move the rest into a work queue. Maybe
usb_add_hcd() should stop at the transition to HC_STATE_RUNNING (i.e.
before calling the driver's ->start method), and return success?

Regards,
Simon
>
> Alan Stern
>
