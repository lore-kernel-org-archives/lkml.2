Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab0GRO1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 10:27:45 -0400
Received: from smtpauth01.tellcom.com.tr ([92.45.6.177]:27405 "EHLO
	smtpout2.superonline.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755462Ab0GRO1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 10:27:44 -0400
Message-ID: <4C430F52.7040400@superonline.com>
Date: Sun, 18 Jul 2010 17:27:30 +0300
From: "M. Vefa Bicakci" <bicave@superonline.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100619 Icedove/3.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Airlie <airlied@gmail.com>, Chris Wilson <chris@chris-wilson.co.uk>,
        earny@net4u.de, Roman Jarosz <kedgedev@gmail.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        jcnengel@googlemail.com, "A. Boulan" <arnaud.boulan@libertysurf.fr>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Pekka Enberg <penberg@cs.helsinki.fi>, A Rojas <nqn1976list@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, rientjes@google.com,
        michael@reinelt.co.at, stable@kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Selectively enable self-reclaim
References: <alpine.LFD.2.00.1001270327580.24253@localhost.localdomain><1264605932-8540-1-git-send-email-chris@chris-wilson.co.uk><alpine.LFD.2.00.1001270738220.24253@localhost.localdomain><89k77n$ms73l9@fmsmga001.fm.intel.com><alpine.LFD.2.00.1001270917120.24253@localhost.localdomain><AANLkTilpK6FfgbgVf4e7jJSvVwVDVLfrxIy3WmgliuLK@mail.gmail.com><89khjo$fr177d@orsmga002.jf.intel.com><AANLkTilwmuXlNYhlFkmpYHSmegPy3ws4x-YRFwkbk8Xm@mail.gmail.com><AANLkTinLB5YtqsnFwWrP37i3Ucr4fOaQzVuDLnyWBRGQ@mail.gmail.com><4C2D180C.5050805@superonline.com><AANLkTiklUBmNYs3710WftVX0Z3QihxFtDlK7tPlHZh8H@mail.gmail.com><AANLkTilOWu6ZwWjwPfHvNXDhyjb6n4N5KV1rUx6byJmq@mail.gmail.com><AANLkTilfkCBfZtRQlybQ721PSF4lSlqeOKL3rYnEz2G1@mail.gmail.com><AANLkTikpw42jE5Eh0EkXuRh70mb9x3njX6R4JNshawe5@mail.gmail.com><4C41FD6E.9090603@superonline.com> <AANLkTikqSwnLqJXPYGjMP0NS8TJ4D2uOBLDipoV89Qwc@mail.gmail.com>
In-Reply-To: <AANLkTikqSwnLqJXPYGjMP0NS8TJ4D2uOBLDipoV89Qwc@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SMTP-Filter: SurGATE SMTP Filter Engine Release 2.1 ($Revision: 184 $) http://www.endersys.com
X-SurGATE-Result: Clean (Content eval: 2.00 points)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/10 10:15 PM, Linus Torvalds wrote:
> On Sat, Jul 17, 2010 at 11:58 AM, M. Vefa Bicakci
> <bicave@superonline.com> wrote:
>>
>> The kernel with d8e0902806c0bd2ccc4f6a267ff52565a3ec933b reverted
>> was able to hibernate/thaw at least 40 times in one go, while
>> the one with your fix applied was able to hibernate/thaw at most
>> 17 times (in two separate trials) after which it crashed during
>> the next thaw.
> 
> Ok. I do wonder if the bug is possibly something entirely different,
> and the allocation patterns just happen to expose/hide it. Reverting
> the original commit should be pretty darn close to applying my fix.
> Any remaining issues would seem to be more about the actual bug in the
> original code (racing on changing that mapping->gfp_mask witthout any
> locking) than about anything else.
> 
>> Is there anything I can do find out the correct flags to use
>> in addition to GFP_HIGHUSER ? Can I do something like a bisection
>> for the flags one by one starting from the pre 2.6.32.8 state?
>> If you could outline a procedure to do this, I would be glad to
>> follow it.
> 
> You can try adding __GFP_RECLAIMABLE | __GFP_NOMEMALLOC to the set of
> flags in i915_gem_object_get_pages(). That's what the old code had
> (and then it played games with NORETRY|NOWARN). I've attached a patch
> (UNTESTED! Maybe it won't compile).
> 
> Now, I don't see why those flags would matter, but NOMEMALLOC in
> particular does make a difference for memory allocation patterns under
> low memory conditions, so maybe it could make a difference.
> 
> And if it _does_ make a difference, it would be interesting to know
> which of the two flags matter. So try both flags first, and see if
> that gets you something reliable. And if it does, remove one of them
> and try again - just to see _which_ flag it is that the i915 driver
> would care about. That would hopefully give us a hint.

Dear Linus,

After hours of testing I came up with the following result: We need
to have the __GFP_RECLAIMABLE flag in addition to GFP_HIGHUSER.

First I tested a kernel with both flags added to your fix. I was able
to get more than 60 hibernate/thaw cycles without any errors, so
I thought that was good.

Then I tried a kernel with __GFP_NOMEMALLOC, and I found out that
this kernel wasn't very reliable. In the first trial run, I got a
crash in the second thaw. (Magic Sys-Rq did work.) In the second
trial run, I got a Xorg related kernel Oops in the 12th thaw.
Therefore I concluded that having only __GFP_NOMEMALLOC in addition
to GFP_HIGHUSER was not good enough.

Finally, I tested a kernel with __GFP_RECLAIMABLE. For this one, I did
two trial runs, each with 60 hibernate/thaw cycles. I had no problems
during these runs, so I concluded that __GFP_RECLAIMABLE is the key
flag to use in addition to GFP_HIGHUSER and __GFP_COLD.

I think in a previous e-mail you were suggesting that __GFP_RECLAIMABLE
could be optionally needed for a few technical reasons. To be honest, I
have no idea why it looks like it is needed for proper operation.

As always, it is great to report test results. Hopefully this time I did
enough amount of tests.

Regards,

M. Vefa Bicakci
