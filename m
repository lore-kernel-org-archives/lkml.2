Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab0GBAG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 20:06:26 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44270 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab0GBAGY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 20:06:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=yGhwmHsQ+seDKHh3IZZ7xLoj15r5VJmwhKH39BqUkYS9OOT0ygCSKPMb0GY1L9gVrb
         EQVWHwm3QoSwXritcl8LZNKR2wIhZTNcZKoiu2x56DKP/9Nbph4BP6zINxdptEW3kQhw
         UcYklkLzFoJdytZh2826DHWwv+rPjOMNMMmss=
MIME-Version: 1.0
In-Reply-To: <AANLkTiklUBmNYs3710WftVX0Z3QihxFtDlK7tPlHZh8H@mail.gmail.com>
References: <alpine.LFD.2.00.1001270327580.24253@localhost.localdomain>
	<1264605932-8540-1-git-send-email-chris@chris-wilson.co.uk>
	<alpine.LFD.2.00.1001270738220.24253@localhost.localdomain>
	<89k77n$ms73l9@fmsmga001.fm.intel.com>
	<alpine.LFD.2.00.1001270917120.24253@localhost.localdomain>
	<AANLkTilpK6FfgbgVf4e7jJSvVwVDVLfrxIy3WmgliuLK@mail.gmail.com>
	<89khjo$fr177d@orsmga002.jf.intel.com>
	<AANLkTilwmuXlNYhlFkmpYHSmegPy3ws4x-YRFwkbk8Xm@mail.gmail.com>
	<AANLkTinLB5YtqsnFwWrP37i3Ucr4fOaQzVuDLnyWBRGQ@mail.gmail.com>
	<4C2D180C.5050805@superonline.com>
	<AANLkTiklUBmNYs3710WftVX0Z3QihxFtDlK7tPlHZh8H@mail.gmail.com>
Date: Fri, 2 Jul 2010 10:06:23 +1000
Message-ID: <AANLkTilOWu6ZwWjwPfHvNXDhyjb6n4N5KV1rUx6byJmq@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Selectively enable self-reclaim
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "M. Vefa Bicakci" <bicave@superonline.com>,
       Chris Wilson <chris@chris-wilson.co.uk>, earny@net4u.de,
       Roman Jarosz <kedgedev@gmail.com>, intel-gfx@lists.freedesktop.org,
       linux-kernel@vger.kernel.org, jcnengel@googlemail.com,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>, A Rojas <nqn1976list@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, rientjes@google.com,
       michael@reinelt.co.at, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 2, 2010 at 9:59 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Jul 1, 2010 at 3:34 PM, M. Vefa Bicakci <bicave@superonline.com> wrote:
>>
>> Based on my testing, I am happy to report that the change you suggest
>> fixes the "memory corruption (segfaults) after thaw" issue for me.
>> I can't thank you enough times for this.
>
> Hey, goodie. And you're the one to be thanked - bisecting it down to
> that commit that wasn't _meant_ to have any real semantic changes
> (except for the bug-fix of racy mapping gfp-flags update) is what
> really cracked the lid on the problem.
>
>> Now, the obligatory question: Could we have this fix applied to 2.6.32,
>> 2.6.33 and 2.6.34 ?
>
> No problem, except we should first determine exactly what flags are
> the appropriate ones. My original patch was obviously not even
> compile-tested, and I actually meant for people to use GFP_HIGHUSER
> rather than __GFP_HIGHMEM. That contains all the "regular" allocation
> flags (but not the __GFP_MOVABLE, which is still just a suspicion of
> being the core reason for the problem).
>
> And the original DRM code had:
>
>   GFP_HIGHUSER |
>   __GFP_COLD |
>   __GFP_FS |
>   __GFP_RECLAIMABLE |
>   __GFP_NORETRY |
>   __GFP_NOWARN |
>   __GFP_NOMEMALLOC
>
> which is not entirely sensible (__GFP_FS is already part of
> GFP_HIGHUSER, for example), and two of the flags (NORETRY and NOWARN)
> are the ones the driver wants to do conditionally.
>
> But that still leaves the question about __GFP_COLD (probably sane),
> __GFP_RECLAIMABLE (I wonder about that one) and __GFP_NOMEMALLOC
> (usually used together with NORETRY, and I'm not at all sure it makes
> sense as a base flag).
>
> So I suspect the final patch should not look like the one you tested,
> but instead likely have
>
>   GFP_HIGHUSER | __GFP_COLD
>
> and possibly the __GFP_RECLAIMABLE flag too instead of just the bare
> __GFP_HIGHMEM..
>
> (Well, we already had that __GFP_COLD there from before, so it's
> really about replacing __GFP_HIGHMEM with something like "GFP_HIGHUSER
> | __GFP_RECLAIMABLE").
>
> But its' great to hear that this does seem to be the underlying cause.
> If you could test with that GFP_HIGHUSER | __GFP_RECLAIMABLE, that
> would be a good thing. After all - maybe the problem was triggered by
> some other flag than __GFP_MOVABLE, and as such, having some
> additional testing with a bigger set of allocation flags would be a
> really good thing.

I just sent a patch I tested here with GFP_HIGHUSER | __GFP_COLD
instead, and it resumes okay for me,

I'll play with GFP_RECLAIMABLE now,

If anyone wants to know why nobody uses hibernate, this laptop with a
4200rpm driver boots faster than the hibernate cycle.

Dave.
