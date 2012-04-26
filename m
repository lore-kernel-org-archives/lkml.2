Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758992Ab2DZTyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 15:54:46 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:35620 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758887Ab2DZTyo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 15:54:44 -0400
MIME-Version: 1.0
Date: Thu, 26 Apr 2012 15:54:43 -0400
Message-ID: <CA+7oygdpMWFRRo8fCRM52by8hO-YcsxxiC5ggnu=APZTLF2uLg@mail.gmail.com>
Subject: help debugging USB URB dequeue error
From: George Nychis <gnychis@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm looking for some high level advice on how to debug an issue I am
having while the kernel is trying to load firmware to a USB device.

--------------------
The Error
--------------------

The error ends up being an error unlinking/dequeueing a URB while
trying to load the firmware:

<3>[ 1101.483446] otg_err: in s5pc110_otghcd_urb_dequeue()::00508
<3>[ 1101.484531] => fail to cancel_transfer()
<7>[ 1101.498039] usb 1-1.2: hcd_unlink_urb e360c100 fail -1
<7>[ 1101.500160] usb 1-1.2: khubd timed out on ep0out len=0/4096
<3>[ 1101.500995] usb 1-1.2: ath9k_htc: Firmware - htc_7010.fw download failed

---------------------
The Kernel
---------------------

This is on sort of a custom kernel for Android based on Kernel 3.0.8,
which someone added a USB OTG s3c host mode support driver.  This is a
specific case, so I'm hoping for just high level guidance on how USB,
URB, and firmware uploads work.  The base information on the custom
kernel is here if you'd like it:

http://forum.xda-developers.com/showthread.php?p=21503438

-----------------------------------------
High-level advice requested
-----------------------------------------

I'm a little bit confused as to what is happening here.  I've read
that URB's are request blocks for USB-based transactions.  I'm
assuming a URB is used to initiate a transfer of the firmware to the
USB device.  This URB is placed in to a queue of requests at the
endpoint of the device.  The driver will then handle the completion of
the URB.

The function s5pc110_otghcd_urb_dequeue() where the error is thrown is
found here:

https://github.com/sztupy/samsung-kernel-herring/blob/android-samsung-3.0-ics-mr1/drivers/usb/host/s3c-otg/s3c-otg-hcdi-hcd.c#L448

In the function I pointed to, the driver is now trying to dequeue a
URB.  It spin locks first (L468), and then checks if the endpoint is
enabled.  Then it seems to pull a descriptor for the URB (L480)?
Then, using this descriptor:

1)  Ensures it is not null (L482)
2)  Checks whether the URB may be unlinked (L491)
3)  Checks that the state of the HCD is running (L499)
4)  Then cancels the transfer??? (L506)

Step 4 is where I'm confused.  Why does it cancel the transfer?  Is
dequeueing in this context meaning that the request has completed?  I
don't think the firmware has yet been transferred, so I'm confused as
to what is being canceled or what is triggering that.

If I better understand what's going on and backtrack it, I can maybe
understand why the cancel_transfer() fails, but I'd like to know first
why the transfer is being requested to be canceled.

Thanks so much for any help.

- George
