Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab2IUAe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:34:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56734 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075Ab2IUAeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:34:25 -0400
Date: Thu, 20 Sep 2012 17:34:22 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de
Subject: Re: [PATCH v2 19/26] bounce: Refactor __blk_queue_bounce to not use
 bi_io_vec
Message-ID: <20120921003422.GN5519@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-20-git-send-email-koverstreet@google.com>
 <20120921002706.GW7264@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120921002706.GW7264@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 05:27:06PM -0700, Tejun Heo wrote:
> On Mon, Sep 10, 2012 at 05:22:30PM -0700, Kent Overstreet wrote:
> > A bunch of what __blk_queue_bounce() was doing was problematic for the
> > immutable bvec work; this cleans that up and the code is quite a bit
> > smaller, too.
> > 
> > The __bio_for_each_segment() in copy_to_high_bio_irq() was changed
> > because that one's looping over the original bio, not the bounce bio -
> > since the bounce code doesn't own that bio the __ version wasn't
> > correct.
> 
> Also, I can't understand the above at all.  I can think why it
> wouldn't be necessary but why is it wrong because bounce code doesn't
> own it?

Another prep work thing - in current code, it isn't really wrong
(slightly inconsistent though).

But the idea is that anything that doesn't own the bio shouldn't assume
anything about bi_idx; the bounce code should loop over the bio starting
from wherever it was when the bio got to the bounce code, not the start
of the bio.

A later patch makes this clearer - __bio_for_each_segment() gets removed
in favor of bio_for_each_segment_all(), and it documents that
bio_for_each_segment_all() is only for code that owns the bio.
