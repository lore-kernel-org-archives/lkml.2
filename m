Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab2KGMJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 07:09:33 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43432 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab2KGMJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 07:09:32 -0500
Date: Wed, 7 Nov 2012 04:06:26 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org
Subject: Re: [RFC v3 0/3] vmpressure_fd: Linux VM pressure notifications
Message-ID: <20121107120626.GB32565@lizard>
References: <20121107105348.GA25549@lizard>
 <CAOJsxLFz+Zi=A0uyuNMj411ngjwpstakNY3fEWy6tW_h4whr7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOJsxLFz+Zi=A0uyuNMj411ngjwpstakNY3fEWy6tW_h4whr7w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 01:30:16PM +0200, Pekka Enberg wrote: [...]
> I love the API and implementation simplifications but I hate the new
> ABI. It's a specialized, single-purpose syscall and bunch of procfs
> tunables and I don't see how it's 'extensible' to anything but VM

It is extensible to VM pressure notifications, yeah. We're probably not
going to add the raw vmstat values to it (and that's why we changed the
name). But having three levels is not the best thing we can do -- we can
do better. As I described here:

	http://lkml.org/lkml/2012/10/25/115

That is, later we might want to tell the kernel how much reclaimable
memory userland has. So this can be two-way communication, which to me
sounds pretty cool. :) And who knows what we'll do after that.

But these are just plans. We might end up not having this, but we always
have an option to have it one day.

> If people object to vmevent_fd() system call, we should consider using
> something more generic like perf_event_open() instead of inventing our
> own special purpose ABI.

Ugh. While I *love* perf, but, IIUC, it was designed for other things:
handling tons of events, so it has many stuff that are completely
unnecessary here: we don't need ring buffers, formats, 7+k LOC, etc. Folks
will complain that we need the whole perf stuff for such a simple thing
(just like cgroups).

Also note that for pre-OOM we have to be really fast, i.e. use shortest
possible path (and, btw, that's why in this version the read() now can be
blocking -- and so we no longer have to do two poll()+read() syscalls,
just single read is now possible).

So I really don't see the need for perf here: it doesn't result in any
code reuse, but instead it just complicates our task. As for ABI
maintenance point of view, it is just the same thing as the dedicated
syscall.

Thanks,
Anton.
