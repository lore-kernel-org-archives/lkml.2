Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab1EUJeL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 05:34:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52963 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab1EUJeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 05:34:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] arch/tile: add arch/tile/drivers/ directory with SROM driver
Date: Sat, 21 May 2011 11:33:50 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        Eric Biederman <ebiederm@aristanetworks.com>,
        linux-kernel@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>,
        Benjamin Thery <benjamin.thery@bull.net>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
References: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com> <4DD6FB9E.2050604@tilera.com> <20110521032102.GD19907@suse.de>
In-Reply-To: <20110521032102.GD19907@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105211133.50238.arnd@arndb.de>
X-Provags-ID: V02:K0:304ItlWDXjtsfTzaNwPfK9WKXQKO7GGtSd7Zx++aTxk
 SNBUcMAXiwiCTcpbbWA3dcCnSK6gCih46voKQRSkHHO9CaLdHS
 khr69wuvLjfABSdPzxFh4ZuZuFkBFh6HXIG3DwTu9acJIOEjwz
 umXDCtCdp+a0QxiqpZvdaXmSW70gRgVie9ZBOHqa+WK7y/AnxD
 eWf0BKIzq5AzJE/hVBf3g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 May 2011 05:21:02 Greg KH wrote:
> On Fri, May 20, 2011 at 07:39:10PM -0400, Chris Metcalf wrote:
> > On 5/20/2011 6:40 PM, Eric Biederman wrote:
> > 
> > > You are vastly exceeding the one value per file rule of sysfs.
> > 
> > True, but bin_attribute has always been an exception to that rule anyway.
> 
> No it hasn't.  A bin attribute is for something that is "one" value, it
> is a binary file that the kernel doesn't know anything about, nor does
> it intrepret it.
> 
> It sounds like you want this binary attribute file to be a bit different
> than the "normal" one, and because of that you are wanting to modify the
> sysfs file, which proves that you are doing things differently here.

I initially argued that the file is the same as all the other ones
in drivers/misc/eeprom/*.c. None of them care what the data is and
they pass it through to the user. It would also be possible to
always flush after each write, which makes the interface act more
like you would expect it to, at the cost of lower performance in
case the user writes it in small blocks.

> > Originally I proposed a straightforward character device for this
> > role.
> 
> Ah, ok, I think you should do that.
> 
> > Arnd Bergmann encouraged me to look at kernel precedents like
> > drivers/char/eeprom/, which is why I converted this driver to sysfs.
> > The first post in this thread is here:
> > https://lkml.org/lkml/2011/5/4/415 .  Since then I've come around to
> > believing that it's more valuable to group this driver with the other
> > eeprom drivers, rather than with the other paravirtualized tile
> > drivers.
> 
> See above why I don't think that is so.

What I only now noticed is that the other eeprom drivers only support
reading the eeprom, not writing it, so there is a significant difference.

Using the bin_attribute doesn't sound completely wrong to me, especially
if you put it in your /sys/hypervisor/* direcory together with the
regular attributes we talked about. The character device would also
be an option (better than /proc/ppc/update_flash that is used on pSeries),
but if we do that, I would group it together with the other similar
files (ps3flash, nwflash, ...) in a new subdirectory.

	Arnd
