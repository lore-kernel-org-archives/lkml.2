Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab2E1Viu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 17:38:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63609 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab2E1Vis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 17:38:48 -0400
Date: Tue, 29 May 2012 06:38:39 +0900
From: Tejun Heo <tj@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>,
        Kent Overstreet <koverstreet@google.com>,
        Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, yehuda@hq.newdream.net,
        vgoyal@redhat.com, bharrosh@panasas.com, sage@newdream.net,
        drbd-dev@lists.linbit.com, Dave Chinner <dchinner@redhat.com>,
        tytso@google.com
Subject: Re: [PATCH v3 14/16] Gut bio_add_page()
Message-ID: <20120528213839.GB18537@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
 <1337977539-16977-15-git-send-email-koverstreet@google.com>
 <20120525204651.GA24246@redhat.com>
 <20120525210944.GB14196@google.com>
 <20120525223937.GF5761@agk-dp.fab.redhat.com>
 <Pine.LNX.4.64.1205281129180.2227@file.rdu.redhat.com>
 <20120528202839.GA18537@dhcp-172-17-108-109.mtv.corp.google.com>
 <Pine.LNX.4.64.1205281659580.11763@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1205281659580.11763@file.rdu.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 28, 2012 at 05:27:33PM -0400, Mikulas Patocka wrote:
> > They're split and made in-flight together.
> 
> I was talking about old ATA disk (without command queueing). So the 
> requests are not sent together. USB 2 may be a similar case, it has 
> limited transfer size and it doesn't have command queueing too.

I meant in the block layer.  For consecutive commands, queueing
doesn't really matter.

> > Disk will most likely seek to the sector read all of them into buffer
> > at once and then serve the two consecutive commands back-to-back
> > without much inter-command delay.
> 
> Without command queueing, the disk will serve the first request, then 
> receive the second request, and then serve the second request (hopefully 
> the data would be already prefetched after the first request).
> 
> The point is that while the disk is processing the second request, the CPU 
> can already process data from the first request.

Those are transfer latencies - multiple orders of magnitude shorter
than IO latencies.  It would be surprising if they actually are
noticeable with any kind of disk bound workload.

> > Isn't it more like you shouldn't be sending read requested by user and
> > read ahead in the same bio?
> 
> If the user calls read with 512 bytes, you would send bio for just one 
> sector. That's too small and you'd get worse performance because of higher 
> command overhead. You need to send larger bios.

All modern FSes are page granular, so the granularity would be
per-page.  Also, RAHEAD is treated differently in terms of
error-handling.  Do filesystems implement their own rahead
(independent from the common logic in vfs layer) on their own?

> AHCI can interrupt after partial transfer (so for example you can send a 
> command to read 1M, but signal interrupt after the first 4k was 
> transferred), but no one really wrote code that could use this feature. It 
> is questionable if this would improve performance because it would double 
> interrupt load.

The feature is pointless for disks anyway.  Think about the scales of
latencies of different phases of command processing.  The difference
is multiple orders of magnitude.

> > If exposing segmenting limit upwards is a must (I'm kinda skeptical),
> > let's have proper hints (or dynamic hinting interface) instead.
> 
> With this patchset, you don't have to expose all the limits. You can 
> expose just a few most useful limits to avoid bio split in the cases 
> described above.

Yeah, if that actually helps, sure.  From what I read, dm is already
(ab)using merge_bvec_fn() like that anyway.

Thanks.

-- 
tejun
