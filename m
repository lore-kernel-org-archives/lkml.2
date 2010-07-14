Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab0GNPiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 11:38:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753161Ab0GNPiD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 11:38:03 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimYDDviG2no6RVPZZj8rD2d2URMAPUCWuftiFiB@mail.gmail.com>
References: <20100713114322.57c8b166.sfr@canb.auug.org.au>
	<AANLkTimC_vXCAOrfTSndZyk8lgkjTlILVSYVYeIg6cUt@mail.gmail.com>
	<AANLkTik-QCXFnjma3J28B9h27uajOcDhthTGz99zKgVi@mail.gmail.com>
	<AANLkTimYDDviG2no6RVPZZj8rD2d2URMAPUCWuftiFiB@mail.gmail.com>
Date: Wed, 14 Jul 2010 08:37:23 -0700
Message-ID: <AANLkTinhMmYi2l29Rlb11yfRlmsv4YAC50JBlXkdjmKh@mail.gmail.com>
Subject: Re: [PATCH] kbuild: Enable building defconfigs from Kconfig files
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <rmk@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 10:47 PM, Grant Likely
<grant.likely@secretlab.ca> wrote:
>
> Okay, well I advocate for the -D /dev/null approach then.  I think
> that validating our defaults, and looking for the subtle interactions
> are exactly what we want to be doing when it comes to defconfigs.  The
> fact that a defconfig does *not* want the default value is exactly
> what the defconfigs should be capturing.

Sure. That does have the downside that it absolutely _requires_
changes to the Kconfig language. Because currently "select" can only
set a config variable, it cannot clear it or downgrade it from the
defaults - so if you start from anything but a noconfig, you can't
unset anything.

But that's not a big downside, since honestly either approach will
want it anyway (even -n wants it for setting integer or string options
- never mind the whole issue of making it easier/cleaner to write the
files in the first place).

>>          set NODES_SHIFT 10
>
> I'm partial to extending select statements myself because it fits
> nicely into the existing grammer; but I can see value in having a set
> statement too.

If it turns out easier to just implement the "set value" as a "select
with a value", that's fine by me too. If the syntax for setting a
particular value ends up being

   select NODES_SHIFT 10

that still works (with or without a "=" there). It looks a bit odd to
me, but that's probably just because it's new. It doesn't look _wrong_
by any stretch.

> It would eliminate the temporary config options that
> both my and Stephen's patch would add.

I don't think there is anything wrong with having the extra config
option just to drive the "select" syntax. In fact, in many cases I
think it would be "documentation", because I think the extra config
option should generally be named by the platform that you're actually
selecting for - even if that name may not be used for anything else.

So having the basic syntax for a Kconfig.xyz file be something like

         config SIDEWINDER_PLATFORM
              def_bool y
              select ...

where that initial config/def_bool is strictly not needed for the
actual end result, but is used to get to the select statements, and to
include that "SIDEWINDER_PLATFORM=y" in the resulting .config as a
kind of top-level comment all looks fine.

                 Linus
