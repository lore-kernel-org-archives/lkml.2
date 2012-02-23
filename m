Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab2BWRMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 12:12:41 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56457 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab2BWRMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 12:12:40 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.216.136.200 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F4669B1.4020306@tu-ilmenau.de>
References: <4F4669B1.4020306@tu-ilmenau.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 23 Feb 2012 09:12:19 -0800
X-Google-Sender-Auth: iEIbtcitJZy4Gtf0KwMmWou2Jbo
Message-ID: <CA+55aFy37+AgjRB0V5f8RMhYPHPo1TK18NnO5s48wyQQP4=bJQ@mail.gmail.com>
Subject: Re: responsiveness: newer kernels causing lagging and blocking
To: stephan.baerwolf@tu-ilmenau.de
Cc: linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 8:30 AM, Stephan Bärwolf
<stephan.baerwolf@tu-ilmenau.de> wrote:
> Under various conditions linux since 2.6.39-rc1 laggs and blocks enormously the whole system.
> (For example while starting "winecfg" (on a thinkpad X220) and parallel moving the
> mousecursor you can observe a periodic blocking for some seconds)
>
> After bisecting a little while, commit "4819d2e4310796c4e9eef674499af9b9caf36b5a"
> (" drm: Retry i2c transfer of EDID block after failure ") seems to be responsible.
>
> Because function "drm_do_probe_ddc_edid" loops trying "i2c_transfer" it consumes a lot
> of time during errors. Reverting or changing "retries" from 5 to 1 extremly minimizes the
> problem to "not perceptible".
> It seems the locking within "i2c_transfer" slows everything down.
> So maybe it is possible to yield() before calling it?

Ugh. The whole i2c thing is a mess. Most of the i2c drivers seem to
busy-loop using 'usleep()' too, so not only do they take a long time,
they take a long time while using CPU and being unresponsive in
general. So it's not just locking, I suspect.

I'm not surprised that it gets to the point that you can notice the
unresponsiveness. At some point I made a bug-report about the i915
driver using 7% of CPU (yes, really) just doing i2c all the time on an
Apple Mac Mini, because it just couldn't get happy with the results,
and the i915 driver would re-start it every five seconds or something
like that.

Your case sounds even worse - at least on that Mac Mini it didn't
cause all that noticeable hickups (possibly because it was
multi-core).

And looking at the code - not only does drm_do_probe_ddc_edid() have a
retry loop, the *callers* sometimes call that thing from two loops
deep. There's the block count, and for some reason there's that "i =
0..3" retry loop around it in drm_do_get_edid() that seems to be
*another* retry loop.

So if I read it right, drm_do_get_edid() actually retries *20* times
for the base block, and then potentially does that for each block.

I wonder if that double retry is really intentional at all.

But yeah, if nothing else, let's *please* add a

    if (need_resched()) schedule();

at the top of drm_do_probe_ddc_edid().

I'm assuming you don't have PREEMPT enabled? Does that hide the problem?

                             Linus
