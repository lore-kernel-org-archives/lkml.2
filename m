Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab1F0Grn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 02:47:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49208 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756824Ab1F0Gqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 02:46:47 -0400
Date: Mon, 27 Jun 2011 16:46:37 +1000
From: NeilBrown <neilb@suse.de>
To: Nico Schottelius <nico-lkml-20110623@schottelius.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Mis-Design of Btrfs?
Message-ID: <20110627164637.377314e2@notabene.brown>
In-Reply-To: <20110623105337.GD3753@ethz.ch>
References: <20110623105337.GD3753@ethz.ch>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jun 2011 12:53:37 +0200 Nico Schottelius
<nico-lkml-20110623@schottelius.org> wrote:

> Good morning devs,
> 
> I'm wondering whether the raid- and volume-management-builtin of btrfs is
> actually a sane idea or not.
> Currently we do have md/device-mapper support for raid
> already, btrfs lacks raid5 support and re-implements stuff that
> has already been done.
> 
> I'm aware of the fact that it is very useful to know on which devices
> we are in a filesystem. But I'm wondering, whether it wouldn't be
> smarter to generalise the information exposure through the VFS layer
> instead of replicating functionality:
> 
> Physical:   USB-HD   SSD   USB-Flash          | Exposes information to
> Raid:       Raid1, Raid5, Raid10, etc.        | higher levels
> Crypto:     Luks                              |
> LVM:        Groups/Volumes                    |
> FS:         xfs/jfs/reiser/ext3               v
> 
> Thus a filesystem like ext3 could be aware that it is running
> on a USB HD, enable -o sync be default or have the filesystem
> to rewrite blocks when running on crypto or optimise for an SSD, ...

I would certainly agree that exposing information to higher levels is a good
idea.  To some extent we do.  But it isn't always as easy as it might sound.
Choosing exactly what information to expose is the challenge.  If you lack
sufficient foresight you might expose something which turns out to be
very specific to just one device, so all those upper levels which make use of
the information find they are really special-casing one specific device,
which isn't a good idea.


However it doesn't follow that RAID5 should not be implemented in BTRFS.
The levels that you have drawn are just one perspective.  While that has
value, it may not be universal.
I could easily argue that the LVM layer is a mistake and that filesystems
should provide that functionality directly.
I could almost argue the same for crypto.
RAID1 can make a lot of sense to be tightly integrated with the FS.
RAID5 ... I'm less convinced, but then I have a vested interest there so that
isn't an objective assessment.

Part of "the way Linux works" is that s/he who writes the code gets to make
the design decisions.   The BTRFS developers might create something truly
awesome, or might end up having to support a RAID feature that they
subsequently think is a bad idea.  But it really is their decision to make.

NeilBrown
