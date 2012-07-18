Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab2GRTz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 15:55:59 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59622 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab2GRTzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 15:55:47 -0400
Date: Wed, 18 Jul 2012 22:55:37 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        Richard Genoud <richard.genoud@gmail.com>
Subject: Re: [PATCH 2/5] ubi: Limit amount of reserved eraseblocks for bad
 PEB handling
Message-ID: <20120718225537.38ddbb60@halley>
In-Reply-To: <1342607317.7530.9.camel@brekeke>
References: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com>
	<1341389164-24409-3-git-send-email-shmulik.ladkani@gmail.com>
	<1342607317.7530.9.camel@brekeke>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

On Wed, 18 Jul 2012 13:28:37 +0300 Artem Bityutskiy <dedekind1@gmail.com> wrote:
> The whole thing will become simpler if we first mark the PEB as bad
> unconditionally (because it _is_ bad), then grab the lock and do all the
> re-calculations.

On first glance that would sound the right thing to do.

Actually, when looked at the original code, which does NOT mark the
block bad when 'beb_rsvd_pebs == 0' (instead, does a 'goto out_ro'),
I initially thought "this is SO wrong, the block IS bad, we MUST mark it
bad, what IS the deal here?".
But then I spent more and more time trying to backtrack the reason for
it - and I think I found a reason, quite an improtant one.

Suppose 'beb_rsvd_pebs == 0'.

In the original scheme, it means that there are NO available PEBs at
all. All good PEBs are "assigned" (to user volumes, layout volume, WL
and EBA).

Now, if one of these PEBs goes bad, and you DO mark it bad, and
decrement the good_peb_count, you'll have a shortage of good PEBs - it
will not match the amount of PEBs assigned to the consumers (user
volumes, layout, WL, EBA).
Meaning, next attach would simply fail with a "no enough physical
eraseblocks" message (grep for these in ubi_wl_init and ubi_eba_init).
You won't even be able to attach anymore. Not good.

However, if you DO NOT mark it bad, but instead go into RO mode, you
should be able to later re-attach because the good_peb_count would fit
(no shortage of PEBs).

So going into RO seems a "less worse" solution than marking bad, for
that particular case.

Anyways, I've really invested some thought into this patch, trying to
cover all sorts of esoteric cases.
I think the logic itself is pretty robust, although I would really
appreciate some reassurances on that...

I agree the code does not "read simple" enough, I tried to make the best
simplifying and adding some comments. Let me know if you'd like some
more polish on it.

I saw you submitted a simplified version, I can surely take a look, but
I'm afraid it lacks the proper treatment discussed above (NOT marking
the bad block as bad when beb_rsvd_pebs is zero).

Let me know.

Many thanks,
Shmulik
