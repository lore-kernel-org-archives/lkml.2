Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab2JVLW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 07:22:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60537 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab2JVLW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 07:22:26 -0400
Date: Mon, 22 Oct 2012 04:19:28 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org
Subject: [RFC v2 0/2] vmevent: A bit reworked pressure attribute + docs + man
 page
Message-ID: <20121022111928.GA12396@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

So this is the second RFC. The main change is that I decided to go with
discrete levels of the pressure.

When I started writing the man page, I had to describe the 'reclaimer
inefficiency index', and while doing this I realized that I'm describing
how the kernel is doing the memory management, which we try to avoid in
the vmevent. And applications don't really care about these details:
reclaimers, its inefficiency indexes, scanning window sizes, priority
levels, etc. -- it's all "not interesting", and purely kernel's stuff. So
I guess Mel Gorman was right, we need some sort of levels.

What applications (well, activity managers) are really interested in is
this:

1. Do we we sacrifice resources for new memory allocations (e.g. files
   cache)?
2. Does the new memory allocations' cost becomes too high, and the system
   hurts because of this?
3. Are we about to OOM soon?

And here are the answers:

1. VMEVENT_PRESSURE_LOW
2. VMEVENT_PRESSURE_MED
3. VMEVENT_PRESSURE_OOM

There is no "high" pressure, since I really don't see any definition of
it, but it's possible to introduce new levels without breaking ABI. The
levels described in more details in the patches, and the stuff is still
tunable, but now via sysctls, not the vmevent_fd() call itself (i.e. we
don't need to rebuild applications to adjust window size or other mm
"details").

What I couldn't fix in this RFC is making vmevent_{scanned,reclaimed}
stuff per-CPU (there's a comment describing the problem with this). But I
made it lockless and tried to make it very lightweight (plus I moved the
vmevent_pressure() call to a more "cold" path).

Thanks,
Anton.
