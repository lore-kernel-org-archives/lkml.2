Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab0C2Lsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 07:48:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55585 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab0C2Lsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 07:48:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock II
Date: Mon, 29 Mar 2010 12:48:37 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, jblunck@suse.de,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       gregkh@suse.de
References: <201003242240.54907.arnd@arndb.de> <8739zk1529.fsf@basil.nowhere.org> <87tys0yly7.fsf_-_@basil.nowhere.org>
In-Reply-To: <87tys0yly7.fsf_-_@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003291348.37997.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19tdoGLS7kY/azYNGVuEGlSRXX5gA766ZfpgBE
 TmXqhYFtBBN18cCHsTHgEYEMeRo4Dxd9/O9b90NBsvFdbx9YXj
 xXI8tmY+8ESN2oRE1xeWA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 March 2010, Andi Kleen wrote:
> Andi Kleen <andi@firstfloor.org> writes:
> >
> > From a quick grep at least EHCI doesn't seem to need it?

Right.

> As a followup:
> 
> I killed some time by going through the various BKL uses in USB and
> came up with this git tree to address them . Feel free to integrate
> into your tree.

Great, I was hoping someone picks up the missing pieces. Maybe someone
else can do the same for the sound drivers ;-).

> With this only some obscure USB low level drivers still need to 
> depend on BKL, the majority is clean. Gadgetfs also still needs
> it for now.

Sure, that absolutely makes sense.

> I ended up also fixing some minor races in usb serial registration/
> unregistration.
> 
> Opens:
> - The usb serial ioctl entry needs to become a unlocked_ioctl,
> but I think that needs your tree first. The code below it doesn't
> need it anymore.

The usb-serial driver has a few instances where it takes the BKL
in the mainline code, but this gets converted to the Big TTY Mutex
in my series. The ioctl method in there is fine as far as I can tell.

> - The seek function in uhci-debug.c probably is still racy.

That function could be removed in favor of using generic_file_ioctl
and setting i_size to up->size.

Also, the race is only between concurrent calls of llseek on
the same file descriptor, which is undefined anyway.
The current code also doesn't protect you against partial updates
of f_pos during ->read() on 32 bit systems (nothing ever does),
and it even fails to protect against the concurrent llseek race
because the assignment is done outside of the f_pos update.

>commit 7160dc70d8a3e5a45c11eadfba05b9996966c6b4
>Author: Andi Kleen <ak@linux.intel.com>
>Date:   Mon Mar 29 01:26:35 2010 +0200
>
>    USB-BKL: Convert usb_driver ioctl to unlocked_ioctl
>
>    And audit all the users. None needed the BKL.  That was easy
>    because there was only very few around.
>
>    Tested with allmodconfig build on x86-64
>
>    Signed-off-by: Andi Kleen <ak@linux.intel.com>
>diff --git a/include/linux/usb.h b/include/linux/usb.h
>index ce1323c..2803ca4 100644
>--- a/include/linux/usb.h
>+++ b/include/linux/usb.h
>@@ -846,7 +846,7 @@ struct usb_driver {
>
> 	void (*disconnect) (struct usb_interface *intf);
>
>-	int (*ioctl) (struct usb_interface *intf, unsigned int code,
>+	int (*unlocked_ioctl) (struct usb_interface *intf, unsigned int code,
> 			void *buf);
>
> 	int (*suspend) (struct usb_interface *intf, pm_message_t message);

The patch looks correct, but I probably wouldn't bother with the rename,
and simply drop the BKL in the caller.

>commit 89361b2e8d3dc3de83e105d60e49d5cdd9a68973
>Author: Andi Kleen <ak@linux.intel.com>
>Date:   Mon Mar 29 01:15:32 2010 +0200
>
>    USB-BKL: Remove BKL from usb serial drivers ioctl handlers
>
>    I audited all the low level serial ioctl handlers and none of them
>    actually need the BKL.
>
>    To make sure all code is checked change the usb_serial_driver ->ioctl
> field to ->unlocked_ioctl
>
>    Note this is still called for now with BKL held because tty drivers
>    don't have a ->unlocked_ioctl from the tty layer in mainline.
>    This could be trivially changed now though.
>
>    Signed-off-by: Andi Kleen <ak@linux.intel.com>

The serial_ioctl function is already called without the BKL, depite the
name. tty_operations->ioctl was converted a long time ago, so I guess this
patch can be dropped from your series.

	Arnd
