Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab0DCTar (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 15:30:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54375 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002Ab0DCTal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 15:30:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Clemens Ladisch" <clemens@ladisch.de>
Subject: Re: [Regression, post-rc2] Commit a5ee4eb7541 breaks OpenGL on RS780 (was: Re: Linux 2.6.34-rc3)
Date: Sat, 3 Apr 2010 21:33:20 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Alex Deucher" <alexdeucher@gmail.com>,
       "Linux PCI" <linux-pci@vger.kernel.org>, "Greg KH" <gregkh@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       dri-devel@lists.sourceforge.net, stable@kernel.org,
       "Dave Airlie" <airlied@gmail.com>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org> <201004021846.06522.rjw@sisk.pl> <1270318093.15869.1368145605@webmail.messagingengine.com>
In-Reply-To: <1270318093.15869.1368145605@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004032133.20872.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 April 2010, Clemens Ladisch wrote:
> Rafael J. Wysocki wrote:
> > From: Clemens Ladisch <clemens@ladisch.de>
> > Subject: PCI quirk: RS780/RS880: disable MSI completely
> > 
> > The missing initialization of the nb_cntl.strap_msi_enable does not
> > seem to be the only problem that prevents MSI, so that quirk is not
> > sufficient to enable MSI on all machines.  To be safe, disable MSI
> > unconditionally for the internal graphics and HDMI audio on these
> > chipsets.
> > 
> > [rjw: Added the PCI_VENDOR_ID_AI quirk.]
> > ...
> > +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x9602, quirk_disable_msi);
> > +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ASUSTEK, 0x9602, quirk_disable_msi);
> > +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AI, 0x9602, quirk_disable_msi);
> 
> I fear I have to NACK this.

I'm afraid it's too late, the patch has been merged.

> The fact that two OEMs have changed the vendor
> ID makes it likely that this is a bug in AMD's template BIOS code, and that
> we will see the same problem on other systems using other vendor IDs.
> 
> So we should not use the vendor ID of device 0x9602 to declare the quirk, but
> use some other device with an ID that is known to be correct.  We already
> access the configuration space of the host bridge, so we should use that.
> 
> Furthermore, the quirk in my first patch was never run at all on the ALi
> system, so it is probable that the nb_cntl.strap_msi_enable detection
> would actually work.  Rafael, please test this patch; if it doesn't work
> on your system, we can still remove the check for the strap_msi_enable bit.
> 
> ==========
> 
> Subject: PCI quirk: RS780/RS880: work around wrong vendor IDs of RS780 bridge
> 
> On many RS780 systems, the vendor ID of the PCI/PCI bridge for the
> internal graphics is set to that of the mainboard vendor, so the quirk
> would not match and failed to notice the disabled MSI.
> 
> Since we do not know in advance all possible vendor IDs, we have to
> declare the quirk on another device with an ID that is known to be
> correct, and use that as a stepping stone to find the PCI/PCI bridge,
> if present.
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> Cc: <stable@kernel.org>

Yes, this works (after reverting commit
5193d7a7f500cfbbfc0de221e808208199723521 and removing the
(rdev->flags & RADEON_IS_IGP) test from radeon_irq_kms_init()).

Thanks,
Rafael
