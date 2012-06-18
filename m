Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab2FRTGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 15:06:20 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38631 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab2FRTGR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 15:06:17 -0400
MIME-Version: 1.0
In-Reply-To: <1339884266-9201-1-git-send-email-dh.herrmann@googlemail.com>
References: <1339884266-9201-1-git-send-email-dh.herrmann@googlemail.com>
Date: Mon, 18 Jun 2012 21:06:16 +0200
Message-ID: <CANq1E4QmtCUFMioYoBm1h+MV9PMc8GSs9b8CkwBdV4c4-fm_og@mail.gmail.com>
Subject: Re: [RFC 00/10] fblog: framebuffer kernel log driver
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-serial@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Herrmann <dh.herrmann@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sun, Jun 17, 2012 at 12:04 AM, David Herrmann
<dh.herrmann@googlemail.com> wrote:
> Hi
>
> As some might know I am working on making CONFIG_VT obsolete. But as a developer
> it is often useful to have a kernel-log on the screen during boot to debug many
> common kernel(-config) errors. However, without CONFIG_VT we cannot use the
> VGA/framebbufer consoles either. Therefore, I am working on a small driver
> called "fblog".
>
> This driver simply writes the kernel log to all connected framebuffers. It works
> similar to fbcon but removes all the complexity of the virtual terminals. There
> is a sysfs attribute called "active" that allows to enable/disable fblog so
> user-space can start an xserver or similar.
>
> The main purpose is debugging kernel boot problems. Therefore, it is not
> optimized for speed and I tried keeping it simple. I splitted the patches
> into 10 small chunks to make review easier.
>
> I would be glad if someone could review this and tell me whether this is
> something we could include in mainline or not.
>
>
> There are still some issues but apart from them it works fine on my
> machine (x86):
>  - I register the fblog device during module_init and need to call
>    module_get(). However, this means it is impossible to call "rmmod fblog" as
>    fblog has a reference to itself. Using "rmmod -f fblog" works fine but is a
>    bit ugly. Is there a nice way to fix this? Otherwise I would need to call
>    device_get() in module_exit() if there is a pending user of the fblog-device
>    even though I unregistered it.
>  - I redraw all framebuffers while holding the console-lock. This may slow down
>    machines with more than 2 framebuffers (like 10 or 20). However, as this is
>    supposed to be a debug driver, I think I can ignore this? If someone wants
>    to improve the redraw logic to avoid redrawing the whole screen all the
>    time, I would be glad to include it in this patchset :)
>  - I am really no expert regarding the framebuffer subsystem. So I would
>    appreciate it if someone could comment whether I need to handle the events
>    in a different way or whether it is ok the way it is now.

One additional issue:
With udlfb.c we have hotplug capable framebuffers. However, fbcon and
fblog currently never close a framebuffer if not explicitely requested
by user-space. Therefore, if a framebuffer device is removed, the
FB_EVENT_FB_UNREGISTER event will never be sent because fbcon/fblog
still have a reference to the framebuffer(-driver). Therefore, the
number of available fbs will grow until there are no more free
indices.

See dlfb_usb_disconnect() in udlfb.c for an example. It does not
invoke unregister_framebuffer() unless the last user closed the FB.
udlfb disables the console on its framebuffer devices to avoid this,
but this doesn't seem to be a good solution.
How about sending an FB_EVENT_FB_DISCONNECT event during unlink_framebuffer()?

This still doesn't force user-space to close /dev/fbX but it at least
will make it possible to fblog/fbcon to close the framebuffer. fbmem.c
can then still be modified to mark the open file as dead so user-space
will also close the device hopefully.

Regards
David
