Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab1AKQBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 11:01:16 -0500
Received: from relais.videotron.ca ([24.201.245.36]:11317 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179Ab1AKQBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 11:01:15 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 11 Jan 2011 11:01:14 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk
Subject: Re: ARM: relocation out of range (when loading a module)
In-reply-to: <4D2BFA08.5030104@ahsoftware.de>
Message-id: <alpine.LFD.2.00.1101111048010.16547@xanadu.home>
References: <4D2B4CE4.9080309@ahsoftware.de>
 <alpine.LFD.2.00.1101101722470.9794@xanadu.home>
 <4D2BFA08.5030104@ahsoftware.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011, Alexander Holler wrote:

> Am 10.01.2011 23:26, schrieb Nicolas Pitre:
> > On Mon, 10 Jan 2011, Alexander Holler wrote:
> > 
> > > I've build a kernel 2.6.37 for an armv5-device which includes an initramfs
> > > of
> > > about 16MB (uncompressed, result is a kernel of about 6MB) and I now
> > > getting
> > > errors when trying to load a module (which is included in that initramfs):
> > 
> > Do you really need to have such a bit initramfs?
> 
> Not really, but it is handier to use than a separate file.
> 
> > What you can do to work around this issue is to load your initramfs
> > separately as a initrd ramdisk image. , and not combine it with the
> > kernel image.
> 
> Point is that I would like to understand why including an initramfs has such
> consequences.

The layout of the kernel virtual memory goes like this:

0xbf000000 to 0xbfffffff: kernel module area
0xc0008000 and above: kernel image

The module area is located just before the kernel memory because this 
allows function calls from modules to be linked directly without any 
indirect branches.  For that to work, the branch destination has to be 
within 32MB of its origin location.

Now the kernel image has its __init section located at the beginning. It 
is located there because of some alignment restriction, and the 
initramfs data is located in the __init section.  So if your initramfs 
is about 16MB, plus the size of the module area which is also 16MB you 
get a distance from a loaded module to the actual kernel core bigger 
than the possible branch fixup.


Nicolas
