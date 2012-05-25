Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab2EYVJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 17:09:50 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57613 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab2EYVJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 17:09:48 -0400
Date: Fri, 25 May 2012 14:09:44 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        yehuda@hq.newdream.net, mpatocka@redhat.com, vgoyal@redhat.com,
        bharrosh@panasas.com, tj@kernel.org, sage@newdream.net, agk@redhat.com,
        drbd-dev@lists.linbit.com, Dave Chinner <dchinner@redhat.com>,
        tytso@google.com
Subject: Re: [PATCH v3 14/16] Gut bio_add_page()
Message-ID: <20120525210944.GB14196@google.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
 <1337977539-16977-15-git-send-email-koverstreet@google.com>
 <20120525204651.GA24246@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120525204651.GA24246@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 04:46:51PM -0400, Mike Snitzer wrote:
> I'd love to see the merge_bvec stuff go away but it does serve a
> purpose: filesystems benefit from accurately building up much larger
> bios (based on underlying device limits).  XFS has leveraged this for
> some time and ext4 adopted this (commit bd2d0210cf) because of the
> performance advantage.

That commit only talks about skipping buffer heads, from the patch
description I don't see how merge_bvec_fn would have anything to do with
what it's after.

> So if you don't have a mechanism for the filesystem's IO to have
> accurate understanding of the limits of the device the filesystem is
> built on (merge_bvec was the mechanism) and are leaning on late
> splitting does filesystem performance suffer?

So is the issue that it may take longer for an IO to complete, or is it
CPU utilization/scalability?

If it's the former, we've got a real problem. If it's the latter - it
might be a problem in the interim (I don't expect generic_make_request()
to be splitting bios in the common case long term), but I doubt it's
going to be much of an issue.

> Would be nice to see before and after XFS and ext4 benchmarks against a
> RAID device (level 5 or 6).  I'm especially interested to get Dave
> Chinner's and Ted's insight here.

Yeah.

I can't remember who it was, but Ted knows someone who was able to
benchmark on a 48 core system. I don't think we need numbers from a 48
core machine for these patches, but whatever workloads they were testing
that were problematic CPU wise would be useful to test.
