Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab2KEMJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:09:10 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:56790 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985Ab2KEMJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:09:07 -0500
Message-ID: <1352117341.14888.275.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] samsung-laptop: Disable if CONFIG_EFI=y
From: Matt Fleming <matt@console-pimps.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Corentin Chary <corentincj@iksaif.net>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        Alessandro Crismani <alessandro.crismani@gmail.com>,
        Mikhail Bakhterev <mike.bakhterev@gmail.com>,
        Patrick H <kernel@feystorm.net>, "H. Peter Anvin" <hpa@zytor.com>,
        stable@vger.kernel.org, x86 <x86@kernel.org>
Date: Mon, 05 Nov 2012 12:09:01 +0000
In-Reply-To: <20121105103753.GA25850@kroah.com>
References: <1352050506-29317-1-git-send-email-matt@console-pimps.org>
	 <20121105103753.GA25850@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-05 at 11:37 +0100, Greg KH wrote:
> On Sun, Nov 04, 2012 at 05:35:06PM +0000, Matt Fleming wrote:
> > From: Matt Fleming <matt.fleming@intel.com>
> > 
> > We've started getting reports of users seeing Machine Check Exceptions
> > when booting their Samsung laptops in UEFI mode,
> > 
> >      https://bugzilla.kernel.org/show_bug.cgi?id=47121
> > 
> > This module seems to be the culprit as it's grovelling around in the
> > 0xf0000 region which has no mapping in either the e820 or EFI memory
> > maps on the affected machines.
> 
> So, does this mean that if we try to ioremap a memory location in the
> kernel, like this driver is, it will not fail, but, when accessing the
> memory, bad things happen?

Yes. I'm not sure exactly what sequence of memory accesses is causing
the MCEs because the above bug report states that the MCEs were frequent
but intermittent and I don't have any hardware to reproduce this on.

> That's not good, shouldn't the call to ioremap_nocache() have failed
> originally?  That sounds like a core EFI/platform bug here, and one that
> you might run into other places.

I think it's an x86 bug. AFAIK it's entirely possible to ioremap
arbitrary memory addresses whether or not the firmware/BIOS knows about
them (by which I mean, includes a mapping in the e820 map). It's just
that traditionally the firmware didn't throw MCEs when you peeked at
some part of the address map. The < 1MB region of the x86 address map
also fills me with visions of voodoo.

Jacob Shin and Yinghai Lu have been working on some patches that avoid
mapping the holes (the address regions for which there is no entry in
the e820 memmap) and I think that could be used to address this problem.

> Shouldn't fixing that be the real fix?

Absolutely, and it was always my intention to fix this properly so that
I didn't have the same bug reported to me over and over again. However,
initially I was more concerned about writing a fix that was good enough
and small enough to be marked for stable. Messing with the kernel memory
map, particularly for EFI systems, has been fraught with peril in the
past.

-- 
Matt Fleming, Intel Open Source Technology Center

