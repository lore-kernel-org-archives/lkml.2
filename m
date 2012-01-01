Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab2AAUa3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 15:30:29 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58951 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab2AAUa1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 15:30:27 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1201011105200.4534-100000@netrider.rowland.org>
References: <201201011322.34483.oliver@neukum.org> <Pine.LNX.4.44L0.1201011105200.4534-100000@netrider.rowland.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 1 Jan 2012 12:30:04 -0800
X-Google-Sender-Auth: kylzpsaYnLc6Lzez0t3v00jBPtU
Message-ID: <CA+55aFw-ar6dnPvn5wy=3Tv8fc_7Witri2mV=cCvH+aMv+jH1Q@mail.gmail.com>
Subject: Re: loading firmware while usermodehelper disabled.
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg@redhat.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 1, 2012 at 8:17 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
>
> As Linus pointed out, the real problem here is the firmware loader.
> The way it is now, a driver can't always depend on the data being
> available, even during a normal boot.  It ought to use an asynchronous
> approach; then none of these problems would arise.

WRONG.

Alan, you're not getting it. Loading firmware as part of
suspend/resume is WRONG.

It would not be made any better by an asynchronous approach, and that
isn't the problem with request_firmware().

Suspend/resume is *special*, and it's special for a very simple
reason: unlike bootup or attaching a new device, suspend/resume
happens WHILE THE USER IS ACTIVE.

Loading firmware at that time is wrong. It's impossible. You have to
have the firmware available *before* any processes might need it, but
at the same time actually loading the firmware may need help from user
space and/or other devices. It's a chicken-and-egg problem.

So let me repeat one more time: Loading firmware at resume time is a
device driver bug. Seriously. How many times do I have to say it?

And making it asynchronous doesn't make it *any* less of a bug. It
doesn't change anything but timing, but the problem was never about
timing in the first place! The problem was about dependencies. User
space may well depend on the device, and *other* devices may well
depend on the device working.

So stop with the inanity. I've already told people what the fix is:
make sure that the firmware image is in memory before the suspend ever
happens, and just reload it from memory. NOT with
"request_firmware()". Because requesting the firmware at resume time
is buggy and wrong, and has nothing to do with "asynchronous" or
"synchronous". It has everything to do with "it's buggy".

Really really really.

So the problem with request_firmware() has absolutely nothing to do
with "asynchronous". The problem is that the firmware interfaces do
not cache the data in memory, and currently *cannot* sanely cache the
firmware data simply because the interface doesn't have any kind of
lifetime rules.

In other words: we could make "request_firmware()" cache *all*
firmware images forever, but there is currently no way to say "ok, the
device was unplugged - and not fakily so by a resume event, but for
real, and physically - so now you can drop the cache". Which means
that effectively request_firmware() can do no caching at all, because
it might eventually just run out of memory.

It is *possible* that we might tie the firmware lifetime rules to the
driver module lifetime. But it would probably be much better if we
made for an explicit model of "ok, the device is now really gone" so
that it would work properly with compiled-in drivers etc too.

And yes, the firmware would have to stay around even around a
resume/suspend that causes unplug events over USB. The "use USB and
lose power" actually happens also for built-in devices that may well
be disks and network cards that are *needed* by user space, so even if
the device has been electrically unplugged, it is still attached and
needs to be brought back *before* user space comes back.

That's the whole point of suspend/resume: we're not starting from a
clean slate. We are supposed to continue as if nothing happened!

                                  Linus
