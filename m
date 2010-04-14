Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab0DNAYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 20:24:36 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:54513 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab0DNAYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 20:24:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=u9U4IcAmobxQtN8VAK9w+PV1BKu/gBi81zWLjA1AKoMfTSW8jl7Io9i55uITf4RwTS
         TlegvW7nw7+EbHOsfeFTXpa827JIAiI7dHD8IShuekFjU6fUFKovJthV8bH3pajzkMbX
         ypuYJKZ0n435BCDvrEoRSZzYfXan6d1HBZQ84=
MIME-Version: 1.0
In-Reply-To: <1271117878-19274-1-git-send-email-david@fromorbit.com>
References: <1271117878-19274-1-git-send-email-david@fromorbit.com>
Date: Wed, 14 Apr 2010 09:24:33 +0900
Message-ID: <m2h28c262361004131724ycf9bf4a5xd9b1bad2b4797f50@mail.gmail.com>
Subject: Re: [PATCH] mm: disallow direct reclaim page writeback
From: Minchan Kim <minchan.kim@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dave.

On Tue, Apr 13, 2010 at 9:17 AM, Dave Chinner <david@fromorbit.com> wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> When we enter direct reclaim we may have used an arbitrary amount of stack
> space, and hence enterring the filesystem to do writeback can then lead to
> stack overruns. This problem was recently encountered x86_64 systems with
> 8k stacks running XFS with simple storage configurations.
>
> Writeback from direct reclaim also adversely affects background writeback. The
> background flusher threads should already be taking care of cleaning dirty
> pages, and direct reclaim will kick them if they aren't already doing work. If
> direct reclaim is also calling ->writepage, it will cause the IO patterns from
> the background flusher threads to be upset by LRU-order writeback from
> pageout() which can be effectively random IO. Having competing sources of IO
> trying to clean pages on the same backing device reduces throughput by
> increasing the amount of seeks that the backing device has to do to write back
> the pages.
>
> Hence for direct reclaim we should not allow ->writepages to be entered at all.
> Set up the relevant scan_control structures to enforce this, and prevent
> sc->may_writepage from being set in other places in the direct reclaim path in
> response to other events.

I think your solution is rather aggressive change as Mel and Kosaki
already pointed out.
Do flush thread aware LRU of dirty pages in system level recency not
dirty pages recency?
Of course flush thread can clean dirty pages faster than direct reclaimer.
But if it don't aware LRUness, hot page thrashing can be happened by
corner case.
It could lost write merge.

And non-rotation storage might be not big of seek cost.
I think we have to consider that case if we decide to change direct reclaim I/O.

How do we separate the problem?

1. stack hogging problem.
2. direct reclaim random write.

And try to solve one by one instead of all at once.

-- 
Kind regards,
Minchan Kim
