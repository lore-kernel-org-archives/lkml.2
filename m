Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab1ATRvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:51:53 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32824 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753319Ab1ATRvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:51:52 -0500
MIME-Version: 1.0
In-Reply-To: <0d30dc$kqf9gp@orsmga001.jf.intel.com>
References: <AANLkTimOkFckq+r4cD-PSzc_RNs+HJL5CcEM-3Yh+dF6@mail.gmail.com>
 <AANLkTin98pf1d29AtT7RwjGBeR=m4rBp7Ks6vvmz18vf@mail.gmail.com>
 <AANLkTi=s9ZMdUe2bsK2OA5rJBej=R8CaJyE+kT3Fd5wG@mail.gmail.com>
 <849307$b7q280@azsmga001.ch.intel.com> <AANLkTi=AEhztUp30A0o5YxHCqqLg38+f5s+mXfbZTX8Y@mail.gmail.com>
 <0d30dc$kqf9gp@orsmga001.jf.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Jan 2011 09:51:00 -0800
Message-ID: <AANLkTimsf+nCtZrO8f9E0b3=_Y2FikbAHioeZk-Vp=Lm@mail.gmail.com>
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

On Thu, Jan 20, 2011 at 9:38 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
>> because from looking at the code, I get the notion that
>> "intel_read_status_page()" may not be exact. But what happens if that
>> inexact value matches our cached ring->actual_head, so we never even
>> try to read the exact case? Does it _stay_ inexact for arbitrarily
>> long times? If so, we might wait for the ring to empty forever (well,
>> until the timeout - the behavior I see), even though the ring really
>> _is_ empty. No?
>
> Ah. Your analysis is spot on and this will cause a hang whilst polling if
> we enter the loop with the last known head the same as the reported value.

So how about just doing this in the loop? It will mean that the
_first_ read uses the fast cached one (the common case, hopefully),
but then if we loop, we'll use the slow exact one.

(cut-and-paste, so whitespace isn't good):

  diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c
b/drivers/gpu/drm/i915/intel_ringbuffer.c
  index 03e3370..11bbfb5 100644
  --- a/drivers/gpu/drm/i915/intel_ringbuffer.c
  +++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
  @@ -961,6 +961,8 @@ int intel_wait_ring_buffer(struct
intel_ring_buffer *ring, int n)
                  msleep(1);
                  if (atomic_read(&dev_priv->mm.wedged))
                          return -EAGAIN;
  +               /* Force a re-read. FIXME: what if read_status_page
says 0 too */
  +               ring->actual_head = 0;
          } while (!time_after(jiffies, end));
          trace_i915_ring_wait_end (dev);
          return -EBUSY;

but to get rid of the FIXME you should probably get rid of
"actual_head" entirely, and just use a local variable as a simple
boolean flag instead.

Hmm?

           Linus
