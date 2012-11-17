Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab2KQC5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 21:57:10 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52873 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab2KQC5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 21:57:09 -0500
Date: Fri, 16 Nov 2012 18:53:55 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Kees Cook <keescook@chromium.org>
Cc: John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] pstore/ram: no timekeeping calls when unavailable
Message-ID: <20121117025355.GC29966@lizard>
References: <20121105220059.GA6379@www.outflux.net>
 <509DA63E.7070500@us.ibm.com>
 <CAGXu5jKq0=+XfH6yDSaJMcd-S3=o7xB67kspPkCRcXjRSGgciw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGXu5jKq0=+XfH6yDSaJMcd-S3=o7xB67kspPkCRcXjRSGgciw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 05:26:53PM -0800, Kees Cook wrote:
[....]
> >> @@ -171,7 +171,13 @@ static size_t ramoops_write_kmsg_hdr(struct
> >> persistent_ram_zone *prz)
> >>         struct timeval timestamp;
> >>         size_t len;
> >>
> >> -       do_gettimeofday(&timestamp);
> >> +       /* Handle dumping before timekeeping has resumed. */
> >> +       if (unlikely(timekeeping_suspended)) {
> >> +               timestamp.tv_sec = 0;
> >> +               timestamp.tv_usec = 0;
> >> +       } else
> >> +               do_gettimeofday(&timestamp);
> >> +
> >
> > Would nulling out the timestamp be better done in do_gettimeofday()?  That
> > way we don't have to export timekeeping internals and users would get
> > something more sane for this corner case.
> 
> Well... I'm not sure. If we don't want to expose the
> timekeeping_suspended variable, maybe we need a function to check
> this? I think it's probably better to find the users of timekeeping
> that could call it when suspended. That's why I figured the BUG was
> there. Very very few things should be attempting to call gettimeofday
> in a place where it might be suspended. As such, it seems like those
> things should be able to determine how to handle it. Maybe not
> everything would be sensible to get back 0s.
> 
> In this particular case, I'm fine with removing the BUG and returning
> 0 instead, since that's fine for ramoops. :)

In the lack of agreement on kernel/time/timekeeping.c change, I can't
apply the patch. And personally I tend to agree that doing this workaround
in the pstore code is odd. How about introducing ___do_gettimeofday() that
is safe to call when suspened, and the func would have good kernel doc
comments explaining the purpose of it?

Thanks,
Anton.
