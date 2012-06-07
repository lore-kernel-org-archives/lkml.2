Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab2FGKzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 06:55:05 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50090 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab2FGKzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 06:55:03 -0400
MIME-Version: 1.0
In-Reply-To: <4FCFEE36.3010902@linaro.org>
References: <1338575387-26972-1-git-send-email-john.stultz@linaro.org>
	<1338575387-26972-4-git-send-email-john.stultz@linaro.org>
	<4FC9235F.5000402@gmail.com>
	<4FC92E30.4000906@linaro.org>
	<4FC9360B.4020401@gmail.com>
	<4FC937AD.8040201@linaro.org>
	<4FC9438B.1000403@gmail.com>
	<4FC94F61.20305@linaro.org>
	<4FCFB4F6.6070308@gmail.com>
	<4FCFEE36.3010902@linaro.org>
Date: Thu, 7 Jun 2012 12:55:01 +0200
Message-ID: <CAO6Zf6D++8hOz19BmUwQ8iwbQknQRNsF4npP4r-830j04vbj=g@mail.gmail.com>
Subject: Re: [PATCH 3/3] [RFC] tmpfs: Add FALLOC_FL_MARK_VOLATILE/UNMARK_VOLATILE
 handlers
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Taras Glek <tgek@mozilla.com>, Mike Hommey <mh@glandium.org>,
        Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ ... ]
>> Ok, so can you please explain your ideal order to reclaim. your last mail
>> described old and new volatiled region. but I'm not sure regular tmpfs pages
>> vs volatile pages vs regular file cache order. That said, when using shrink_slab(),
>> we choose random order to drop against page cache. I'm not sure why you sure
>> it is ideal.
>
> So I'm not totally sure its ideal, but I can tell you what make sense to
> me. If there is a more ideal order, I'm open to suggestions.
>
> So volatile ranges should be purged first-in-first-out. So the first
> range marked volatile should be purged first. Since volatile ranges
> might have different costs depending on what filesystem the file is
> backed by, this LRU order is per-filesystem.
>
> It seems that if we have tmpfs volatile ranges, we should purge them
> before we swap out any regular tmpfs pages. Thus why I'm purging any
> available ranges on shmem_writepage before swapping, rather then using a
> shrinker now (I'm hoping you saw the updated patchset I sent out friday).
>

so there are multiple sources of reclaimable memory, each coming with
its own cost of (a) giving a memory page back to the kernel and (b)
populating a new page with the content (if accessed later). Given that
the costs are different, I assume that the kernel tries to balance
between different sources with the goal of minimizing the overall
cost.

In this light, the placement of a new source (like 'volatile ranges')
of reclaimable memory does affect this balance (and hence, the overall
cost) one way or another. For instance,

"we should purge them before we swap out any regular tmpfs pages"

but maybe we should also purge them before we swap out some non-tmpfs
pages or drop some file-backed pages?

-- Dmitry
