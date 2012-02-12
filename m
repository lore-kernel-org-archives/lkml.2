Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab2BLQQr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 11:16:47 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35069 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964Ab2BLQQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 11:16:45 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 12 Feb 2012 17:16:17 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org
Subject: Re: [RFC][PATCH 00/13] firewire-sbp-target: FireWire SBP-2 SCSI
 target
Message-ID: <20120212171617.3c0e4389@stein>
In-Reply-To: <4F37D714.3010006@bootc.net>
References: <4E4BD560.4010806@bootc.net>
	<1328989452-20921-1-git-send-email-bootc@bootc.net>
	<20120212151247.3d33d45b@stein>
	<4F37D714.3010006@bootc.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 12 Chris Boot wrote:
> On 12/02/2012 14:12, Stefan Richter wrote:
> > The APIs which you include from "../../firewire/core.h" should eventually
> > be moved to<linux/firewire.h>.  I think it does not matter whether this
> > is done before or after mainline merge.  When we do so we should check
> > whether the affected APIs can be improved for usage in drivers.
> 
> I'm not even sure I use that much from there at all. Possibly only 
> fw_card_{get,put,release}(), so that could quite easily be moved into 
> <linux/firewire.h>.

Yes, I suppose this is just the card reference counting which we found
is needed for some types of userspace drivers too.  But for them it is
wrapped up in the core-cdev.c glue, thus still core-internal presently.

> > Many of the printks should surely be demoted to debug messages with
> > runtime on-and-off switch.
> 
> I've moved a lot of them to pr_debug() which doesn't emit anything 
> unless you ask it to. Are there others you think should be pr_debug() 
> that aren't?

OK, could have been a wrong impression after superficial reading.

[...]
> > sbp_login.c:
> > +			pr_notice("initiator already logged-in\n");
> > +
> > +			/*
> > +			 * SBP-2 R4 says we should return access denied, but
> > +			 * that can confuse initiators. Instead we need to
> > +			 * treat this like a reconnect, but send the login
> > +			 * response block like a fresh login.
> > +			 */
> > Are there initiators which don't bother with reconnect but send relogin
> > straight away?
> 
> I found my PowerBook did. It looks like when OpenFirmware hands over to 
> Darwin, the latter just does a login. I changed this before I had the 
> code to expire sessions once the reconnect timeout expires though so 
> it's probably unnecessary now but it would slow down the boot by several 
> seconds.

Right, this is a special case.  I remember this as an issue with Linux on
Apple PCs as well, together with a particular harddisk firmware with
somewhat unusual timing characteristics, which rejects firewire-sbp2's
login because it still considers the firmware's login valid.  The former
ieee1394 + sbp2 stack had more luck, but probably just because of slightly
different timing on their part.

You could make this a special case for initiators with Apple's OUI in
the EUI-64.  But I suppose there is no real downside to do this
unconditionally.

Anyway, the case of Apple firmware login -> OS login handover could
certainly be mentioned in the quoted comment, as the one quite common case
where this deviation from the spec is required or at least beneficial.

> > Kconfig:
> > "default n" is redundant.
> > "*older* Apple computers":  They are still manufactured with this feature.
> 
> I thought all the newer ones only did this over Thunderbolt and not 
> FireWire? I'm more than happy to change this though.

Oh, I don't actually know about these ones.
-- 
Stefan Richter
-=====-===-- --=- -==--
http://arcgraph.de/sr/
