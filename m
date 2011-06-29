Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab1F2LVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 07:21:05 -0400
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:6803 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753403Ab1F2LVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 07:21:02 -0400
Message-ID: <4E0B0A76.5010204@draigBrady.com>
Date: Wed, 29 Jun 2011 12:20:22 +0100
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andrea Righi <andrea@betterlinux.com>, Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Jerry James <jamesjer@betterlinux.com>,
        Marcus Sorensen <marcus@bluehost.com>, Matt Heaton <matt@bluehost.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Theodore Tso <tytso@mit.edu>,
        Shaohua Li <shaohua.li@intel.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/2] fadvise: move active pages to inactive list with
 POSIX_FADV_DONTNEED
References: <1309181361-14633-1-git-send-email-andrea@betterlinux.com>	<20110628151233.f0a279be.akpm@linux-foundation.org>	<20110628225645.GB2274@thinkpad> <20110628160347.a5ffcc26.akpm@linux-foundation.org>
In-Reply-To: <20110628160347.a5ffcc26.akpm@linux-foundation.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/06/11 00:03, Andrew Morton wrote:
> On Wed, 29 Jun 2011 00:56:45 +0200
> Andrea Righi <andrea@betterlinux.com> wrote:
> 
>>>>
>>>> In this way if the backup was the only user of a page, that page will be
>>>> immediately removed from the page cache by calling POSIX_FADV_DONTNEED.  If the
>>>> page was also touched by other processes it'll be moved to the inactive list,
>>>> having another chance of being re-added to the working set, or simply reclaimed
>>>> when memory is needed.
>>>
>>> So if an application touches a page twice and then runs
>>> POSIX_FADV_DONTNEED, that page will now not be freed.
>>>
>>> That's a big behaviour change.  For many existing users
>>> POSIX_FADV_DONTNEED simply doesn't work any more!
>>
>> Yes. This is the main concern that was raised by P__draig.
>>
>>>
>>> I'd have thought that adding a new POSIX_FADV_ANDREA would be safer
>>> than this.
>>
>> Actually Jerry (in cc) proposed
>> POSIX_FADV_IDONTNEEDTHISBUTIFSOMEBODYELSEDOESTHENDONTTOUCHIT in a
>> private email. :)
> 
> Sounds good.  Needs more underscores though.
> 
>>>
>>>
>>> The various POSIX_FADV_foo's are so ill-defined that it was a mistake
>>> to ever use them.  We should have done something overtly linux-specific
>>> and given userspace more explicit and direct pagecache control.
>>
>> That would give us the possibility to implement a wide range of
>> different operations (drop, drop if used once, add to the active list,
>> add to the inactive list, etc..). Some users always complain that they
>> would like to have a better control over the page cache from userspace.
> 
> Well, I'd listen to proposals ;)
> 
> One thing we must be careful about is to not expose things like "active
> list" to userspace.  linux-4.5 may not _have_ an active list, and its
> implementors would hate us and would have to jump through hoops to
> implement vaguely compatible behaviour in the new scheme.
> 
> So any primitives which are exposed should be easily implementable and
> should *make sense* within any future scheme...

Agreed.

In fairness to posix_fadvise(), I think it's designed to
specify hints for the current process' use of data
so that it can get at it more efficiently and also be
allow the system to manipulate cache more efficiently.
I.E. it's not meant for direct control of the cache.

That being said, existing use has allowed this,
and it would be nice not to change without consideration.

I've mentioned how high level cache control functions
might map to the existing FADV knobs here:

http://marc.info/?l=linux-kernel&m=130917619416123&w=2

cheers,
Pádraig.
