Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab1JITe1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 15:34:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43752 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751392Ab1JITe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 15:34:26 -0400
Date: Sun, 9 Oct 2011 20:34:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Valdis.Kletnieks@vt.edu
Cc: dp@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/2] regmap: Allow caches for devices with no defaults
Message-ID: <20111009193424.GA24008@opensource.wolfsonmicro.com>
References: <1318167876-17801-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1318167876-17801-2-git-send-email-broonie@opensource.wolfsonmicro.com> <109263.1318182222@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <109263.1318182222@turing-police.cc.vt.edu>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 09, 2011 at 01:43:42PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Sun, 09 Oct 2011 14:44:36 BST, Mark Brown said:

> > We only really need the defaults in order to cut down the number of
> > registers we sync and to satisfy reads while the device is powered off

> So let me get this straight - we cache the values so that if there's a read,
> we can return our best guess as to what the device would return if it was
> in fact powered on, instead of notifying the caller that the device is off?

> I think I just sprained my brain trying to parse the logic there :)

It's not a guess, it's very solid information which comes from a
combination of knowing the default register values, knowing that the
registers we cache won't be changed except by writes and caching writes.
We're not really doing the caching for this particular feature, having a
cache is really useful anyway and once you're doing register caching
it's a small step to be able to skip the actual device interaction.

Having a register cache is useful where you don't need much abstraction
between the register and the upper layers that talk to the driver - you
can end up with large chunks of driver which are just data tables saying
"this bitfield in this register has these semantics" which is obviously
a substantial win.

However, not all devices have readback support (on older analogue
processes digital was very expensive and there were a few other issues
for some buses) and this can get very read heavy (both from
read/modify/write cycles and from upper layers querying state) so when
your device is on a slow bus it's really useful to be able to cache the
register values rather than actually read from the device.

Once you've got a cache it's a simple matter to skip the step where we
actually interact with the device for non-volatile registers.  In
situations where the device is idle and we've got the sort of thin
mapping described above we don't really want to have to keep the device
powered on just for the mapping and the register values are about all
the abstraction we need so we don't want another layer. If there a lot
of updates being made this can give a further performance boost as upper
layers can update things in any order they see fit as often as they like
and then we can coalesce the actual writes into a minimal subset when
powering the device up for actual use.

For a concrete example think of an audio CODEC - there's lots of
controls like volume settings which can be mapped very directly to what
users interact with and which have no practical impact unless the device
is actually doing something other than to store the setting which will
be used then.
