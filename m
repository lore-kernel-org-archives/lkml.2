Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab1ATR7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:59:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753502Ab1ATR7e convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:59:34 -0500
MIME-Version: 1.0
In-Reply-To: <4D387109.9020207@t-online.de>
References: <4D387109.9020207@t-online.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Jan 2011 09:58:42 -0800
Message-ID: <AANLkTi=GjnyE1_RosS_L_sn=QCTDSgO7v9EL+1bpJTu7@mail.gmail.com>
Subject: Re: [BUG] 2.6.38-rc1-git1: hard lockup related to i915 / automated
 cgroup scheduling
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: airlied@linux.ie, jesse.barnes@intel.com, linux-kernel@vger.kernel.org,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 9:29 AM, Knut Petersen
<Knut_Petersen@t-online.de> wrote:
> Kernel 2.6.38-rc1 and -git1 will lock my AOpen i915GMm-HFS
> at the end of  KDE startup if automatic process group scheduling
> is actived in kernel config. A hard reset is necessary.
> Without automatic process group scheduling everything is ok.

Interesting. Most likely timing-related, but maybe there's some actual
memory corruption. Adding the scheduler guys just in case.

It might be interesting to see if enabling SLUB debugging makes any
difference. Interesting for two reasons:

 - it may just make the problem go away because it changes timings
radically enough (which is the bad case, since that doesn't really
help us very much)

 - maybe it's not timing-related, and instead shows some slab misuse
and corruption that explains the problem.

I dunno.

> Reproducibility of bug: 100 %
> System: AOpen i915GMm-Hfs, 2GB, Pentium M
> Distribution: openSuSE 11.3
>
> cu,
>  Knut
>
> Jan 20 17:57:07 golem kernel: [   58.087054] ------------[ cut here ]------------
> Jan 20 17:57:07 golem kernel: [   58.087117] kernel BUG at drivers/gpu/drm/i915/i915_gem.c:3254!

Grr. Hate people who do BUG_ON() calls that kill the machine and make
things harder to debug.

What happens if you replace that

  BUG_ON(obj->pin_count == DRM_I915_GEM_OBJECT_MAX_PIN_COUNT);

with a

  if (WARN_ON_ONCE(obj->pin_count == DRM_I915_GEM_OBJECT_MAX_PIN_COUNT))
    return -ENOMEM;

or similar? Does it limp along? I'm not suggesting that as a fix
(obviously), but I do think that we have way too many BUG_ON's, and
too few people thinking about "how can I make the machine possibly
limp on so that the oops is easier to see and report"

                     Linus
