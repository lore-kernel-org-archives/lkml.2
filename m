Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934154Ab0J1S4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:56:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51588 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761442Ab0J1Szs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:55:48 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=8tq1zu_RWjmk5rLOWvP_KPH5UQioQ6wEkc0Ob@mail.gmail.com>
References: <E1PBKT9-0004Uk-Sm@tytso-glaptop> <20101028075631.GA7690@elte.hu>
 <AANLkTi=8SbOZizWpxLg=Bgp7atdgr8MsR6tnRDYr1+eW@mail.gmail.com>
 <20101028163854.GA15450@elte.hu> <AANLkTin62vAwJxcsrFk6Yn7Q6tzr-D=EmKKwPazuAJ11@mail.gmail.com>
 <20101028171701.GA18368@elte.hu> <20101028172725.GA6814@thunk.org> <AANLkTi=8tq1zu_RWjmk5rLOWvP_KPH5UQioQ6wEkc0Ob@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 28 Oct 2010 11:54:55 -0700
Message-ID: <AANLkTin=EeQx4pEPk9ST27kcRpDP65NQvL1c1m8UcRmO@mail.gmail.com>
Subject: Re: Minimum git commit abbrev length (Was Re: -tip: origin tree build
 failure (was: [GIT PULL] ext4 update) for 2.6.37)
To: "Ted Ts'o" <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>, git@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 11:28 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Yes. The default of 7 (I think) comes from fairly early in git
> development, when seven hex digits was a lot (it covers about 250+
> million hash values). Back then I thought that 65k revisions was a lot
> (it was what we were about to hit in BK), and each revision tends to
> be about 5-10 new objects or so, so a million objects was a big
> number.
>
> These days, the kernel isn't even the largest git project, and even
> the kernel has about 220k revisions (_much_ bigger than the BK tree
> ever was) and we are approaching two million objects. At that point,
> seven hex digits is still unique for a lot of them, but when we're
> talking about just two orders of magnitude difference between number
> of objects and the hash size, there _will_ be hash collisions. It's no
> longer even close to unrealistic - it happens all the time.

Hmm. In fact, in the kernel, we currently have about twelve thousand
objects that end up having collisions in 7 hex digits. Even in the old
historical BK kernel tree, we have over a thousand objects that
collide (each bucket in both cases gets just two objects, there are as
of yet no multiple collisions, which is what you'd expect with a good
hash). See with

  git rev-list --objects --all | cut -c1-7 | sort | uniq -dc

and in fact git itself has a few collisions (but currently just 44
objects ending up sharing 22 SHA1 buckets in 7 digits).

With each digit, you'd expect the collisions to decrease by a factor
of 16, and that is indeed exactly what happens. For my current kernel
tree I get:

 - 7 digits: 5823 buckets with duplicates (ie 11646 objects that aren't unique)
 - 8: 406
 - 9: 30
 - 10: 1
 - 11: 0

so 12 hex digits is indeed pretty safe for the kernel, and is likely
to remain so until the kernel history grows by a factor of 16.

                        Linus
