Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab2AYNf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 08:35:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50165 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab2AYNfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 08:35:25 -0500
MIME-Version: 1.0
In-Reply-To: <20120125115705.GF3687@opensource.wolfsonmicro.com>
References: <1327491338-18817-1-git-send-email-s.nawrocki@samsung.com>
	<20120125115705.GF3687@opensource.wolfsonmicro.com>
Date: Wed, 25 Jan 2012 14:35:25 +0100
Message-ID: <CADkCAuudPtdb04HXMgHzgDpFWrr9xPJu3yMRe9pE4YDLD+_cUw@mail.gmail.com>
Subject: Re: [PATCH/RFC] regulator: Reverse the disable sequence in regulator_bulk_disable()
From: Bill Gatliff <bgat@billgatliff.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys:

On Wed, Jan 25, 2012 at 12:57 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Jan 25, 2012 at 12:35:38PM +0100, Sylwester Nawrocki wrote:
>
>
> So, I've applied this since it shouldn't do any harm and probably is
> more what we meant to do but note that the bulk APIs don't make any
> guarantees about ordering - in particular when we do the enable we fire
> off a bunch of threads to bring the regulators up in parallel so the
> ordering really is going to be unreliable as it depends on the scheduler
> and the rates at which the various regulators ramp.  This is done so
> that we can enable faster as we don't have to wait for each regulator to
> ramp in series.

Presumably, then, the notifier mechanism will remain positive
confirmation that the associated regulator has indeed come up?  And
that multithreading thing will be interesting to implement given
parent-child relationships of regulator sources at times...

> Whatever driver inspired you to submit this change is therefore probably
> buggy or fragile at the minute - is it something that's in mainline or
> next right now?

I think he's probably dealing with a "VLOGIC <= VDD"-type requirement,
which isn't uncommon.  I'm dealing with it myself right now, actually.

In addition to the sequencing that imposes, it also has implications
for recalculating VLOGIC when VDD changes--- which means a notifier
somewhere.  I might be convinced that implementing this logic inside
the API itself might be of benefit, though I don't see right now how
to do it in a clear and generic way.

> At some point I'd like to enhance things further so we can coalesce
> register writes where multiple regulators have their enable bits in the
> same register but that's a relatively large amount of work for a small
> benefit unless we do something cute with regmap (and that is likely to
> be too cute).

That sounds awfully cute for such marginal benefit.  :)  I really like
the correct-by-inspection-ness of the current implementation.

>> The alternatives to directly modifying regulator_bulk_disable() could be:

I really don't have a problem with the disable order being the reverse
of the enable order, as it generally follows common sense for people
who work with e.g. multiple mutexes.  I kind of would have expected it
to be that way, actually.

> The third option is that where devices really care about the power
> sequencing they should explicitly write that in code and only use the
> bulk APIs where they don't care.

This is probably the best way, since it keeps the "care about" part in
front of the author's eyes and implements it in the chip-specific
code, where it is immune from changes in how the regulator API might
behave in the future.  Changes like the one we are discussing, for
example. :)


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
