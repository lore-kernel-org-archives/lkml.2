Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097Ab2ABIdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 03:33:41 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:37631 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab2ABIdj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 03:33:39 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Michael =?iso-8859-1?q?B=FCsch?= <m@bues.ch>
Subject: Re: loading firmware while usermodehelper disabled.
Date: Mon, 2 Jan 2012 08:56:25 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Matthew Garrett <mjg@redhat.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
References: <201201011322.34483.oliver@neukum.org> <201201012227.56568.oliver@neukum.org> <20120101223913.3ff57d0f@milhouse>
In-Reply-To: <20120101223913.3ff57d0f@milhouse>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201201020856.26235.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 1. Januar 2012, 22:39:13 schrieb Michael Büsch:

> These change-id-on-bootstrap devices usually work like this,
> as far as I know:
> 
> probe bootstrap device (switches hw to real device)

And you will find no driver if the firmware is uploaded in user space.
udev runs a firmware loader that uses libusb. usb_modeswitch
presents you with the same problem.

> probe real device (firmware is loaded)

The real driver will often be generic and have no idea the device
needs firmware to turn it into a functional generic device. And we really don't
want to contaminate the generic drivers with that information.

So we'd need

a) kernel infrastructure to track "shadow" drivers for firmware upload
b) a heuristic to decide when a device underwent a virtual replug

> Suspend machine
> Resume machine
> usb detects that the device is "gone"
> probe/resume bootstrap device (switches hw to real device)

We need a way to verify this is really the device which we need firmware
for.

> probe/resume real device (No need to fetch fw from userspace. It's already cached)

Now we need to wait for the firmware upload to take effect. How long?
And we need to hold off telling the driver that its device was disconnected. 

> What did I get wrong?

In addition you now need logic to tell the "shadow" drivers that a device
is gone so that they can free the firmware. Oh and of course you will need
to refcount firmware (but we probably need to do that anyway)

	Regards
		Oliver
