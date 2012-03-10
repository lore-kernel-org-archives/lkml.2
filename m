Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861Ab2CJAwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 19:52:46 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:62578 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab2CJAwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 19:52:44 -0500
From: Christian Lamparter <chunkeey@googlemail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when helper is not yet available
Date: Sat, 10 Mar 2012 01:52:27 +0100
User-Agent: KMail/1.13.7 (Linux/3.3.0-rc6-wl+; KDE/4.7.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <201203092330.24438.chunkeey@googlemail.com> <20120309233659.GA21256@kroah.com>
In-Reply-To: <20120309233659.GA21256@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203100152.27901.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 March 2012 00:36:59 Greg KH wrote:
> On Fri, Mar 09, 2012 at 11:30:24PM +0100, Christian Lamparter wrote:
> > This patch fixes a regression which was introduced by:
> > "PM: Print a warning if firmware is requested when tasks are frozen"
> > 
> > request_firmware_nowait does not stall in any system resume paths.
> > Therefore, I think it is perfectly save to use request_firmware_nowait
> > from at least the ->complete() callback.
> 
> Is there code somewhere in the kernel that wants to do this?
uum, yes: The USB subsystem [Good thing, I'm already talking to you! :-D]

Take a look at drivers/usb/core/usb.c:

the ->complete callback is registered to usb_dev_complete(dev*), which
is just a lengthy wrapper for usb_resume(dev, PMSG_ON).

Now, let's switch to drivers/usb/core/driver.c:

usb_resume calls do_unbind_rebind(udev, DO_REBIND) and there we go...
So any usb driver which uses request_firmware_nowait in .probe is
a possible target for the warning.

The one I stumbled across is the pcmcia subsystem. Currently it
tries to rebind the devices during ->resume but I have already
sent a patch to postpone that till the ->complete callback comes in.
<http://lkml.org/lkml/2012/3/3/101>

> Has commit a144c6a broken it somehow that this fix would resolve it?
When I read the commit, it only talked only about broken drivers doing
"request_firmware" during .probe. But it does not mention what should
be done with "request_firmware_nowait" in such a case at all. I think
it was just an oversight from all involved parties that just got
noticed now.

> > Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> > ---
> >  drivers/base/firmware_class.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> > index 6c9387d..017e020 100644
> > --- a/drivers/base/firmware_class.c
> > +++ b/drivers/base/firmware_class.c
> > @@ -535,7 +535,7 @@ static int _request_firmware(const struct firmware **firmware_p,
> >  
> >  	read_lock_usermodehelper();
> >  
> > -	if (WARN_ON(usermodehelper_is_disabled())) {
> > +	if (WARN_ON(usermodehelper_is_disabled() && !(nowait && uevent))) {
> 
> What does uevent have to do with things here?
I found this "useful" comment about uevent in request_firmware_nowait's kdocs:
 * @uevent: sends uevent to copy the firmware image if this flag
 *      is non-zero else the firmware copy must be done manually.
I think this flag controls whenever we want to sent a firmware request event
to the usermodehelper...
[No idea why this should ever be 'false', maybe there is a good use-case for
it when the firmware is built-in... But anyway let's just say I'm as ignorant
as everybody else and I haven't got a single clue about it.]

Regards,
	Christian
