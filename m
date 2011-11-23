Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab1KWTWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 14:22:34 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40979 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab1KWTWd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 14:22:33 -0500
MIME-Version: 1.0
In-Reply-To: <20111123192233.44f512b7@bob.linux.org.uk>
References: <CAFQmdRbkYiOArK09smfMvf2DJ8h-bYvKyXRN_nmX-bPG8ENmjA@mail.gmail.com>
	<1322074412-10873-1-git-send-email-hskinnemoen@google.com>
	<20111123192233.44f512b7@bob.linux.org.uk>
Date: Wed, 23 Nov 2011 11:22:32 -0800
Message-ID: <CAFQmdRYh3vSz4s-ks5dbz7bXJx-EZNHEGzsr5bcpEYquXmB6Fg@mail.gmail.com>
Subject: Re: [RFC] cdc-acm: Fix potential deadlock (lockdep warning)
From: Havard Skinnemoen <hskinnemoen@google.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Slaby <jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 11:22 AM, Alan Cox <alan@linux.intel.com> wrote:
>        take lock
>        mark device disconnected
>        drop lock
>        for each tty on the device {
>                tty_port_tty_get
>                if (tty) {
>                        tty_vhangup(tty);
>                        tty_kref_put(tty);
>        }
>        then do the USB disconnect processing
>        and drop our USB side kref

Ok, by USB side kref do you mean the tty_port_get/put calls I
introduced in this patch, or a kref associated with the USB device
itself?

> and on the open side they provide their own install() method which
> nicely avoids all the nasty locking problems and lets them use the
> standard tty_port_open/close/hangup etc rather than the partial ones.

Right, that makes sense.

> It might be worth turning the ACM driver to work the same way as it'll
> save doing that work later to achieve the same use of
> tty_port_open/close/..
>
> The main thing is the use of install - which lets you plug the USB and
> tty bits together during the lookup of the device.

Ok, so the basic idea is:
  * USB side: tty_port_get() in probe, tty_port_put() in disconnect
  * TTY side: tty_port_get() in install, tty_port_put() in remove

And I need to check if the device is properly marked as disconnected,
switch to vhangup, and possibly reorder things a bit as well. Right?

Havard
