Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab2DJRZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 13:25:26 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64646 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab2DJRZZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 13:25:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120410092944.GC3789@suse.de>
References: <1332950783-31662-1-git-send-email-mgorman@suse.de>
	<1332950783-31662-2-git-send-email-mgorman@suse.de>
	<CALWz4iymXkJ-88u9Aegc2DjwO2vZp3xVuw_5qTRW2KgPP8ti=g@mail.gmail.com>
	<20120410082454.GA3789@suse.de>
	<20120410092944.GC3789@suse.de>
Date: Tue, 10 Apr 2012 10:25:23 -0700
Message-ID: <CALWz4iw7aTi9mVos98SuLe_vibmhrY19oQvMN36aBwp0exH7DQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: vmscan: Remove lumpy reclaim
From: Ying Han <yinghan@google.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 2:29 AM, Mel Gorman <mgorman@suse.de> wrote:
> On Tue, Apr 10, 2012 at 09:24:54AM +0100, Mel Gorman wrote:
>> On Fri, Apr 06, 2012 at 04:52:09PM -0700, Ying Han wrote:
>> > On Wed, Mar 28, 2012 at 9:06 AM, Mel Gorman <mgorman@suse.de> wrote:
>> > > Lumpy reclaim had a purpose but in the mind of some, it was to kick
>> > > the system so hard it trashed. For others the purpose was to complicate
>> > > vmscan.c. Over time it was giving softer shoes and a nicer attitude but
>> > > memory compaction needs to step up and replace it so this patch sends
>> > > lumpy reclaim to the farm.
>> > >
>> > > Here are the important notes related to the patch.
>> > >
>> > > 1. The tracepoint format changes for isolating LRU pages.
>> > >
>> > > 2. This patch stops reclaim/compaction entering sync reclaim as this
>> > >   was only intended for lumpy reclaim and an oversight. Page migration
>> > >   has its own logic for stalling on writeback pages if necessary and
>> > >   memory compaction is already using it. This is a behaviour change.
>> > >
>> > > 3. RECLAIM_MODE_SYNC no longer exists. pageout() does not stall
>> > >   on PageWriteback with CONFIG_COMPACTION has been this way for a while.
>> > >   I am calling it out in case this is a surpise to people.
>> >
>> > Mel,
>> >
>> > Can you point me the commit making that change? I am looking at
>> > v3.4-rc1 where set_reclaim_mode() still set RECLAIM_MODE_SYNC for
>> > COMPACTION_BUILD.
>> >
>>
>> You're right.
>>
>> There is only one call site that passes sync==true for set_reclaim_mode() in
>> vmscan.c and that is only if should_reclaim_stall() returns true. It had the
>> comment "Only stall on lumpy reclaim" but the comment is not accurate
>> and that mislead me.
>>
>> Thanks, I'll revisit the patch.
>>
>
> Just to be clear, I think the patch is right in that stalling on page
> writeback was intended just for lumpy reclaim.

I see mismatch between the comment "Only stall on lumpy reclaim" and
the actual implementation in should_reclaim_stall(). Not sure what is
intended, but based on the code, both lumpy and compaction reclaim
will be stalled under PageWriteback.

I've split out the patch
> that stops reclaim/compaction entering sync reclaim but the end result
> of the series is the same.

I think that make senses to me for compaction due to its migrating page nature.

Unfortunately we do not have tracing to record
> how often reclaim waited on writeback during compaction so my historical
> data does not indicate how often it happened. However, it may partially
> explain occasionaly complaints about interactivity during heavy writeback
> when THP is enabled (the bulk of the stalls were due to something else but
> on rare occasions disabling THP was reported to make a small unquantifable
> difference). I'll enable ftrace to record how often mm_vmscan_writepage()
> used RECLAIM_MODE_SYNC during tests for this series and include that
> information in the changelog.

Thanks for looking into it.

--Ying

> --
> Mel Gorman
> SUSE Labs
