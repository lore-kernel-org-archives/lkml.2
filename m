Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400Ab0J1X2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 19:28:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53797 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759127Ab0J1X2Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 19:28:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PymEhufouCWRc67cUHloWpdxNMx2zQue6DZ8HUSAcc2ZE+0H3V3/IufOws4PON0AoA
         gtE9hc3h9MD+9i91UbhypONGgnFj5ntHpv24kzqMvwm8Su3fzAHqxqRfBW341fgCthJC
         ISmOB51dfXzXpuadq2NeWxqnT9SsJatUEuXzk=
MIME-Version: 1.0
In-Reply-To: <20101028220331.GZ26494@google.com>
References: <20101028191523.GA14972@google.com>
	<20101028131029.ee0aadc0.akpm@linux-foundation.org>
	<20101028220331.GZ26494@google.com>
Date: Fri, 29 Oct 2010 08:28:23 +0900
Message-ID: <AANLkTi=VnTkuyYht8D+2MPO1d4mXR1ah-0aQeAjZsTaq@mail.gmail.com>
Subject: Re: [PATCH] RFC: vmscan: add min_filelist_kbytes sysctl for
 protecting the working set
From: Minchan Kim <minchan.kim@gmail.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, wad@chromium.org, olofj@chromium.org,
        hughd@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 7:03 AM, Mandeep Singh Baines <msb@chromium.org> wrote:
> Andrew Morton (akpm@linux-foundation.org) wrote:
>> On Thu, 28 Oct 2010 12:15:23 -0700
>> Mandeep Singh Baines <msb@chromium.org> wrote:
>>
>> > On ChromiumOS, we do not use swap.
>>
>> Well that's bad.  Why not?
>>
>
> We're using SSDs. We're still in the "make it work" phase so wanted
> avoid swap unless/until we learn how to use it effectively with
> an SSD.
>
> You'll want to tune swap differently if you're using an SSD. Not sure
> if swappiness is the answer. Maybe a new tunable to control how aggressive
> swap is unless such a thing already exits?
>
>> > When memory is low, the only way to
>> > free memory is to reclaim pages from the file list. This results in a
>> > lot of thrashing under low memory conditions. We see the system become
>> > unresponsive for minutes before it eventually OOMs. We also see very
>> > slow browser tab switching under low memory. Instead of an unresponsive
>> > system, we'd really like the kernel to OOM as soon as it starts to
>> > thrash. If it can't keep the working set in memory, then OOM.
>> > Losing one of many tabs is a better behaviour for the user than an
>> > unresponsive system.
>> >
>> > This patch create a new sysctl, min_filelist_kbytes, which disables reclaim
>> > of file-backed pages when when there are less than min_filelist_bytes worth
>> > of such pages in the cache. This tunable is handy for low memory systems
>> > using solid-state storage where interactive response is more important
>> > than not OOMing.
>> >
>> > With this patch and min_filelist_kbytes set to 50000, I see very little
>> > block layer activity during low memory. The system stays responsive under
>> > low memory and browser tab switching is fast. Eventually, a process a gets
>> > killed by OOM. Without this patch, the system gets wedged for minutes
>> > before it eventually OOMs. Below is the vmstat output from my test runs.
>> >
>> > BEFORE (notice the high bi and wa, also how long it takes to OOM):
>>
>> That's an interesting result.
>>
>> Having the machine "wedged for minutes" thrashing away paging
>> executable text is pretty bad behaviour.  I wonder how to fix it.
>> Perhaps simply declaring oom at an earlier stage.
>>
>> Your patch is certainly simple enough but a bit sad.  It says "the VM
>> gets this wrong, so lets just disable it all".  And thereby reduces the
>> motivation to fix it for real.
>>
>
> Yeah, I used the RFC label because we're thinking this is just a temporary
> bandaid until something better comes along.
>
> Couple of other nits I have with our patch:
> * Not really sure what to do for the cgroup case. We do something
>  reasonable for now.
> * One of my colleagues also brought up the point that we might want to do
>  something different if swap was enabled.
>
>> But the patch definitely improves the situation in real-world
>> situations and there's a case to be made that it should be available at
>> least as an interim thing until the VM gets fixed for real.  Which
>> means that the /proc tunable might disappear again (or become a no-op)
>> some time in the future.

I think this feature that "System response time doesn't allow but OOM allow".
While we can control process to not killed by OOM using
/oom_score_adj, we can't control response time directly.
But in mobile system, we have to control response time. One of cause
to avoid swap is due to response time.

How about using memcg?
Isolate processes related to system response(ex, rendering engine, IPC
engine and so no)  to another group.

-- 
Kind regards,
Minchan Kim
