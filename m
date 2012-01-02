Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab2ABQyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 11:54:21 -0500
Received: from netrider.rowland.org ([192.131.102.5]:35685 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752415Ab2ABQyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 11:54:20 -0500
Date: Mon, 2 Jan 2012 11:54:18 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg@redhat.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
In-Reply-To: <CA+55aFw-ar6dnPvn5wy=3Tv8fc_7Witri2mV=cCvH+aMv+jH1Q@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jan 2012, Linus Torvalds wrote:

> On Sun, Jan 1, 2012 at 8:17 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> >
> > As Linus pointed out, the real problem here is the firmware loader.
> > The way it is now, a driver can't always depend on the data being
> > available, even during a normal boot.  It ought to use an asynchronous
> > approach; then none of these problems would arise.
> 
> WRONG.
> 
> Alan, you're not getting it. Loading firmware as part of
> suspend/resume is WRONG.

Having read through the remainder of your message, I now see your point
and agree with it.  However, you misunderstood what I was trying to
say.

(For example, consider the issue of firmware loading during bootup.  
Wouldn't that work out better if an async approach was always used?  
And doesn't this argue that drivers should never do synchronous 
firmware loads?)

The issue with firmware, USB, and suspend/resume involves several
considerations.  The basic fact is this:

	USB devices sometimes lose their firmware during suspend.
	Before the device can be used again, the firmware has to be
	reloaded.

The question is how and when to reload the firmware.  As a general
rule, current drivers do this synchronously as part of their probe
routine (though there are exceptions).  For all I know, some drivers
may try to do this even if the firmware is already loaded.  The problem
we face is that the USB core may call the probe routine during the
resume procedure.  And as we know, during resume is not a good time to
load firmware.

What Oliver and I have been discussing is delaying the probe call until
after resume is finished, when userspace is back up and everything is
operating normally again.  It would be more awkward than the current
code, but it definitely can be done.

> It would not be made any better by an asynchronous approach, and that
> isn't the problem with request_firmware().

Leaving aside questions about request_firmware()'s merits, consider
what would happen if drivers loaded firmware asynchronously during
probe.  The USB core could call the probe routine while the system was
resuming, the probe routine would return immediately, and the actual
firmware load would not take place until later when userspace was
operating.  Then everything would look the same as if probe had been
called after the system resume was finished.

If, as mentioned parenthetically above, drivers should always load 
firmware asynchronously, then the USB core wouldn't need to be changed 
at all.

> Suspend/resume is *special*, and it's special for a very simple
> reason: unlike bootup or attaching a new device, suspend/resume
> happens WHILE THE USER IS ACTIVE.
> 
> Loading firmware at that time is wrong. It's impossible. You have to
> have the firmware available *before* any processes might need it, but
> at the same time actually loading the firmware may need help from user
> space and/or other devices. It's a chicken-and-egg problem.

Not in the case we have been discussing.  There is no chicken-and-egg
dependancy; no processes can need to use the device before the firmware
is loaded because the old device instance has already been unregistered
(and the new one won't be registered until after the firmware is
loaded).

> So let me repeat one more time: Loading firmware at resume time is a
> device driver bug. Seriously. How many times do I have to say it?

It sounds like you were thinking of a situation in which the driver
would try to reload the firmware while keeping the device instance
intact and available the entire time.  That isn't what Oliver and I
have been talking about.

On the other hand, something very much like it may crop up in
connection with reset-resume.  Usually it doesn't, because a USB device
without firmware generally presents a different set of descriptors from 
the ones it presents when the firmware is running.  As a result, when 
the firmware is lost the device will change identities, and the USB 
core will not attempt a reset-resume.

But it is possible that some devices might present the same descriptors
with and without firmware.  In such cases it would then be up to the
driver to detect that the firmware was gone and arrange for it to be
reloaded somehow -- before userspace wakes up.  In this case your point
is perfectly valid; the driver simply cannot rely on the firmware
loader for this, whether synchronously or not.  The only option is for
the driver to cache the firmware.  (Or give up entirely and unbind
itself from the device -- but then how would it eventually rebind?)

A similar problem can occur with USB drivers that don't support
suspend/resume at all.  Such drivers get unbound during suspend and
then rebound during resume.  When the probe routine runs for rebinding,
it may try to reload the firmware -- even though the firmware is most
likely still present.  It's fair to say this really is a driver bug.

Alan Stern

