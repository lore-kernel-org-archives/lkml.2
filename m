Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666Ab2GMBmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 21:42:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36502 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab2GMBmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 21:42:11 -0400
Date: Thu, 12 Jul 2012 22:42:04 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Javier Marcet <jmarcet@gmail.com>, Andrey Rahmatullin <wrar@wrar.name>,
        Oleksij Rempel <bug-track@fisher-privat.net>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [ 51/68] PCI: EHCI: fix crash during suspend on ASUS computers
Message-ID: <20120713014203.GB3121@herton-Z68MA-D2H-B3>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
 <20120712175039.938377320@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120712175039.938377320@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 04:02:25PM -0700, Greg Kroah-Hartman wrote:
> From: Greg KH <gregkh@linuxfoundation.org>
> 
> 3.0-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------

Missing also the diff/"signoff area" on this one.

> 
> From: Alan Stern <stern@rowland.harvard.edu>
> 
> commit dbf0e4c7257f8d684ec1a3c919853464293de66e upstream.
> 
> Quite a few ASUS computers experience a nasty problem, related to the
> EHCI controllers, when going into system suspend.  It was observed
> that the problem didn't occur if the controllers were not put into the
> D3 power state before starting the suspend, and commit
> 151b61284776be2d6f02d48c23c3625678960b97 (USB: EHCI: fix crash during
> suspend on ASUS computers) was created to do this.
> 
> It turned out this approach messed up other computers that didn't have
> the problem -- it prevented USB wakeup from working.  Consequently
> commit c2fb8a3fa25513de8fedb38509b1f15a5bbee47b (USB: add
> NO_D3_DURING_SLEEP flag and revert 151b61284776be2) was merged; it
> reverted the earlier commit and added a whitelist of known good board
> names.
> 
> Now we know the actual cause of the problem.  Thanks to AceLan Kao for
> tracking it down.
> 
> According to him, an engineer at ASUS explained that some of their
> BIOSes contain a bug that was added in an attempt to work around a
> problem in early versions of Windows.  When the computer goes into S3
> suspend, the BIOS tries to verify that the EHCI controllers were first
> quiesced by the OS.  Nothing's wrong with this, but the BIOS does it
> by checking that the PCI COMMAND registers contain 0 without checking
> the controllers' power state.  If the register isn't 0, the BIOS
> assumes the controller needs to be quiesced and tries to do so.  This
> involves making various MMIO accesses to the controller, which don't
> work very well if the controller is already in D3.  The end result is
> a system hang or memory corruption.
> 
> Since the value in the PCI COMMAND register doesn't matter once the
> controller has been suspended, and since the value will be restored
> anyway when the controller is resumed, we can work around the BIOS bug
> simply by setting the register to 0 during system suspend.  This patch
> (as1590) does so and also reverts the second commit mentioned above,
> which is now unnecessary.
> 
> In theory we could do this for every PCI device.  However to avoid
> introducing new problems, the patch restricts itself to EHCI host
> controllers.
> 
> Finally the affected systems can suspend with USB wakeup working
> properly.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
[]'s
Herton
