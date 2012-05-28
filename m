Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab2E1Wtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 18:49:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37712 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab2E1Wtv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 18:49:51 -0400
MIME-Version: 1.0
In-Reply-To: <201205220006.31481.rjw@sisk.pl>
References: <20120518222148.E80C09D401E@zog.reactivated.net>
	<201205220006.31481.rjw@sisk.pl>
Date: Mon, 28 May 2012 16:49:50 -0600
X-Google-Sender-Auth: dZTvl19QzTssZSCckHxQoEeA4Pk
Message-ID: <CAMLZHHRcsVP3KApLUMJ-bdyw4oej5O5B=Btp+_3gC967XXuDUw@mail.gmail.com>
Subject: Re: [PATCH] firmware_class: improve suspend handling
From: Daniel Drake <dsd@laptop.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 4:06 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> If I remember correctly, we used to have an equivalent of this, but it
> didn't work.  The reason is that there are situations in which
> request_firmware_nowait() shouldn't be aborted even if system suspend is
> in progress (or more generally user space is frozen).

OK, maybe this is not the right approach. But we still need a
solution. Do you have any ideas, or am I not managing to communicate
the problem well enough?

> By definition, request_firmware_nowait() should not interfere with the
> suspend process, because it is asynchronous with respect to it, but
> if the driver actually waits for it to complete, it should simply use
> request_firmware() instead.

In this case we need to load firmware from probe. udev no longer lets
us use request_firmware() here, as per
http://www.spinics.net/lists/linux-wireless/msg85541.html

This is why we must move to request_firmware_nowait() and (I think) is
why several drivers have recently moved to the async version.

So, after probe returns the device may still be initialising. If the
device gets disconnected, the remove handler gets called. The remove
handler will want to wait for any ongoing firmware loads to complete
before tearing down the device, otherwise later the firmware callback
will execute on a device that has been freed.

What happens if the device gets removed while the system is suspending
(or if the suspend causes the device disconnection)? We hit this
issue.

I guess what is really needed here is a way to immediately cancel the
async firmware load without waiting for it to complete, without
requiring any communication with userspace. This would require
changing the API a little, to return some kind of handle that can be
cancelled. The suspend handlers could then cancel the firmware load if
they need.

What do you think?

Thanks
Daniel
