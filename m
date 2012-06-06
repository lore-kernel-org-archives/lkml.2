Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339Ab2FFX44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 19:56:56 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:37732 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab2FFX4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 19:56:54 -0400
Message-ID: <4FCFEE36.3010902@linaro.org>
Date: Wed, 06 Jun 2012 16:56:38 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Taras Glek <tgek@mozilla.com>, Mike Hommey <mh@glandium.org>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] [RFC] tmpfs: Add FALLOC_FL_MARK_VOLATILE/UNMARK_VOLATILE
 handlers
References: <1338575387-26972-1-git-send-email-john.stultz@linaro.org> <1338575387-26972-4-git-send-email-john.stultz@linaro.org> <4FC9235F.5000402@gmail.com> <4FC92E30.4000906@linaro.org> <4FC9360B.4020401@gmail.com> <4FC937AD.8040201@linaro.org> <4FC9438B.1000403@gmail.com> <4FC94F61.20305@linaro.org> <4FCFB4F6.6070308@gmail.com>
In-Reply-To: <4FCFB4F6.6070308@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060623-5518-0000-0000-000004FA2EE5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2012 12:52 PM, KOSAKI Motohiro wrote:
>> The key point is we want volatile ranges to be purged in the order they
>> were marked volatile.
>> If we use the page lru via shmem_writeout to trigger range purging, we
>> wouldn't necessarily get this desired behavior.
> Ok, so can you please explain your ideal order to reclaim. your last mail
> described old and new volatiled region. but I'm not sure regular tmpfs pages
> vs volatile pages vs regular file cache order. That said, when using shrink_slab(),
> we choose random order to drop against page cache. I'm not sure why you sure
> it is ideal.

So I'm not totally sure its ideal, but I can tell you what make sense to
me. If there is a more ideal order, I'm open to suggestions.

So volatile ranges should be purged first-in-first-out. So the first
range marked volatile should be purged first. Since volatile ranges
might have different costs depending on what filesystem the file is
backed by, this LRU order is per-filesystem.

It seems that if we have tmpfs volatile ranges, we should purge them
before we swap out any regular tmpfs pages. Thus why I'm purging any
available ranges on shmem_writepage before swapping, rather then using a
shrinker now (I'm hoping you saw the updated patchset I sent out friday).

Does that make sense?

> And, now I guess you think nobody touch volatiled page, yes? because otherwise
> volatile marking order is silly choice. If yes, what's happen if anyone touch
> a patch which volatiled. no-op? SIGBUS? 

So more of a noop. If you read a page that has been marked volatile, it
may return the data that was there, or it may return an empty nulled page.

I guess we could throw a signal to help avoid developers making
programming mistakes, but I'm not sure what the extra cost would be to
set up and tare that down each time. One important aspect of this is
that in order to make it attractive for an application to mark ranges as
volatile, it has to be very cheap to mark and unmark ranges.



> Which worklord didn't work. Usually, anon pages reclaim are only
> happen when 1) tmpfs streaming io workload or 2) heavy vm pressure.
> So, this scenario are not so inaccurate to me.

So it was more of a theoretical issue in my discussions, but once it was
brought up, ashmems' global range lru made more sense.

I think the workload we're mostly concerned with here is heavy vm pressure.



>> That's when I added the LRU tracking at the volatile range level (which
>> reverted back to the behavior ashmem has always used), and have been
>> using that model sense.
>>
>> Hopefully this clarifies things. My apologies if I don't always use the
>> correct terminology, as I'm still a newbie when it comes to VM code.
> I think your code is enough clean. But I'm still not sure your background
> design. Please help me to understand clearly.
Hopefully the above helps. But let me know where you'd like more
clarification.


> btw, Why do you choice fallocate instead of fadvise? As far as I skimmed,
> fallocate() is an operation of a disk layout, not of a cache. And, why
> did you choice fadvise() instead of madvise() at initial version. vma
> hint might be useful than fadvise() because it can be used for anonymous
> pages too.
I actually started with madvise, but quickly moved to fadvise when
feeling that the fd based ranges made more sense. With ashmem, fds are
often shared, and coordinating volatile ranges on a shared fd made more
sense on a (fd, offset, len) tuple, rather then on an offset and length
on an mmapped region.

I moved to fallocate at Dave Chinner's request. In short, it allows
non-tmpfs filesystems to implement volatile range semantics allowing
them to zap rather then writeout dirty volatile pages. And since the
volatile ranges are very similar to a delayed/cancel-able hole-punch, it
made sense to use a similar interface to FALLOC_FL_HOLE_PUNCH.

You can read the details of DaveC's suggestion here:
https://lkml.org/lkml/2012/4/30/441

thanks
-john





