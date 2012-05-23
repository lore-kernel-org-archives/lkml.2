Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab2EWPwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:52:04 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50083 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab2EWPwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:52:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120523093208.GB4085@opensource.wolfsonmicro.com>
References: <20120522183037.75ec03c9d8881ec188e7f787@canb.auug.org.au>
 <4FBBAF1B.1070702@xenotime.net> <alpine.DEB.2.00.1205222339030.9290@chino.kir.corp.google.com>
 <20120523093208.GB4085@opensource.wolfsonmicro.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 May 2012 08:51:39 -0700
X-Google-Sender-Auth: mnEdi2I23x4Rz1Gzb0uJeHHfH8Q
Message-ID: <CA+55aFynyjrHUCh48aXSQpZpboQM7MCCtMHvxBxCf+gDoCVWXg@mail.gmail.com>
Subject: Re: [patch -linus] regmap: REMAP_IRQ should select IRQ_DOMAIN itself
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Rientjes <rientjes@google.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 2:32 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
>
> The reason we're selecting things from the users is that multi-level
> selects have never seemed to be terribly robust, they've been a
> noticable source of breakage with this sort of randconfig stuff in the
> past which is painful and annoying, especially given the strange fixes
> that tend to come from randconfig reports.

Multi-level pure selects *should* work correctly. So you can select
stuff that then in turn selects other stuff - and that should all be
fine.

It's *dependencies* that do not work.

So if you "select" something that depends on something else, you need
to make sure that you select all those dependencies (and because
recursive selects work, you have to check the entire *chain* of
selects to see the dependencies).

This is one reason why "select" is generally much more friendly than
"depends on". In general, we should strive to

 - only make "depends on" for really *major* subsystems (like the
whole architecture, or something like networking), or on "pure user
helper variables" like the "You do want to see network drivers from
vendor Xyz" kind things.

  This way "depends on" doesn't get too complicated: either it's
really big deals ("this works only on ARM") or it's high-level pure UI
stuff ("I won't bother to ask about fifteen different 3com cards,
because the user already said he isn't interested in 3com networking")

 - use select for "the small details" - ie a driver should "select"
the helper stuff it needs and that people shouldn't need to even know
about (like random encryption engines etc).

but obviously there's a lot of gray areas in between, and then usually
it becomes an issue of "what are things that are sane to ask users".

But in general, a simple "select" is actually the *easiest* and most
straightforward thing, especially if the thing you are selecting
itself does not have any "depends on".

                   Linus
