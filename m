Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab0KXFaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 00:30:05 -0500
Received: from cantor.suse.de ([195.135.220.2]:50562 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710Ab0KXFaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 00:30:02 -0500
Date: Wed, 24 Nov 2010 16:29:53 +1100
From: Neil Brown <neilb@suse.de>
To: <aniket@netezza.com>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] md: Fix nr_pending race during raid10 recovery
Message-ID: <20101124162953.4a405299@notabene.brown>
In-Reply-To: <1290020270.3055.12.camel@aniket-desktop>
References: <1290020270.3055.12.camel@aniket-desktop>
X-Mailer: Claws Mail 3.7.7 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010 13:57:50 -0500
Aniket Kulkarni <aniket@netezza.com> wrote:

> If a RAID10 rdev that is undergoing recovery is marked 'faulty', the rdev 
> could get taken out of the array in spite of outstanding IOs leading to 
> a kernel panic. There are two issues here -
> 
> 1. The ref count (nr_pending) increment for sync or recovery leaves a lot of
> open windows for concurrent rdev removals
> 2. raid10 sync thread continues to submit recovery IOs to faulty devices. These get
> rejected at a later stage by management thread (raid10d).
> 
> Note - rd denotes the rdev from which we are reading, and wr the one we are
> writing to
> 
>   Sync Thread                                Management Thread
> 
> sync_request
>   ++rd.nr_pending
>   bi_end_io = end_sync_read
>   generic_make_request         -------> recovery_request_write
>          |                    |             wr.nr_pending++
>          |                    |             bi_end_io = end_sync_write
>          V                    |             generic_make_request
> end_sync_read    --------------                      |
>   --rd.nr_pending                                    |
>   reschedule_retry for write                         |
>                                                      v
>                                          end_sync_write
>                                              --wr.nr_pending
> 
> So a set-faulty and remove on recovery rdev between sync_request and 
> recovery_request_write is allowed and will lead to a panic.
> 
> The fix is -
> 
> 1. Increment wr.nr_pending immediately after selecting a good target. Ofcourse
> the decrements will be added to error paths in sync_request and end_sync_read.
> 2. Don't submit recovery IOs to faulty targets

Hi again,
 I've been thinking about this some more and cannot see that it is a real
 problem.
 Do you have an actual 'oops' showing a crash in this situation?

 The reason it shouldn't happen is that devices are only removed by
 remove_and_add_devices, and that is only called when no resync/recovery is
 happening.
 So when a device fail, the recovery will abort (waiting for all requests to
 complete), then failed devices are removed and possibly spares are added,
 then possible recovery starts up again.

 So it should work correctly as it is....

confused,
NeilBrown

