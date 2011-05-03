Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901Ab1ECBAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 21:00:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755026Ab1ECBAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 21:00:16 -0400
MIME-Version: 1.0
In-Reply-To: <20110502232820.GA9578@suse.de>
References: <201105030044.51661.rjw@sisk.pl> <20110502231234.GA6430@suse.de>
 <BANLkTikCHO1ST27uhJLU5mBxtWPuuVkNKA@mail.gmail.com> <20110502232820.GA9578@suse.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 May 2011 17:59:22 -0700
Message-ID: <BANLkTimwmC=ckj4g_ct4EhOSLD7NDgxdng@mail.gmail.com>
Subject: Re: [RFC][PATCH] PM: Print a warning if firmware is requested when
 tasks are frozen
To: Greg KH <gregkh@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 2, 2011 at 4:28 PM, Greg KH <gregkh@suse.de> wrote:
>
> A driver that does not rely on the firmware being built in would be
> correct in calling request_firmware_nowait() on resume, then when
> userspace is properly woken up, the firmware would be sent to the
> device, then the driver would be notified, load it, and handle things
> as part of its resume sequence from that notification.
>
> Isn't that ideally what we want to have happen?

No. Absolutely not.

What we ideally want to happen is for the driver to not be a stupid
piece of sh*t.

A driver that needs firmware loading at resume time IS A BROKEN DRIVER.

It really is that simple.

> Or am I missing something else?

The only correct thing to do is for a driver that is active over a
suspend to cache the firmware in RAM.

There is absolutely no other possible solution. You can't rely on
user-space loading, because the user space may well require that
driver to load things in the first place. And even if it doesn't, it
leaves a huge gaping window where the driver is useless because it has
no firmware, and then any other (unrelated to firmware loading or udev
or anythign else) user space that wants to access the device - because
it was accessing it before the suspend - will be hosed.

Seriously. Anything else is pure idiocy. The only sane model is for
drivers to load the firmware before the suspend even happens.
Preferably by simply never unloading the firmware in the first place.

No amount of crazy hacks will ever solve the problem if a driver
doesn't do that.  Not "nowait", not "reload it from udev when user
space comes back".

                        Linus
