Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab0KRLz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 06:55:29 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59656 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab0KRLz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 06:55:28 -0500
MIME-Version: 1.0
In-Reply-To: <20101118101519.11729a74@lxorguk.ukuu.org.uk>
References: <AANLkTimn7zyEjLhmOmUVQGnLDfM-A_uEgWETsM3nsyuY@mail.gmail.com>
	<20101116171447.29336514@lxorguk.ukuu.org.uk>
	<AANLkTi=ju4fON7Hz=j_tFtqFGD0b-c=-Ou+HQwfYDgOy@mail.gmail.com>
	<20101116195538.7fa66b97@lxorguk.ukuu.org.uk>
	<20101116213622.GA17824@tango.0pointer.de>
	<20101116225619.5fa7ef8b@lxorguk.ukuu.org.uk>
	<20101116231023.GB27594@tango.0pointer.de>
	<25482.1290031268@localhost>
	<AANLkTimV_zKK-Ubw3vJkDUtrYvB+W06cRR7Nz2vam6fP@mail.gmail.com>
	<20101117235647.00766e32@lxorguk.ukuu.org.uk>
	<20101118012734.GA8558@kroah.com>
	<20101118101519.11729a74@lxorguk.ukuu.org.uk>
Date: Thu, 18 Nov 2010 12:55:27 +0100
Message-ID: <AANLkTikRcw9cahHpWadmHMJ1A2jT9vztwfydzjaGp1zh@mail.gmail.com>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
From: Kay Sievers <kay.sievers@vrfy.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Valdis.Kletnieks@vt.edu,
        Lennart Poettering <mzxreary@0pointer.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Werner Fink <werner@suse.de>, Jiri Slaby <jslaby@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-18, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> 	- the existing ioctl is broken and no userspace program can use
>> 	  it properly, so it might as well be removed.
>
> You can use it happily for various things providing you hold the vt
> switch lock. It's not a very good API and wants something doing about it.
> However we can't deprecate it using either of the proposed patches
> because neither of them cover the needed functionality.
>
>> 	- Kay's patch is one proposed solution for what userspace is
>> 	  wanting to learn about ttys.  Werner's is another one.
>
> Kay's patch is useless. As we've demonstrated by as you call it "going
> off topic" it can't actually provide a credible security model. Its
> providing a variable without holding the locks that make the value
> meaningful. Thats as basic an error I can think of.
>
> We wouldn't accept kernel code which did
>
> 	mutex_lock(&foo->lock)
> 	temp = foo->only_valid_under_lock;
> 	mutex_unlock(&foo->lock);
> 	return temp;	/* ma invalid by now */
>
> especially when it was going to be used for permission management. We'd
> call it a bug. So why are we proposing to add an API that does exactly
> that ?

All this is just no real issue for us. This is not about security in
the sense of untrusted users being able to do something they couldn't
do already, it's about passing the currently active user _some_
additional rights.

And if that user goes inactive there will always be a window where
this user keeps some rights it had while active. There is always some
kind of overlap, and even if we had revoke() we probably couldn't it
for many reasons. Soft hand-over is the expected behavior. But the
poll() will still show us that *something* has changed, and it's all
we need to know to switch to the new user.

>> I can do any one, or multiple things from the following options:
>>
>> 	- disable the existing ioctl to return an error so that no new
>> 	  userspace program starts to use it thinking it is valid
>> 	- accept Werner's patch for those who like proc files
>> 	- accept Kay's patch
>>
>> Any suggestions?
>
> None of the above. In fact the current situation is better than either of
> the patches because it's equally broken and involves no more broken APIs !
>
> Doing it right means:
> - deprecating the existing ioctl (because it's a dumb interface and Kay
>   is right about that)
> - adding a proper event device which is pollable and returns the same
>   events (and more) using a small kfifo queue. Trivial to code and will
>   not add another API we'll need to deprecate again the moment anyone
>   wants to use it.
> - support synchronous switching by that interface or verify the existing
>   vt locking interfaces will do the job in conjunction with it.
>
> Kay's approach doesn't solve three things

Synchronous interface means we block the VT switch until we have
handled the event in userspace? We have several in-kernel VT switches
during suspend-resume and such. I really don't think this will want to
wait for userspace to do random crap in /dev? :)

We also never want single-use interfaces again. It's a pain when we
need to switch to some new way of doing things,a nd need to run two
services during the transition period. It is also always handy for
debugging. We will not use any single-user-subscribe interface. It's
an absolute requirement in the Linux eco-system not to block kernel
interfaces with a running service, otherwise we end up with the
/proc/acpi/* nightmare.

So if we have multiple subscribers, we need for all subscribers to
finish userspace handling and let all other block in the VT switch
ioctl()?

That all sounds nice to have for some tasks, sure no doubt, but it
sounds pretty complicated/fragile for what we need to do. We are fine
so far with the async behavior.

> - You can't use the data to implement proper secure desktop switching
> - It doesn't support moving to multiple active vts at a time
> - You can't deprecate the wait event interface unless you replace all the
>   features of it that people use (eg resize events)
>
> So we will be back here again doing the same thing deprecating Kay's
> interface if we go that way. Having an event device actually lets us
> solve the problem properly, and if we are careful about the message
> formats cover the fact the KMS folks and others want multiple "live"
> virtual consoles at a time.

As far as I know, the future is VT-like stuff in Wayland-like things
using a pty, and not legacy kernel-based VTs at all. They even think
to leave all kernel VT stuff behind, because there are too many
assumptions about, and they don't fit into the modern world of
internationalization key/font-handling anyway.

I also see problems with a lot of compat stuff that is based on
fg_console, and ...

And last, we could just have more than a single name in the 'active'
file, if that really will ever happen, which I seriously don't expect.

> If you have a /dev/vtmanager or similar and opening it allocates a kfifo
> of a page into which we stuff the events we currently post for waitevent
> then the code is trivial and it does what Kay needs as well as being able
> to cover the rest of the WAITEVENT interface and future multi-desktop
> stuff.
>
> So its trivial to do the job properly, which makes the existing patches
> all the wrong thing to do.

I'm not against this, it might be what others are looking for. We
could also use that, even when it's 100 times more complicated than
the simple poll()able text interface.

As long as we can have multiple subscribers doing the same thing, and
have a way not to block VT switches, but receive all this
asynchronously.

I just expect a ton of problems if we now start making VT switches
block, which they never did before.

Kay
