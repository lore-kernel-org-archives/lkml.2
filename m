Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875Ab2ACHR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 02:17:59 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52900 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab2ACHR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 02:17:57 -0500
From: Marek Vasut <marek.vasut@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: loading firmware while usermodehelper disabled.
Date: Tue, 3 Jan 2012 08:17:52 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Jack Stone <jwjstone@fastmail.fm>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg@redhat.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org> <c163595a-163e-4e68-ba0f-de5ca58e8de9@email.android.com> <20120103005839.618af359@pyramind.ukuu.org.uk>
In-Reply-To: <20120103005839.618af359@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201030817.53203.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >Hm ... and we can't have memory type that "can be swapped-out, but must
> > >be
> > >loaded back before suspend" in kernel, right?
> > 
> > Nope. Kernel swapping is a big headache and Linux doesn't do it. The only
> > thing we can do is drop any clean cache pages, but that has performance
> > implications.
> 
> You could however have an arrangement where the firmware refmanager does
> a list of request_firmware()s at the very start of the suspend process. It
> cannot be done during suspend for obvious reasons (sorry I already
> suspended the hard disk) but it can be done just before.

Yep, that sounds sane.
> 
> In that case with get/put_firmware you'd just need to extend the API to
> 
> 	get_firmware()
> 	put_firmware()
> 	get_for_suspend_firmware()
> 
> and a driver might do something like
> 
> 
> module_init
> 
> 	fw = get_for_suspend_firmware("wombatdepolariser.fw");
> 
> 
> open:  /* just optimising */
> 	kref_get(&fw->kref);
> 
> close:
> 	put_firmware(fw);
> 
> 
> module_unload:
> 	put_firmware(fw);
> 
> 
> Now the uglier side of that is how you make sure that if
> get_for_suspend_firmware() works that when we suspend the firmware is
> present. We could keep the file handle open but that might block unmounts

Nope, not like this.

> or we could assume that as its superuser stuff that the distro authors
> don't screw up - in which case we'd refuse to suspend with a nasty
> complaint if the firmware turned out to have been deleted behind our back.

No, we should just emit a warning after resume (or even before suspend) with 
something like "Couldn't reload firmware, you are an idiot for deleting it, your 
hardware won't work anymore, sorry".

> 
> You'd also have to be in situation where new device probes were not
> processed but userspace (eg the fw loader helper) were still running.

Yes, I think it'd help not only usb to have a state of userland where fw loader 
and a few similar things would still be operational. Aka. we'd need a way for 
the kernel to tell userland part of FW loader "ok, now we're going zzz, do your 
job quickly" and bump it's priority to highest (so other processes won't 
interfere). Then wait till fw loader confirms that all FW was passed to the 
kernel and suspend.

> 
> That seems to me to be a useful optimisation project for bigger firmwares
> but not something to implement on day 1 ?

For me on PalmTX, with 32MB of RAM, every kb is good. The wifi firmware there 
has 120kb or so, so I'd like to avoid having it in kernel all the time. But that 
might be a bit of an extreme case.

> 
> Alan

M
