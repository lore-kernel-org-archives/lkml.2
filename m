Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758458Ab2CPXfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:35:55 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49871 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab2CPXfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:35:53 -0400
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC] firmware loader: retry _nowait requests when userhelper is not yet available
Date: Sat, 17 Mar 2012 00:35:47 +0100
User-Agent: KMail/1.13.7 (Linux/3.3.0-rc6-wl+; KDE/4.7.4; x86_64; ; )
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <201203162325.56303.chunkeey@googlemail.com> <201203162357.10770.rjw@sisk.pl>
In-Reply-To: <201203162357.10770.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203170035.47756.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 March 2012 23:57:10 Rafael J. Wysocki wrote:
> On Friday, March 16, 2012, Christian Lamparter wrote:
> > On Friday 16 March 2012 23:19:53 Rafael J. Wysocki wrote:
> > > > On 03/04/2012 01:52 AM, Christian Lamparter wrote:
> > > > > During resume, the userhelper might not be available. However for
> > > > > drivers which use the request_firmware_nowait interface, this will
> > > > > only lead to a pointless WARNING and a device which no longer works
> > > > > after the resume [since it couldn't get the firmware, because the
> > > > > userhelper was not available to take the request].
> > > > > 
> > > > > In order to solve this "chicken or egg" dilemma, the code now
> > > > > retries _nowait requests at one second intervals until the
> > > > > "loading_timeout" time is up.
> > > 
> > > BTW, I wonder what comments on this patch were posted?
> > Only Alan Cox was kind enough to drop me a few words.
> > 
> > Why? Do you think it is actually sane from a specific POV?
> > [Don't tell me you do :D !]
> 
> I don't think it's really wrong.
Of course, I've tested both patches [the RFC and the other one].
The RFC might not be "really wrong" but the concept of busy
msleeping strikes me as a bit insane. [Maybe, that's because I
write drivers and I hate it when IO needs msleeps... brrr]
 
> I agree that the WARN_ON() isn't really useful in the request_firmware_nowait()
> case, because the user of that doesn't really know when exactly the firmware is
> going to be requested, so it can't really do anything about the warning.
> 
> Moreover, failures of request_firmware_nowait() just because it happens to
> race with system suspend (or something of that kind), just because of "bad"
> timing, aren't really useful either.
> 
If it's just about "waiting until the firmware can be loaded" then why not go
with the "easy approach in the [PATCH] don't cancel...". This just queues the
request in the _nowait case. And once the userspace helper is running, it will
pick up all backlogged firmware requests [of course, only the ones that have
not been timeouted yet] and life goes on!

Anyway, I know that I don't really have a say in what will be accepted.
So, it's all up to you guys! But I'll happily test any patches.

> So, I think it makes sense for it to wait until the firmware can be loaded.
> 
> I'd do that a bit differently, though, for example like in the appended patch
> (untested).
Just one comment. [see below] 

And now, I'm off to bed.

Good night,
	Chr

> ---
>  drivers/base/firmware_class.c |   31 +++++++++++++++++++++++++++----
>  1 file changed, 27 insertions(+), 4 deletions(-)


> Index: linux/drivers/base/firmware_class.c
> ===================================================================
> --- linux.orig/drivers/base/firmware_class.c
> +++ linux/drivers/base/firmware_class.c
> @@ -20,6 +20,7 @@
>  #include <linux/highmem.h>
>  #include <linux/firmware.h>
>  #include <linux/slab.h>
> +#include <linux/delay.h>
>  
>  #define to_dev(obj) container_of(obj, struct device, kobj)
>  
> @@ -535,10 +536,31 @@ static int _request_firmware(const struc
>  
>  	read_lock_usermodehelper();
>  
> -	if (WARN_ON(usermodehelper_is_disabled())) {
> +	if (nowait) {
> +		int limit = loading_timeout * MSEC_PER_SEC;
> +		int timeout = 10;  /* in msec */
> +
> +		while (usermodehelper_is_disabled()) {
> +			read_unlock_usermodehelper();
> +
> +			msleep(timeout);
timeout is 10 ms, right?

so this might apply:
Documentation/timers/timers-howto.txt
	- Why not msleep for (1ms - 20ms)?
		Explained originally here:
			http://lkml.org/lkml/2007/8/3/250
		msleep(1~20) may not do what the caller intends, and
		will often sleep longer (~20 ms actual sleep for any
		value given in the 1~20ms range). In many cases this
		is not the desired behavior.

Of course, that's of little importance.
