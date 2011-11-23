Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab1KWMvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 07:51:36 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57610 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab1KWMve convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 07:51:34 -0500
MIME-Version: 1.0
In-Reply-To: <20111123110041.GM19415@suse.de>
References: <1321900608-27687-1-git-send-email-mgorman@suse.de>
	<1321900608-27687-8-git-send-email-mgorman@suse.de>
	<1321945011.22361.335.camel@sli10-conroe>
	<CAPQyPG4DQCxDah5VYMU6PNgeuD_3WJ-zm8XpL7V7BK8hAF8OJg@mail.gmail.com>
	<20111123110041.GM19415@suse.de>
Date: Wed, 23 Nov 2011 20:51:34 +0800
Message-ID: <CAPQyPG50Fme_zU3awoSbSxPN69S+gEEMSSEYQOYRNqBJd7H-aA@mail.gmail.com>
Subject: Re: [PATCH 7/7] mm: compaction: Introduce sync-light migration for
 use by compaction
From: Nai Xia <nai.xia@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Shaohua Li <shaohua.li@intel.com>, Linux-MM <linux-mm@kvack.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 7:00 PM, Mel Gorman <mgorman@suse.de> wrote:
> On Wed, Nov 23, 2011 at 10:01:53AM +0800, Nai Xia wrote:
>> On Tue, Nov 22, 2011 at 2:56 PM, Shaohua Li <shaohua.li@intel.com> wrote:
>> > On Tue, 2011-11-22 at 02:36 +0800, Mel Gorman wrote:
>> >> This patch adds a lightweight sync migrate operation MIGRATE_SYNC_LIGHT
>> >> mode that avoids writing back pages to backing storage. Async
>> >> compaction maps to MIGRATE_ASYNC while sync compaction maps to
>> >> MIGRATE_SYNC_LIGHT. For other migrate_pages users such as memory
>> >> hotplug, MIGRATE_SYNC is used.
>> >>
>> >> This avoids sync compaction stalling for an excessive length of time,
>> >> particularly when copying files to a USB stick where there might be
>> >> a large number of dirty pages backed by a filesystem that does not
>> >> support ->writepages.
>> > Hi,
>> > from my understanding, with this, even writes
>> > to /proc/sys/vm/compact_memory doesn't wait for pageout, is this
>> > intended?
>> > on the other hand, MIGRATE_SYNC_LIGHT now waits for pagelock and buffer
>> > lock, so could wait on page read. page read and page out have the same
>> > latency, why takes them different?
>>
>> So for the problem you raised, I think my suggestion to Mel is to adopt the
>> following logic:
>>
>>            if (!trylock_page(page) && !PageUptodate(page))
>>                       we are quite likely to block on read, so we
>>                       depend on yet another MIGRATE_SYNC_MODE to decide
>>                       if we really want to lock_page() and wait for this IO.
>>
>> How do you think ?
>>
>
> Where are you adding this check?
>
> If you mean in __unmap_and_move(), the check is unnecessary unless
> another subsystem starts using sync-light compaction. With this series,
> only direct compaction cares about MIGRATE_SYNC_LIGHT. If the page is


Oh, Yes, I think I did not pay enough attention that direction compaction
is the *only* user after I saw your comment on MIGRATE_SYNC_LIGHT
of "allow blocking on most operations".... I guess Shaohua also missed
this point too....

Then MIGRATE_SYNC_LIGHT now is solely  for ruling out writeout for
dirty pages. My suggestion would be reserved for future if anyone
doing originally async compaction becomes willing to wait some time for
transient page locking to improve success rate.


> not up to date, it is also locked during the IO and unlocked after
> setting Uptodate in the IO completion handler.
>
> As the page is locked, compaction will fail trylock_page, do the
> PF_MEMALLOC check and bail as it is not safe for direct compaction
> to call lock_page as the comment in __unmap_and_move explains. This
> should avoid the stall.
>
> Did I misunderstand your suggestion?
>
> --
> Mel Gorman
> SUSE Labs
>
