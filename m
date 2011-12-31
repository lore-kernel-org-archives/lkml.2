Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab1LaAWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 19:22:32 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53440 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab1LaAW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 19:22:28 -0500
MIME-Version: 1.0
In-Reply-To: <20111230235421.GA6054@redhat.com>
References: <20111230235421.GA6054@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 30 Dec 2011 16:22:06 -0800
X-Google-Sender-Auth: SVceJ502rWsGZQSo67be3H80Ih4
Message-ID: <CA+55aFyqm4FbW=--7U4ULk1EBb6RLP0sRgtokODBYnZNiJXWew@mail.gmail.com>
Subject: Re: loading firmware while usermodehelper disabled.
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: Matthew Garrett <mjg@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 30, 2011 at 3:54 PM, Dave Jones <davej@redhat.com> wrote:
> We're getting a bunch of reports against Fedora 16
> (still using 3.1) which look like some drivers are trying to
> load firmware on resume from suspend, while usermodehelper
> is disabled.

Ok, buggy drivers. You *must*not* load firmware in your resume path,
since there is no actual guarantee that any particular device will be
resumed after the disk that contains the firmware images.

So it's very simple: drivers that load firmware at resume time are
buggy. No ifs, buts, or maybes about it.

> Here are some example traces:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=746411

It's isight_firmware_load(), in the isight_firmware driver. The driver
doesn't actually do anything but load the firmware, and is apparently
not very good at that either.

It should either fake a disconnect and reconnect of the device (and
let the reconnect then load the firmware through udev or something) or
it should just save the firmware image in memory from the original
load, and make the resume just re-initialize it - not load it.

It's also possible that it could be considered a USB layer bug, and
the USB layer should just not rebind the devices directly in the
resume function, but do it somehow later. HOWEVER, that would only
work for "random" USB devices that aren't in use by user space (like
disks etc might be). So I think that in general the real solution is
always just "make sure that the firmware is in memory before the
suspend even happens".

Greg - has the USB resume logic been changed lately?

Matthew? Any comments about that particular driver?

> https://bugzilla.redhat.com/show_bug.cgi?id=771002

Same issue, different driver. Again, it's USB, and it's possible that
USB just makes it really hard to do this correctly (ie the "save
firmware image across suspend so that you don't have to load it at
resume time").

It's also possible that we should blame the firmware code, which is
expressly written to encourage these kinds of bugs. It may be that i
tshould be the firmware code that has a "get_firmware()" +
"put_firmware()" model, and it should cache the firmware explicitly if
the config supports suspend, so that a firmware read at resume time
would actually work. The whole "request_firmware()" interface really
is very prone to these kinds of bugs.

But it's possible this could be fixed at the driver level by doing the
caching there.

In this case it's the rtl8192cu driver, so Larry, Chaoming, John etc
added to the cc for that one.

> This possibly sounds like the problem that caca9510ff4e5d842c0589110243d60927836222
> was trying to fix, but that patch is present in the kernels
> being reported.

No, caca9510ff4e is only for the case where you actually compile the
firmware *into* the kernel, so it's part of the kernel image. That's
useful mainly for avoiding modules and initrd images, thus allowing
things like having root directly on a disk that needs firmware to be
loaded. Quite unusual, and it doesn't really work all that well.

Oh, and some people use it for the Radeon firmware with the radeon DRM
code built it.

It really does need to be fixed at a driver level (possibly with the
help of firmware/usb support infrastructure).

                  Linus
