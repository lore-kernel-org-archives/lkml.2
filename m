Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab2ABUtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 15:49:12 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:33434 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2ABUtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 15:49:10 -0500
MIME-Version: 1.0
In-Reply-To: <4F02165C.1060400@fastmail.fm>
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org> <4F02165C.1060400@fastmail.fm>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 Jan 2012 12:48:48 -0800
X-Google-Sender-Auth: wzGLGqvG2W0UM5F8_OGQKq9H2WA
Message-ID: <CA+55aFwf06vRraVqtz8_2qWjxH0V=Yj5m7mEy3XVbA7+qj5k5A@mail.gmail.com>
Subject: Re: loading firmware while usermodehelper disabled.
To: Jack Stone <jwjstone@fastmail.fm>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>,
        Matthew Garrett <mjg@redhat.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 2, 2012 at 12:41 PM, Jack Stone <jwjstone@fastmail.fm> wrote:
>
> What about the case where the firmware that needs to be loaded is on the
> USB device that needs the firmware. This can be resolved at boot using
> an initrd but at resume time we don't have that.

Quite frankly, caching the firmware will just automagically fix this.

I don't understand why people even bother to talk about USB ID's etc
changing - that is totally irrelevant. We don't look up firmware by
USB ID's anyway.

So the *only* thing you need is:

 - don't have the firmware loaded by some special user space helper -
use "load_firmware()" (which in turn then will use a user-space helper
to load it, but that's a separate issue)

 - make sure "load_firmware()" caches the firmware by firmware name.

You can even make the caching be some simple "cache for at least 10
seconds after the last 'put' operation", and you'll be able to
trivially handle the case of a device "going away" only to be
immediately reconnected due to some electrical issue or whatever
(including changing USB ID's).

Even if the ID's change, the driver should damn well react to the new
ID and load the same damn firmware, because it's the same damn
physical device.

Why are you guys making it any more complicated than that?

Sure, if you have a user-space driver and you load the firmware
magically from user space too, and never use "request_firmware()" in a
real kernel driver, then you can never handle suspend/resume
correctly, BUT WHO THE F*CK CARES? At that point it's a "the kernel
cannot do it, because the kernel has nothing to do with it", but
exactly for the same reason it is TOTALLY POINTLESS to even bring it
up as an issue. It's not an issue - it's a broken user-space driver
that has nothing to do with the kernel, and shouldn't be discussed on
kernel lists as a kernel issue.

So the only thing we need is to fix the braindamaged firmware
interfaces. We need caching, and we need to replace (or at least
extend) "load_firware()" with "[get|put]_firmware()".

                             Linus
