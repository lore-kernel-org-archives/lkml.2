Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab0L3U6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 15:58:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58821 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab0L3U6L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 15:58:11 -0500
MIME-Version: 1.0
In-Reply-To: <20101230082654.GB11721@angua.secretlab.ca>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
 <1290706801-7323-3-git-send-email-bigeasy@linutronix.de> <1290807736.32570.143.camel@pasglop>
 <20101128134907.GA30784@www.tglx.de> <20101230082654.GB11721@angua.secretlab.ca>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 30 Dec 2010 13:57:50 -0700
X-Google-Sender-Auth: i1OhBWdK1A6KvTQLvyRdibFWpNA
Message-ID: <AANLkTimZoC+5zGY75aWB=x1Z1q+qcyyFgAHEvaEgzXyH@mail.gmail.com>
Subject: Re: [PATCH 02/11] x86: Add device tree support
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, sodaville@linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 1:26 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Sun, Nov 28, 2010 at 02:49:07PM +0100, Sebastian Andrzej Siewior wrote:
>> The reason why you have multiple .o wrapper files is because the specific
>> platform code is not simply passing the device tree but also adding /
>> updating nodes like MAC address, bus clocks, ... which are coming from
>> the (different) bd_t struct or something else. The simpleboot target is
>> covering the case where you just pass the embedded dtb to kernel without
>> changing it.
>>
>> On x86 we want to have the bootloader passing us the final dtb. The
>> in-kernel dtb is more like a generic simpleboot target.
>
> /me gets ready to dodge tomatoes thrown at him.
>
> Hmmm, back up a minute...
>
> Since Linux on x86 has pretty much always depended on a two stage boot
> (firmware boots a bootloader like grub which in turn boots the
> kernel), then what is the use case for pursuing an in-kernel dtb
> linkage?  simpleimage was used on powerpc for the use-case where there
> is no 2nd stage bootloader, but instead only the kernel which is
> booted from some firmware that is non-upgradeable (or at least too
> risky to upgrade).  Same with the cuImages.  The wrapper is
> effectively a 2nd stage bootloader to adapt from what older u-boot
> provides and what the kernel needs.
>
> What is the boot sequence for the embedded x86 platforms?  Is there
> still a bootloader?  If so, what prevents always depending on the
> bootloader to pass in the device tree blob?  If the bootloader is
> software (not firmware) then it should be something we have control
> over when shipping a distribution.
>
> BTW, don't take microblaze as the example to be emulated.  Some of
> the things it does for device tree support is not scalable, like
> linking the .dtbs directly into the kernel.
>
> John Bonesio has also prototyped doing a similar zImage bootwrapper on
> arm which allows a dtb to be concatenated to the kernel image and
> updated before passing it to the kernel.  As it stands, there are no
> plans to use in-kernel .dtb linking on ARM.

Hmmm, I shouldn't be sending email at 1:30 in the morning.  The above
statement is not really true.  One of the use-cases on ARM is using a
device tree with existing firmware that doesn't pass a dt blob.  Right
now there are two possible methods for doing this.  Option one is to
link the .dtbs in the the kernel proper and point to them from the
machine struct.  The dtb would be used when a matching machine id is
passed by the firmware.  Option 2 is to select the correct .dtb with a
kernel boot wrapper, which is exactly the method used by the powerpc
boot wrappers and is the mechanism that John Bonesio is prototyping
(hopefully will have patches out on the list early in the new year).

Personally I prefer the boot wrapper method because it means there is
exactly one mechanism for providing the kernel proper with a .dtb and
it allows the set of dtbs to be provided at install time instead of
kernel compile time.  Since the boot wrapper prototype is so-far
successful, it is the approach that I'm going to pursue on ARM (but
I'm not yet completely ruling out option 1).

Peter & Dirk, I realize that this is different from what we talked
about at Plumbers this year.  I'm not saying no to linking the .dtbs
into the kernel proper on x86, and I don't pretend to know the details
of the x86 Linux boot interface, but if dtb linking is merged, then
x86 will probably be the only major architecture to use it (microblaze
doesn't count as major)  :-).

g.
