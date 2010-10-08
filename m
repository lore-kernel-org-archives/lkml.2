Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab0JHLqx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 07:46:53 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39619 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756514Ab0JHLqw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 07:46:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=D9iPQG9gpWyV/DK9moC6OosFQ8MMLUT16hyKL/poGimPlpDEJrMCzk1Q1tRuzu6fgG
         7LJNT5Dc+1GRiXYHbpZP992MsY/rO7GBqYPL3R3UwbzZtu0EG3ocpTLO7bfOgds3P6w4
         rvxeOXBv/R7OWwUiOizFi0EGlnMV/fEmAVCaI=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1010080941160.7653@localhost6.localdomain6>
References: <AANLkTikZj21CtFwC2ttvc0wJPx2qyedn7b1xXaxH659E@mail.gmail.com>
	<alpine.LFD.2.00.1010072227420.2484@localhost6.localdomain6>
	<alpine.LFD.2.00.1010072329220.3354@localhost6.localdomain6>
	<alpine.LFD.2.00.1010080941160.7653@localhost6.localdomain6>
Date: Fri, 8 Oct 2010 21:46:50 +1000
Message-ID: <AANLkTim=kmzwV+S-aP3+B1CNkS_XrvHuEewpmYZZtcA9@mail.gmail.com>
Subject: Re: "do_IRQ: 0.89 No irq handler for vector (irq -1)"
From: Dave Airlie <airlied@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Keith Packard <keithp@keithp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 8, 2010 at 5:52 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Thu, 7 Oct 2010, Thomas Gleixner wrote:
>  Oct  7 23:21:24 ionos kernel: Console: switching to colour VGA+ 80x25
>> Oct  7 23:21:31 ionos kernel: drm: unregistered panic notifier
>> Oct  7 23:21:31 ionos kernel: vga_switcheroo: disabled
>> Oct  7 23:21:31 ionos kernel: [drm:drm_mm_takedown] *ERROR* Memory manager not clean. Delaying takedown
>>
>> That one scares me :)
>>
>> Oct  7 23:21:32 ionos kernel: BUG: unable to handle kernel paging request at 00000037362e313a
>>
>> We are again dereferencing a user space address.
>
> Further debugging shows that the interrupt is torn down and the
> vectors are cleared. On modprobe the irq is set up again and a
> different vector is assigned.
>
> The interrupt which comes in is going to the old vector. So something
> is stale in the card.

Okay I've traced it with the hints Thomas gave me,

What happens is we have never called pci_disable_device on video
devices for various reasons, like shutting down VGA devices could be
hostile,

however on rmmod of the driver the PCI layer sets the device power
state to PCI_UNKNOWN, when we next load the driver we call
pci_enable_device
which sees the enable cnt is 1, so never calls
pci_set_power_state(PCI_D0), the MSI code won't actually write MSI
msgs unless it knows we are in D0.

Not sure how best to fix, I can workaround by calling
pci_set_power_state(PCI_D0) in the drm drivers, but I sorta thing the
PCI layer should take care of this.

Dave.
