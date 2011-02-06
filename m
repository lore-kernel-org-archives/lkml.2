Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab1BFXfE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:35:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48708 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438Ab1BFXfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:35:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 5/5] ACPI: Tie ACPI backlight devices to PCI devices if possible
Date: Mon, 7 Feb 2011 00:34:43 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: akpm@linux-foundation.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, rpurdie@rpsys.net,
        Len Brown <lenb@kernel.org>
References: <1295033065-13450-1-git-send-email-mjg@redhat.com> <201102070001.25814.rjw@sisk.pl> <20110206230558.GA23889@srcf.ucam.org>
In-Reply-To: <20110206230558.GA23889@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102070034.43691.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 07, 2011, Matthew Garrett wrote:
> On Mon, Feb 07, 2011 at 12:01:25AM +0100, Rafael J. Wysocki wrote:
> 
> > Yes, it seems so, but I'm not sure what the short term consequences of that
> > change will be.  Perhaps there will be none. :-)
> 
> Ok, I'll have a play with that. Maybe we should be fixing this up 
> somehow in the acpi-pci glue code? It seems wrong to have acpi devices 
> resumed before the PCI device they're associated with.

Those device's don't have ACPI drivers and therefore they are not really
suspended or resumed, so we don't need to fix anything in that area.

Still, IMO, there is a design issue in the entire ACPI subsystem, because the
idea of "ACPI device" really is not well defined, so to speak.  Sometimes
they are just "device interfaces" that can be used to ask the firmware for
something (like in the case of the "ACPI devices" associated with PCI devices)
and sometimes they are "real devices" with real drivers.  The video device
apparently wants to be both at the same time, which is even more confusing. :-)

I _think_ that struct acpi_device shouldn't really contain the embedded device
object and each of struct acpi_device objects should be pointed to by the
archdata member of certain struct device.  In turn, struct acpi_device should
contain a pointer to the struct device that it's pointed to by via the archdata
field.  Then, the struct acpi_device objects will always be "device interfaces"
and all of the device-driver interactions will be represented through their
corresponding device objects.  That should allow us to avoid all of the
suspend-resume complications (and all sorts of other ugliness).
