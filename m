Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab2EGMQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 08:16:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63895 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929Ab2EGMQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 08:16:52 -0400
Date: Mon, 7 May 2012 05:15:27 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>, Minchan Kim <minchan@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 3/3] vmevent: Implement special low-memory attribute
Message-ID: <20120507121527.GA19526@lizard>
References: <20120501132409.GA22894@lizard>
 <20120501132620.GC24226@lizard>
 <4FA35A85.4070804@kernel.org>
 <20120504073810.GA25175@lizard>
 <CAOJsxLH_7mMMe+2DvUxBW1i5nbUfkbfRE3iEhLQV9F_MM7=eiw@mail.gmail.com>
 <CAHGf_=qcGfuG1g15SdE0SDxiuhCyVN025pQB+sQNuNba4Q4jcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHGf_=qcGfuG1g15SdE0SDxiuhCyVN025pQB+sQNuNba4Q4jcA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 04:26:00AM -0400, KOSAKI Motohiro wrote:
> >> If we'll give up on "1." (Pekka, ping), then we need to solve "2."
> >> in a sane way: we'll have to add a 'NR_FILE_PAGES - NR_SHMEM -
> >> <todo-locked-file-pages>' attribute, and give it a name.
> >
> > Well, no, we can't give up on (1) completely. That'd mean that
> > eventually we'd need to change the ABI and break userspace. The
> > difference between exposing internal details and reasonable
> > abstractions is by no means black and white.
> >
> > AFAICT, RECLAIMABLE_CACHE_PAGES is a reasonable thing to support. Can
> > anyone come up with a reason why we couldn't do that in the future?
> 
> It can. but the problem is, that is completely useless.

Surely it is useful. Could be not ideal, but you can't say that
it is completely useless.

> Because of, 1) dirty pages writing-out is sometimes very slow and

I don't see it as a unresolvable problem: we can exclude dirty pages,
that's a nice idea actually.

Easily reclaimable cache pages = file_pages - shmem - locked pages
- dirty pages.

The amount of dirty pages is configurable, which is also great.

Even more, we may introduce two attributes:

RECLAIMABLE_CACHE_PAGES and
RECLAIMABLE_CACHE_PAGES_NOIO (which excludes dirty pages).

This makes ABI detached from the mm internals and still keeps a
defined meaning of the attributes.

> 2) libc and some important library's pages are critical important
> for running a system even though it is clean and reclaimable. In other
> word, kernel don't have an info then can't expose it.

First off, I guess LRU would try to keep important/most used pages in
the cache, as we try to never fully drain page cache to the zero mark.

Secondly, if we're really low on memory (which low memory notifications
help to prevent) and kernel decided to throw libc's pages out of the
cache, you'll get cache miss and kernel will have to read it back. Well,
sometimes cache misses do happen, that's life. And if somebody really
don't want this for the essential parts of the system, one have to
mlock it (which eliminates your "kernel don't have an info" argument).


Btw, if you have any better strategy on helping userspace to define
'low memory' conditions, I'll readily try to implement it.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
