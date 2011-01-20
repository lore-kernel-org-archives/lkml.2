Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab1ATQLH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 11:11:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768Ab1ATQLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 11:11:06 -0500
MIME-Version: 1.0
In-Reply-To: <849307$b7q280@azsmga001.ch.intel.com>
References: <AANLkTimOkFckq+r4cD-PSzc_RNs+HJL5CcEM-3Yh+dF6@mail.gmail.com>
 <AANLkTin98pf1d29AtT7RwjGBeR=m4rBp7Ks6vvmz18vf@mail.gmail.com>
 <AANLkTi=s9ZMdUe2bsK2OA5rJBej=R8CaJyE+kT3Fd5wG@mail.gmail.com> <849307$b7q280@azsmga001.ch.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Jan 2011 08:07:02 -0800
Message-ID: <AANLkTi=AEhztUp30A0o5YxHCqqLg38+f5s+mXfbZTX8Y@mail.gmail.com>
Subject: Re: more intel drm issues (was Re: [git pull] drm intel only fixes)
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 2:25 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> Right, the autoreported HEAD may have been already reset to 0 and so hit
> the wraparound bug which caused it to exit early without actually
> quiescing the ringbuffer.

Yeah, that would explain the issue.

> Another possibility is that I added a 3s timeout waiting for a request if
> IRQs were suspended:

No, if IRQ's are actually suspended here, then that codepath is
totally buggy and would blow up (msleep() doesn't work, and jiffies
wouldn't advance on UP). So that's not it.

> Both of those I think are symptoms of another problem, that perhaps during
> suspend we are shutting down parts of the chip before idling?

That could be, but looking at the code, one thing strikes me: the
_normal_ case (of just waiting for "enough space" in the ring buffer)
doesn't need to use the exact case, but the "wait for ring buffer to
be totally empty" does.

Which means that the use of the "fast-but-inaccurate" 'head' sounds
wrong for the "wait for idle" case.

So can you explain the difference between

   intel_read_status_page(ring, 4);

vs

   I915_READ_HEAD(ring);

because from looking at the code, I get the notion that
"intel_read_status_page()" may not be exact. But what happens if that
inexact value matches our cached ring->actual_head, so we never even
try to read the exact case? Does it _stay_ inexact for arbitrarily
long times? If so, we might wait for the ring to empty forever (well,
until the timeout - the behavior I see), even though the ring really
_is_ empty. No?

Also, isn't that "head < ring->actual_head" buggy? What about the
overflow case? Not that we care, because afaik, 'actual_head' is not
actually used anywhere, so it should be called 'pointless_head'?

That code looks suspiciously bogus.

                    Linus
