Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723Ab1KPA2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 19:28:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45622 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757326Ab1KPA2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 19:28:37 -0500
MIME-Version: 1.0
In-Reply-To: <20111116002235.GA10958@barrios-laptop.redhat.com>
References: <20111114140421.GA27150@suse.de>
	<CAEwNFnALUoeh5cEW=XZqy7Aab4hxtE11-mAjWB1c5eddzGuQFA@mail.gmail.com>
	<20111115173656.GJ27150@suse.de>
	<20111116002235.GA10958@barrios-laptop.redhat.com>
Date: Tue, 15 Nov 2011 16:28:36 -0800
X-Google-Sender-Auth: vHuIk4G19EbIIlkP2dqKTYzmFFY
Message-ID: <CAMbhsRSePzsN-4JXEEwFoaa9EhBfHQ11gsjqJCDzV2nonJ0DqQ@mail.gmail.com>
Subject: Re: [PATCH] mm: avoid livelock on !__GFP_FS allocations
From: Colin Cross <ccross@android.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 4:22 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
> On Tue, Nov 15, 2011 at 05:36:56PM +0000, Mel Gorman wrote:
>> On Wed, Nov 16, 2011 at 01:13:30AM +0900, Minchan Kim wrote:
>> The impact would be that during the time between processes been frozen
>> and storage being suspended, GFP_NOIO allocations that used to call
>> wait_iff_congested and retry while kswapd does its thing will return
>> failure instead. These GFP_NOIO allocations that used to succeed will
>> now fail in rare cases during suspend and I don't think we want that.
>>
>> Is this what you meant or had you something else in mind?
>>
>
> You read my mind exactly!
>
> I thought hibernation process is as follows,
>
> freeze user processes
> oom_disable
> hibernate_preallocate_memory
> freeze kernel processes(include kswapd)
> pm_restrict_gfp_mask
> swsusp_save
>
> My guessing is hibernate_prealocate_memory should reserve all memory needed
> for hibernation for reclaimaing pages of kswapd because kswapd just would be
> stopped so during swsusp_save, page reclaim should not be occured.
>
> But being see description of patch, my guess seems wrong.
> Now the problem happens and it means page reclaim happens during swsusp_save.
> Colin or someone could confirm this?

The problem I see is during suspend, not hibernation.  The particular
allocation that usually causes the problem is the pgd_alloc for page
tables when re-enabling the 2nd cpu during resume, which is odd as
those same page tables were freed during suspend.  I guess an
unfreezable kernel thread allocated that memory between the free and
re-allocation.

> If so, could we reserve more memory when we preallocate hibernation memory
> for avoiding page reclaim without kswapd?
>
> --
> Kind regards,
> Minchan Kim
>
