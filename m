Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab0GAKPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 06:15:21 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34866 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab0GAKPS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 06:15:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V/KflMyq6KcwTA4zt9SGwLSlQY28OOtqyDPyvByVsBwkPw8N0SZthc8ln9l0Z0wAv3
         QhfoGAypLmeUIvvgKpIvWpyyFBEAfiMmZ0VbnsWAS8TNdlfkjHbJI4lvSTbBbcX2wmHg
         iqz9AO9gvt/e3+wmY8k5kmgGYqXwx6a2sqmF4=
MIME-Version: 1.0
In-Reply-To: <AANLkTinLB5YtqsnFwWrP37i3Ucr4fOaQzVuDLnyWBRGQ@mail.gmail.com>
References: <alpine.LFD.2.00.1001270327580.24253@localhost.localdomain>
	<1264605932-8540-1-git-send-email-chris@chris-wilson.co.uk>
	<alpine.LFD.2.00.1001270738220.24253@localhost.localdomain>
	<89k77n$ms73l9@fmsmga001.fm.intel.com>
	<alpine.LFD.2.00.1001270917120.24253@localhost.localdomain>
	<AANLkTilpK6FfgbgVf4e7jJSvVwVDVLfrxIy3WmgliuLK@mail.gmail.com>
	<89khjo$fr177d@orsmga002.jf.intel.com>
	<AANLkTilwmuXlNYhlFkmpYHSmegPy3ws4x-YRFwkbk8Xm@mail.gmail.com>
	<AANLkTinLB5YtqsnFwWrP37i3Ucr4fOaQzVuDLnyWBRGQ@mail.gmail.com>
Date: Thu, 1 Jul 2010 20:15:16 +1000
Message-ID: <AANLkTilKezSkoNKYxaKlsC7lI-RTHlkE4qVcE5eER-WE@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Selectively enable self-reclaim
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, earny@net4u.de,
       Roman Jarosz <kedgedev@gmail.com>, intel-gfx@lists.freedesktop.org,
       linux-kernel@vger.kernel.org, jcnengel@googlemail.com,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>, A Rojas <nqn1976list@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, rientjes@google.com,
       michael@reinelt.co.at, stable@kernel.org,
       Vefa Bicakci <bicave@superonline.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 1, 2010 at 11:24 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Jun 30, 2010 at 4:07 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> That commit changes the page cache allocation to use
>>
>> +                                          mapping_gfp_mask (mapping) |
>> +                                          __GFP_COLD |
>> +                                          gfpmask);
>>
>> if I read it right. And the default mapping_gfp_mask() is
>> GFP_HIGHUSER_MOVABLE, so I think you get all of
>> (__GFP_WAIT | __GFP_IO | __GFP_FS | __GFP_HARDWALL | __GFP_HIGHMEM)
>> set by default.
>
> .. and then I left out the one flag I _meant_ to have there, namely
> __GFP_MOVABLE.
>
>> The old code didn't just play games with ~__GFP_NORETRY and change
>> that at runtime (which was buggy - no locking, no protection, no
>> nothing), it also initialized the gfp mask. And that code also got
>> removed:
>
> In fact, I don't really see why we should use that mapping_gfp_mask()
> at all, since all allocations should be going through that
> i915_gem_object_get_pages() function anyway. So why not just change
> that function to ignore the default gfp mask for the mapping, and just
> use the mask that the o915 driver wants?
>
> Btw, why did it want to mark the pages reclaimable?
>
> Anyway, what I'm suggesting somebody who sees this test is just
> something like the patch below (whitespace-damage - I'm cutting and
> pasting, it's a trivial one-liner).  Does this change any behavior?
> Vefa?
>

I think Linus is on to something, I'll finish my testing tomorrow,

I'm stuck testing this on a laptop with a 4200rpm driver, hibernating
takes quite a long time ;-(

But I have reproduced the initial failure,reverted the patch
reproduced success, and then did a couple of cycles with Linus patch
before I left.

Tomorrow I'll do another 3-4 cycles to confirm.

the patch also needs a couple of __ before GFP_HIGHMEM, in  case
anyone else was hacking it.

Dave.


>                    Linus
>
> ---
> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> index 9ded3da..ec8ed6b 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -2239,7 +2239,7 @@ i915_gem_object_get_pages(struct drm_gem_object *obj,
>        mapping = inode->i_mapping;
>        for (i = 0; i < page_count; i++) {
>                page = read_cache_page_gfp(mapping, i,
> -                                          mapping_gfp_mask (mapping) |
> +                                          GFP_HIGHMEM |
>                                           __GFP_COLD |
>                                           gfpmask);
>                if (IS_ERR(page))
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
