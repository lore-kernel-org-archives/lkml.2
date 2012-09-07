Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab2IGWZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 18:25:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62434 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757304Ab2IGWZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 18:25:25 -0400
Date: Fri, 7 Sep 2012 15:25:22 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: [PATCH v10 4/8] block: Add bio_reset()
Message-ID: <20120907222522.GE16360@google.com>
References: <1346970902-10931-1-git-send-email-koverstreet@google.com>
 <1346970902-10931-5-git-send-email-koverstreet@google.com>
 <50494F1A.4080207@kernel.dk>
 <20120907205823.GD16360@google.com>
 <504A6D57.1030607@kernel.dk>
 <504A6FF5.3090603@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504A6FF5.3090603@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 04:06:45PM -0600, Jens Axboe wrote:
> On 2012-09-07 15:55, Jens Axboe wrote:
> > On 2012-09-07 14:58, Kent Overstreet wrote:
> >> On Thu, Sep 06, 2012 at 07:34:18PM -0600, Jens Axboe wrote:
> >>> On 2012-09-06 16:34, Kent Overstreet wrote:
> >>>> Reusing bios is something that's been highly frowned upon in the past,
> >>>> but driver code keeps doing it anyways. If it's going to happen anyways,
> >>>> we should provide a generic method.
> >>>>
> >>>> This'll help with getting rid of bi_destructor - drivers/block/pktcdvd.c
> >>>> was open coding it, by doing a bio_init() and resetting bi_destructor.
> >>>>
> >>>> This required reordering struct bio, but the block layer is not yet
> >>>> nearly fast enough for any cacheline effects to matter here.
> >>>
> >>> That's an odd and misplaced comment. Was just doing testing today at 5M
> >>> IOPS, and even years back we've had cache effects for O_DIRECT in higher
> >>> speed setups.
> >>
> >> Ah, I wasn't aware that you were pushing that many iops through the
> >> block layer - most I've tested myself was around 1M. It wouldn't
> >> surprise me if cache effects in struct bio mattered around 5M...
> > 
> > 5M is nothing, just did 13.5M :-)
> > 
> > But we can reshuffle for now. As mentioned, we're way overdue for a
> > decent look at cache profiling in any case.
> 
> No ill effects seen so far, fwiw:
> 
>   read : io=1735.8GB, bw=53690MB/s, iops=13745K, runt= 33104msec

Cool!

I'd be really curious to see a profile. Of the patches I've got queued
up I don't think anything's going to significantly affect performance
yet, but I'm hoping the cleanups/immutable bvec stuff/efficient bio
splitting enables some performance gains.

Well, it certainly will for stacking drivers, but I'm less sure what
it's going to look like running on just a raw flash device.

My end goal is making generic_make_request handle arbitrary sized bios,
and have (efficient) splitting happen as required. This'll get rid of a
bunch of code and complexity in the upper layers, in bio_add_page() and
elsewhere. More in the stacking drivers - merge_bvec_fn is horrendous to
support.

I think I might be able to efficiently get rid of the
segments-after-merging precalculating, and just have segments merged
once. That'd get rid of a couple fields in struct bio, and get it under
2 cachelines last I counted.

Course, all this doesn't matter as much for 4k bios so it may just be a
wash for you.
