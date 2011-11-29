Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab1K2S7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 13:59:07 -0500
Received: from imr4.ericy.com ([198.24.6.9]:53845 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334Ab1K2S7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 13:59:05 -0500
Date: Tue, 29 Nov 2011 10:57:46 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: =?iso-8859-1?Q?Jean-Fran=E7ois?= Dagenais <dagenaisj@sonatest.com>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: MFD: core assumes that all children are platform devices
Message-ID: <20111129185746.GA23986@ericsson.com>
References: <2F9D884C-6B95-4F81-8445-8056676B28D8@sonatest.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2F9D884C-6B95-4F81-8445-8056676B28D8@sonatest.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 11:23:00AM -0500, Jean-François Dagenais wrote:
> Hi,
> 
> I have a pci driver that registers with UIO for it's operations. As a consequence, the pci device
> instance has a child device of class uio.
> 
> My driver also declares a ds1wm instance that has it's register interface at an offset in BAR0
> of the pci device, as an MFD cell.
> 
> When I call mfd_remove_devices, MFD proceeds to enumerate ALL the parent device's chilren
> and assumes that they are MFD cells, and thus platform_device, which is not true in my case.
> (...uio is a child of the parent pci device)
> 
> I had (luckily or unluckily) not seen signs of this broken assumption on certain setups I have
> used, but in my current setup, this page-faults every time now.
> 
> This is a major thing and I have not found the assumption documented anywhere.
> 
> I could first declare a new child device on my pci device and then declare it as the parent to
> the mfd cells...
> 
I had the same problem, with a Multi-function USB device. Took me a while to figure out that
mfd_remove_devices() removed the USB child devices when I used the USB device as MFD parent device.

My solution was to do what you suggested - my MFD probe function now creates a platform device
to be used as MFD parent device. Works nicely, it doesn't require much additional code,
and I think it is cleaner than other possible solutions (at least the ones I came up with).
We'll see how it flies with the MFD and USB maintainers once I submit the patch ;).

> Or, is there a way for the mfd-core, as it's doing the "for each child device", to recognize
> non-MFD-cell children and skip them?
> 
Looking at your proposed patch, I personally prefer my solution. Of course it would be nice
if it was documented that MFD parent devices MUST be dedicated (platform) devices and must not
have any non-MFD child devices. This would be a simple documentation patch and avoid making
assumptions on MFD child device removal.

Guenter 
