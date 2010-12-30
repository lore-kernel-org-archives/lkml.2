Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab0L3Wa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 17:30:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322Ab0L3Wa2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 17:30:28 -0500
MIME-Version: 1.0
In-Reply-To: <20101230140103.1189c545@jbarnes-desktop>
References: <0d30dc$kjvpke@orsmga001.jf.intel.com> <20101230140103.1189c545@jbarnes-desktop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 30 Dec 2010 14:29:34 -0800
Message-ID: <AANLkTik4j48eUg=EuL1OzcjQ2hXRGMYNwQcKxpudxKxB@mail.gmail.com>
Subject: Re: [git pull] i915 fixes
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Dave Airlie <airlied@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 2:01 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
> Did you want to disable SSC entirely on gen5+ just so we can get all
> the known machines working?  It's possible it could add some wifi or
> sound interference, but that's better than not having a display (most
> of the time).

It would be sad to possibly add more electrical noise to machines that
already work with it, but at the same time I do think that "working
screen" tends to be a lot more important than "try to avoid RF noise".

Also, are you sure it's really the fact that we enable spread-spectrum
that causes this? The code is really confused, and seems to mix up
"lvds_use_ssc" not just with the enabling of SSC, but it also with how
impacts the reference clock itself.

And it impacts the reference clock in really odd ways, that look buggy
and confusing, where the tests are repeated in multiple places: first
to set the reference frequency, and then later to set the bits that
choose the reference input frequency.

In particular, look at how 'refclk' is calculated in
intel_crtc_mode_set(), vs how we actually set the input frequency
later in the function. The two don't actually *match*. That sounds
bogus to me - since it means that the pll values have been calculated
for a reference clock that isn't actually used. No?

Look at the code for the "!is_lvds" case, for example. It uses
"IS_GEN2()" to determine what refclk to use, but then when setting the
PLL_REF_INPUT_xyz bits, we actually take "is_tv" into account - which
the code didn't when it calculated refclk. That strikes me as odd. No?

Now, that shouldn't matter for the LVDS case, but I'm wondering
whether something similar is going on where the conditionals just
don't match up, and we end up calculating the plls for a different
frequency than the one we actually end up _using_.

There's also this very odd special refclock magic for ironlake
limiting that only happens for ssc_freq == 100 when ssc is enabled.
Maybe the problem is in the limiting tables, and the ssc frequency
change just ends up then picking the "wrong" limiter table? So even if
the frequency is correct, and the pll calculations are using that
correct frequency, the 120-vs-100Mhz frequency change ended up
switching the tables around?

                               Linus
