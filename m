Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759879Ab0GAWlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:41:45 -0400
Received: from smtpauth.tellcom.com.tr ([92.45.6.172]:35887 "EHLO
	smtpout2.superonline.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758781Ab0GAWln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 18:41:43 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Jul 2010 18:41:42 EDT
Message-ID: <4C2D180C.5050805@superonline.com>
Date: Fri, 02 Jul 2010 01:34:52 +0300
From: "M. Vefa Bicakci" <bicave@superonline.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100619 Icedove/3.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Chris Wilson <chris@chris-wilson.co.uk>, Dave Airlie <airlied@gmail.com>,
       earny@net4u.de, Roman Jarosz <kedgedev@gmail.com>,
       intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       jcnengel@googlemail.com, "A. Boulan" <arnaud.boulan@libertysurf.fr>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>, A Rojas <nqn1976list@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, rientjes@google.com,
       michael@reinelt.co.at, stable@kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Selectively enable self-reclaim
References: <alpine.LFD.2.00.1001270327580.24253@localhost.localdomain><1264605932-8540-1-git-send-email-chris@chris-wilson.co.uk><alpine.LFD.2.00.1001270738220.24253@localhost.localdomain><89k77n$ms73l9@fmsmga001.fm.intel.com><alpine.LFD.2.00.1001270917120.24253@localhost.localdomain><AANLkTilpK6FfgbgVf4e7jJSvVwVDVLfrxIy3WmgliuLK@mail.gmail.com><89khjo$fr177d@orsmga002.jf.intel.com><AANLkTilwmuXlNYhlFkmpYHSmegPy3ws4x-YRFwkbk8Xm@mail.gmail.com> <AANLkTinLB5YtqsnFwWrP37i3Ucr4fOaQzVuDLnyWBRGQ@mail.gmail.com>
In-Reply-To: <AANLkTinLB5YtqsnFwWrP37i3Ucr4fOaQzVuDLnyWBRGQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SMTP-Filter: SurGATE SMTP Filter Engine Release 2.1 ($Revision: 184 $) http://www.endersys.com
X-SurGATE-Result: Clean (Content eval: 2.00 points)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/10 04:24 AM, Linus Torvalds wrote:
> On Wed, Jun 30, 2010 at 4:07 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> That commit changes the page cache allocation to use
>>
>> +                                          mapping_gfp_mask (mapping) |
>> +                                          __GFP_COLD |
>> +                                          gfpmask);
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
> pasting, it's a trivial one-liner).  Does this change any behavior?
> Vefa?
> 
>                     Linus

Dear Linus,

I made the code change you documented below to a vanilla 2.6.34 tree,
compiled it and tested hibernate/thaw cycles. In total, I tested
16 cycles, with 8 consecutive cycles in one installation (Debian Sid)
and 8 consecutive cycles in another one (Fedora 13). For every cycle,
I tried to run "old" and "new" programs, in terms of whether they were
run in previous cycles. I tried a few extra cycles with uswsusp as well.

Based on my testing, I am happy to report that the change you suggest
fixes the "memory corruption (segfaults) after thaw" issue for me.
I can't thank you enough times for this.

Now, the obligatory question: Could we have this fix applied to 2.6.32,
2.6.33 and 2.6.34 ?

Thanks a lot again!

M. Vefa Bicakci

--- linux-2.6.34/drivers/gpu/drm/i915/i915_gem.c.orig	2010-07-01 17:47:30.000000000 +0000
+++ linux-2.6.34/drivers/gpu/drm/i915/i915_gem.c	2010-07-01 17:54:03.000000000 +0000
@@ -2312,7 +2312,7 @@
 	mapping = inode->i_mapping;
 	for (i = 0; i < page_count; i++) {
 		page = read_cache_page_gfp(mapping, i,
-					   mapping_gfp_mask (mapping) |
+					   __GFP_HIGHMEM |
 					   __GFP_COLD |
 					   gfpmask);
 		if (IS_ERR(page))

