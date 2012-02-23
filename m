Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab2BWSPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 13:15:47 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:43120 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756538Ab2BWSPp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 13:15:45 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.84.170 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <aefc95$3a3h8b@orsmga001.jf.intel.com>
References: <4F4669B1.4020306@tu-ilmenau.de> <aefc95$3a3h8b@orsmga001.jf.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 23 Feb 2012 10:15:24 -0800
X-Google-Sender-Auth: Cl2PmSFtkg2Zr5qDstDdfVq3EGY
Message-ID: <CA+55aFxO27oa+WAtDLuWtr-NFNmKb2T0V6pccn=AE+g5PePPUg@mail.gmail.com>
Subject: Re: responsiveness: newer kernels causing lagging and blocking
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stephan.baerwolf@tu-ilmenau.de, linux-kernel@vger.kernel.org,
        Michael Buesch <mb@bu3sch.de>, Alex Deucher <alexdeucher@gmail.com>,
        Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 9:21 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> The second is to break the loop for fatal errors, which is addressed by
>
> commit 9292f37e1f5c79400254dca46f83313488093825
> Author: Eugeni Dodonov <eugeni.dodonov@intel.com>
> Date:   Thu Jan 5 09:34:28 2012 -0200
>
>    drm: give up on edid retries when i2c bus is not responding

So I tried cherry-picking this one commit on top of current -git on
one of those nasty Mac Mini's.

I'm sad to report that I don't get anywhere *close* to the reported
performance numbers. Are there other commits involved that I should
have tried?

>    Timing results for i915-powered machines for 'time xrandr' command:
>    Machine 1: from 0.840s to 0.290s
>    Machine 2: from 0.315s to 0.280s
>    Machine 3: from +/- 4s to 0.184s
>
>    Timing results for HD5770 with 'time xrandr' command:
>    Machine 4: from 3.210s to 1.060s

On that Mac Mini, I get 0.611s before, and 0.553s after. So it does
seem to improve, but not nearly enough.

Part of the problem seems to be the bogus "TV1 unknown connection",
which just isn't true (and probably due to some insane Apple
connection setup). So I suspect something just doesn't get a proper
EDID, and times out or fails, and falls back to some bogus default. I
get

  TV1 unknown connection (normal left inverted right x axis y axis)
     1024x768       60.0
     800x600        60.3
     640x480        59.9

and I'm pretty sure there's no TV attached unless it is hiding under
the carpet somehow.

"perf record -a" shows that it's spending the time in udelay() as
expected (30% from intel_wait_for_pipe_off(), 30% from sclhi(), 30%
from bit_xfer() and 10% from acknak()). Which is what you'd expect
with that CPU-polling EDID thing.

So adding some scheduling might be a good idea regardless of that commit.

                             Linus
